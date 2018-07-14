/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
lib			= require('..')()
randombytes	= require('crypto').randomBytes
test		= require('tape')

patterns	= [
	'N' 'X' 'K'
	'NN' 'NK' 'NX' 'XN' 'XK' 'XX' 'KN' 'KK' 'KX' 'IN' 'IK' 'IX'
	'XXfallback'
	'Xnoidh' 'NXnoidh' 'XXnoidh' 'KXnoidh' 'IKnoidh' 'IXnoidh'
	'NNhfs' 'NKhfs' 'NXhfs' 'XNhfs' 'XKhfs' 'XXhfs' 'KNhfs' 'KKhfs' 'KXhfs' 'INhfs' 'IKhfs' 'IXhfs'
	'XXfallback+hfs' 'NXnoidh+hfs' 'XXnoidh+hfs' 'KXnoidh+hfs' 'IKnoidh+hfs' 'IXnoidh+hfs'
]
curves		= ['25519' '448' 'NewHope']
ciphers		= ['ChaChaPoly' 'AESGCM']
hashes		= ['SHA256' 'SHA512' 'BLAKE2s' 'BLAKE2b']
plaintexts	= [new Uint8Array, Uint8Array.from(randombytes(10))]
random1		= randombytes(32)
random2		= randombytes(64)
random3		= randombytes(128)

# Convenient for debugging common issues instead of looping through thousands of combinations
#patterns	= [patterns[0]]
#curves		= [curves[0]]
#ciphers		= [ciphers[0]]
#hashes		= [hashes[0]]
#plaintexts	= [plaintexts[0]]

<-! lib.ready
for let pattern in patterns => for let curve in curves => for let cipher in ciphers => for let hash in hashes => for let plaintext in plaintexts
	protocol_name	= "Noise_#{pattern}_#{curve}_#{cipher}_#{hash}"
	test("SymmetricState: #protocol_name, plaintext length #{plaintext.length}", (t) !->
		var ss1
		t.doesNotThrow (!->
			ss1	:= lib.SymmetricState(protocol_name)
		), "Constructor doesn't throw an error"

		t.doesNotThrow (!->
			ss1.MixKey(random1)
		), "MixKey() doesn't throw an error"
		t.doesNotThrow (!->
			ss1.MixHash(random2)
		), "MixHash() doesn't throw an error"
		t.doesNotThrow (!->
			ss1.MixKeyAndHash(random3)
		), "MixKeyAndHash() doesn't throw an error"

		var ciphertext
		t.doesNotThrow (!->
			ciphertext	:= ss1.EncryptAndHash(plaintext)
		), "EncryptAndHash() doesn't throw an error"
		t.equal(ciphertext.length, plaintext.length + ss1._mac_length, 'ciphertext length is plaintext length + MAC')
		# Empty plaintext will be, obviously, the same as empty ciphertext
		if plaintext.length
			t.notEqual(plaintext.toString(), ciphertext.slice(0, plaintext.length).toString(), 'Plaintext and ciphertext are different')

		ciphertext2	= ss1.EncryptAndHash(plaintext)
		t.notEqual(ciphertext.toString(), ciphertext2.toString(), "Subsequent encryption doesn't have the same result")
		ss1.free()

		t.throws (!->
			ss1.EncryptAndHash(new Uint8Array, plaintext)
		), Error, "SymmetricState() shouldn't be usable after free() is called"

		ss2	= lib.SymmetricState(protocol_name)
		ss2.MixKey(random1)
		ss2.MixHash(random2)
		ss2.MixKeyAndHash(random3)
		var plaintext_decrypted
		t.doesNotThrow (!->
			plaintext_decrypted	:= ss2.DecryptAndHash(ciphertext)
		), "DecryptAndHash() doesn't throw an error"
		t.equal(plaintext.toString(), plaintext_decrypted.toString(), 'Plaintext decrypted correctly')

		t.throws (!->
			ss2.DecryptAndHash(ciphertext)
		), Error, 'Subsequent decryption fails'
		# No need to call free(), since we've failed during last call

		ss3	= lib.SymmetricState(protocol_name)
		ss3.MixKey(random1)
		ss3.MixHash(random2)
		ss3.MixKeyAndHash(random3)
		var cs1, cs2
		t.doesNotThrow (!->
			[cs1, cs2]	:= ss3.Split()
		), "Split() doesn't throw an error"
		t.ok(cs1 instanceof lib.CipherState, 'Element #1 after Split() implements CipherState')
		t.ok(cs2 instanceof lib.CipherState, 'Element #2 after Split() implements CipherState')
		cs1.free()
		cs2.free()

		t.throws (!->
			ss3.EncryptAndHash(plaintext)
		), Error, "SymmetricState shouldn't be usable after Split() is called"

		t.end()
	)

protocol_name		= "Noise_N_448_ChaChaPoly_BLAKE2b"
key					= Buffer.from('672caf1690343dd69a993cea46901622f0140709b3f0f3c543f6ec9393a47a46', 'hex')
known_plaintext		= Buffer.from('2fb6c173fdf9a0dfbaa5', 'hex')
known_ciphertext	= Buffer.from('472c69a4b2dacd0b4f4c0ff98d113aac2f52c533622f9710345f', 'hex')
random1				= Buffer.from('329f3e489d464f629baa2ed17daf14e0', 'hex')
random2				= Buffer.from('a3297da8389fe404a843fbffcf32e39fdcb324a1d1b81f5aba875bc79652f318', 'hex')
random3				= Buffer.from('fce9bea6a335d78fb7f3f7ddda156d257e33c98c42c3bc873fd628e171428dd9', 'hex')

test('SymmetricState: Check for encryption correctness', (t) !->
	ss1					= lib.SymmetricState(protocol_name)
	ss1.MixKey(random1)
	ss1.MixHash(random2)
	ss1.MixKeyAndHash(random3)
	ciphertext			= ss1.EncryptAndHash(known_plaintext)
	t.equal(ciphertext.toString(), Uint8Array.from(known_ciphertext).toString(), 'Encrypted correctly')
	ss1.free()

	ss2					= lib.SymmetricState(protocol_name)
	ss2.MixKey(random1)
	ss2.MixHash(random2)
	ss2.MixKeyAndHash(random3)
	plaintext			= ss2.DecryptAndHash(known_ciphertext)
	t.equal(plaintext.toString(), Uint8Array.from(known_plaintext).toString(), 'Decrypted correctly')
	ss2.free()

	t.end()
)
