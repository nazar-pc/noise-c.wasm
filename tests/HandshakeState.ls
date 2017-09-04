/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes	= require('crypto').randomBytes
lib			= require('..')
test		= require('tape')

patterns		= [
	'N' 'X' 'K'
	'NN' 'NK' 'NX' 'XN' 'XK' 'XX' 'KN' 'KK' 'KX' 'IN' 'IK' 'IX'
]
curves			= ['25519' '448'/* 'NewHope'*/]
ciphers			= ['ChaChaPoly' 'AESGCM']
hashes			= ['SHA256' 'SHA512' 'BLAKE2s' 'BLAKE2b']
roles			= ['NOISE_ROLE_INITIATOR' 'NOISE_ROLE_RESPONDER']
prologues		= [null, new Uint8Array, randombytes(10)]
psks			= [null, new Uint8Array, randombytes(32)]
plaintexts		= [new Uint8Array, new Uint8Array(randombytes(10))]
static_keys		=
	NOISE_ROLE_INITIATOR	:
		private	:
			'25519'	: Uint8Array.of(230 30 249 145 156 222 69 221 95 130 22 100 4 189 8 227 139 206 181 223 223 222 208 163 76 141 247 237 84 34 20 209)
			'448'	: Uint8Array.of(52 213 100 196 190 150 61 27 42 137 252 254 131 230 167 43 94 63 94 49 39 249 245 150 255 199 87 94 65 141 252 31 78 130 124 252 16 201 254 211 142 146 173 86 221 248 240 133 113 67 13 242 231 109 84 17)
		public	:
			'25519'	: Uint8Array.of(107 195 130 42 42 167 244 230 152 29 101 56 105 43 60 223 62 109 249 238 166 237 38 158 180 29 147 194 39 87 183 90)
			'448'	: Uint8Array.of(48 21 81 236 161 120 143 68 81 194 105 190 175 237 17 11 81 240 140 4 148 168 222 97 74 24 79 243 212 103 215 222 253 252 124 19 142 70 105 89 17 8 182 154 5 109 37 202 253 162 137 242 45 31 50 192)
	NOISE_ROLE_RESPONDER	:
		private	:
			'25519'	: Uint8Array.of(74 58 203 253 177 99 222 198 81 223 163 25 77 236 230 118 212 55 2 156 98 164 8 180 197 234 145 20 36 110 72 147)
			'448'	: Uint8Array.of(169 180 89 113 24 8 130 167 155 137 163 57 149 68 164 37 239 129 54 210 120 239 164 67 237 103 211 255 157 54 232 131 188 51 12 98 149 187 246 237 115 255 111 209 12 190 215 103 173 5 206 3 235 210 124 124)
		public	:
			'25519'	: Uint8Array.of(49 224 48 63 214 65 141 47 140 14 120 185 31 34 232 202 237 15 190 72 101 109 207 71 103 228 131 79 112 27 143 98)
			'448'	: Uint8Array.of(189 32 15 166 213 13 179 167 67 121 123 0 172 161 183 15 65 123 252 56 27 40 178 27 88 53 216 76 247 166 218 106 187 161 158 59 167 212 107 37 52 18 183 70 101 212 98 123 101 252 239 63 41 201 93 62)
roles_keys		=
	'NOISE_ROLE_INITIATOR'
	'NOISE_ROLE_RESPONDER'
	null
no_empty_keys	=
	# Any pattern that starts with K, X or I requires initiator's static private key
	local	: /^[KXI]/
	# Any one-way pattern or pattern that ends with K, X or I requires responders's static public key
	remote	: /(^.|[KXI])$/
no_empty_keys	=
	NOISE_ROLE_INITIATOR	:
		local	: no_empty_keys.local
		remote	: no_empty_keys.remote
	NOISE_ROLE_RESPONDER	:
		local	: no_empty_keys.remote
		remote	: no_empty_keys.local

# Convenient for debugging common issues instead of looping through thousands of combinations
#patterns	= [patterns[0]]
#curves		= [curves[0]]
#ciphers		= [ciphers[0]]
#hashes		= [hashes[0]]
#prologues	= [prologues[0]]
#psks		= [psks[0]]
#plaintexts	= [plaintexts[0]]

<-! lib.ready
for let pattern in patterns => for let curve in curves => for let cipher in ciphers => for let hash in hashes => for let role in roles => for let prologue in prologues => for let psk in psks => for let role_key_s in roles_keys => for let role_key_rs in roles_keys
	# Skip some loops where patterns require local or remote keys to be present, but they are `null` for this particular loop iteration
	if !role_key_s && no_empty_keys[role].local.test(pattern)
		return
	if !role_key_rs && no_empty_keys[role].remote.test(pattern)
		return
	protocol_name	= "Noise_#{pattern}_#{curve}_#{cipher}_#{hash}"
	prologue_title	= if prologue then "length #{prologue.length}" else 'null'
	psk_title		= if psk then "length #{psk.length}" else 'null'
	test("HandshakeState: #protocol_name, role #role, prologue #prologue_title, psk #psk_title, role_key_s #role_key_s, role_key_rs #role_key_rs", (t) !->
		var hs1
		t.doesNotThrow (!->
			hs1	:= new lib.HandshakeState(protocol_name, lib.constants[role])
		), "Constructor doesn't throw an error"

		t.doesNotThrow (!->
			s	= role_key_s
			if s
				s	= static_keys[s].private[curve]
			rs	= role_key_rs
			if rs
				rs	= static_keys[rs].public[curve]
			hs1.Initialize(prologue, s, rs, psk)
		), "Initialize() doesn't throw an error"

		var action
		t.doesNotThrow (!->
			action	:= hs1.GetAction()
		), "GetAction() doesn't throw an error"

		t.ok(action == lib.constants.NOISE_ACTION_READ_MESSAGE || action == lib.constants.NOISE_ACTION_WRITE_MESSAGE, 'GetAction() initially returns either read or write')
		hs1.free()

		t.throws (!->
			hs1.Initialize(plaintext)
		), "HandshakeState shouldn't be usable after free() is called"

		t.end()
	)
