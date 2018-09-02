// Generated by LiveScript 1.5.0
/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
(function(){
  var exec, glob, gulp, rename, uglify;
  exec = require('child_process').exec;
  glob = require('glob');
  gulp = require('gulp');
  rename = require('gulp-rename');
  uglify = require('gulp-uglify');
  gulp.task('build', ['wasm', 'minify']).task('wasm', function(callback){
    var files, functions, optimize, clang_opts, command;
    files = ['vendor/src/protocol/cipherstate.c', 'vendor/src/protocol/dhstate.c', 'vendor/src/protocol/errors.c', 'vendor/src/protocol/handshakestate.c', 'vendor/src/protocol/hashstate.c', 'vendor/src/protocol/internal.c', 'vendor/src/protocol/names.c', 'vendor/src/protocol/patterns.c', 'vendor/src/protocol/randstate.c', 'vendor/src/protocol/signstate.c', 'vendor/src/protocol/symmetricstate.c', 'vendor/src/protocol/util.c', 'vendor/src/backend/ref/dh-curve448.c', 'vendor/src/backend/ref/dh-newhope.c', 'vendor/src/backend/ref/hash-blake2s.c', 'vendor/src/crypto/blake2/blake2s.c', 'vendor/src/crypto/curve448/curve448.c', 'vendor/src/crypto/goldilocks/src/p448/arch_32/p448.c', 'vendor/src/crypto/newhope/batcher.c', 'vendor/src/crypto/newhope/error_correction.c', 'vendor/src/crypto/newhope/fips202.c', 'vendor/src/crypto/newhope/newhope.c', 'vendor/src/crypto/newhope/ntt.c', 'vendor/src/crypto/newhope/poly.c', 'vendor/src/crypto/newhope/precomp.c', 'vendor/src/crypto/newhope/reduce.c', 'vendor/src/backend/ref/cipher-aesgcm.c', 'vendor/src/backend/ref/cipher-aesgcm.c', 'vendor/src/backend/ref/cipher-chachapoly.c', 'vendor/src/backend/ref/dh-curve25519.c', 'vendor/src/backend/ref/hash-blake2b.c', 'vendor/src/backend/ref/hash-sha256.c', 'vendor/src/backend/ref/hash-sha512.c', 'vendor/src/backend/ref/sign-ed25519.c', 'vendor/src/crypto/aes/rijndael-alg-fst.c', 'vendor/src/crypto/blake2/blake2b.c', 'vendor/src/crypto/chacha/chacha.c', 'vendor/src/crypto/donna/poly1305-donna.c', 'vendor/src/crypto/ghash/ghash.c', 'vendor/src/crypto/newhope/crypto_stream_chacha20.c', 'vendor/src/crypto/sha2/sha256.c', 'vendor/src/crypto/sha2/sha512.c', 'vendor/src/crypto/ed25519/ed25519.c'].join(' ');
    /**
     * There are many functions exposed by the library, but only subset of them is used in production, so the rest are still here, uncomment when/if needed
     * for debugging or other purposes
     *
     * _noise_handshakestate_get_fixed_ephemeral_dh, _noise_handshakestate_get_fixed_hybrid_dh and _noise_handshakestate_get_handshake_hash are only used in tests
     */
    functions = JSON.stringify(['_malloc', '_free', '_noise_cipherstate_decrypt_with_ad', '_noise_cipherstate_encrypt_with_ad', '_noise_cipherstate_free', '_noise_cipherstate_get_mac_length', '_noise_cipherstate_has_key', '_noise_cipherstate_init_key', '_noise_cipherstate_new_by_id', '_noise_cipherstate_set_nonce', '_noise_symmetricstate_decrypt_and_hash', '_noise_symmetricstate_encrypt_and_hash', '_noise_symmetricstate_free', '_noise_symmetricstate_get_mac_length', '_noise_symmetricstate_mix_hash', '_noise_symmetricstate_mix_key', '_noise_symmetricstate_new_by_name', '_noise_symmetricstate_split', '_noise_handshakestate_fallback_to', '_noise_handshakestate_free', '_noise_handshakestate_get_action', '_noise_handshakestate_get_fixed_ephemeral_dh', '_noise_handshakestate_get_fixed_hybrid_dh', '_noise_handshakestate_get_handshake_hash', '_noise_handshakestate_get_local_keypair_dh', '_noise_handshakestate_get_protocol_id', '_noise_handshakestate_get_remote_public_key_dh', '_noise_handshakestate_has_remote_public_key', '_noise_handshakestate_needs_local_keypair', '_noise_handshakestate_needs_pre_shared_key', '_noise_handshakestate_needs_remote_public_key', '_noise_handshakestate_new_by_name', '_noise_handshakestate_read_message', '_noise_handshakestate_set_pre_shared_key', '_noise_handshakestate_set_prologue', '_noise_handshakestate_split', '_noise_handshakestate_start', '_noise_handshakestate_write_message', '_noise_dhstate_free', '_noise_dhstate_generate_keypair', '_noise_dhstate_get_dh_id', '_noise_dhstate_get_keypair', '_noise_dhstate_new_by_id', '_noise_dhstate_set_keypair_private', '_noise_dhstate_set_public_key', '_NoiseBuffer_create', '_NoiseBuffer_get_size', '_SymmetricState_get_ck', '_NoiseProtocolId_get_dh_id', '_NoiseProtocolId_get_hash_id']);
    optimize = "-Oz --llvm-lto 1 --closure 1 -s NO_EXIT_RUNTIME=1 -s NO_FILESYSTEM=1 -s EXPORTED_RUNTIME_METHODS=[] -s DEFAULT_LIBRARY_FUNCS_TO_INCLUDE=[]";
    clang_opts = "-include " + __dirname + "/src/ed25519_random_and_hash.h -I vendor/include -I vendor/include/noise/keys -I vendor/src -I vendor/src/protocol -I vendor/src/crypto/goldilocks/src/include -I vendor/src/crypto/goldilocks/src/p448 -I vendor/src/crypto/goldilocks/src/p448/arch_32";
    command = "EMMAKEN_CFLAGS='" + clang_opts + "' emcc " + files + " src/noise-c.c src/ed25519_random_and_hash.c --js-library src/library_random_bytes.js --post-js src/bytes_allocation.js -o src/noise-c.js -s MODULARIZE=1 -s 'EXPORT_NAME=\"__noise_c_wasm\"' -s EXPORTED_FUNCTIONS='" + functions + "' -s WASM=1 " + optimize;
    exec(command, function(error, stdout, stderr){
      if (stdout) {
        console.log(stdout);
      }
      if (stderr) {
        console.error(stderr);
      }
      callback(error);
    });
  }).task('minify', function(){
    return gulp.src("src/index.js").pipe(uglify()).pipe(rename({
      suffix: '.min'
    })).pipe(gulp.dest('src'));
  });
}).call(this);
