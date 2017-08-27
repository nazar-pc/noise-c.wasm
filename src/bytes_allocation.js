(function() {
  var pointers = [];
  /**
   * Make Uint8Array of the value, since it might be any other TypedArray, while we're working with `Module['HEAPU8']`
   */
  function normalizeValue (value) {
    if (value && value.buffer instanceof ArrayBuffer) {
      value = new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
    }
    return value;
  }
  Module['createPointer'] = function (address, size) {
    var pointer;
    pointer = new Number(address);
    pointer['length'] = size;
    pointer['get'] = function (as) {
      as = as || Uint8Array;
      // Create copy, since source buffer might be changed later
      return (new as(Module['buffer'], pointer, size / as.BYTES_PER_ELEMENT)).slice();
    };
    pointer['dereference'] = function (size) {
      size = size || 4;
      return Module['createPointer'](pointer['get'](Uint32Array)[0], size);
    };
    pointer['set'] = function (value) {
      value = normalizeValue(value);
      if (value.length > size) {
        throw RangeError('invalid array length');
      }
      Module['HEAPU8'].set(value, pointer);
    };
    pointer['free'] = function () {
      Module['_free'](pointer);
      pointers.splice(pointers.indexOf(pointer), 1)
    };
    pointers.push(pointer);
    return pointer;
  };
  Module['allocatePointer'] = function (address) {
    if (address) {
      address = Uint32Array.of(address);
    }
    return Module['allocateBytes'](4, address);
  };
  Module['allocateBytes'] = function (size, value) {
    var pointer;
    value = normalizeValue(value);
    // Compute size to be allocated from supplied value, allows writing cleaner code without `value.length` all the time
    if (size === 0) {
      size = value.length;
    }
    pointer = Module['createPointer'](Module['_malloc'](size), size);
    if (value !== undefined) {
      pointer['set'](value);
      if (value.length < size) {
        // Override with zeroes the rest of allocated memory
        Module['HEAPU8'].fill(0, pointer + value.length, pointer + size);
      }
    } else {
      // Like `_calloc()`, but not requiring it to be present
      Module['HEAPU8'].fill(0, pointer, pointer + size);
    }
    return pointer;
  };
  Module['freeBytes'] = function () {
    for (var i = 0, length = pointers.length; i < length; ++i) {
      Module['_free'](pointers[i]);
    }
    pointers = [];
  };
})();
