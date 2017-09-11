/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes		= require('crypto').randomBytes
lib				= require('..')
test			= require('tape')
# Should be require()(), but https://github.com/kripken/emscripten/issues/5568
lib_internal	= require('../noise-c')#()

patterns			= [
	'N' 'X' 'K'
	'NN' 'NK' 'NX' 'XN' 'XK' 'XX' 'KN' 'KK' 'KX' 'IN' 'IK' 'IX'
]
curves				= ['25519' '448'/* 'NewHope'*/]
ciphers				= ['ChaChaPoly' 'AESGCM']
hashes				= ['SHA256' 'SHA512' 'BLAKE2s' 'BLAKE2b']
prologues			= [null, new Uint8Array, randombytes(10)]
psks				= [null, new Uint8Array, randombytes(32)]
ads					= [new Uint8Array, randombytes(256)]
plaintexts			= [new Uint8Array, new Uint8Array(randombytes(10))]
static_keys			=
	NOISE_ROLE_INITIATOR	:
		private	:
			'25519'	: Uint8Array.of(230 30 249 145 156 222 69 221 95 130 22 100 4 189 8 227 139 206 181 223 223 222 208 163 76 141 247 237 84 34 20 209)
			'448'	: Uint8Array.of(52 213 100 196 190 150 61 27 42 137 252 254 131 230 167 43 94 63 94 49 39 249 245 150 255 199 87 94 65 141 252 31 78 130 124 252 16 201 254 211 142 146 173 86 221 248 240 133 113 67 13 242 231 109 84 17)
		public	:
			'25519'	: Uint8Array.of(107 195 130 42 42 167 244 230 152 29 101 56 105 43 60 223 62 109 249 238 166 237 38 158 180 29 147 194 39 87 183 90)
			'448'	: Uint8Array.of(48 21 81 236 161 120 143 68 81 194 105 190 175 237 17 11 81 240 140 4 148 168 222 97 74 24 79 243 212 103 215 222 253 252 124 19 142 70 105 89 17 8 182 154 5 109 37 202 253 162 137 242 45 31 50 192)
	NOISE_ROLE_RESPONDER	:
		private	:
			'25519'	: Uint8Array.of(74 58 203 253 177 99 222 198 81 223 163 25 77 236 230 118 212 55 2 156 98 164 8 180 197 234 145 20 36 110 72 147)
			'448'	: Uint8Array.of(169 180 89 113 24 8 130 167 155 137 163 57 149 68 164 37 239 129 54 210 120 239 164 67 237 103 211 255 157 54 232 131 188 51 12 98 149 187 246 237 115 255 111 209 12 190 215 103 173 5 206 3 235 210 124 124)
		public	:
			'25519'	: Uint8Array.of(49 224 48 63 214 65 141 47 140 14 120 185 31 34 232 202 237 15 190 72 101 109 207 71 103 228 131 79 112 27 143 98)
			'448'	: Uint8Array.of(189 32 15 166 213 13 179 167 67 121 123 0 172 161 183 15 65 123 252 56 27 40 178 27 88 53 216 76 247 166 218 106 187 161 158 59 167 212 107 37 52 18 183 70 101 212 98 123 101 252 239 63 41 201 93 62)
roles_keys			=
	'NOISE_ROLE_INITIATOR'
	'NOISE_ROLE_RESPONDER'
	null
no_empty_keys		=
	# Any pattern that starts with K, X or I requires initiator's static private key
	local	: /^[KXI]/
	# Any one-way pattern or pattern that ends with K, X or I requires responders's static public key
	remote	: /(^.|[KXI])$/
roundtrip_halves	=
	1	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE']
	2	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE']
	3	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE']
expected_actions	=
	N	: roundtrip_halves.1
	X	: roundtrip_halves.1
	K	: roundtrip_halves.1
	NN	: roundtrip_halves.2
	NK	: roundtrip_halves.2
	NX	: roundtrip_halves.2
	XN	: roundtrip_halves.3
	XK	: roundtrip_halves.3
	XX	: roundtrip_halves.3
	KN	: roundtrip_halves.2
	KK	: roundtrip_halves.2
	KX	: roundtrip_halves.2
	IN	: roundtrip_halves.2
	IK	: roundtrip_halves.2
	IX	: roundtrip_halves.2

# Convenient for debugging common issues instead of looping through thousands of combinations
#patterns	= [patterns[0]]
#curves		= [curves[0]]
#ciphers		= [ciphers[0]]
#hashes		= [hashes[0]]
#prologues	= [prologues[0]]
#psks		= [psks[0]]
#ads			= [ads[0]]
#plaintexts	= [plaintexts[0]]

<-! lib.ready
for let pattern in patterns => for let curve in curves => for let cipher in ciphers => for let hash in hashes => for let prologue in prologues => for let psk in psks => for let role_key_s in roles_keys => for let role_key_rs in roles_keys
	# Skip some loops where patterns require local or remote keys to be present, but they are `null` for this particular loop iteration
	if !role_key_s && no_empty_keys.local.test(pattern)
		return
	if !role_key_rs && no_empty_keys.remote.test(pattern)
		return
	protocol_name	= "Noise_#{pattern}_#{curve}_#{cipher}_#{hash}"
	prologue_title	= if prologue then "length #{prologue.length}" else 'null'
	psk_title		= if psk then "length #{psk.length}" else 'null'

	for let ad in ads => for let plaintext in plaintexts
		test("HandshakeState: #protocol_name, prologue #prologue_title, psk #psk_title, role_key_s #role_key_s, role_key_rs #role_key_rs, plaintext length #{plaintext.length}, ad length #{ad.length}", (t) !->
			var initiator_hs, responder_hs
			t.doesNotThrow (!->
				initiator_hs	:= new lib.HandshakeState(protocol_name, lib.constants.NOISE_ROLE_INITIATOR)
			), "Initiator constructor doesn't throw an error"

			t.doesNotThrow (!->
				responder_hs	:= new lib.HandshakeState(protocol_name, lib.constants.NOISE_ROLE_RESPONDER)
			), "Responder constructor doesn't throw an error"

			t.doesNotThrow (!->
				s	= role_key_s
				if s
					s	= static_keys[s].private[curve]
				rs	= role_key_rs
				if rs
					rs	= static_keys[rs].public[curve]
				initiator_hs.Initialize(prologue, s, rs, psk)
			), "Initiator Initialize() doesn't throw an error"

			t.doesNotThrow (!->
				s	= role_key_rs
				if s
					s	= static_keys[s].private[curve]
				rs	= role_key_s
				if rs
					rs	= static_keys[rs].public[curve]
				responder_hs.Initialize(prologue, s, rs, psk)
			), "Responder Initialize() doesn't throw an error"

			initiator_actions	= expected_actions[pattern].initiator.slice()
			responder_actions	= expected_actions[pattern].responder.slice()
			var message
			:initiator_loop while action = initiator_actions.shift()
				if action
					t.equal(initiator_hs.GetAction(), lib.constants[action], "Initiator expected action: #action")

				switch action
					case 'NOISE_ACTION_WRITE_MESSAGE'
						t.doesNotThrow (!->
							message	:= initiator_hs.WriteMessage()
						), "Initiator WriteMessage() doesn't throw an error"

						while action = responder_actions.shift()
							if action
								t.equal(responder_hs.GetAction(), lib.constants[action], "Responder expected action: #action")

							switch action
								case 'NOISE_ACTION_READ_MESSAGE'
									t.doesNotThrow (!->
										responder_hs.ReadMessage(message)
									), "Responder ReadMessage() doesn't throw an error"

								case 'NOISE_ACTION_WRITE_MESSAGE'
									t.doesNotThrow (!->
										message	:= responder_hs.WriteMessage()
									), "Responder WriteMessage() doesn't throw an error"

									continue initiator_loop

					case 'NOISE_ACTION_READ_MESSAGE' ''
						t.doesNotThrow (!->
							initiator_hs.ReadMessage(message)
						), "Initiator ReadMessage() doesn't throw an error"

			t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, 'Initiator is ready to split')
			t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, 'Responder is ready to split')

			var initiator_send, initiator_receive
			t.doesNotThrow (!->
				[initiator_send, initiator_receive]	:= initiator_hs.Split()
			), "Initiator Split() doesn't throw an error"
			t.ok(initiator_send instanceof lib.CipherState, 'Initiator Element #1 after Split() implements CipherState')
			t.ok(initiator_receive instanceof lib.CipherState, 'Initiator Element #2 after Split() implements CipherState')

			t.throws (!->
				initiator_hs.Initialize(plaintext)
			), "Initiator HandshakeState shouldn't be usable after Split() is called"

			var responder_send, responder_receive
			t.doesNotThrow (!->
				[responder_send, responder_receive]	:= responder_hs.Split()
			), "Responder Split() doesn't throw an error"
			t.ok(responder_send instanceof lib.CipherState, 'Responder Element #1 after Split() implements CipherState')
			t.ok(responder_receive instanceof lib.CipherState, 'Responder Element #2 after Split() implements CipherState')

			t.throws (!->
				responder_hs.Initialize(plaintext)
			), "Responder HandshakeState shouldn't be usable after Split() is called"

			# Initiator sends data
			ciphertext	= initiator_send.EncryptWithAd(ad, plaintext)

			t.equal(ciphertext.length, plaintext.length + initiator_send._mac_length, 'Initiator ciphertext has expected length')
			# Empty plaintext will be, obviously, the same as empty ciphertext
			if plaintext.length
				t.notEqual(ciphertext.slice(0, plaintext.length).toString(), plaintext.toString(), 'Initiator ciphertext is not the same as plaintext')
			initiator_send.free()

			# Responder receives data
			plaintext_decrypted	= responder_receive.DecryptWithAd(ad, ciphertext)
			responder_receive.free()

			t.equal(plaintext_decrypted.toString(), plaintext.toString(), 'Responder plaintext decrypted correctly')

			# Responder sends data
			ciphertext	= responder_send.EncryptWithAd(ad, plaintext)

			t.equal(ciphertext.length, plaintext.length + responder_send._mac_length, 'Responder ciphertext has expected length')
			# Empty plaintext will be, obviously, the same as empty ciphertext
			if plaintext.length
				t.notEqual(ciphertext.slice(0, plaintext.length).toString(), plaintext.toString(), 'Responder ciphertext is not the same as plaintext')
			responder_send.free()

			# Initiator receives data
			plaintext_decrypted	= initiator_receive.DecryptWithAd(ad, ciphertext)
			initiator_receive.free()

			t.equal(plaintext_decrypted.toString(), plaintext.toString(), 'Initiator plaintext decrypted correctly')

			t.end()
		)

known_prologue			= Uint8Array.of(43 32 195 206 138 156 161 18 151 93)
known_plaintext			= Uint8Array.of(57 250 199 143 113 176 210 75 100 38)
known_ad				= Uint8Array.of(240 104 34 55 185 175 63 127 129 111)
fixed_ephemeral			= Uint8Array.of(127 210 108 139 138 13 92 152 200 95 249 202 29 123 198 109 120 87 139 159 44 76 23 8 80 116 139 39 153 39 103 230 234 108 201 153 42 86 28 157 25 223 195 66 226 96 194 128 239 79 63 155 143 135 157 78)
initiator_ciphertext	= Uint8Array.of(95 85 166 4 191 171 103 202 218 205 57 60 42 43 221 13 179 231 27 58 170 168 114 58 107 19)
responder_ciphertext	= Uint8Array.of(172 42 69 220 217 91 2 152 7 238 167 34 157 21 242 97 46 236 129 73 50 199 252 69 12 118)

!function set_fixed_ephemeral (hs)
	dh		= lib_internal._noise_handshakestate_get_fixed_ephemeral_dh(hs._state)
	if dh
		s		= lib_internal.allocateBytes(0, fixed_ephemeral)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != lib.constants.NOISE_ERROR_NONE
			throw new Error(error)
	dh		= lib_internal._noise_handshakestate_get_fixed_hybrid_dh(hs._state)
	if dh
		s		= lib_internal.allocateBytes(0, fixed_ephemeral)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != lib.constants.NOISE_ERROR_NONE
			throw new Error(error)

test("HandshakeState: Fallback testing", (t) !->
	var initiator_hs, responder_hs, message
	var initiator_send, initiator_receive
	var responder_send, responder_receive

	t.doesNotThrow (!->
		initiator_hs	:= new lib.HandshakeState('Noise_IK_448_ChaChaPoly_BLAKE2b', lib.constants.NOISE_ROLE_INITIATOR)
		responder_hs	:= new lib.HandshakeState('Noise_IK_448_ChaChaPoly_BLAKE2b', lib.constants.NOISE_ROLE_RESPONDER)

		# Fix ephemeral key pairs in order to get predictable ciphertext
		set_fixed_ephemeral(initiator_hs)
		set_fixed_ephemeral(responder_hs)

		initiator_hs.Initialize(known_prologue, static_keys.NOISE_ROLE_INITIATOR.private.448, static_keys.NOISE_ROLE_RESPONDER.public.448)
		responder_hs.Initialize(randombytes(10), static_keys.NOISE_ROLE_RESPONDER.private.448, static_keys.NOISE_ROLE_RESPONDER.public.448)

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Initiator expected action: NOISE_ACTION_WRITE_MESSAGE")

		# Start IK handshake pattern
		message	:= initiator_hs.WriteMessage()

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Initiator expected action: NOISE_ACTION_READ_MESSAGE")

		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Responder expected action: NOISE_ACTION_READ_MESSAGE")
	), "Preparation goes well"

	t.throws (!->
		# IK handshake pattern fails here
		responder_hs.ReadMessage(message, false, true)
	), "Responder ReadMessage() throws an error because of different prologue"

	t.doesNotThrow (!->
		# Fallback to XX handshake pattern
		responder_hs.FallbackTo(lib.constants.NOISE_PATTERN_XX_FALLBACK)
		responder_hs.Initialize(known_prologue)
	), "Responder FallbackTo() and Initialize() doesn't throw an error"


	t.doesNotThrow (!->
		# Responder starts XX handshake pattern
		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Responder expected action: NOISE_ACTION_WRITE_MESSAGE")

		message	:= responder_hs.WriteMessage()

		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Responder expected action: NOISE_ACTION_READ_MESSAGE")

		# Initiator fallbacks to XX pattern too
		t.doesNotThrow (!->
			initiator_hs.FallbackTo(lib.constants.NOISE_PATTERN_XX_FALLBACK)
			initiator_hs.Initialize()
		), "Initiator FallbackTo() and Initialize() doesn't throw an error"

		# Initiator now expects to read message from responder that initialized XX fallback handshake pattern
		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Initiator expected action: NOISE_ACTION_READ_MESSAGE")

		initiator_hs.ReadMessage(message)

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Initiator expected action: NOISE_ACTION_WRITE_MESSAGE")

		message	:= initiator_hs.WriteMessage()

		# Initiator is ready to split
		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, "Initiator expected action: NOISE_ACTION_SPLIT")

		responder_hs.ReadMessage(message)

		# Responder is ready to split
		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, "Responder expected action: NOISE_ACTION_SPLIT")

		[initiator_send, initiator_receive]	:= initiator_hs.Split()
		[responder_send, responder_receive]	:= responder_hs.Split()
	), "The rest goes well too"

	# Initiator sends data
	ciphertext	= initiator_send.EncryptWithAd(known_ad, known_plaintext)

	t.equal(ciphertext.toString(), initiator_ciphertext.toString(), "Initiator plaintext encrypted correctly")
	initiator_send.free()

	# Responder receives data
	plaintext_decrypted	= responder_receive.DecryptWithAd(known_ad, ciphertext)
	responder_receive.free()

	t.equal(plaintext_decrypted.toString(), known_plaintext.toString(), 'Responder plaintext decrypted correctly')

	# Responder sends data
	ciphertext	= responder_send.EncryptWithAd(known_ad, known_plaintext)

	t.equal(ciphertext.toString(), responder_ciphertext.toString(), 'Responder plaintext encrypted correctly')
	responder_send.free()

	# Initiator receives data
	plaintext_decrypted	= initiator_receive.DecryptWithAd(known_ad, ciphertext)
	initiator_receive.free()

	t.equal(plaintext_decrypted.toString(), known_plaintext.toString(), 'Initiator plaintext decrypted correctly')

	t.end()
)
