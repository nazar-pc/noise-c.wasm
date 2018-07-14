/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
if typeof crypto != 'undefined'
	/**
	 * @param {number} size
	 *
	 * @return {!Uint8Array}
	 */
	random_bytes	= (size) ->
		array = new Uint8Array(size)
		crypto.getRandomValues(array)
		array
else
	/**
	 * @param {string} size
	 *
	 * @return {!Uint8Array}
	 */
	random_bytes	= require('crypto').randomBytes

function CreateLib (lib, constants, options)
	lib						= lib(options)
	# Hack: For Closure Compiler that otherwise complains about `require`
	lib['_random_bytes']	= random_bytes
	allocate				= lib['allocateBytes']
	allocate_pointer		= lib['allocatePointer']

	function allocate_buffer (data, size)
		tmp		= allocate_pointer()
		lib._NoiseBuffer_create(tmp, data, size, data.length)
		buffer	= tmp.dereference()
		tmp.free()
		buffer
	!function assert_no_error (error, object_to_free)
		if error == constants.NOISE_ERROR_NONE
			return
		for key, code of constants
			if code == error
				if object_to_free
					try
						object_to_free.free()
				throw new Error(key)

	/**
	 * The CipherState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-cipherstate-object
	 *
	 * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
	 * to call free() method, as it was called for you automatically already (except in EncryptWithAd and DecryptWithAd)
	 *
	 * @param {string} cipher constants.NOISE_CIPHER_CHACHAPOLY, constants.NOISE_CIPHER_AESGCM, etc.
	 */
	!function CipherState (cipher)
		if !(@ instanceof CipherState)
			return new CipherState(cipher)
		tmp		= allocate_pointer()
		error	= lib._noise_cipherstate_new_by_id(tmp, cipher)
		assert_no_error(error, tmp)
		@_state			= tmp.dereference()
		@_mac_length	= lib._noise_cipherstate_get_mac_length(@_state)
		tmp.free()

	CipherState:: =
		/**
		 * @param {Uint8Array} key
		 */
		InitializeKey	: (key) !->
			key		= allocate(0, key)
			error	= lib._noise_cipherstate_init_key(@_state, key, key.length)
			key.free()
			assert_no_error(error, @)
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
			error		= lib._noise_cipherstate_encrypt_with_ad(@_state, ad, ad.length, buffer)
			# Encryption happened in place with MAC at the end
			ciphertext	= plaintext.get()
			ad.free()
			plaintext.free()
			buffer.free()
			assert_no_error(error)
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
			error		= lib._noise_cipherstate_decrypt_with_ad(@_state, ad, ad.length, buffer)
			# Decryption happened in place, but we need to remove MAC from the end
			plaintext	= ciphertext.get().slice(0, ciphertext.length - @_mac_length)
			ad.free()
			ciphertext.free()
			buffer.free()
			assert_no_error(error)
			plaintext
		/**
		 * @return {boolean}
		 */
		Rekey			: !->
			# TODO: noise_cipherstate_rekey() is not implemented yet (https://github.com/rweather/noise-c/issues/24)
			throw 'Not implemented'
		/**
		 * Call this when object is not needed anymore to avoid memory leaks
		 */
		free			: !->
			error	= lib._noise_cipherstate_free(@_state)
			delete @_state
			delete @_mac_length
			assert_no_error(error)

	Object.defineProperty(CipherState::, 'constructor', {enumerable: false, value: CipherState})

	!function CipherState_split (state)
		@_state			= state
		@_mac_length	= lib._noise_cipherstate_get_mac_length(@_state)

	CipherState_split:: = Object.create(CipherState::)

	Object.defineProperty(CipherState_split::, 'constructor', {enumerable: false, value: CipherState_split})

	/**
	 * The SymmetricState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-symmetricstate-object
	 *
	 * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
	 * to call free() method, as it was called for you automatically already
	 *
	 * @param {string} protocol_name The name of the Noise protocol to use, for instance, Noise_N_25519_ChaChaPoly_BLAKE2b
	 */
	!function SymmetricState (protocol_name)
		if !(@ instanceof SymmetricState)
			return new SymmetricState(protocol_name)
		tmp				= allocate_pointer()
		protocol_name	= allocate(0, protocol_name)
		error			= lib._noise_symmetricstate_new_by_name(tmp, protocol_name)
		assert_no_error(error, tmp)
		@_state			= tmp.dereference()
		tmp.free()
		protocol_name.free()
		# MAC length is 0 until key is is not set, so let's define getter and replace it with fixed property once we have non-zero MAC length
		Object.defineProperty(@, '_mac_length', {
			configurable	: true
			get				: ~>
				mac_length	= lib._noise_symmetricstate_get_mac_length(@_state)
				if mac_length > 0
					@_mac_length	= mac_length
				mac_length
		})

	SymmetricState:: =
		/**
		 * @param {Uint8Array} input_key_material
		 */
		MixKey				: (input_key_material) !->
			input_key_material	= allocate(0, input_key_material)
			error				= lib._noise_symmetricstate_mix_key(@_state, input_key_material, input_key_material.length)
			input_key_material.free()
			assert_no_error(error, @)
		/**
		 * @param {Uint8Array} data
		 */
		MixHash				: (data) !->
			data	= allocate(0, data)
			error	= lib._noise_symmetricstate_mix_hash(@_state, data, data.length)
			data.free()
			assert_no_error(error, @)
		/**
		 * @param {Uint8Array} input_key_material
		 */
		MixKeyAndHash		: (input_key_material) !->
			# TODO: should be a single call to wrapper method in future versions of noise-c, also it will be possible to then remove _SymmetricState_get_ck
			@MixKey(input_key_material)
			tmp		= allocate_pointer()
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
			error		= lib._noise_symmetricstate_encrypt_and_hash(@_state, buffer)
			# Encryption happened in place with MAC at the end
			ciphertext	= plaintext.get()
			plaintext.free()
			buffer.free()
			assert_no_error(error, @)
			ciphertext
		/**
		 * @param {Uint8Array} ciphertext
		 *
		 * @return {Uint8Array}
		 */
		DecryptAndHash		: (ciphertext) ->
			ciphertext	= allocate(0, ciphertext)
			buffer		= allocate_buffer(ciphertext, ciphertext.length)
			error		= lib._noise_symmetricstate_decrypt_and_hash(@_state, buffer)
			# Decryption happened in place, but we need to remove MAC from the end
			plaintext	= ciphertext.get().slice(0, ciphertext.length - @_mac_length)
			ciphertext.free()
			buffer.free()
			assert_no_error(error, @)
			plaintext
		/**
		 * @return {CipherState[]}
		 */
		Split				: ->
			tmp1	= allocate_pointer()
			tmp2	= allocate_pointer()
			error	= lib._noise_symmetricstate_split(@_state, tmp1, tmp2)
			try
				assert_no_error(error)
			catch e
				tmp1.free()
				tmp2.free()
				throw e
			cs1		= new CipherState_split(tmp1.dereference())
			cs2		= new CipherState_split(tmp2.dereference())
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
		/**
		 * Call this when object is not needed anymore to avoid memory leaks
		 */
		free				: !->
			error	= lib._noise_symmetricstate_free(@_state)
			delete @_state
			delete @_mac_length
			assert_no_error(error)

	Object.defineProperty(SymmetricState::, 'constructor', {enumerable: false, value: SymmetricState})

	/**
	 * The HandshakeState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-handshakestate-object
	 *
	 * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
	 * to call free() method, as it was called for you automatically already (except in ReadMessage with fallback_supported == true)
	 *
	 * @param {string}	protocol_name	The name of the Noise protocol to use, for instance, Noise_N_25519_ChaChaPoly_BLAKE2b
	 * @param {number}	role			The role for the new object, either constants.NOISE_ROLE_INITIATOR or constants.NOISE_ROLE_RESPONDER
	 */
	!function HandshakeState (protocol_name, role)
		if !(@ instanceof HandshakeState)
			return new HandshakeState(protocol_name, role)
		tmp				= allocate_pointer()
		protocol_name	= allocate(0, protocol_name)
		error			= lib._noise_handshakestate_new_by_name(tmp, protocol_name, role)
		protocol_name.free()
		assert_no_error(error, tmp)
		@_state			= tmp.dereference()
		tmp.free()

	HandshakeState:: =
		/**
		 * Must be called after object creation and after switch to a fallback handshake.
		 *
		 * In case of fallback handshake it is not required to specify values that are the same as in previous Initialize() call, those will be used by default
		 *
		 * @param {null|Uint8Array}	prologue	Prologue value
		 * @param {null|Uint8Array}	s			Local static private key
		 * @param {null|Uint8Array}	rs			Remote static public key
		 * @param {null|Uint8Array}	psk			Pre-shared symmetric key
		 */
		Initialize		: (prologue = null, s = null, rs = null, psk = null) !->
			if prologue
				prologue	= allocate(0, prologue)
				error		= lib._noise_handshakestate_set_prologue(@_state, prologue, prologue.length)
				prologue.free()
				assert_no_error(error, @)
			if psk && lib._noise_handshakestate_needs_pre_shared_key(@_state) == 1
				psk		= allocate(0, psk)
				error	= lib._noise_handshakestate_set_pre_shared_key(@_state, psk, psk.length)
				psk.free()
				assert_no_error(error, @)
			if lib._noise_handshakestate_needs_local_keypair(@_state) == 1
				if !s
					throw new Error('Local static private key (s) required, but not provided')
				dh		= lib._noise_handshakestate_get_local_keypair_dh(@_state)
				s		= allocate(0, s)
				error	= lib._noise_dhstate_set_keypair_private(dh, s, s.length)
				s.free()
				assert_no_error(error, @)
			if lib._noise_handshakestate_needs_remote_public_key(@_state) == 1
				if !rs
					throw new Error('Remote static public key (rs) required, but not provided')
				dh		= lib._noise_handshakestate_get_remote_public_key_dh(@_state)
				rs		= allocate(0, rs)
				error	= lib._noise_dhstate_set_public_key(dh, rs, rs.length)
				rs.free()
				assert_no_error(error, @)
			error	= lib._noise_handshakestate_start(@_state)
			assert_no_error(error, @)
		/**
		 * @return {number} One of constants.NOISE_ACTION_*
		 */
		GetAction		: ->
			lib._noise_handshakestate_get_action(@_state)
		/**
		 * Might be called when GetAction() returned constants.NOISE_ACTION_FAILED and switching to fallback protocol is desired, don't forget to call Initialize()
		 * after FallbackTo()
		 *
		 * @param {number} pattern_id One of constants.NOISE_PATTERN_*_FALLBACK*
		 */
		FallbackTo		: (pattern_id = constants.NOISE_PATTERN_XX_FALLBACK) !->
			error	= lib._noise_handshakestate_fallback_to(@_state, pattern_id)
			assert_no_error(error, @)
		/**
		 * @param {null|Uint8Array} payload null if no payload is required
		 *
		 * @return {Uint8Array} Message that should be sent to the other side
		 */
		WriteMessage	: (payload = null) ->
			message			= allocate(constants.NOISE_MAX_PAYLOAD_LEN)
			message_buffer	= allocate_buffer(message, 0)
			payload_buffer	= null
			if payload
				payload			= allocate(0, payload)
				payload_buffer	= allocate_buffer(payload, payload.length)
			error			= lib._noise_handshakestate_write_message(@_state, message_buffer, payload_buffer)
			if payload
				payload.free()
				payload_buffer.free()
			try
				assert_no_error(error, @)
			catch e
				message.free()
				message_buffer.free()
				throw e
			message_length	= lib._NoiseBuffer_get_size(message_buffer)
			real_message	= message.get().slice(0, message_length)
			message.free()
			message_buffer.free()
			real_message
		/**
		 * @param {Uint8Array}	message				Message received from the other side
		 * @param {boolean}		payload_needed		false if the application does not need the message payload
		 * @param {boolean}		fallback_supported	true if application is ready to switch to fallback pattern (will throw, but without free() call on read failure)
		 *
		 * @return {null|Uint8Array}
		 */
		ReadMessage		: (message, payload_needed = false, fallback_supported = false) ->
			message			= allocate(0, message)
			message_buffer	= allocate_buffer(message, message.length)
			payload_buffer	= null
			if payload_needed
				payload			= allocate(constants.NOISE_MAX_PAYLOAD_LEN)
				payload_buffer	= allocate_buffer(payload, payload.length)
			error			= lib._noise_handshakestate_read_message(@_state, message_buffer, payload_buffer)
			message.free()
			message_buffer.free()
			try
				assert_no_error(error, if fallback_supported then undefined else @)
			catch e
				if payload_needed
					payload.free()
					payload_buffer.free()
				throw e
			real_payload	= null
			if payload_needed
				payload_length	= lib._NoiseBuffer_get_size(payload_buffer)
				real_payload	= payload.get().slice(0, payload_length)
				payload.free()
				payload_buffer.free()
			real_payload
		/**
		 * @return {CipherState[]} [send, receive]
		 */
		Split			: ->
			tmp1	= allocate_pointer()
			tmp2	= allocate_pointer()
			error	= lib._noise_handshakestate_split(@_state, tmp1, tmp2)
			try
				assert_no_error(error, @)
			catch e
				tmp1.free()
				tmp2.free()
				throw e
			cs1		= new CipherState_split(tmp1.dereference())
			cs2		= new CipherState_split(tmp2.dereference())
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
		/**
		 * Call this when object is not needed anymore to avoid memory leaks
		 */
		free			: !->
			error	= lib._noise_handshakestate_free(@_state)
			delete @_state
			assert_no_error(error)

	Object.defineProperty(HandshakeState::, 'constructor', {enumerable: false, value: HandshakeState})

	{
		'ready'				: lib.then
		'constants'			: constants
		'CipherState'		: CipherState
		'SymmetricState'	: SymmetricState
		'HandshakeState'	: HandshakeState
		'_lib_internal'		: lib
	}

function Wrapper (lib, constants)
	CreateLib.bind(@, lib, constants)

if typeof define == 'function' && define['amd']
	# AMD
	define(['./noise-c', './constants'], Wrapper)
else if typeof exports == 'object'
	# CommonJS
	module.exports = Wrapper(require('./noise-c'), require('./constants'))
else
	# Browser globals
	@'noise_c_wasm' = Wrapper(@'__noise_c_wasm', @'__noise_c_wasm_constants')
