(function() {
  var pointers = [];
  /**
   * Make Uint8Array of the value, since it might be any other TypedArray, while we're working with `Module['HEAPU8']`
   */
  function normalizeValue (value) {
    if (value && value.buffer instanceof ArrayBuffer) {
      value = new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
    } else if (typeof value === 'string') {
      // `+ 1` means that NUL will be present at the end of the string
      var length = value.length, array = new Uint8Array(length + 1);
      for(var i = 0; i < length; ++i) {
        array[i] = value.charCodeAt(i);
      }
      return array;
    }
    return value;
  }
  function createPointer (address, size) {
    var pointer;
    pointer = new Number(address);
    pointer['length'] = size;
    pointer['get'] = function (as) {
      as = as || Uint8Array;
      // Create copy, since source buffer might be changed later
      return (new as(buffer, pointer, size / as.BYTES_PER_ELEMENT)).slice();
    };
    pointer['dereference'] = function (size) {
      size = size || 4;
      return createPointer(pointer['get'](Uint32Array)[0], size);
    };
    pointer['set'] = function (value) {
      value = normalizeValue(value);
      if (value.length > size) {
        throw RangeError('invalid array length');
      }
      HEAPU8.set(value, pointer);
    };
    pointer['free'] = function () {
      _free(pointer);
      pointers.splice(pointers.indexOf(pointer), 1)
    };
    pointers.push(pointer);
    return pointer;
  }
  function allocatePointer (address) {
    if (address) {
      address = Uint32Array.of(address);
    }
    return allocateBytes(4, address);
  }
  function allocateBytes (size, value) {
    var pointer;
    value = normalizeValue(value);
    // Compute size to be allocated from supplied value, allows writing cleaner code without `value.length` all the time
    if (size === 0) {
      size = value.length;
    }
    pointer = createPointer(_malloc(size), size);
    if (value !== undefined) {
      pointer['set'](value);
      if (value.length < size) {
        // Override with zeroes the rest of allocated memory
        HEAPU8.fill(0, pointer + value.length, pointer + size);
      }
    } else {
      // Like `_calloc()`, but not requiring it to be present
      HEAPU8.fill(0, pointer, pointer + size);
    }
    return pointer;
  }
  function freeBytes () {
    for (var i = 0, length = pointers.length; i < length; ++i) {
      _free(pointers[i]);
    }
    pointers = [];
  }
  Module['createPointer'] = createPointer;
  Module['allocatePointer'] = allocatePointer;
  Module['allocateBytes'] = allocateBytes;
  Module['freeBytes'] = freeBytes;
})();
