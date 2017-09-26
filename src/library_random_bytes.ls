/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
mergeInto(LibraryManager.library, {
	noise_rand_bytes	: (offset, size) !->
		randombytes	= require('./src/randombytes')
		HEAPU8.set(randombytes(size), offset)
})
