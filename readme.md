# noise-c.wasm
[rweather/noise-c](https://github.com/rweather/noise-c) compiled to WebAssembly using Emscripten and optimized for small size

Noise protocol implementation that works both in Node.js and in modern browsers.

## Supported Patterns and Algorithms
The same as in noise-c: https://rweather.github.io/noise-c/index.html#algorithms

## About this project
This project basically does 2 things:
* compiles upstream noise-c C library into WebAssembly
* wraps plain functions into OOP interface close to what is specified in the spec (including functions names)

When reading LiveScript code make sure to configure 1 tab to be 4 spaces (GitHub uses 8 by default), otherwise code might be hard to read.

## Current status

API should be near stable and unlikely to change.

Still considered unstable, so be careful and make sure to report any issues you encounter. Project is covered with a lot of tests though to ensure it works as intended (see `tests` directory).

## API

### lib.ready(callback)
* `callback` - Callback function that is called WebAssembly is loaded and library is ready for use

### lib.constants
A bunch of constants that are needed for certain calls or for identifying errors.
In most cases only `NOISE_ROLE_INITIATOR` and `NOISE_ROLE_RESPONDER` will be used directly, but others are used in OOP wrapper and/or in tests.

Check `src/constants.ls` for complete list of available constants.

### lib.CipherState(cipher)
CipherState object [as in specification](http://noiseprotocol.org/noise.html#the-cipherstate-object), has following methods:
* `InitializeKey(key)`
* `HasKey()`
* `EncryptWithAd(ad, plaintext)`
* `DecryptWithAd(ad, ciphertext)`
* `Rekey()`
* `free()`

Take a look at `src/index.ls` for JsDoc sections with arguments and return types as well as methods description, look at `tests/CipherState.ls` for usage examples.

### lib.SymmetricState(protocol_name)
SymmetricState object [as in specification](http://noiseprotocol.org/noise.html#the-symmetricstate-object), has following methods:
* `MixKey(input_key_material)`
* `MixHash(data)`
* `MixKeyAndHash(input_key_material)`
* `EncryptAndHash(plaintext)`
* `DecryptAndHash(ciphertext)`
* `Split()`
* `free()`

Take a look at `src/index.ls` for JsDoc sections with arguments and return types as well as methods description, look at `tests/SymmetricState.ls` for usage examples.

### lib.HandshakeState(protocol_name, role)
HandshakeState object [as in specification](http://noiseprotocol.org/noise.html#the-handshakestate-object), has following methods:
* `Initialize(prologue = null, s = null, rs = null, psk = null)`
* `GetAction()`
* `FallbackTo(pattern_id = lib.constants.NOISE_PATTERN_XX_FALLBACK)`
* `WriteMessage(payload = null)`
* `ReadMessage(message, payload_needed = false, fallback_supported = false)`
* `Split()`
* `free()`

Take a look at `src/index.ls` for JsDoc sections with arguments and return types as well as methods description, look at `tests/HandshakeState.ls` for usage examples.

## Contribution
Feel free to create issues and send pull requests (for big changes create an issue first and link it from the PR), they are highly appreciated!

## License
MIT, see license.txt
