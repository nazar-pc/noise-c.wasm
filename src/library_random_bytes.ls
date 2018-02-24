/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
mergeInto(LibraryManager.library, {
	noise_rand_bytes	: (offset, size) !->
		HEAPU8.set(Module['_random_bytes'](size), offset)
})
