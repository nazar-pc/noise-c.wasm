/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
constants	= require('./constants')
lib			= require('../noise-c')()

module.exports = {ready: lib.then, constants, CipherState, SymmetricState}

allocate		= lib.allocateBytes
allocate_buffer	= (data, size) ->
	tmp		= lib.allocatePointer()
	lib._NoiseBuffer_create(tmp, data, size, data.length)
	buffer	= tmp.dereference()
	tmp.free()
	buffer
assert_no_error	= (result) !->
	if result == constants.NOISE_ERROR_NONE
		return
	for key, value of constants
		if value == result
			throw "Error: #key"

/**
 * @param {string} cipher constants.NOISE_CIPHER_CHACHAPOLY, constants.NOISE_CIPHER_AESGCM, etc.
 */
!function CipherState (cipher)
	if !(@ instanceof CipherState)
		return new CipherState(cipher)
	tmp		= lib.allocatePointer()
	result	= lib._noise_cipherstate_new_by_id(tmp, cipher)
	try
		assert_no_error(result)
	catch e
		tmp.free()
		throw e
	@_state			= tmp.dereference()
	@_mac_length	= lib._noise_cipherstate_get_mac_length(@_state)
	tmp.free()

CipherState:: =
	/**
	 * @param {Uint8Array} key
	 */
	InitializeKey	: (key) !->
		key		= allocate(0, key)
		result	= lib._noise_cipherstate_init_key(@_state, key, key.length)
		key.free()
		assert_no_error(result)
	HasKey			: ->
		lib._noise_cipherstate_has_key(@_state) == 1
	/**
	 * @param {Uint8Array} ad
	 * @param {Uint8Array} plaintext
	 *
	 * @return {Uint8Array}
	 */
	EncryptWithAd	: (ad, plaintext) ->
		ad			= allocate(0, ad)
		# Encryption will happen in place, so we allocate a chunk of memory that will both hold encrypted data and appended MAC
		plaintext	= allocate(plaintext.length + @_mac_length, plaintext)
		buffer		= allocate_buffer(plaintext, plaintext.length - @_mac_length)
		result		= lib._noise_cipherstate_encrypt_with_ad(@_state, ad, ad.length, buffer)
		# Encryption happened in place with MAC at the end
		ciphertext	= plaintext.get()
		ad.free()
		plaintext.free()
		buffer.free()
		assert_no_error(result)
		ciphertext
	/**
	 * @param {Uint8Array} ad
	 * @param {Uint8Array} ciphertext
	 *
	 * @return {Uint8Array}
	 */
	DecryptWithAd	: (ad, ciphertext) ->
		ad			= allocate(0, ad)
		ciphertext	= allocate(0, ciphertext)
		buffer		= allocate_buffer(ciphertext, ciphertext.length)
		result		= lib._noise_cipherstate_decrypt_with_ad(@_state, ad, ad.length, buffer)
		# Decryption happened in place, but we need to remove MAC from the end
		plaintext	= ciphertext.get().slice(0, ciphertext.length - @_mac_length)
		ad.free()
		ciphertext.free()
		buffer.free()
		assert_no_error(result)
		plaintext
	Rekey			: !->
		# TODO: noise_cipherstate_rekey() is not implemented yet (https://github.com/rweather/noise-c/issues/24)
		throw 'Not implemented'
	free			: !->
		result	= lib._noise_cipherstate_free(@_state)
		delete @_state
		delete @_mac_length
		assert_no_error(result)

!function CipherState_split (state)
	@_state			= state
	@_mac_length	= lib._noise_cipherstate_get_mac_length(@_state)

CipherState_split:: = Object.create(CipherState)
Object.defineProperty(CipherState_split::, 'constructor', {enumerable: false, value: CipherState_split})

/**
 * @param {string} protocol_name The name of the Noise protocol to use, for instance, Noise_N_25519_ChaChaPoly_BLAKE2b
 */
!function SymmetricState (protocol_name)
	if !(@ instanceof SymmetricState)
		return new SymmetricState(protocol_name)
	tmp				= lib.allocatePointer()
	protocol_name	= allocate(0, protocol_name)
	result			= lib._noise_symmetricstate_new_by_name(tmp, protocol_name)
	try
		assert_no_error(result)
	catch e
		tmp.free()
		throw e
	@_state			= tmp.dereference()
	@_mac_length	= lib._noise_symmetricstate_get_mac_length(@_state)
	tmp.free()
	protocol_name.free()

SymmetricState:: =
	/**
	 * @param {Uint8Array} input_key_material
	 */
	MixKey				: (input_key_material) !->
		input_key_material	= allocate(0, input_key_material)
		result				= lib._noise_symmetricstate_mix_key(@_state, input_key_material, input_key_material.length)
		input_key_material.free()
		assert_no_error(result)
	/**
	 * @param {Uint8Array} data
	 */
	MixHash				: (data) !->
		data	= allocate(0, data)
		result	= lib._noise_symmetricstate_mix_hash(@_state, data, data.length)
		data.free()
		assert_no_error(result)
	/**
	 * @param {Uint8Array} input_key_material
	 */
	MixKeyAndHash		: (input_key_material) !->
		@MixKey(input_key_material)
		tmp		= lib.allocatePointer()
		length	= lib._SymmetricState_get_ck(@_state, tmp)
		ck		= tmp.dereference(length)
		tmp.free()
		data	= ck.get()
		ck.free()
		@MixHash(data)
	/**
	 * @param {Uint8Array} plaintext
	 *
	 * @return {Uint8Array}
	 */
	EncryptAndHash		: (plaintext) ->
		# Encryption will happen in place, so we allocate a chunk of memory that will both hold encrypted data and appended MAC
		plaintext	= allocate(plaintext.length + @_mac_length, plaintext)
		buffer		= allocate_buffer(plaintext, plaintext.length - @_mac_length)
		result		= lib._noise_symmetricstate_encrypt_and_hash(@_state, buffer)
		# Encryption happened in place with MAC at the end
		ciphertext	= plaintext.get()
		plaintext.free()
		buffer.free()
		assert_no_error(result)
		ciphertext
	/**
	 * @param {Uint8Array} ciphertext
	 *
	 * @return {Uint8Array}
	 */
	DecryptAndHash		: (ciphertext) ->
		ciphertext	= allocate(0, ciphertext)
		buffer		= allocate_buffer(ciphertext, ciphertext.length)
		result		= lib._noise_symmetricstate_decrypt_and_hash(@_state, buffer)
		# Decryption happened in place, but we need to remove MAC from the end
		plaintext	= ciphertext.get().slice(0, ciphertext.length - @_mac_length)
		ciphertext.free()
		buffer.free()
		assert_no_error(result)
		plaintext
	/**
	 * @return {CipherState[]}
	 */
	Split				: ->
		tmp1		= lib.allocatePointer()
		tmp2		= lib.allocatePointer()
		result		= lib._noise_symmetricstate_split(@_state, tmp1, tmp2)
		try
			assert_no_error(result)
		catch e
			tmp1.free()
			tmp2.free()
			throw e
		cs1	= new CipherState_split(tmp1.dereference())
		cs2	= new CipherState_split(tmp2.dereference())
		tmp1.free()
		tmp2.free()
		try
			@free()
		catch e
			try
				cs1.free()
			try
				cs2.free()
			throw e
		[cs1, cs2]
	free				: !->
		result	= lib._noise_symmetricstate_free(@_state)
		delete @_state
		delete @_mac_length
		assert_no_error(result)
