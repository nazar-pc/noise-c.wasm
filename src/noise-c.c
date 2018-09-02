/**
 * @package noise-c.wasm
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
#include <stdlib.h>
#include <protocol/internal.h>

void NoiseBuffer_create (NoiseBuffer **buffer, uint8_t *data, size_t size, size_t max_size) {
	*buffer				= (NoiseBuffer*)malloc(sizeof(NoiseBuffer));
	(*buffer)->data		= data;
	(*buffer)->size		= size;
	(*buffer)->max_size	= max_size;
}

size_t NoiseBuffer_get_size (NoiseBuffer *buffer) {
	return buffer->size;
}

size_t SymmetricState_get_ck (NoiseSymmetricState *state, uint8_t **ck) {
	*ck	= state->ck;
	return NOISE_MAX_HASHLEN;
}

int NoiseProtocolId_get_dh_id (NoiseProtocolId *id) {
	return id->dh_id;
}

int NoiseProtocolId_get_hash_id (NoiseProtocolId *id) {
	return id->hash_id;
}
