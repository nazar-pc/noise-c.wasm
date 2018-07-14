/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
fs				= require('fs')
lib				= require('..')()
lib_internal	= lib._lib_internal
randombytes		= require('crypto').randomBytes
test			= require('tape')

{
	NOISE_PATTERN_XX_FALLBACK
	NOISE_PATTERN_XX_FALLBACK_HFS

	NOISE_ACTION_NONE
	NOISE_ACTION_WRITE_MESSAGE
	NOISE_ACTION_READ_MESSAGE
	NOISE_ACTION_FAILED
	NOISE_ACTION_SPLIT

	NOISE_ROLE_INITIATOR
	NOISE_ROLE_RESPONDER

	NOISE_ERROR_NONE
}						= lib.constants
files_to_test			= [
	__dirname + '/../vendor/tests/vector/cacophony.txt'
	__dirname + '/../vendor/tests/vector/noise-c-basic.txt'
	__dirname + '/../vendor/tests/vector/noise-c-fallback.txt'
	__dirname + '/../vendor/tests/vector/noise-c-hybrid.txt'
]
one_way_pattern_regexp	= /^Noise[^_]*_[NXK][^NKXI]/

!function set_fixed_ephemeral (hs, ephemeral, hybrid)
	dh		= lib_internal._noise_handshakestate_get_fixed_ephemeral_dh(hs._state)
	if dh && ephemeral
		s		= lib_internal.allocateBytes(0, ephemeral)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != NOISE_ERROR_NONE
			throw new Error(error)
	dh		= lib_internal._noise_handshakestate_get_fixed_hybrid_dh(hs._state)
	if dh && hybrid
		s		= lib_internal.allocateBytes(0, hybrid)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != NOISE_ERROR_NONE
			throw new Error(error)

function get_handshake_hash (hs, length)
	s				= lib_internal.allocateBytes(length)
	error			= lib_internal._noise_handshakestate_get_handshake_hash(hs._state, s, s.length)
	handshake_hash	= s.get()
	s.free()
	if error != NOISE_ERROR_NONE
		throw new Error(error)
	handshake_hash

!function process_test_vectors (filename)
	test("Testing #filename", (t) !->
		vectors		= JSON.parse(fs.readFileSync(filename)).vectors
		for let vector, i in vectors
			# TODO: Remove when noise-c imports newer vectors
			if !vector.protocol_name
				psk						= if vector.init_psk || vector.resp_psk then 'PSK' else ''
				dh2						= if vector.hybrid then "+#{vector.hybrid}" else ''
				vector.protocol_name	= "Noise#{psk}_#{vector.pattern}_#{vector.dh}#{dh2}_#{vector.cipher}_#{vector.hash}"

			t.test("Vector index: #i, pattern #{vector.name} #{vector.protocol_name}", (t) !->
				test_vector_run(t, vector)
				t.end()
			)
	)

!function test_vector_run (t, vector)
	is_one_way		= one_way_pattern_regexp.test(vector.protocol_name)
	fallback		= vector.fallback
	compare			= t~equal
	compare_blocks	= (array, string) ->
		buffer	= Buffer.from(array)
		t.equal(buffer.toString('hex'), string)

	initiator	= lib.HandshakeState(vector.protocol_name, NOISE_ROLE_INITIATOR)
	responder	= lib.HandshakeState(vector.protocol_name, NOISE_ROLE_RESPONDER)

	init_ephemeral			= vector.init_ephemeral			&& Buffer.from(vector.init_ephemeral, 'hex')
	init_hybrid_ephemeral	= vector.init_hybrid_ephemeral	&& Buffer.from(vector.init_hybrid_ephemeral, 'hex')
	resp_ephemeral			= vector.resp_ephemeral			&& Buffer.from(vector.resp_ephemeral, 'hex')
	resp_hybrid_ephemeral	= vector.resp_hybrid_ephemeral	&& Buffer.from(vector.resp_hybrid_ephemeral, 'hex')
	init_prologue			= vector.init_prologue			&& Buffer.from(vector.init_prologue, 'hex')
	init_static				= vector.init_static			&& Buffer.from(vector.init_static, 'hex')
	init_remote_static		= vector.init_remote_static		&& Buffer.from(vector.init_remote_static, 'hex')
	init_psk				= vector.init_psk				&& Buffer.from(vector.init_psk, 'hex')
	resp_prologue			= vector.resp_prologue			&& Buffer.from(vector.resp_prologue, 'hex')
	resp_static				= vector.resp_static			&& Buffer.from(vector.resp_static, 'hex')
	resp_remote_static		= vector.resp_remote_static		&& Buffer.from(vector.resp_remote_static, 'hex')
	resp_psk				= vector.resp_psk				&& Buffer.from(vector.resp_psk, 'hex')

	set_fixed_ephemeral(initiator, init_ephemeral, init_hybrid_ephemeral)
	set_fixed_ephemeral(responder, resp_ephemeral, resp_hybrid_ephemeral)

	initiator.Initialize(init_prologue, init_static, init_remote_static, init_psk)
	responder.Initialize(resp_prologue, resp_static, resp_remote_static, resp_psk)

	role = NOISE_ROLE_INITIATOR

	for message, i in vector.messages
		if initiator.GetAction() == NOISE_ACTION_SPLIT && responder.GetAction() == NOISE_ACTION_SPLIT
			break
		if role == NOISE_ROLE_INITIATOR
			send	= initiator
			recv	= responder
			if !is_one_way
				role	= NOISE_ROLE_RESPONDER
		else
			send	= responder
			recv	= initiator
			role	= NOISE_ROLE_INITIATOR

		compare(send.GetAction(), NOISE_ACTION_WRITE_MESSAGE)
		compare(recv.GetAction(), NOISE_ACTION_READ_MESSAGE)

		ciphertext	= send.WriteMessage(Buffer.from(message.payload, 'hex'))
		compare_blocks(ciphertext, message.ciphertext)

		if fallback
			fallback_id	= NOISE_PATTERN_XX_FALLBACK
			if vector.fallback_pattern && vector.fallback_pattern == 'XXfallback+hfs'
				fallback_id	= NOISE_PATTERN_XX_FALLBACK_HFS

			t.throws !->
				recv.ReadMessage(ciphertext, true, true)

			initiator.FallbackTo(fallback_id)
			responder.FallbackTo(fallback_id)

			initiator.Initialize()
			responder.Initialize()

			fallback	= false
		else
			payload	= recv.ReadMessage(Buffer.from(message.ciphertext, 'hex'), true)
			compare_blocks(payload, message.payload)

	last_loop_index	= i

	if vector.handshake_hash
		handshake_hash_length	= Buffer.from(vector.handshake_hash, 'hex').length

		compare_blocks(get_handshake_hash(initiator, handshake_hash_length), vector.handshake_hash)
		compare_blocks(get_handshake_hash(responder, handshake_hash_length), vector.handshake_hash)

	[c1init, c2init]	= initiator.Split()
	[c2resp, c1resp]	= responder.Split()
	mac_len				= c1init._mac_length

	for message, i in vector.messages.slice(last_loop_index)
		if role == NOISE_ROLE_INITIATOR
			csend	= c1init
			crecv	= c1resp
			if !is_one_way
				role	= NOISE_ROLE_RESPONDER
		else
			csend	= c2resp
			crecv	= c2init
			role	= NOISE_ROLE_INITIATOR

		ciphertext	= csend.EncryptWithAd(new Uint8Array, Buffer.from(message.payload, 'hex'))
		compare_blocks(ciphertext, message.ciphertext)

		payload	= crecv.DecryptWithAd(new Uint8Array, ciphertext)
		compare_blocks(payload, message.payload)

	c1init.free()
	c2init.free()
	c1resp.free()
	c2resp.free()

<-! lib.ready
for filename in files_to_test
	process_test_vectors(filename)
