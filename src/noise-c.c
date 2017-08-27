#include <stdlib.h>
#include <noise/protocol.h>
#include <protocol/internal.h>
//#include <protocol/randstate.c>
// Should be randstate.h ->
#include <crypto/chacha/chacha.h>
struct NoiseRandState_s
{
    /** \brief Total size of the structure */
    size_t size;

    /** \brief Number of bytes left until the next reseed */
    size_t left;

    /** \brief ChaCha20 state for the random number generator */
    chacha_ctx chacha;
};
// <- Should be randstate.h

#include <noise/keys/certificate.h>
#include <keys/certificate.c>


size_t NoiseCipherState_struct_size (void) {
	return sizeof(NoiseCipherState);
}

size_t NoiseHandshakeState_struct_size (void) {
	return sizeof(NoiseHandshakeState);
}

size_t NoiseSymmetricState_struct_size (void) {
	return sizeof(NoiseSymmetricState);
}

size_t NoiseHashState_struct_size (void) {
	return sizeof(NoiseHashState);
}

size_t NoiseDHState_struct_size (void) {
	return sizeof(NoiseDHState);
}

size_t NoiseSignState_struct_size (void) {
	return sizeof(NoiseSignState);
}

size_t NoiseRandState_struct_size (void) {
	return sizeof(NoiseRandState);
}

size_t Noise_CertificateChain_struct_size (void) {
	return sizeof(Noise_CertificateChain);
}

size_t NoiseProtobuf_struct_size (void) {
	return sizeof(NoiseProtobuf);
}

size_t Noise_Certificate_struct_size (void) {
	return sizeof(Noise_Certificate);
}

size_t Noise_PrivateKey_struct_size (void) {
	return sizeof(Noise_PrivateKey);
}

size_t NoiseBuffer_struct_size (void) {
	return sizeof(NoiseBuffer);
}

void NoiseBuffer_set_buffer_data (NoiseBuffer *buffer, uint8_t *data, size_t len, size_t max_size) {
    buffer->data = data;
    buffer->size = len;
    buffer->max_size = max_size;
}
