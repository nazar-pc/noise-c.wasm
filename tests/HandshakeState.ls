/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
randombytes		= require('crypto').randomBytes
lib				= require('..')
test			= require('tape')
# Should be require()(), but https://github.com/kripken/emscripten/issues/5568
lib_internal	= require('../noise-c')#()

patterns			= [
	'N' 'X' 'K'
	'NN' 'NK' 'NX' 'XN' 'XK' 'XX' 'KN' 'KK' 'KX' 'IN' 'IK' 'IX'
]
curves				= ['25519' '448' 'NewHope']
ciphers				= ['ChaChaPoly' 'AESGCM']
hashes				= ['SHA256' 'SHA512' 'BLAKE2s' 'BLAKE2b']
prologues			= [null, new Uint8Array, randombytes(10)]
psks				= [null, new Uint8Array, randombytes(32)]
ads					= [new Uint8Array, randombytes(256)]
plaintexts			= [new Uint8Array, new Uint8Array(randombytes(10))]
static_keys			=
	NOISE_ROLE_INITIATOR	:
		private	:
			'25519'		: Uint8Array.of(230 30 249 145 156 222 69 221 95 130 22 100 4 189 8 227 139 206 181 223 223 222 208 163 76 141 247 237 84 34 20 209)
			'448'		: Uint8Array.of(52 213 100 196 190 150 61 27 42 137 252 254 131 230 167 43 94 63 94 49 39 249 245 150 255 199 87 94 65 141 252 31 78 130 124 252 16 201 254 211 142 146 173 86 221 248 240 133 113 67 13 242 231 109 84 17)
			'NewHope'	: Uint8Array.of(147 77 96 179 86 36 215 64 179 10 127 34 122 242 174 124 103 142 78 4 225 60 95 80 158 173 226 183 154 234 119 226 62 42 46 166 201 196 118 252 73 55 176 19 201 147 167 147 214 192 171 153 96 105 91 168 56 246 73 218 83 156 163 208)
		public	:
			'25519'		: Uint8Array.of(107 195 130 42 42 167 244 230 152 29 101 56 105 43 60 223 62 109 249 238 166 237 38 158 180 29 147 194 39 87 183 90)
			'448'		: Uint8Array.of(48 21 81 236 161 120 143 68 81 194 105 190 175 237 17 11 81 240 140 4 148 168 222 97 74 24 79 243 212 103 215 222 253 252 124 19 142 70 105 89 17 8 182 154 5 109 37 202 253 162 137 242 45 31 50 192)
			'NewHope'	: Uint8Array.of(168 87 243 193 45 30 164 60 205 4 235 201 237 141 120 83 105 228 126 118 50 90 172 119 136 220 116 152 103 100 82 219 119 142 125 80 211 151 197 225 121 74 223 37 147 219 195 34 172 33 76 115 55 211 216 58 215 168 25 163 99 86 83 211 46 129 51 180 165 136 138 10 224 34 73 122 16 16 167 29 55 198 40 160 94 224 226 160 50 109 39 40 239 51 91 185 144 66 50 234 161 121 156 98 15 43 93 33 202 70 236 166 186 80 118 198 165 4 71 131 95 213 52 65 200 86 227 142 126 138 210 106 79 91 210 57 199 63 194 136 155 10 235 68 191 253 190 231 135 193 242 164 190 5 249 147 210 43 22 248 173 69 147 12 89 60 80 101 245 196 59 86 108 204 126 87 97 160 167 146 217 28 66 225 135 85 136 132 114 233 19 153 160 127 62 72 184 19 100 74 25 221 14 154 26 226 250 95 136 150 30 15 11 22 240 92 21 31 139 145 224 0 100 35 173 207 195 114 233 194 97 224 47 151 54 150 112 104 112 137 157 199 25 106 38 44 207 46 246 137 232 2 119 136 57 10 91 32 18 169 28 69 230 248 113 137 194 144 191 216 222 105 74 82 217 233 242 45 180 149 150 133 102 228 128 80 21 131 159 171 133 125 64 82 10 84 30 129 216 113 13 199 158 186 186 224 117 78 217 165 133 137 8 129 18 20 86 45 7 193 52 64 243 21 44 169 238 225 21 35 6 109 224 180 137 55 179 77 232 225 93 136 73 9 149 118 165 32 92 132 81 11 23 137 225 125 175 155 108 9 196 76 0 94 220 44 96 113 196 228 184 187 229 203 248 121 185 143 193 100 154 33 98 228 34 130 17 111 180 198 18 103 17 194 184 216 61 21 191 163 143 151 38 198 201 82 130 77 5 202 159 134 191 240 14 78 180 107 44 78 73 85 187 194 2 101 63 133 228 60 25 50 38 71 10 161 79 35 159 232 112 16 210 180 241 206 240 182 21 159 71 116 169 160 37 13 199 37 212 249 13 108 91 137 65 165 232 81 12 55 209 53 32 130 118 65 94 155 82 53 167 212 32 246 225 73 137 112 4 3 98 17 147 233 124 24 103 14 102 45 105 168 77 184 28 192 242 209 24 218 54 57 169 195 86 79 222 72 195 76 80 87 160 37 25 92 43 19 2 23 245 21 114 150 49 102 125 94 139 110 5 60 73 195 240 56 171 228 37 128 192 168 55 46 156 25 64 74 13 140 38 104 43 240 190 152 70 119 173 203 249 235 226 8 102 162 122 194 231 182 159 148 160 198 192 233 177 60 151 88 105 83 101 220 177 15 5 246 85 2 174 88 73 134 197 225 243 56 134 78 35 101 100 93 240 166 199 229 122 139 131 150 18 172 160 80 73 216 194 71 109 234 185 183 239 89 25 9 198 205 0 183 113 134 236 166 232 57 208 105 155 184 227 167 6 70 230 6 171 211 138 34 31 100 112 77 91 105 40 46 48 143 174 155 143 54 50 209 50 140 26 129 48 188 4 106 115 72 233 50 206 144 51 136 8 110 52 57 186 109 162 108 219 162 21 249 40 124 236 252 51 245 166 131 212 160 83 40 79 62 65 1 192 154 64 79 106 78 60 219 18 26 137 169 23 10 81 37 195 57 180 183 244 163 16 18 71 158 76 17 215 38 82 129 145 89 74 194 217 180 244 12 178 167 104 171 19 49 162 104 179 107 191 186 170 228 147 176 77 210 26 202 10 97 89 34 110 233 41 80 163 104 24 14 231 244 90 169 71 89 174 240 55 120 106 41 231 245 71 51 218 93 7 106 190 195 173 93 188 16 67 205 72 240 34 110 139 146 115 1 17 216 139 90 67 98 48 88 214 66 8 106 254 84 82 216 165 167 147 186 198 10 102 78 6 203 206 155 223 133 188 43 201 8 196 8 160 177 118 17 37 87 78 248 2 198 171 234 106 218 52 183 126 202 34 102 38 4 72 143 142 118 34 157 116 10 45 224 96 144 97 220 99 244 192 173 176 84 250 84 61 205 47 160 19 90 57 21 104 187 153 210 98 163 192 167 86 74 236 102 55 89 158 243 137 14 193 147 76 163 134 39 216 78 159 224 232 186 246 161 116 173 23 103 237 132 238 218 89 165 3 69 249 149 76 73 143 76 136 42 201 101 14 3 142 250 118 98 109 23 66 22 144 212 153 117 15 41 103 115 37 87 181 168 150 10 102 199 105 94 70 7 72 176 20 95 86 7 240 8 251 202 117 165 176 83 199 183 74 51 136 50 146 135 148 87 156 104 62 250 225 32 22 63 108 167 111 108 183 89 72 38 96 50 65 237 35 109 156 180 193 199 116 231 77 94 59 96 84 6 184 0 202 112 179 99 56 160 81 73 89 156 212 177 112 79 41 92 102 195 53 89 17 212 120 42 136 133 26 24 122 63 75 199 247 151 138 200 54 158 237 155 66 254 156 22 168 130 223 19 157 228 95 46 235 26 97 222 196 37 67 40 56 217 229 20 90 236 197 52 208 76 114 154 197 104 183 72 69 121 87 21 71 59 36 136 146 138 159 143 106 184 159 33 43 207 169 165 180 88 17 69 199 89 233 103 252 168 164 186 27 45 168 14 64 173 72 194 203 68 234 122 87 245 77 232 242 43 121 50 196 172 219 112 78 152 25 68 67 183 50 168 25 0 60 158 22 23 12 74 0 9 235 0 70 2 136 129 170 202 215 89 20 50 106 121 47 104 116 131 41 150 103 192 174 226 169 156 18 236 74 214 219 65 241 134 149 87 136 200 214 0 85 158 131 117 99 172 142 156 70 218 38 160 52 213 107 163 225 104 75 185 172 129 114 19 41 112 122 42 159 212 229 236 23 159 68 121 188 226 117 152 108 89 185 52 110 177 16 111 36 20 120 143 134 213 183 254 22 127 222 161 65 100 124 147 41 128 8 65 79 73 86 114 34 134 10 197 193 65 248 225 99 231 85 86 187 69 66 183 2 23 22 165 231 4 75 244 235 70 10 185 21 202 100 46 66 37 237 3 25 51 232 146 130 193 3 55 233 146 57 18 197 219 231 65 236 154 162 197 89 58 234 158 104 153 101 110 45 201 226 53 159 229 146 67 240 95 81 91 151 75 78 153 28 184 152 85 76 0 193 66 216 39 160 12 193 64 31 109 12 103 92 173 167 62 230 150 146 231 238 9 19 181 175 92 151 0 130 232 196 180 48 91 179 152 194 28 127 161 75 76 137 197 93 92 253 25 166 193 108 157 88 154 46 117 16 96 248 49 61 199 185 167 54 192 68 225 10 254 107 254 164 190 136 89 99 24 47 142 174 191 162 238 203 182 177 2 95 92 77 247 128 230 146 6 110 95 180 132 209 119 88 82 42 196 168 181 180 255 228 56 17 81 101 170 66 25 94 134 18 65 127 247 195 230 160 126 172 175 141 175 245 118 57 68 121 73 203 185 135 194 28 3 193 129 125 106 45 78 137 48 214 82 2 57 38 166 123 199 210 119 37 5 182 101 224 47 231 67 124 87 188 12 165 122 205 245 100 154 170 58 22 245 105 174 181 163 140 39 193 184 15 174 168 172 181 21 0 110 128 35 190 246 224 141 17 162 24 173 59 104 146 60 70 69 168 244 9 242 170 235 223 81 116 149 36 116 168 230 139 38 65 113 72 216 20 79 177 6 96 12 166 219 176 136 59 26 12 3 206 133 128 216 122 136 153 92 88 84 220 117 131 157 83 244 233 57 238 62 208 130 12 183 55 236 73 253 231 124 153 135 224 83 88 89 130 48 8 36 132 28 12 93 134 134 129 156 225 17 49 120 103 193 80 104 145 30 9 47 237 74 186 83 167 161 185 64 111 100 140 34 2 107 253 39 99 75 92 119 75 0 37 44 65 85 11 10 45 0 64 214 132 194 2 89 170 149 208 149 248 187 58 12 164 218 226 224 196 253 104 201 78 159 51 15 169 111 39 30 127 9 83 121 155 158 92 91 21 121 129 120 52 154 158 140 145 209 22 120 15 249 199 219 96 137 237 76 6 179 78 218 168 72 187 255 217 133 66 130 126 83 49 190)
	NOISE_ROLE_RESPONDER	:
		private	:
			'25519'		: Uint8Array.of(74 58 203 253 177 99 222 198 81 223 163 25 77 236 230 118 212 55 2 156 98 164 8 180 197 234 145 20 36 110 72 147)
			'448'		: Uint8Array.of(169 180 89 113 24 8 130 167 155 137 163 57 149 68 164 37 239 129 54 210 120 239 164 67 237 103 211 255 157 54 232 131 188 51 12 98 149 187 246 237 115 255 111 209 12 190 215 103 173 5 206 3 235 210 124 124)
			'NewHope'	: Uint8Array.of(186 197 186 136 29 211 92 89 113 150 112 0 70 146 214 117 184 60 152 219 106 14 85 128 11 175 235 126 112 73 27 244)
		public	:
			'25519'		: Uint8Array.of(49 224 48 63 214 65 141 47 140 14 120 185 31 34 232 202 237 15 190 72 101 109 207 71 103 228 131 79 112 27 143 98)
			'448'		: Uint8Array.of(189 32 15 166 213 13 179 167 67 121 123 0 172 161 183 15 65 123 252 56 27 40 178 27 88 53 216 76 247 166 218 106 187 161 158 59 167 212 107 37 52 18 183 70 101 212 98 123 101 252 239 63 41 201 93 62)
			'NewHope'	: Uint8Array.of(159 168 224 5 154 156 89 155 163 235 86 76 174 33 185 128 128 162 190 24 65 55 198 148 163 141 134 91 239 77 88 17 138 110 13 129 141 137 148 159 238 91 225 7 4 89 241 224 68 225 102 184 67 78 238 45 96 149 252 250 198 5 127 72 140 36 164 191 34 115 113 234 157 150 109 113 29 173 143 237 26 14 8 78 189 8 134 160 205 48 168 129 212 137 184 192 92 150 85 202 93 136 19 84 141 18 160 138 104 214 241 186 23 65 220 6 114 154 171 76 108 250 71 26 114 176 145 202 212 57 141 86 153 116 207 149 235 119 98 157 19 12 249 139 69 68 188 231 231 104 202 242 66 137 68 64 111 23 11 72 40 68 158 218 90 161 90 27 32 42 231 59 65 29 0 158 47 145 137 237 100 22 134 0 31 120 56 64 121 9 142 197 234 172 158 74 217 86 89 200 247 104 190 145 210 237 119 10 245 138 33 26 145 227 191 148 86 14 154 17 67 46 80 161 48 29 15 53 56 30 118 0 13 154 196 255 170 65 40 109 35 81 41 206 135 195 201 167 123 1 234 175 19 109 167 71 113 73 188 158 173 218 120 147 17 7 137 45 153 96 9 245 54 191 68 189 208 95 118 93 105 150 48 59 242 236 57 22 228 220 251 15 254 98 238 169 96 122 253 217 136 3 73 126 209 76 190 13 177 96 17 69 214 158 77 209 98 87 217 120 168 8 218 173 3 242 172 153 6 47 138 167 103 220 42 141 23 237 109 100 5 185 63 243 196 149 97 108 84 75 94 66 114 122 3 77 20 187 95 229 209 140 64 187 182 132 0 168 191 73 121 243 71 170 81 8 26 107 112 10 196 41 135 62 190 174 131 16 199 155 89 144 11 226 62 68 176 228 157 211 222 23 117 110 252 61 221 144 185 50 73 48 178 180 25 147 136 75 53 11 95 15 80 68 101 62 138 123 148 144 170 67 69 83 156 206 120 176 110 24 154 182 209 191 36 2 37 78 37 194 220 183 230 200 56 194 224 74 145 234 90 123 95 101 12 82 40 157 13 73 44 164 171 49 188 37 17 78 237 103 17 204 8 0 211 120 177 174 116 26 126 34 119 23 188 156 12 251 196 115 245 7 97 56 143 106 210 228 3 161 149 21 102 231 244 19 88 79 50 195 6 85 240 129 33 38 105 115 224 60 49 12 25 151 249 35 71 232 182 118 215 251 65 120 249 146 245 68 221 33 60 81 103 177 104 199 21 82 224 119 4 153 132 232 210 34 134 232 75 124 226 9 26 118 192 166 135 69 154 109 114 183 36 208 1 253 150 174 230 109 11 91 9 12 59 137 107 39 217 0 194 132 69 96 13 133 48 5 75 71 31 110 241 45 126 97 130 132 9 7 95 232 39 4 204 133 251 233 112 115 243 133 175 107 117 233 96 110 195 23 150 224 72 180 75 169 50 74 43 178 84 223 22 167 171 144 22 76 3 94 66 18 67 161 76 97 210 151 114 91 138 187 91 97 34 199 23 41 40 188 204 74 231 117 21 154 84 97 22 120 158 18 160 156 68 10 176 63 93 148 184 200 84 9 219 237 160 188 28 114 150 104 221 103 120 86 1 11 156 65 82 70 84 205 146 87 2 105 42 7 53 228 253 68 136 13 236 131 192 55 237 101 23 17 92 40 5 86 2 100 140 122 102 71 181 22 219 29 141 40 240 184 153 170 28 224 240 154 229 61 161 94 24 105 131 53 65 128 206 142 208 125 238 135 165 103 206 24 183 5 190 97 15 208 165 81 133 15 121 163 100 168 129 21 51 139 6 68 33 221 120 18 230 131 209 151 84 130 66 86 95 158 183 13 68 63 134 12 25 208 194 170 28 132 234 241 180 249 9 33 201 235 40 241 211 60 54 249 28 231 116 32 221 120 23 157 17 224 239 61 116 131 94 4 104 79 129 79 221 70 83 235 177 106 187 180 16 74 187 13 25 50 37 80 66 55 6 30 88 190 82 215 234 227 217 176 185 216 248 64 30 78 26 78 10 184 132 53 152 72 6 66 154 230 30 69 93 8 135 211 16 172 193 151 192 159 81 192 97 136 134 236 221 47 193 107 29 47 8 5 214 58 137 118 139 31 83 122 209 91 220 181 171 43 103 151 142 70 174 223 217 228 9 30 193 32 166 233 151 5 155 90 68 57 159 144 120 170 97 52 69 64 67 132 7 112 165 108 38 148 34 72 161 77 96 203 235 39 104 33 62 30 132 32 195 91 217 132 250 67 215 11 28 73 189 24 99 63 161 244 174 40 250 32 90 230 16 124 181 112 195 149 101 22 101 60 215 35 204 212 160 164 47 15 161 105 2 23 113 23 19 207 242 119 86 50 168 80 167 172 97 107 30 189 89 36 199 217 211 140 45 50 110 190 243 84 92 36 148 81 185 80 109 58 185 36 146 198 146 109 141 29 225 44 180 151 123 161 115 15 223 254 51 97 138 40 183 87 10 138 255 106 30 196 35 35 177 20 52 60 20 129 181 56 61 250 78 166 136 20 165 213 16 98 50 30 207 226 55 16 86 176 40 83 149 216 78 56 122 157 134 33 117 38 0 147 152 134 132 56 224 48 255 167 223 131 135 89 158 116 194 236 128 222 173 59 201 220 122 217 71 189 175 79 144 225 232 111 20 154 2 108 107 91 141 53 167 28 192 177 242 184 230 120 41 37 178 139 180 209 111 3 171 84 132 96 160 93 176 233 193 218 245 229 43 153 200 82 122 11 161 131 133 14 4 248 220 140 123 14 42 193 185 13 196 17 166 70 184 216 48 182 187 243 93 160 197 2 210 125 181 111 103 168 255 188 128 110 225 85 119 147 153 43 82 100 152 40 226 209 145 50 95 21 34 120 209 164 56 129 11 64 60 150 149 229 238 98 43 38 106 115 156 219 160 89 178 109 64 133 47 97 212 14 156 31 167 28 116 199 210 77 20 143 87 105 224 102 186 183 16 238 101 227 136 146 104 169 19 200 84 167 225 161 219 39 162 41 170 250 148 170 89 65 148 24 72 161 45 129 241 16 156 81 120 145 228 194 87 130 146 164 64 75 103 163 97 161 24 224 220 118 40 106 66 90 26 83 138 55 111 46 178 251 214 5 90 90 30 86 139 93 219 171 27 88 28 41 142 211 248 80 84 146 126 88 101 113 112 74 71 39 8 224 129 183 80 117 77 0 194 9 0 55 135 82 41 230 192 61 226 135 121 140 37 244 68 53 37 118 205 60 118 25 14 51 29 139 144 55 162 72 123 74 66 128 200 70 141 158 253 223 41 226 238 32 43 110 155 95 21 20 140 154 6 212 15 246 25 165 125 237 239 46 10 223 5 97 141 8 237 49 250 89 1 208 225 156 8 191 192 33 46 232 60 10 51 198 64 140 131 225 27 117 86 76 137 45 150 59 72 206 118 186 211 229 249 111 224 4 232 70 64 6 156 90 125 141 172 239 41 52 201 76 172 138 185 215 138 64 77 146 18 137 107 111 185 169 5 9 235 107 69 97 75 201 151 198 218 83 18 143 68 98 209 242 2 242 176 142 94 228 64 161 232 128 114 232 217 176 229 188 20 26 137 57 118 236 146 60 113 147 210 102 117 70 134 48 31 48 244 154 122 97 228 108 196 27 86 13 139 75 7 49 230 74 5 81 27 145 125 64 188 122 78 188 200 9 134 251 122 133 199 154 58 144 233 40 69 189 168 118 187 45 20 26 37 175 209 165 131 168 170 97 169 243 39 142 29 169 147 219 247 138 200 48 146 81 166 133 241 135 6 19 227 5 102 115 235 34 47 162 171 187 67 181 81 0 59 44 101 162 98 132 105 46 1 3 248 101 208 118 125 93 219 59 176 32 1 222 171 186 203 20 220 123 185 105 219 50 232 186 50 60 11 237 6 252 173 186 13 140 139 68 153 242 129 65 138 113 17 223 117 106 203 18 141 149 229 173 115 19 202 228 69 82 40 37 204 109 71 232 18 1 28 94 93 111 147 65 201 73 11 173 244 251 166 75 94 77 89 137 141 153 141 130 47 132 106 161 39 31 37 14 175 247 85 77 83 137 76 130 45 56)
roles_keys			=
	'NOISE_ROLE_INITIATOR'
	'NOISE_ROLE_RESPONDER'
	null
no_empty_keys		=
	# Any pattern that starts with K, X or I requires initiator's static private key
	local	: /^[KXI]/
	# Any one-way pattern or pattern that ends with K, X or I requires responders's static public key
	remote	: /(^.|[KXI])$/
roundtrip_halves	=
	1	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE']
	2	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE']
	3	:
		initiator	: ['NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE']
		responder	: ['NOISE_ACTION_READ_MESSAGE' 'NOISE_ACTION_WRITE_MESSAGE' 'NOISE_ACTION_READ_MESSAGE']
expected_actions	=
	N	: roundtrip_halves.1
	X	: roundtrip_halves.1
	K	: roundtrip_halves.1
	NN	: roundtrip_halves.2
	NK	: roundtrip_halves.2
	NX	: roundtrip_halves.2
	XN	: roundtrip_halves.3
	XK	: roundtrip_halves.3
	XX	: roundtrip_halves.3
	KN	: roundtrip_halves.2
	KK	: roundtrip_halves.2
	KX	: roundtrip_halves.2
	IN	: roundtrip_halves.2
	IK	: roundtrip_halves.2
	IX	: roundtrip_halves.2

# Convenient for debugging common issues instead of looping through thousands of combinations
#patterns	= [patterns[0]]
#curves		= [curves[0]]
#ciphers		= [ciphers[0]]
#hashes		= [hashes[0]]
#prologues	= [prologues[0]]
#psks		= [psks[0]]
#ads			= [ads[0]]
#plaintexts	= [plaintexts[0]]

<-! lib.ready
for let pattern in patterns => for let curve in curves => for let cipher in ciphers => for let hash in hashes => for let prologue in prologues => for let psk in psks => for let role_key_s in roles_keys => for let role_key_rs in roles_keys
	# NewHope not supported with other patterns: https://rweather.github.io/noise-c/index.html#algorithms
	if curve == 'NewHope' && pattern != 'NN'
		return
	# Skip some loops where patterns require local or remote keys to be present, but they are `null` for this particular loop iteration
	if !role_key_s && no_empty_keys.local.test(pattern)
		return
	if !role_key_rs && no_empty_keys.remote.test(pattern)
		return
	protocol_name	= "Noise_#{pattern}_#{curve}_#{cipher}_#{hash}"
	prologue_title	= if prologue then "length #{prologue.length}" else 'null'
	psk_title		= if psk then "length #{psk.length}" else 'null'

	for let ad in ads => for let plaintext in plaintexts
		test("HandshakeState: #protocol_name, prologue #prologue_title, psk #psk_title, role_key_s #role_key_s, role_key_rs #role_key_rs, plaintext length #{plaintext.length}, ad length #{ad.length}", (t) !->
			var initiator_hs, responder_hs
			t.doesNotThrow (!->
				initiator_hs	:= new lib.HandshakeState(protocol_name, lib.constants.NOISE_ROLE_INITIATOR)
			), "Initiator constructor doesn't throw an error"

			t.doesNotThrow (!->
				responder_hs	:= new lib.HandshakeState(protocol_name, lib.constants.NOISE_ROLE_RESPONDER)
			), "Responder constructor doesn't throw an error"

			t.doesNotThrow (!->
				s	= role_key_s
				if s
					s	= static_keys[s].private[curve]
				rs	= role_key_rs
				if rs
					rs	= static_keys[rs].public[curve]
				initiator_hs.Initialize(prologue, s, rs, psk)
			), "Initiator Initialize() doesn't throw an error"

			t.doesNotThrow (!->
				s	= role_key_rs
				if s
					s	= static_keys[s].private[curve]
				rs	= role_key_s
				if rs
					rs	= static_keys[rs].public[curve]
				responder_hs.Initialize(prologue, s, rs, psk)
			), "Responder Initialize() doesn't throw an error"

			initiator_actions	= expected_actions[pattern].initiator.slice()
			responder_actions	= expected_actions[pattern].responder.slice()
			var message
			:initiator_loop while action = initiator_actions.shift()
				if action
					t.equal(initiator_hs.GetAction(), lib.constants[action], "Initiator expected action: #action")

				switch action
					case 'NOISE_ACTION_WRITE_MESSAGE'
						t.doesNotThrow (!->
							message	:= initiator_hs.WriteMessage()
						), "Initiator WriteMessage() doesn't throw an error"

						while action = responder_actions.shift()
							if action
								t.equal(responder_hs.GetAction(), lib.constants[action], "Responder expected action: #action")

							switch action
								case 'NOISE_ACTION_READ_MESSAGE'
									t.doesNotThrow (!->
										responder_hs.ReadMessage(message)
									), "Responder ReadMessage() doesn't throw an error"

								case 'NOISE_ACTION_WRITE_MESSAGE'
									t.doesNotThrow (!->
										message	:= responder_hs.WriteMessage()
									), "Responder WriteMessage() doesn't throw an error"

									continue initiator_loop

					case 'NOISE_ACTION_READ_MESSAGE' ''
						t.doesNotThrow (!->
							initiator_hs.ReadMessage(message)
						), "Initiator ReadMessage() doesn't throw an error"

			t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, 'Initiator is ready to split')
			t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, 'Responder is ready to split')

			var initiator_send, initiator_receive
			t.doesNotThrow (!->
				[initiator_send, initiator_receive]	:= initiator_hs.Split()
			), "Initiator Split() doesn't throw an error"
			t.ok(initiator_send instanceof lib.CipherState, 'Initiator Element #1 after Split() implements CipherState')
			t.ok(initiator_receive instanceof lib.CipherState, 'Initiator Element #2 after Split() implements CipherState')

			t.throws (!->
				initiator_hs.Initialize(plaintext)
			), "Initiator HandshakeState shouldn't be usable after Split() is called"

			var responder_send, responder_receive
			t.doesNotThrow (!->
				[responder_send, responder_receive]	:= responder_hs.Split()
			), "Responder Split() doesn't throw an error"
			t.ok(responder_send instanceof lib.CipherState, 'Responder Element #1 after Split() implements CipherState')
			t.ok(responder_receive instanceof lib.CipherState, 'Responder Element #2 after Split() implements CipherState')

			t.throws (!->
				responder_hs.Initialize(plaintext)
			), "Responder HandshakeState shouldn't be usable after Split() is called"

			# Initiator sends data
			ciphertext	= initiator_send.EncryptWithAd(ad, plaintext)

			t.equal(ciphertext.length, plaintext.length + initiator_send._mac_length, 'Initiator ciphertext has expected length')
			# Empty plaintext will be, obviously, the same as empty ciphertext
			if plaintext.length
				t.notEqual(ciphertext.slice(0, plaintext.length).toString(), plaintext.toString(), 'Initiator ciphertext is not the same as plaintext')
			initiator_send.free()

			# Responder receives data
			plaintext_decrypted	= responder_receive.DecryptWithAd(ad, ciphertext)
			responder_receive.free()

			t.equal(plaintext_decrypted.toString(), plaintext.toString(), 'Responder plaintext decrypted correctly')

			# Responder sends data
			ciphertext	= responder_send.EncryptWithAd(ad, plaintext)

			t.equal(ciphertext.length, plaintext.length + responder_send._mac_length, 'Responder ciphertext has expected length')
			# Empty plaintext will be, obviously, the same as empty ciphertext
			if plaintext.length
				t.notEqual(ciphertext.slice(0, plaintext.length).toString(), plaintext.toString(), 'Responder ciphertext is not the same as plaintext')
			responder_send.free()

			# Initiator receives data
			plaintext_decrypted	= initiator_receive.DecryptWithAd(ad, ciphertext)
			initiator_receive.free()

			t.equal(plaintext_decrypted.toString(), plaintext.toString(), 'Initiator plaintext decrypted correctly')

			t.end()
		)

known_prologue			= Uint8Array.of(43 32 195 206 138 156 161 18 151 93)
known_plaintext			= Uint8Array.of(57 250 199 143 113 176 210 75 100 38)
known_ad				= Uint8Array.of(240 104 34 55 185 175 63 127 129 111)
fixed_ephemeral			= Uint8Array.of(127 210 108 139 138 13 92 152 200 95 249 202 29 123 198 109 120 87 139 159 44 76 23 8 80 116 139 39 153 39 103 230 234 108 201 153 42 86 28 157 25 223 195 66 226 96 194 128 239 79 63 155 143 135 157 78)
initiator_ciphertext	= Uint8Array.of(95 85 166 4 191 171 103 202 218 205 57 60 42 43 221 13 179 231 27 58 170 168 114 58 107 19)
responder_ciphertext	= Uint8Array.of(172 42 69 220 217 91 2 152 7 238 167 34 157 21 242 97 46 236 129 73 50 199 252 69 12 118)

!function set_fixed_ephemeral (hs)
	dh		= lib_internal._noise_handshakestate_get_fixed_ephemeral_dh(hs._state)
	if dh
		s		= lib_internal.allocateBytes(0, fixed_ephemeral)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != lib.constants.NOISE_ERROR_NONE
			throw new Error(error)
	dh		= lib_internal._noise_handshakestate_get_fixed_hybrid_dh(hs._state)
	if dh
		s		= lib_internal.allocateBytes(0, fixed_ephemeral)
		error	= lib_internal._noise_dhstate_set_keypair_private(dh, s, s.length)
		s.free()
		if error != lib.constants.NOISE_ERROR_NONE
			throw new Error(error)

test("HandshakeState: Fallback testing", (t) !->
	var initiator_hs, responder_hs, message
	var initiator_send, initiator_receive
	var responder_send, responder_receive

	t.doesNotThrow (!->
		initiator_hs	:= new lib.HandshakeState('Noise_IK_448_ChaChaPoly_BLAKE2b', lib.constants.NOISE_ROLE_INITIATOR)
		responder_hs	:= new lib.HandshakeState('Noise_IK_448_ChaChaPoly_BLAKE2b', lib.constants.NOISE_ROLE_RESPONDER)

		# Fix ephemeral key pairs in order to get predictable ciphertext
		set_fixed_ephemeral(initiator_hs)
		set_fixed_ephemeral(responder_hs)

		initiator_hs.Initialize(known_prologue, static_keys.NOISE_ROLE_INITIATOR.private.448, static_keys.NOISE_ROLE_RESPONDER.public.448)
		responder_hs.Initialize(randombytes(10), static_keys.NOISE_ROLE_RESPONDER.private.448, static_keys.NOISE_ROLE_RESPONDER.public.448)

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Initiator expected action: NOISE_ACTION_WRITE_MESSAGE")

		# Start IK handshake pattern
		message	:= initiator_hs.WriteMessage()

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Initiator expected action: NOISE_ACTION_READ_MESSAGE")

		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Responder expected action: NOISE_ACTION_READ_MESSAGE")
	), "Preparation goes well"

	t.throws (!->
		# IK handshake pattern fails here
		responder_hs.ReadMessage(message, false, true)
	), "Responder ReadMessage() throws an error because of different prologue"

	t.doesNotThrow (!->
		# Fallback to XX handshake pattern
		responder_hs.FallbackTo(lib.constants.NOISE_PATTERN_XX_FALLBACK)
		responder_hs.Initialize(known_prologue)
	), "Responder FallbackTo() and Initialize() doesn't throw an error"


	t.doesNotThrow (!->
		# Responder starts XX handshake pattern
		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Responder expected action: NOISE_ACTION_WRITE_MESSAGE")

		message	:= responder_hs.WriteMessage()

		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Responder expected action: NOISE_ACTION_READ_MESSAGE")

		# Initiator fallbacks to XX pattern too
		t.doesNotThrow (!->
			initiator_hs.FallbackTo(lib.constants.NOISE_PATTERN_XX_FALLBACK)
			initiator_hs.Initialize()
		), "Initiator FallbackTo() and Initialize() doesn't throw an error"

		# Initiator now expects to read message from responder that initialized XX fallback handshake pattern
		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_READ_MESSAGE, "Initiator expected action: NOISE_ACTION_READ_MESSAGE")

		initiator_hs.ReadMessage(message)

		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_WRITE_MESSAGE, "Initiator expected action: NOISE_ACTION_WRITE_MESSAGE")

		message	:= initiator_hs.WriteMessage()

		# Initiator is ready to split
		t.equal(initiator_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, "Initiator expected action: NOISE_ACTION_SPLIT")

		responder_hs.ReadMessage(message)

		# Responder is ready to split
		t.equal(responder_hs.GetAction(), lib.constants.NOISE_ACTION_SPLIT, "Responder expected action: NOISE_ACTION_SPLIT")

		[initiator_send, initiator_receive]	:= initiator_hs.Split()
		[responder_send, responder_receive]	:= responder_hs.Split()
	), "The rest goes well too"

	# Initiator sends data
	ciphertext	= initiator_send.EncryptWithAd(known_ad, known_plaintext)

	t.equal(ciphertext.toString(), initiator_ciphertext.toString(), "Initiator plaintext encrypted correctly")
	initiator_send.free()

	# Responder receives data
	plaintext_decrypted	= responder_receive.DecryptWithAd(known_ad, ciphertext)
	responder_receive.free()

	t.equal(plaintext_decrypted.toString(), known_plaintext.toString(), 'Responder plaintext decrypted correctly')

	# Responder sends data
	ciphertext	= responder_send.EncryptWithAd(known_ad, known_plaintext)

	t.equal(ciphertext.toString(), responder_ciphertext.toString(), 'Responder plaintext encrypted correctly')
	responder_send.free()

	# Initiator receives data
	plaintext_decrypted	= initiator_receive.DecryptWithAd(known_ad, ciphertext)
	initiator_receive.free()

	t.equal(plaintext_decrypted.toString(), known_plaintext.toString(), 'Initiator plaintext decrypted correctly')

	t.end()
)
