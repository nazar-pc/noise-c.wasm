/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
/**
 * Obtained using `vendor/include/noise/protocol/constants.h` converted to JavaScript and post-processed with Prepack to eliminate runtime computations
 *
 * There are many constants exposed by the library, but only subset of them is used in production, so the rest are still here, uncomment when/if needed
 * for debugging or other purposes
 */
constants =
# AEAD cipher algorithms
	NOISE_CIPHER_NONE				: 0
#	NOISE_CIPHER_CATEGORY			: 17152
	NOISE_CIPHER_CHACHAPOLY			: 17153
	NOISE_CIPHER_AESGCM				: 17154

# Hash algorithms
#	NOISE_HASH_NONE					: 0
#	NOISE_HASH_CATEGORY				: 18432
	NOISE_HASH_BLAKE2s				: 18433
	NOISE_HASH_BLAKE2b				: 18434
	NOISE_HASH_SHA256				: 18435
	NOISE_HASH_SHA512				: 18436

# Diffie-Hellman algorithms
#	NOISE_DH_NONE					: 0
#	NOISE_DH_CATEGORY				: 17408
	NOISE_DH_CURVE25519				: 17409
	NOISE_DH_CURVE448				: 17410
#	NOISE_DH_NEWHOPE				: 17411

# Handshake patterns
#	NOISE_PATTERN_NONE				: 0
#	NOISE_PATTERN_CATEGORY			: 20480
#	NOISE_PATTERN_N					: 20481
#	NOISE_PATTERN_X					: 20482
#	NOISE_PATTERN_K					: 20483
#	NOISE_PATTERN_NN				: 20484
#	NOISE_PATTERN_NK				: 20485
#	NOISE_PATTERN_NX				: 20486
#	NOISE_PATTERN_XN				: 20487
#	NOISE_PATTERN_XK				: 20488
#	NOISE_PATTERN_XX				: 20489
#	NOISE_PATTERN_KN				: 20490
#	NOISE_PATTERN_KK				: 20491
#	NOISE_PATTERN_KX				: 20492
#	NOISE_PATTERN_IN				: 20493
#	NOISE_PATTERN_IK				: 20494
#	NOISE_PATTERN_IX				: 20495
	NOISE_PATTERN_XX_FALLBACK		: 20496
#	NOISE_PATTERN_X_NOIDH			: 20512
#	NOISE_PATTERN_NX_NOIDH			: 20513
#	NOISE_PATTERN_XX_NOIDH			: 20514
#	NOISE_PATTERN_KX_NOIDH			: 20515
#	NOISE_PATTERN_IK_NOIDH			: 20516
#	NOISE_PATTERN_IX_NOIDH			: 20517
#	NOISE_PATTERN_NN_HFS			: 20528
#	NOISE_PATTERN_NK_HFS			: 20529
#	NOISE_PATTERN_NX_HFS			: 20530
#	NOISE_PATTERN_XN_HFS			: 20531
#	NOISE_PATTERN_XK_HFS			: 20532
#	NOISE_PATTERN_XX_HFS			: 20533
#	NOISE_PATTERN_KN_HFS			: 20534
#	NOISE_PATTERN_KK_HFS			: 20535
#	NOISE_PATTERN_KX_HFS			: 20536
#	NOISE_PATTERN_IN_HFS			: 20537
#	NOISE_PATTERN_IK_HFS			: 20538
#	NOISE_PATTERN_IX_HFS			: 20539
	NOISE_PATTERN_XX_FALLBACK_HFS	: 20540
#	NOISE_PATTERN_NX_NOIDH_HFS		: 20560
#	NOISE_PATTERN_XX_NOIDH_HFS		: 20561
#	NOISE_PATTERN_KX_NOIDH_HFS		: 20562
#	NOISE_PATTERN_IK_NOIDH_HFS		: 20563
#	NOISE_PATTERN_IX_NOIDH_HFS		: 20564

# Protocol name prefixes
#	NOISE_PREFIX_NONE				: 0
#	NOISE_PREFIX_CATEGORY			: 19968
#	NOISE_PREFIX_STANDARD			: 19969
#	NOISE_PREFIX_PSK				: 19970

# Signature algorithms
#	NOISE_SIGN_NONE					: 0
#	NOISE_SIGN_CATEGORY				: 21248
#	NOISE_SIGN_ED25519				: 21249

# Role for this end of the communications
	NOISE_ROLE_INITIATOR			: 20993
	NOISE_ROLE_RESPONDER			: 20994

# Actions for the application to take, as directed by the HandshakeState
	NOISE_ACTION_NONE				: 0
	NOISE_ACTION_WRITE_MESSAGE		: 16641
	NOISE_ACTION_READ_MESSAGE		: 16642
	NOISE_ACTION_FAILED				: 16643
	NOISE_ACTION_SPLIT				: 16644
#	NOISE_ACTION_COMPLETE			: 16645

# Padding modes for noise_cipherstate_pad()
#	NOISE_PADDING_ZERO				: 18177
#	NOISE_PADDING_RANDOM			: 18178

# Key fingerprint types
#	NOISE_FINGERPRINT_BASIC			: 17921
#	NOISE_FINGERPRINT_FULL			: 17922

# Error codes
	NOISE_ERROR_NONE				: 0
	NOISE_ERROR_NO_MEMORY			: 17665
	NOISE_ERROR_UNKNOWN_ID			: 17666
	NOISE_ERROR_UNKNOWN_NAME		: 17667
	NOISE_ERROR_MAC_FAILURE			: 17668
	NOISE_ERROR_NOT_APPLICABLE		: 17669
	NOISE_ERROR_SYSTEM				: 17670
	NOISE_ERROR_REMOTE_KEY_REQUIRED	: 17671
	NOISE_ERROR_LOCAL_KEY_REQUIRED	: 17672
	NOISE_ERROR_PSK_REQUIRED		: 17673
	NOISE_ERROR_INVALID_LENGTH		: 17674
	NOISE_ERROR_INVALID_PARAM		: 17675
	NOISE_ERROR_INVALID_STATE		: 17676
	NOISE_ERROR_INVALID_NONCE		: 17677
	NOISE_ERROR_INVALID_PRIVATE_KEY	: 17678
	NOISE_ERROR_INVALID_PUBLIC_KEY	: 17679
	NOISE_ERROR_INVALID_FORMAT		: 17680
	NOISE_ERROR_INVALID_SIGNATURE	: 17681

# Maximum length of a packet payload
	NOISE_MAX_PAYLOAD_LEN			: 65535

# Maximum length of a protocol name string
#	NOISE_MAX_PROTOCOL_NAME			: 128

# Recommended maximum length for fingerprint buffers
#	NOISE_MAX_FINGERPRINT_LEN		: 256

if typeof define == 'function' && define['amd']
	# AMD
	define(-> constants)
else if typeof exports == 'object'
	# CommonJS
	module.exports = constants
else
	# Browser globals
	@'__noise_c_wasm_constants' = constants
