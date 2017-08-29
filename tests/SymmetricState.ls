/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes	= require('crypto').randomBytes
lib			= require('..')
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
plaintexts	= [new Uint8Array, new Uint8Array(randombytes(10))]
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
			ss1	:= new lib.SymmetricState(protocol_name)
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
		), "SymmetricState() shouldn't be usable after .free() is called"

		ss2	= new lib.SymmetricState(protocol_name)
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
		ss2.free()

		ss3	= new lib.SymmetricState(protocol_name)
		ss3.MixKey(random1)
		ss3.MixHash(random2)
		ss3.MixKeyAndHash(random3)
		var cs1, cs2
		t.doesNotThrow (!->
			[cs1, cs2]	:= ss3.Split()
		), "Split() doesn't throw an error"
		t.ok(cs1 instanceof lib.CipherState, 'Element #1 after Split() implements CipherState')
		t.ok(cs2 instanceof lib.CipherState, 'Element #2 after Split() implements CipherState')

		t.throws (!->
			ss3.EncryptAndHash(plaintext)
		), "SymmetricState shouldn't be usable after Split() is called"

		t.end()
	)

test('SymmetricState: Check for encryption correctness', (t) !->
	protocol_name		= "Noise_N_448_ChaChaPoly_BLAKE2b"
	key					= Uint8Array.of(103 44 175 22 144 52 61 214 154 153 60 234 70 144 22 34 240 20 7 9 179 240 243 197 67 246 236 147 147 164 122 70)
	known_plaintext		= Uint8Array.of(47 182 193 115 253 249 160 223 186 165)
	known_ciphertext	= Uint8Array.of(71 44 105 164 178 218 205 11 79 76 15 249 141 17 58 172 47 82 197 51 98 47 151 16 52 95)
	random1				= Uint8Array.of(50 159 62 72 157 70 79 98 155 170 46 209 125 175 20 224)
	random2				= Uint8Array.of(163 41 125 168 56 159 228 4 168 67 251 255 207 50 227 159 220 179 36 161 209 184 31 90 186 135 91 199 150 82 243 24)
	random3				= Uint8Array.of(252 233 190 166 163 53 215 143 183 243 247 221 218 21 109 37 126 51 201 140 66 195 188 135 63 214 40 225 113 66 141 217)

	ss1					= new lib.SymmetricState(protocol_name)
	ss1.MixKey(random1)
	ss1.MixHash(random2)
	ss1.MixKeyAndHash(random3)
	ciphertext			= ss1.EncryptAndHash(known_plaintext)
	t.equal(known_ciphertext.toString(), ciphertext.toString(), 'Encrypted correctly')
	ss1.free()

	ss2					= new lib.SymmetricState(protocol_name)
	ss2.MixKey(random1)
	ss2.MixHash(random2)
	ss2.MixKeyAndHash(random3)
	plaintext			= ss2.DecryptAndHash(known_ciphertext)
	t.equal(known_plaintext.toString(), plaintext.toString(), 'Decrypted correctly')
	ss2.free()

	t.end()
)
