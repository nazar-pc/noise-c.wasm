/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
lib			= require('..')()
randombytes	= require('crypto').randomBytes
test		= require('tape')

ciphers		= ['NOISE_CIPHER_CHACHAPOLY', 'NOISE_CIPHER_AESGCM']
plaintexts	= [new Uint8Array, Uint8Array.from(randombytes(10))]
ads			= [new Uint8Array, randombytes(256)]
key			= randombytes(32)

# Convenient for debugging common issues instead of looping through thousands of combinations
#ciphers		= [ciphers[0]]
#plaintexts	= [plaintexts[0]]

<-! lib.ready
for let cipher in ciphers => for let plaintext in plaintexts => for let ad in ads
	test("CipherState: #cipher, plaintext length #{plaintext.length}, ad length #{ad.length}", (t) !->
		var cs1
		t.doesNotThrow (!->
			cs1	:= lib.CipherState(lib.constants[cipher])
		), "Constructor doesn't throw an error"
		t.equal(cs1.HasKey(), false, 'No key initially')

		cs1.InitializeKey(key)
		t.equal(cs1.HasKey(), true, 'Key was initialized')

		var ciphertext
		t.doesNotThrow (!->
			ciphertext	:= cs1.EncryptWithAd(ad, plaintext)
		), "EncryptWithAd() doesn't throw an error"
		t.equal(ciphertext.length, plaintext.length + cs1._mac_length, 'ciphertext length is plaintext length + MAC')
		# Empty plaintext will be, obviously, the same as empty ciphertext
		if plaintext.length
			t.notEqual(plaintext.toString(), ciphertext.slice(0, plaintext.length).toString(), 'Plaintext and ciphertext are different')

		ciphertext2	= cs1.EncryptWithAd(ad, plaintext)
		t.notEqual(ciphertext.toString(), ciphertext2.toString(), "Subsequent encryption doesn't have the same result")
		cs1.free()

		t.throws (!->
			cs1.EncryptWithAd(new Uint8Array, plaintext)
		), Error, "CipherState shouldn't be usable after free() is called"

		cs2	= lib.CipherState(lib.constants[cipher])
		cs2.InitializeKey(key)
		var plaintext_decrypted
		t.doesNotThrow (!->
			plaintext_decrypted	:= cs2.DecryptWithAd(ad, ciphertext)
		), "DecryptWithAd() doesn't throw an error"
		t.equal(plaintext.toString(), plaintext_decrypted.toString(), 'Plaintext decrypted correctly')

		t.throws (!->
			cs2.DecryptWithAd(ad, ciphertext)
		), Error, 'Subsequent decryption fails'
		# No need to call free(), since we've failed during last call

		cs3	= lib.CipherState(lib.constants[cipher])
		cs3.InitializeKey(key)
		t.throws (!->
			cs3.DecryptWithAd(randombytes(256), ciphertext)
		), Error, 'Plaintext decryption with incorrect additional data fails'
		cs3.free()

		cs4	= lib.CipherState(lib.constants[cipher])
		cs4.InitializeKey(key)
		t.throws (!->
			cs4.DecryptWithAd(ad, randombytes(256))
		), Error, 'Plaintext decryption with incorrect ciphertext fails'
		cs4.free()

		t.end()
	)

cipher				= lib.constants.NOISE_CIPHER_CHACHAPOLY
ad					= new Uint8Array
key					= Buffer.from('672caf1690343dd69a993cea46901622f0140709b3f0f3c543f6ec9393a47a46', 'hex')
known_plaintext		= Buffer.from('2fb6c173fdf9a0dfbaa5', 'hex')
known_ciphertext	= Buffer.from('91d46bd475958c9e2ec8abaab7757bea81784783500ac6e8fe23', 'hex')

test('CipherState: Check for encryption correctness', (t) !->
	cs1					= lib.CipherState(cipher)
	cs1.InitializeKey(key)
	ciphertext			= cs1.EncryptWithAd(ad, known_plaintext)
	t.equal(ciphertext.toString(), Uint8Array.from(known_ciphertext).toString(), 'Encrypted correctly')
	cs1.free()

	cs2					= lib.CipherState(cipher)
	cs2.InitializeKey(key)
	plaintext			= cs2.DecryptWithAd(ad, known_ciphertext)
	t.equal(plaintext.toString(), Uint8Array.from(known_plaintext).toString(), 'Decrypted correctly')
	cs2.free()

	t.end()
)


test('CipherState: Nonce increment on failed decryption', (t) !->
	cs	= lib.CipherState(cipher)
	cs.InitializeKey(key)
	# Intentionally causing decryption to fail
	try
		cs.DecryptWithAd(ad, new Uint8Array(known_ciphertext.length))
	plaintext	= cs.DecryptWithAd(ad, known_ciphertext)
	t.equal(plaintext.toString(), Uint8Array.from(known_plaintext).toString(), 'Decrypted correctly')
	cs.free()

	t.end()
)
