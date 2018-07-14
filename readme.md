# noise-c.wasm [![Travis CI](https://img.shields.io/travis/nazar-pc/noise-c.wasm/master.svg?label=Travis%20CI)](https://travis-ci.org/nazar-pc/noise-c.wasm)
[rweather/noise-c](https://github.com/rweather/noise-c) compiled to WebAssembly using Emscripten and optimized for small size.

[Noise protocol](https://noiseprotocol.org/) implementation that works both in Node.js and in modern browsers.

## Supported Patterns and Algorithms
The same as in noise-c: https://rweather.github.io/noise-c/index.html#algorithms

## About this project
This project basically does 2 things:
* compiles upstream noise-c C library into WebAssembly
* wraps plain functions into OOP interface close to what is specified in the spec (including functions names)

When reading LiveScript code make sure to configure 1 tab to be 4 spaces, otherwise code might be hard to read.

## How to install
```
npm install noise-c.wasm
```

## API

### lib.ready(callback)
* `callback` - Callback function that is called when WebAssembly is loaded and library is ready for use

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

When reading LiveScript code make sure to configure 1 tab to be 4 spaces, otherwise code might be hard to read.

## License
Free Public License 1.0.0 / Zero Clause BSD License

https://opensource.org/licenses/FPL-1.0.0

https://tldrlegal.com/license/bsd-0-clause-license
