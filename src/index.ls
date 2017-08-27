/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
constants	= require('./constants')
lib			= require('../noise-c')()
#randombytes	= require('./randombytes')

allocate	= lib.allocateBytes

module.exports = {ready: lib.then, constants, CipherState}

/**
 * @param {string} cipher constants.NOISE_CIPHER_CHACHAPOLY, constants.NOISE_CIPHER_AESGCM, etc.
 */
!function CipherState (cipher)
	tmp	= lib.allocatePointer()
	if lib._noise_cipherstate_new_by_id(tmp, cipher) != constants.NOISE_ERROR_NONE
		throw 'Error'
	@_state			= tmp.dereference()
	@_mac_length	= lib._noise_cipherstate_get_mac_length(@_state)
	tmp.free()

CipherState:: =
	/**
	 * @param {Uint8Array} key
	 */
	InitializeKey	: (key) !->
		key	= allocate(0, key)
		if lib._noise_cipherstate_init_key(@_state, key, key.length) != constants.NOISE_ERROR_NONE
			throw 'Error'
		key.free()
	HasKey			: ->
		lib._noise_cipherstate_has_key(@_state) == 1
	/**
	 * @param {Uint8Array} ad
	 * @param {Uint8Array} plaintext
	 *
	 * @return {Uint8Array}
	 */
	EncryptWithAd	: (ad, plaintext) ->
		buffer		= allocate(lib._NoiseBuffer_struct_size())
		# Encryption will happen in place, so we allocate a chunk of memory that will both hold encrypted data and appended MAC
		plaintext	= allocate(plaintext.length + @_mac_length, plaintext)
		lib._NoiseBuffer_set_buffer_data(buffer, plaintext, plaintext.length - @_mac_length, plaintext.length)
		result		= lib._noise_cipherstate_encrypt_with_ad(@_state, ad, ad.length, buffer)
		# Encryption happened in place with MAC at the end
		ciphertext	= plaintext.get()
		buffer.free()
		plaintext.free()
		if result != constants.NOISE_ERROR_NONE
			throw 'Error'
		ciphertext
	/**
	 * @param {Uint8Array} ad
	 * @param {Uint8Array} ciphertext
	 *
	 * @return {Uint8Array}
	 */
	DecryptWithAd	: (ad, ciphertext) ->
		buffer		= allocate(lib._NoiseBuffer_struct_size())
		ciphertext	= allocate(0, ciphertext)
		lib._NoiseBuffer_set_buffer_data(buffer, ciphertext, ciphertext.length, ciphertext.length)
		result		= lib._noise_cipherstate_decrypt_with_ad(@_state, ad, ad.length, buffer)
		# Decryption happened in place, but we need to remove MAC from the end
		plaintext	= ciphertext.get().slice(0, ciphertext.length - @_mac_length)
		buffer.free()
		ciphertext.free()
		if result != constants.NOISE_ERROR_NONE
			throw 'Error'
		plaintext
	Rekey			: !->
		# noise_cipherstate_rekey() is not implemented yet (https://github.com/rweather/noise-c/issues/24)
		throw 'Not implemented'
	free			: !->
		lib._noise_cipherstate_free(@_state)
		delete @_state
		delete @_mac_length

