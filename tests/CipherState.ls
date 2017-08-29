/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes	= require('crypto').randomBytes
lib			= require('..')
test		= require('tape')

ciphers		= ['NOISE_CIPHER_CHACHAPOLY', 'NOISE_CIPHER_AESGCM']
plaintexts	= [new Uint8Array, new Uint8Array(randombytes(10))]
ads			= [new Uint8Array, randombytes(256)]
key			= randombytes(32)

<-! lib.ready
for cipher in ciphers then for plaintext in plaintexts then for ad in ads
	test("CipherState: #cipher, plaintext length #{plaintext.length}, ad length #{ad.length}", (t) !->
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

test('CipherState: Check for encryption correctness', (t) !->
	cipher				= lib.constants.NOISE_CIPHER_CHACHAPOLY
	ad					= new Uint8Array
	key					= Uint8Array.of(103 44 175 22 144 52 61 214 154 153 60 234 70 144 22 34 240 20 7 9 179 240 243 197 67 246 236 147 147 164 122 70)
	known_plaintext		= Uint8Array.of(47 182 193 115 253 249 160 223 186 165)
	known_ciphertext	= Uint8Array.of(145 212 107 212 117 149 140 158 46 200 171 170 183 117 123 234 129 120 71 131 80 10 198 232 254 35)

	cs1					= new lib.CipherState(cipher)
	cs1.InitializeKey(key)
	ciphertext			= cs1.EncryptWithAd(ad, known_plaintext)
	t.equal(known_ciphertext.toString(), ciphertext.toString(), 'Encrypted correctly')
	cs1.free()

	cs2					= new lib.CipherState(cipher)
	cs2.InitializeKey(key)
	plaintext			= cs2.DecryptWithAd(ad, known_ciphertext)
	t.equal(known_plaintext.toString(), plaintext.toString(), 'Decrypted correctly')
	cs2.free()

	t.end()
)
