/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
exec		= require('child_process').exec
glob		= require('glob')
gulp		= require('gulp')
rename		= require('gulp-rename')
uglify		= require('gulp-uglify')

gulp
	.task('build', ['wasm', 'minify'])
	.task('wasm', (callback) !->
		files		= [
			'vendor/src/protocol/cipherstate.c'
			'vendor/src/protocol/dhstate.c'
			'vendor/src/protocol/errors.c'
			'vendor/src/protocol/handshakestate.c'
			'vendor/src/protocol/hashstate.c'
			'vendor/src/protocol/internal.c'
			'vendor/src/protocol/names.c'
			'vendor/src/protocol/patterns.c'
			'vendor/src/protocol/randstate.c'
			'vendor/src/protocol/signstate.c'
			'vendor/src/protocol/symmetricstate.c'
			'vendor/src/protocol/util.c'
			'vendor/src/backend/ref/dh-curve448.c'
			'vendor/src/backend/ref/dh-newhope.c'
			'vendor/src/backend/ref/hash-blake2s.c'
			'vendor/src/crypto/blake2/blake2s.c'
			'vendor/src/crypto/curve448/curve448.c'
			'vendor/src/crypto/goldilocks/src/p448/arch_32/p448.c'
			'vendor/src/crypto/newhope/batcher.c'
			'vendor/src/crypto/newhope/error_correction.c'
			'vendor/src/crypto/newhope/fips202.c'
			'vendor/src/crypto/newhope/newhope.c'
			'vendor/src/crypto/newhope/ntt.c'
			'vendor/src/crypto/newhope/poly.c'
			'vendor/src/crypto/newhope/precomp.c'
			'vendor/src/crypto/newhope/reduce.c'
			'vendor/src/backend/ref/cipher-aesgcm.c'
			'vendor/src/backend/ref/cipher-aesgcm.c'
			'vendor/src/backend/ref/cipher-chachapoly.c'
			'vendor/src/backend/ref/dh-curve25519.c'
			'vendor/src/backend/ref/hash-blake2b.c'
			'vendor/src/backend/ref/hash-sha256.c'
			'vendor/src/backend/ref/hash-sha512.c'
			'vendor/src/backend/ref/sign-ed25519.c'
			'vendor/src/crypto/aes/rijndael-alg-fst.c'
			'vendor/src/crypto/blake2/blake2b.c'
			'vendor/src/crypto/chacha/chacha.c'
			'vendor/src/crypto/donna/poly1305-donna.c'
			'vendor/src/crypto/ghash/ghash.c'
			'vendor/src/crypto/newhope/crypto_stream_chacha20.c'
			'vendor/src/crypto/sha2/sha256.c'
			'vendor/src/crypto/sha2/sha512.c'
			'vendor/src/crypto/ed25519/ed25519.c'
		].join(' ')
		/**
		 * There are many functions exposed by the library, but only subset of them is used in production, so the rest are still here, uncomment when/if needed
		 * for debugging or other purposes
		 *
		 * _noise_handshakestate_get_fixed_ephemeral_dh, _noise_handshakestate_get_fixed_hybrid_dh and _noise_handshakestate_get_handshake_hash are only used in tests
		 */
		functions	= JSON.stringify([
			'_malloc'
			'_free'

#			'_noise_cipherstate_decrypt'
			'_noise_cipherstate_decrypt_with_ad'
#			'_noise_cipherstate_encrypt'
			'_noise_cipherstate_encrypt_with_ad'
			'_noise_cipherstate_free'
#			'_noise_cipherstate_get_cipher_id'
#			'_noise_cipherstate_get_key_length'
			'_noise_cipherstate_get_mac_length'
#			'_noise_cipherstate_get_max_key_length'
#			'_noise_cipherstate_get_max_mac_length'
			'_noise_cipherstate_has_key'
			'_noise_cipherstate_init_key'
			'_noise_cipherstate_new_by_id'
#			'_noise_cipherstate_new_by_name'
#			'_noise_cipherstate_set_nonce'

			'_noise_symmetricstate_decrypt_and_hash'
			'_noise_symmetricstate_encrypt_and_hash'
			'_noise_symmetricstate_free'
			'_noise_symmetricstate_get_mac_length'
#			'_noise_symmetricstate_get_protocol_id'
			'_noise_symmetricstate_mix_hash'
			'_noise_symmetricstate_mix_key'
#			'_noise_symmetricstate_new_by_id'
			'_noise_symmetricstate_new_by_name'
			'_noise_symmetricstate_split'

#			'_noise_handshakestate_fallback'
			'_noise_handshakestate_fallback_to'
			'_noise_handshakestate_free'
			'_noise_handshakestate_get_action'
			'_noise_handshakestate_get_fixed_ephemeral_dh'
			'_noise_handshakestate_get_fixed_hybrid_dh'
			'_noise_handshakestate_get_handshake_hash'
			'_noise_handshakestate_get_local_keypair_dh'
#			'_noise_handshakestate_get_protocol_id'
			'_noise_handshakestate_get_remote_public_key_dh'
#			'_noise_handshakestate_get_role'
#			'_noise_handshakestate_has_local_keypair'
#			'_noise_handshakestate_has_pre_shared_key'
#			'_noise_handshakestate_has_remote_public_key'
			'_noise_handshakestate_needs_local_keypair'
			'_noise_handshakestate_needs_pre_shared_key'
			'_noise_handshakestate_needs_remote_public_key'
#			'_noise_handshakestate_new_by_id'
			'_noise_handshakestate_new_by_name'
			'_noise_handshakestate_read_message'
			'_noise_handshakestate_set_pre_shared_key'
			'_noise_handshakestate_set_prologue'
			'_noise_handshakestate_split'
			'_noise_handshakestate_start'
			'_noise_handshakestate_write_message'

#			'_noise_hashstate_finalize'
#			'_noise_hashstate_free'
#			'_noise_hashstate_get_block_length'
#			'_noise_hashstate_get_hash_id'
#			'_noise_hashstate_get_hash_length'
#			'_noise_hashstate_get_max_block_length'
#			'_noise_hashstate_get_max_hash_length'
#			'_noise_hashstate_hash_one'
#			'_noise_hashstate_hash_two'
#			'_noise_hashstate_hkdf'
#			'_noise_hashstate_new_by_id'
#			'_noise_hashstate_new_by_name'
#			'_noise_hashstate_pbkdf2'
#			'_noise_hashstate_reset'
#			'_noise_hashstate_update'

#			'_noise_dhstate_calculate'
#			'_noise_dhstate_clear_key'
#			'_noise_dhstate_copy'
#			'_noise_dhstate_format_fingerprint'
#			'_noise_dhstate_free'
#			'_noise_dhstate_generate_dependent_keypair'
#			'_noise_dhstate_generate_keypair'
#			'_noise_dhstate_get_dh_id'
#			'_noise_dhstate_get_keypair'
#			'_noise_dhstate_get_private_key_length'
#			'_noise_dhstate_get_public_key'
#			'_noise_dhstate_get_public_key_length'
#			'_noise_dhstate_get_role'
#			'_noise_dhstate_get_shared_key_length'
#			'_noise_dhstate_has_keypair'
#			'_noise_dhstate_has_public_key'
#			'_noise_dhstate_is_ephemeral_only'
#			'_noise_dhstate_is_null_public_key'
#			'_noise_dhstate_new_by_id'
#			'_noise_dhstate_new_by_name'
#			'_noise_dhstate_set_keypair'
			'_noise_dhstate_set_keypair_private'
#			'_noise_dhstate_set_null_public_key'
			'_noise_dhstate_set_public_key'
#			'_noise_dhstate_set_role'

#			'_noise_signstate_clear_key'
#			'_noise_signstate_copy'
#			'_noise_signstate_format_fingerprint'
#			'_noise_signstate_free'
#			'_noise_signstate_generate_keypair'
#			'_noise_signstate_get_keypair'
#			'_noise_signstate_get_max_key_length'
#			'_noise_signstate_get_max_signature_length'
#			'_noise_signstate_get_private_key_length'
#			'_noise_signstate_get_public_key'
#			'_noise_signstate_get_public_key_length'
#			'_noise_signstate_get_sign_id'
#			'_noise_signstate_get_signature_length'
#			'_noise_signstate_has_keypair'
#			'_noise_signstate_has_public_key'
#			'_noise_signstate_new_by_id'
#			'_noise_signstate_new_by_name'
#			'_noise_signstate_set_keypair'
#			'_noise_signstate_set_keypair_private'
#			'_noise_signstate_set_public_key'
#			'_noise_signstate_sign'
#			'_noise_signstate_verify'

#			'_noise_randstate_free'
#			'_noise_randstate_generate (NoiseRandState *state, uint8_t '
#			'_noise_randstate_generate_simple (uint8_t '
#			'_noise_randstate_new'
#			'_noise_randstate_pad (NoiseRandState *state, uint8_t *payload, size_t orig_len, size_t'
#			'_noise_randstate_reseed'

#			'_noise_load_certificate_chain_from_buffer'
#			'_noise_load_certificate_chain_from_file'
#			'_noise_load_certificate_from_buffer'
#			'_noise_load_certificate_from_file'
#			'_noise_load_private_key_from_buffer'
#			'_noise_load_private_key_from_file'
#			'_noise_save_certificate_chain_to_buffer'
#			'_noise_save_certificate_chain_to_file'
#			'_noise_save_certificate_to_buffer'
#			'_noise_save_certificate_to_file'
#			'_noise_save_private_key_to_buffer'
#			'_noise_save_private_key_to_file'

#			'_noise_clean'
#			'_noise_format_fingerprint'
#			'_noise_free'
#			'_noise_init'
#			'_noise_is_equal'
#			'_noise_is_zero'
#			'_noise_new_object'

# Custom functions written for this port and are not part of noise-c
			'_NoiseBuffer_create'
			'_NoiseBuffer_get_size'
			'_SymmetricState_get_ck'
		])
		# Options that are only specified to optimize resulting file size and basically remove unused features
		optimize	= "-Oz --llvm-lto 1 --closure 1 -s NO_EXIT_RUNTIME=1 -s NO_FILESYSTEM=1 -s EXPORTED_RUNTIME_METHODS=[] -s DEFAULT_LIBRARY_FUNCS_TO_INCLUDE=[]"
		clang_opts	= "-include #__dirname/src/ed25519_random_and_hash.h -I vendor/include -I vendor/include/noise/keys -I vendor/src -I vendor/src/protocol -I vendor/src/crypto/goldilocks/src/include -I vendor/src/crypto/goldilocks/src/p448 -I vendor/src/crypto/goldilocks/src/p448/arch_32"
		command		= "EMMAKEN_CFLAGS='#clang_opts' emcc #files src/noise-c.c src/ed25519_random_and_hash.c --js-library src/library_random_bytes.js --post-js src/bytes_allocation.js -o src/noise-c.js -s MODULARIZE=1 -s 'EXPORT_NAME=\"__noise_c_wasm\"' -s EXPORTED_FUNCTIONS='#functions' -s WASM=1 #optimize"
		exec(command, (error, stdout, stderr) !->
			if stdout
				console.log(stdout)
			if stderr
				console.error(stderr)
			callback(error)
		)
	)
	.task('minify', ->
		gulp.src("src/index.js")
			.pipe(uglify())
			.pipe(rename(
				suffix: '.min'
			))
			.pipe(gulp.dest('src'))
	)
