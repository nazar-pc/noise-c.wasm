/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes	= require('crypto').randomBytes
lib			= require('..')
test		= require('tape')

lib.ready !->
	for cipher in ['NOISE_CIPHER_CHACHAPOLY', 'NOISE_CIPHER_AESGCM']
		for plaintext in [new Uint8Array, new Uint8Array(randombytes(10))]
			for ad in [new Uint8Array, randombytes(256)]
				test("CipherState (#cipher, plaintext length #{plaintext.length}, ad length #{ad.length}): Encryption/decryption with additional data", (t) !->
					key			= randombytes(32)

					var cs1
					t.doesNotThrow (!->
						cs1	:= new lib.CipherState(lib.constants[cipher])
					), "Constructor doesn't throw an error"
					t.equal(cs1.HasKey(), false, 'No key initially')

					cs1.InitializeKey(key)
					t.equal(cs1.HasKey(), true, 'Key was initialized')

					var ciphertext
					t.doesNotThrow (!->
						ciphertext	:= cs1.EncryptWithAd(ad, plaintext)
					), "EncryptWithAd() doesn't throw an error"
					t.equal(ciphertext.length, plaintext.length + cs1._mac_length, 'ciphertext length is plaintext length + MAC')
					t.notEqual(plaintext.toString(), ciphertext.slice(0, plaintext.length).toString(), 'Plaintext and ciphertext are different')

					ciphertext2	= cs1.EncryptWithAd(ad, plaintext)
					t.notEqual(ciphertext.toString(), ciphertext2.toString(), "Subsequent encryption doesn't have the same result")
					cs1.free()

					t.throws (!->
						cs1.EncryptWithAd(new Uint8Array, plaintext)
					), "CipherState shouldn't be usable after free() is called"

					cs2	= new lib.CipherState(lib.constants[cipher])
					cs2.InitializeKey(key)
					var plaintext_decrypted
					t.doesNotThrow (!->
						plaintext_decrypted	:= cs2.DecryptWithAd(ad, ciphertext)
					), "DecryptWithAd() doesn't throw an error"
					t.equal(plaintext.toString(), plaintext_decrypted.toString(), 'Plaintext decrypted correctly')

					t.throws (!->
						cs2.DecryptWithAd(ad, ciphertext)
					), Error, 'Subsequent decryption fails'
					cs2.free()

					cs3	= new lib.CipherState(lib.constants[cipher])
					cs3.InitializeKey(key)
					t.throws (!->
						cs3.DecryptWithAd(randombytes(256), ciphertext)
					), Error, 'Plaintext decryption with incorrect additional data fails'
					cs3.free()

					cs4	= new lib.CipherState(lib.constants[cipher])
					cs4.InitializeKey(key)
					t.throws (!->
						cs4.DecryptWithAd(ad, randombytes(256))
					), Error, 'Plaintext decryption with incorrect ciphertext fails'
					cs4.free()

					t.end()
				)

