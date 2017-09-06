(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.noise_c_wasm = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict'

function oldBrowser () {
  throw new Error('secure random number generation not supported by this browser\nuse chrome, FireFox or Internet Explorer 11')
}

var Buffer = require('safe-buffer').Buffer
var crypto = global.crypto || global.msCrypto

if (crypto && crypto.getRandomValues) {
  module.exports = randomBytes
} else {
  module.exports = oldBrowser
}

function randomBytes (size, cb) {
  // phantomjs needs to throw
  if (size > 65536) throw new Error('requested too many random bytes')
  // in case browserify  isn't using the Uint8Array version
  var rawBytes = new global.Uint8Array(size)

  // This will not work in older browsers.
  // See https://developer.mozilla.org/en-US/docs/Web/API/window.crypto.getRandomValues
  if (size > 0) {  // getRandomValues fails on IE if size == 0
    crypto.getRandomValues(rawBytes)
  }

  // XXX: phantomjs doesn't like a buffer being passed here
  var bytes = Buffer.from(rawBytes.buffer)

  if (typeof cb === 'function') {
    return process.nextTick(function () {
      cb(null, bytes)
    })
  }

  return bytes
}

},{"safe-buffer":2}],2:[function(require,module,exports){
/* eslint-disable node/no-deprecated-api */
var buffer = require('buffer')
var Buffer = buffer.Buffer

// alternative to using Object.keys for old browsers
function copyProps (src, dst) {
  for (var key in src) {
    dst[key] = src[key]
  }
}
if (Buffer.from && Buffer.alloc && Buffer.allocUnsafe && Buffer.allocUnsafeSlow) {
  module.exports = buffer
} else {
  // Copy properties from require('buffer')
  copyProps(buffer, exports)
  exports.Buffer = SafeBuffer
}

function SafeBuffer (arg, encodingOrOffset, length) {
  return Buffer(arg, encodingOrOffset, length)
}

// Copy static methods from Buffer
copyProps(Buffer, SafeBuffer)

SafeBuffer.from = function (arg, encodingOrOffset, length) {
  if (typeof arg === 'number') {
    throw new TypeError('Argument must not be a number')
  }
  return Buffer(arg, encodingOrOffset, length)
}

SafeBuffer.alloc = function (size, fill, encoding) {
  if (typeof size !== 'number') {
    throw new TypeError('Argument must be a number')
  }
  var buf = Buffer(size)
  if (fill !== undefined) {
    if (typeof encoding === 'string') {
      buf.fill(fill, encoding)
    } else {
      buf.fill(fill)
    }
  } else {
    buf.fill(0)
  }
  return buf
}

SafeBuffer.allocUnsafe = function (size) {
  if (typeof size !== 'number') {
    throw new TypeError('Argument must be a number')
  }
  return Buffer(size)
}

SafeBuffer.allocUnsafeSlow = function (size) {
  if (typeof size !== 'number') {
    throw new TypeError('Argument must be a number')
  }
  return buffer.SlowBuffer(size)
}

},{"buffer":undefined}],3:[function(require,module,exports){
var Module = function(Module) {
  Module = Module || {};
  var Module = Module;

var b;b||(b=eval("(function() { try { return Module || {} } catch(e) { return {} } })()"));var k={},m;for(m in b)b.hasOwnProperty(m)&&(k[m]=b[m]);var n=!1,r=!1,t=!1,u=!1;
if(b.ENVIRONMENT)if("WEB"===b.ENVIRONMENT)n=!0;else if("WORKER"===b.ENVIRONMENT)r=!0;else if("NODE"===b.ENVIRONMENT)t=!0;else if("SHELL"===b.ENVIRONMENT)u=!0;else throw Error("The provided Module['ENVIRONMENT'] value is not valid. It must be one of: WEB|WORKER|NODE|SHELL.");else n="object"===typeof window,r="function"===typeof importScripts,t="object"===typeof process&&"function"===typeof require&&!n&&!r,u=!n&&!t&&!r;
if(t){b.print||(b.print=console.log);b.printErr||(b.printErr=console.warn);var v,w;b.read=function(a,c){v||(v=require("fs"));w||(w=require("path"));a=w.normalize(a);var d=v.readFileSync(a);return c?d:d.toString()};b.readBinary=function(a){a=b.read(a,!0);a.buffer||(a=new Uint8Array(a));assert(a.buffer);return a};b.load=function(a){aa(read(a))};b.thisProgram||(b.thisProgram=1<process.argv.length?process.argv[1].replace(/\\/g,"/"):"unknown-program");b.arguments=process.argv.slice(2);"undefined"!==typeof module&&
(module.exports=b);process.on("uncaughtException",function(a){if(!(a instanceof x))throw a;});b.inspect=function(){return"[Emscripten Module object]"}}else if(u)b.print||(b.print=print),"undefined"!=typeof printErr&&(b.printErr=printErr),b.read="undefined"!=typeof read?read:function(){throw"no read() available";},b.readBinary=function(a){if("function"===typeof readbuffer)return new Uint8Array(readbuffer(a));a=read(a,"binary");assert("object"===typeof a);return a},"undefined"!=typeof scriptArgs?b.arguments=
scriptArgs:"undefined"!=typeof arguments&&(b.arguments=arguments),"function"===typeof quit&&(b.quit=function(a){quit(a)}),eval("if (typeof gc === 'function' && gc.toString().indexOf('[native code]') > 0) var gc = undefined");else if(n||r)b.read=function(a){var c=new XMLHttpRequest;c.open("GET",a,!1);c.send(null);return c.responseText},r&&(b.readBinary=function(a){var c=new XMLHttpRequest;c.open("GET",a,!1);c.responseType="arraybuffer";c.send(null);return new Uint8Array(c.response)}),b.readAsync=function(a,
c,d){var e=new XMLHttpRequest;e.open("GET",a,!0);e.responseType="arraybuffer";e.onload=function(){200==e.status||0==e.status&&e.response?c(e.response):d()};e.onerror=d;e.send(null)},"undefined"!=typeof arguments&&(b.arguments=arguments),"undefined"!==typeof console?(b.print||(b.print=function(a){console.log(a)}),b.printErr||(b.printErr=function(a){console.warn(a)})):b.print||(b.print=function(){}),r&&(b.load=importScripts),"undefined"===typeof b.setWindowTitle&&(b.setWindowTitle=function(a){document.title=
a});else throw"Unknown runtime environment. Where are we?";function aa(a){eval.call(null,a)}!b.load&&b.read&&(b.load=function(a){aa(b.read(a))});b.print||(b.print=function(){});b.printErr||(b.printErr=b.print);b.arguments||(b.arguments=[]);b.thisProgram||(b.thisProgram="./this.program");b.quit||(b.quit=function(a,c){throw c;});b.print=b.print;b.d=b.printErr;b.preRun=[];b.postRun=[];for(m in k)k.hasOwnProperty(m)&&(b[m]=k[m]);
var k=void 0,z={A:function(a){return tempRet0=a},v:function(){return tempRet0},o:function(){return y},n:function(a){y=a},l:function(a){switch(a){case "i1":case "i8":return 1;case "i16":return 2;case "i32":return 4;case "i64":return 8;case "float":return 4;case "double":return 8;default:return"*"===a[a.length-1]?z.f:"i"===a[0]?(a=parseInt(a.substr(1)),assert(0===a%8),a/8):0}},u:function(a){return Math.max(z.l(a),z.f)},B:16,Q:function(a,c){"double"===c||"i64"===c?a&7&&(assert(4===(a&7)),a+=4):assert(0===
(a&3));return a},K:function(a,c,d){return d||"i64"!=a&&"double"!=a?a?Math.min(c||(a?z.u(a):0),z.f):Math.min(c,8):8},h:function(a,c,d){return d&&d.length?b["dynCall_"+a].apply(null,[c].concat(d)):b["dynCall_"+a].call(null,c)},c:[],q:function(a){for(var c=0;c<z.c.length;c++)if(!z.c[c])return z.c[c]=a,2*(1+c);throw"Finished up all reserved function pointers. Use a higher value for RESERVED_FUNCTION_POINTERS.";},w:function(a){z.c[(a-2)/2]=null},b:function(a){z.b.j||(z.b.j={});z.b.j[a]||(z.b.j[a]=1,b.d(a))},
i:{},M:function(a,c){assert(c);z.i[c]||(z.i[c]={});var d=z.i[c];d[a]||(d[a]=1===c.length?function(){return z.h(c,a)}:2===c.length?function(d){return z.h(c,a,[d])}:function(){return z.h(c,a,Array.prototype.slice.call(arguments))});return d[a]},L:function(){throw"You must build with -s RETAIN_COMPILER_SETTINGS=1 for Runtime.getCompilerSetting or emscripten_get_compiler_setting to work";},m:function(a){var c=y;y=y+a|0;y=y+15&-16;return c},p:function(a){var c=A;A=A+a|0;A=A+15&-16;return c},t:function(a){var c=
C[D>>2];a=(c+a+15|0)&-16;C[D>>2]=a;if(a=a>=E)F(),a=!0;return a?(C[D>>2]=c,0):c},k:function(a,c){return Math.ceil(a/(c?c:16))*(c?c:16)},P:function(a,c,d){return d?+(a>>>0)+4294967296*+(c>>>0):+(a>>>0)+4294967296*+(c|0)},e:1024,f:4,C:0};z.addFunction=z.q;z.removeFunction=z.w;var G=0;function assert(a,c){a||H("Assertion failed: "+c)}
function ba(a){var c;c="i32";"*"===c.charAt(c.length-1)&&(c="i32");switch(c){case "i1":return I[a>>0];case "i8":return I[a>>0];case "i16":return J[a>>1];case "i32":return C[a>>2];case "i64":return C[a>>2];case "float":return K[a>>2];case "double":return L[a>>3];default:H("invalid type for setValue: "+c)}return null}
function N(a,c,d){var e,f,g;"number"===typeof a?(f=!0,g=a):(f=!1,g=a.length);var h="string"===typeof c?c:null,l;4==d?l=e:l=["function"===typeof O?O:z.p,z.m,z.p,z.t][void 0===d?2:d](Math.max(g,h?1:c.length));if(f){e=l;assert(0==(l&3));for(a=l+(g&-4);e<a;e+=4)C[e>>2]=0;for(a=l+g;e<a;)I[e++>>0]=0;return l}if("i8"===h)return a.subarray||a.slice?P.set(a,l):P.set(new Uint8Array(a),l),l;e=0;for(var p,M;e<g;){var q=a[e];"function"===typeof q&&(q=z.N(q));d=h||c[e];if(0===d)e++;else{"i64"==d&&(d="i32");f=l+
e;var B=d,B=B||"i8";"*"===B.charAt(B.length-1)&&(B="i32");switch(B){case "i1":I[f>>0]=q;break;case "i8":I[f>>0]=q;break;case "i16":J[f>>1]=q;break;case "i32":C[f>>2]=q;break;case "i64":tempI64=[q>>>0,(tempDouble=q,1<=+ca(tempDouble)?0<tempDouble?(da(+ea(tempDouble/4294967296),4294967295)|0)>>>0:~~+fa((tempDouble-+(~~tempDouble>>>0))/4294967296)>>>0:0)];C[f>>2]=tempI64[0];C[f+4>>2]=tempI64[1];break;case "float":K[f>>2]=q;break;case "double":L[f>>3]=q;break;default:H("invalid type for setValue: "+B)}M!==
d&&(p=z.l(d),M=d);e+=p}}return l}function Q(a){var c;if(0===c||!a)return"";for(var d=0,e,f=0;;){e=P[a+f>>0];d|=e;if(0==e&&!c)break;f++;if(c&&f==c)break}c||(c=f);e="";if(128>d){for(;0<c;)d=String.fromCharCode.apply(String,P.subarray(a,a+Math.min(c,1024))),e=e?e+d:d,a+=1024,c-=1024;return e}return b.UTF8ToString(a)}"undefined"!==typeof TextDecoder&&new TextDecoder("utf8");
function ga(a,c,d,e){if(0<e){e=d+e-1;for(var f=0;f<a.length;++f){var g=a.charCodeAt(f);55296<=g&&57343>=g&&(g=65536+((g&1023)<<10)|a.charCodeAt(++f)&1023);if(127>=g){if(d>=e)break;c[d++]=g}else{if(2047>=g){if(d+1>=e)break;c[d++]=192|g>>6}else{if(65535>=g){if(d+2>=e)break;c[d++]=224|g>>12}else{if(2097151>=g){if(d+3>=e)break;c[d++]=240|g>>18}else{if(67108863>=g){if(d+4>=e)break;c[d++]=248|g>>24}else{if(d+5>=e)break;c[d++]=252|g>>30;c[d++]=128|g>>24&63}c[d++]=128|g>>18&63}c[d++]=128|g>>12&63}c[d++]=
128|g>>6&63}c[d++]=128|g&63}}c[d]=0}}function ha(a){for(var c=0,d=0;d<a.length;++d){var e=a.charCodeAt(d);55296<=e&&57343>=e&&(e=65536+((e&1023)<<10)|a.charCodeAt(++d)&1023);127>=e?++c:c=2047>=e?c+2:65535>=e?c+3:2097151>=e?c+4:67108863>=e?c+5:c+6}return c}"undefined"!==typeof TextDecoder&&new TextDecoder("utf-16le");
function ia(a){return a.replace(/__Z[\w\d_]+/g,function(a){var d;a:{var e=b.___cxa_demangle||b.__cxa_demangle;if(e)try{var f=a.substr(1),g=ha(f)+1,h=O(g);ga(f,P,h,g);var l=O(4),p=e(h,0,0,l);if(0===ba(l)&&p){d=Q(p);break a}}catch(M){}finally{h&&R(h),l&&R(l),p&&R(p)}else z.b("warning: build with  -s DEMANGLE_SUPPORT=1  to link in libcxxabi demangling");d=a}return a===d?a:a+" ["+d+"]"})}
function ja(){var a;a:{a=Error();if(!a.stack){try{throw Error(0);}catch(c){a=c}if(!a.stack){a="(no stack trace available)";break a}}a=a.stack.toString()}b.extraStackTrace&&(a+="\n"+b.extraStackTrace());return ia(a)}var buffer,I,P,J,ka,C,la,K,L;
function ma(){b.HEAP8=I=new Int8Array(buffer);b.HEAP16=J=new Int16Array(buffer);b.HEAP32=C=new Int32Array(buffer);b.HEAPU8=P=new Uint8Array(buffer);b.HEAPU16=ka=new Uint16Array(buffer);b.HEAPU32=la=new Uint32Array(buffer);b.HEAPF32=K=new Float32Array(buffer);b.HEAPF64=L=new Float64Array(buffer)}var S,A,na,y,T,oa,D;S=A=na=y=T=oa=D=0;
function F(){H("Cannot enlarge memory arrays. Either (1) compile with  -s TOTAL_MEMORY=X  with X higher than the current value "+E+", (2) compile with  -s ALLOW_MEMORY_GROWTH=1  which allows increasing the size at runtime, or (3) if you want malloc to return NULL (0) instead of this abort, compile with  -s ABORTING_MALLOC=0 ")}var pa=b.TOTAL_STACK||5242880,E=b.TOTAL_MEMORY||16777216;E<pa&&b.d("TOTAL_MEMORY should be larger than TOTAL_STACK, was "+E+"! (TOTAL_STACK="+pa+")");
b.buffer?buffer=b.buffer:"object"===typeof WebAssembly&&"function"===typeof WebAssembly.Memory?(b.wasmMemory=new WebAssembly.Memory({initial:E/65536,maximum:E/65536}),buffer=b.wasmMemory.buffer):buffer=new ArrayBuffer(E);ma();C[0]=1668509029;J[1]=25459;if(115!==P[2]||99!==P[3])throw"Runtime error: expected the system to be little-endian!";b.HEAP=void 0;b.buffer=buffer;b.HEAP8=I;b.HEAP16=J;b.HEAP32=C;b.HEAPU8=P;b.HEAPU16=ka;b.HEAPU32=la;b.HEAPF32=K;b.HEAPF64=L;
function U(a){for(;0<a.length;){var c=a.shift();if("function"==typeof c)c();else{var d=c.J;"number"===typeof d?void 0===c.g?b.dynCall_v(d):b.dynCall_vi(d,c.g):d(void 0===c.g?null:c.g)}}}var qa=[],ra=[],sa=[],ta=[],ua=[],V=!1;function va(){var a=b.preRun.shift();qa.unshift(a)}function wa(a){var c=Array(ha(a)+1);ga(a,c,0,c.length);return c}Math.imul&&-5===Math.imul(4294967295,5)||(Math.imul=function(a,c){var d=a&65535,e=c&65535;return d*e+((a>>>16)*e+d*(c>>>16)<<16)|0});Math.O=Math.imul;
if(!Math.fround){var xa=new Float32Array(1);Math.fround=function(a){xa[0]=a;return xa[0]}}Math.I=Math.fround;Math.clz32||(Math.clz32=function(a){a=a>>>0;for(var c=0;32>c;c++)if(a&1<<31-c)return c;return 32});Math.F=Math.clz32;Math.trunc||(Math.trunc=function(a){return 0>a?Math.ceil(a):Math.floor(a)});Math.trunc=Math.trunc;var ca=Math.abs,fa=Math.ceil,ea=Math.floor,da=Math.min,W=0,ya=null,X=null;function za(){W++;b.monitorRunDependencies&&b.monitorRunDependencies(W)}
function Aa(){W--;b.monitorRunDependencies&&b.monitorRunDependencies(W);if(0==W&&(null!==ya&&(clearInterval(ya),ya=null),X)){var a=X;X=null;a()}}b.preloadedImages={};b.preloadedAudios={};var Y=null;
(function(a){function c(c){var d=a.usingWasm?65536:16777216;0<c%d&&(c+=d-c%d);var d=a.buffer,e=d.byteLength;if(a.usingWasm)try{return-1!==a.wasmMemory.grow((c-e)/65536)?a.buffer=a.wasmMemory.buffer:null}catch(f){return null}else return p.__growWasmMemory((c-e)/65536),a.buffer!==d?a.buffer:null}function d(){return a.wasmBinary||"function"!==typeof fetch?new Promise(function(c){var d;a:{try{var e;if(a.wasmBinary)e=a.wasmBinary,e=new Uint8Array(e);else if(a.readBinary)e=a.readBinary(g);else throw"on the web, we need the wasm binary to be preloaded and set on Module['wasmBinary']. emcc.py will do that for you when generating HTML (but not JS)";
d=e;break a}catch(f){H(f)}d=void 0}c(d)}):fetch(g,{G:"same-origin"}).then(function(a){if(!a.ok)throw"failed to load wasm binary file at '"+g+"'";return a.arrayBuffer()})}function e(c,e){function f(c){p=c.exports;if(p.memory){c=p.memory;var d=a.buffer;c.byteLength<d.byteLength&&a.printErr("the new buffer in mergeMemory is smaller than the previous one. in native wasm, we should grow memory here");var d=new Int8Array(d),e=new Int8Array(c);Y||d.set(e.subarray(a.STATIC_BASE,a.STATIC_BASE+a.STATIC_BUMP),
a.STATIC_BASE);e.set(d);b.buffer=buffer=c;ma()}a.asm=p;a.usingWasm=!0;Aa()}if("object"!==typeof WebAssembly)return a.printErr("no native wasm support detected"),!1;if(!(a.wasmMemory instanceof WebAssembly.Memory))return a.printErr("no native wasm Memory in use"),!1;e.memory=a.wasmMemory;l.global={NaN:NaN,Infinity:Infinity};l["global.Math"]=c.Math;l.env=e;za();if(a.instantiateWasm)try{return a.instantiateWasm(l,f)}catch(g){return a.printErr("Module.instantiateWasm callback failed with error: "+g),
!1}d().then(function(a){return WebAssembly.instantiate(a,l)}).then(function(a){f(a.instance)}).catch(function(c){a.printErr("failed to asynchronously prepare wasm: "+c);H(c)});return{}}a.wasmJSMethod=a.wasmJSMethod||"native-wasm";var f=a.wasmTextFile||"noise-c.wast",g=a.wasmBinaryFile||"noise-c.wasm",h=a.asmjsCodeFile||"noise-c.temp.asm.js";"function"===typeof a.locateFile&&(f=a.locateFile(f),g=a.locateFile(g),h=a.locateFile(h));var l={global:null,env:null,asm2wasm:{"f64-rem":function(a,c){return a%
c},"f64-to-int":function(a){return a|0},"i32s-div":function(a,c){return(a|0)/(c|0)|0},"i32u-div":function(a,c){return(a>>>0)/(c>>>0)>>>0},"i32s-rem":function(a,c){return(a|0)%(c|0)|0},"i32u-rem":function(a,c){return(a>>>0)%(c>>>0)>>>0},"debugger":function(){debugger}},parent:a},p=null;a.asmPreload=a.asm;var M=a.reallocBuffer;a.reallocBuffer=function(a){return"asmjs"===q?M(a):c(a)};var q="";a.asm=function(c,d){if(!d.table){var f=a.wasmTableSize;void 0===f&&(f=1024);var g=a.wasmMaxTableSize;d.table=
"object"===typeof WebAssembly&&"function"===typeof WebAssembly.Table?void 0!==g?new WebAssembly.Table({initial:f,maximum:g,element:"anyfunc"}):new WebAssembly.Table({initial:f,element:"anyfunc"}):Array(f);a.wasmTable=d.table}d.memoryBase||(d.memoryBase=a.STATIC_BASE);d.tableBase||(d.tableBase=0);return e(c,d)}})(b);S=z.e;A=S+42992;ra.push();Y=0<=b.wasmJSMethod.indexOf("asmjs")||0<=b.wasmJSMethod.indexOf("interpret-asm2wasm")?"noise-c.js.mem":null;b.STATIC_BASE=S;b.STATIC_BUMP=42992;var Ba=A;A+=16;
function Z(){Z.a||(Z.a=[]);Z.a.push(z.o());return Z.a.length-1}D=N(1,"i32",2);na=y=z.k(A);T=na+pa;oa=z.k(T);C[D>>2]=oa;b.wasmTableSize=68;b.wasmMaxTableSize=68;b.r={Math:Math,Int8Array:Int8Array,Int16Array:Int16Array,Int32Array:Int32Array,Uint8Array:Uint8Array,Uint16Array:Uint16Array,Uint32Array:Uint32Array,Float32Array:Float32Array,Float64Array:Float64Array,NaN:NaN,Infinity:Infinity};
b.s={abort:H,assert:assert,enlargeMemory:function(){F()},getTotalMemory:function(){return E},abortOnCannotGrowMemory:F,invoke_iiiiii:function(a,c,d,e,f,g){try{return b.dynCall_iiiiii(a,c,d,e,f,g)}catch(h){if("number"!==typeof h&&"longjmp"!==h)throw h;b.setThrew(1,0)}},invoke_i:function(a){try{return b.dynCall_i(a)}catch(c){if("number"!==typeof c&&"longjmp"!==c)throw c;b.setThrew(1,0)}},invoke_vi:function(a,c){try{b.dynCall_vi(a,c)}catch(d){if("number"!==typeof d&&"longjmp"!==d)throw d;b.setThrew(1,
0)}},invoke_vii:function(a,c,d){try{b.dynCall_vii(a,c,d)}catch(e){if("number"!==typeof e&&"longjmp"!==e)throw e;b.setThrew(1,0)}},invoke_iiii:function(a,c,d,e){try{return b.dynCall_iiii(a,c,d,e)}catch(f){if("number"!==typeof f&&"longjmp"!==f)throw f;b.setThrew(1,0)}},invoke_viii:function(a,c,d,e){try{b.dynCall_viii(a,c,d,e)}catch(f){if("number"!==typeof f&&"longjmp"!==f)throw f;b.setThrew(1,0)}},invoke_iii:function(a,c,d){try{return b.dynCall_iii(a,c,d)}catch(e){if("number"!==typeof e&&"longjmp"!==
e)throw e;b.setThrew(1,0)}},_noise_rand_bytes:function(a,c){var d;d=require("randombytes");P.set(d(c),a)},_llvm_stacksave:Z,___setErrNo:function(a){b.___errno_location&&(C[b.___errno_location()>>2]=a);return a},_emscripten_memcpy_big:function(a,c,d){P.set(P.subarray(c,c+d),a);return a},_llvm_stackrestore:function(a){var c=Z.a[a];Z.a.splice(a,1);z.n(c)},___assert_fail:function(a,c,d,e){G=!0;throw"Assertion failed: "+Q(a)+", at: "+[c?Q(c):"unknown filename",d,e?Q(e):"unknown function"]+" at "+ja();
},DYNAMICTOP_PTR:D,tempDoublePtr:Ba,ABORT:G,STACKTOP:y,STACK_MAX:T};var Ca=b.asm(b.r,b.s,buffer);b.asm=Ca;b._noise_symmetricstate_split=function(){return b.asm._noise_symmetricstate_split.apply(null,arguments)};b.stackSave=function(){return b.asm.stackSave.apply(null,arguments)};b._NoiseBuffer_get_size=function(){return b.asm._NoiseBuffer_get_size.apply(null,arguments)};b._noise_cipherstate_decrypt_with_ad=function(){return b.asm._noise_cipherstate_decrypt_with_ad.apply(null,arguments)};
b.getTempRet0=function(){return b.asm.getTempRet0.apply(null,arguments)};b._noise_symmetricstate_decrypt_and_hash=function(){return b.asm._noise_symmetricstate_decrypt_and_hash.apply(null,arguments)};b.setTempRet0=function(){return b.asm.setTempRet0.apply(null,arguments)};b._noise_handshakestate_get_local_keypair_dh=function(){return b.asm._noise_handshakestate_get_local_keypair_dh.apply(null,arguments)};b._noise_handshakestate_free=function(){return b.asm._noise_handshakestate_free.apply(null,arguments)};
b._sbrk=function(){return b.asm._sbrk.apply(null,arguments)};b._noise_handshakestate_needs_remote_public_key=function(){return b.asm._noise_handshakestate_needs_remote_public_key.apply(null,arguments)};b._noise_dhstate_set_public_key=function(){return b.asm._noise_dhstate_set_public_key.apply(null,arguments)};b._noise_symmetricstate_get_mac_length=function(){return b.asm._noise_symmetricstate_get_mac_length.apply(null,arguments)};
b._noise_cipherstate_get_mac_length=function(){return b.asm._noise_cipherstate_get_mac_length.apply(null,arguments)};b._noise_handshakestate_read_message=function(){return b.asm._noise_handshakestate_read_message.apply(null,arguments)};b._noise_dhstate_set_keypair_private=function(){return b.asm._noise_dhstate_set_keypair_private.apply(null,arguments)};b._memset=function(){return b.asm._memset.apply(null,arguments)};
b._noise_handshakestate_needs_pre_shared_key=function(){return b.asm._noise_handshakestate_needs_pre_shared_key.apply(null,arguments)};b._noise_cipherstate_has_key=function(){return b.asm._noise_cipherstate_has_key.apply(null,arguments)};b._noise_cipherstate_free=function(){return b.asm._noise_cipherstate_free.apply(null,arguments)};b._memcpy=function(){return b.asm._memcpy.apply(null,arguments)};
b._noise_handshakestate_set_prologue=function(){return b.asm._noise_handshakestate_set_prologue.apply(null,arguments)};b.stackAlloc=function(){return b.asm.stackAlloc.apply(null,arguments)};b._noise_handshakestate_new_by_name=function(){return b.asm._noise_handshakestate_new_by_name.apply(null,arguments)};b._noise_handshakestate_fallback_to=function(){return b.asm._noise_handshakestate_fallback_to.apply(null,arguments)};
b._noise_cipherstate_encrypt_with_ad=function(){return b.asm._noise_cipherstate_encrypt_with_ad.apply(null,arguments)};b._noise_handshakestate_split=function(){return b.asm._noise_handshakestate_split.apply(null,arguments)};b._noise_handshakestate_start=function(){return b.asm._noise_handshakestate_start.apply(null,arguments)};b.stackRestore=function(){return b.asm.stackRestore.apply(null,arguments)};
b._noise_handshakestate_write_message=function(){return b.asm._noise_handshakestate_write_message.apply(null,arguments)};b._llvm_bswap_i16=function(){return b.asm._llvm_bswap_i16.apply(null,arguments)};b._noise_handshakestate_get_action=function(){return b.asm._noise_handshakestate_get_action.apply(null,arguments)};b._noise_handshakestate_get_remote_public_key_dh=function(){return b.asm._noise_handshakestate_get_remote_public_key_dh.apply(null,arguments)};
b._noise_symmetricstate_encrypt_and_hash=function(){return b.asm._noise_symmetricstate_encrypt_and_hash.apply(null,arguments)};b._noise_symmetricstate_mix_key=function(){return b.asm._noise_symmetricstate_mix_key.apply(null,arguments)};b._noise_cipherstate_new_by_id=function(){return b.asm._noise_cipherstate_new_by_id.apply(null,arguments)};b._llvm_bswap_i32=function(){return b.asm._llvm_bswap_i32.apply(null,arguments)};
b._NoiseBuffer_create=function(){return b.asm._NoiseBuffer_create.apply(null,arguments)};b._SymmetricState_get_ck=function(){return b.asm._SymmetricState_get_ck.apply(null,arguments)};b._noise_symmetricstate_mix_hash=function(){return b.asm._noise_symmetricstate_mix_hash.apply(null,arguments)};b._noise_handshakestate_needs_local_keypair=function(){return b.asm._noise_handshakestate_needs_local_keypair.apply(null,arguments)};var R=b._free=function(){return b.asm._free.apply(null,arguments)};
b.runPostSets=function(){return b.asm.runPostSets.apply(null,arguments)};b.setThrew=function(){return b.asm.setThrew.apply(null,arguments)};b.establishStackSpace=function(){return b.asm.establishStackSpace.apply(null,arguments)};b._noise_symmetricstate_free=function(){return b.asm._noise_symmetricstate_free.apply(null,arguments)};b._noise_symmetricstate_new_by_name=function(){return b.asm._noise_symmetricstate_new_by_name.apply(null,arguments)};
b._emscripten_get_global_libc=function(){return b.asm._emscripten_get_global_libc.apply(null,arguments)};var O=b._malloc=function(){return b.asm._malloc.apply(null,arguments)};b._noise_cipherstate_init_key=function(){return b.asm._noise_cipherstate_init_key.apply(null,arguments)};b._noise_handshakestate_set_pre_shared_key=function(){return b.asm._noise_handshakestate_set_pre_shared_key.apply(null,arguments)};b.dynCall_iiiiii=function(){return b.asm.dynCall_iiiiii.apply(null,arguments)};
b.dynCall_i=function(){return b.asm.dynCall_i.apply(null,arguments)};b.dynCall_vi=function(){return b.asm.dynCall_vi.apply(null,arguments)};b.dynCall_vii=function(){return b.asm.dynCall_vii.apply(null,arguments)};b.dynCall_iiii=function(){return b.asm.dynCall_iiii.apply(null,arguments)};b.dynCall_viii=function(){return b.asm.dynCall_viii.apply(null,arguments)};b.dynCall_iii=function(){return b.asm.dynCall_iii.apply(null,arguments)};z.m=b.stackAlloc;z.o=b.stackSave;z.n=b.stackRestore;z.H=b.establishStackSpace;
z.A=b.setTempRet0;z.v=b.getTempRet0;b.asm=Ca;
if(Y)if("function"===typeof b.locateFile?Y=b.locateFile(Y):b.memoryInitializerPrefixURL&&(Y=b.memoryInitializerPrefixURL+Y),t||u){var Da=b.readBinary(Y);P.set(Da,z.e)}else{var Fa=function(){b.readAsync(Y,Ea,function(){throw"could not load memory initializer "+Y;})};za();var Ea=function(a){a.byteLength&&(a=new Uint8Array(a));P.set(a,z.e);b.memoryInitializerRequest&&delete b.memoryInitializerRequest.response;Aa()};if(b.memoryInitializerRequest){var Ga=function(){var a=b.memoryInitializerRequest;200!==
a.status&&0!==a.status?(console.warn("a problem seems to have happened with Module.memoryInitializerRequest, status: "+a.status+", retrying "+Y),Fa()):Ea(a.response)};b.memoryInitializerRequest.response?setTimeout(Ga,0):b.memoryInitializerRequest.addEventListener("load",Ga)}else Fa()}b.then=function(a){if(b.calledRun)a(b);else{var c=b.onRuntimeInitialized;b.onRuntimeInitialized=function(){c&&c();a(b)}}return b};
function x(a){this.name="ExitStatus";this.message="Program terminated with exit("+a+")";this.status=a}x.prototype=Error();x.prototype.constructor=x;var Ha=null,X=function Ia(){b.calledRun||Ja();b.calledRun||(X=Ia)};
b.callMain=b.D=function(a){function c(){for(var a=0;3>a;a++)e.push(0)}a=a||[];V||(V=!0,U(ra));var d=a.length+1,e=[N(wa(b.thisProgram),"i8",0)];c();for(var f=0;f<d-1;f+=1)e.push(N(wa(a[f]),"i8",0)),c();e.push(0);e=N(e,"i32",0);try{var g=b._main(d,e,0);Ka(g,!0)}catch(h){h instanceof x||("SimulateInfiniteLoop"==h?b.noExitRuntime=!0:((a=h)&&"object"===typeof h&&h.stack&&(a=[h,h.stack]),b.d("exception thrown: "+a),b.quit(1,h)))}finally{}};
function Ja(a){function c(){if(!b.calledRun&&(b.calledRun=!0,!G)){V||(V=!0,U(ra));U(sa);if(b.onRuntimeInitialized)b.onRuntimeInitialized();b._main&&La&&b.callMain(a);if(b.postRun)for("function"==typeof b.postRun&&(b.postRun=[b.postRun]);b.postRun.length;){var c=b.postRun.shift();ua.unshift(c)}U(ua)}}a=a||b.arguments;null===Ha&&(Ha=Date.now());if(!(0<W)){if(b.preRun)for("function"==typeof b.preRun&&(b.preRun=[b.preRun]);b.preRun.length;)va();U(qa);0<W||b.calledRun||(b.setStatus?(b.setStatus("Running..."),
setTimeout(function(){setTimeout(function(){b.setStatus("")},1);c()},1)):c())}}b.run=b.run=Ja;function Ka(a,c){if(!c||!b.noExitRuntime){if(!b.noExitRuntime&&(G=!0,y=void 0,U(ta),b.onExit))b.onExit(a);t&&process.exit(a);b.quit(a,new x(a))}}b.exit=b.exit=Ka;var Ma=[];
function H(a){if(b.onAbort)b.onAbort(a);void 0!==a?(b.print(a),b.d(a),a=JSON.stringify(a)):a="";G=!0;var c="abort("+a+") at "+ja()+"\nIf this abort() is unexpected, build with -s ASSERTIONS=1 which can give more information.";Ma&&Ma.forEach(function(d){c=d(c,a)});throw c;}b.abort=b.abort=H;if(b.preInit)for("function"==typeof b.preInit&&(b.preInit=[b.preInit]);0<b.preInit.length;)b.preInit.pop()();var La=!0;b.noInitialRun&&(La=!1);b.noExitRuntime=!0;Ja();
(function(){function a(a){if(a&&a.buffer instanceof ArrayBuffer)a=new Uint8Array(a.buffer,a.byteOffset,a.byteLength);else if("string"===typeof a){for(var c=a.length,d=new Uint8Array(c+1),e=0;e<c;++e)d[e]=a.charCodeAt(e);return d}return a}function c(d,g){var h;h=new Number(d);h.length=g;h.get=function(a){a=a||Uint8Array;return(new a(buffer,h,g/a.BYTES_PER_ELEMENT)).slice()};h.dereference=function(a){a=a||4;return c(h.get(Uint32Array)[0],a)};h.set=function(c){c=a(c);if(c.length>g)throw RangeError("invalid array length");
P.set(c,h)};h.free=function(){R(h);e.splice(e.indexOf(h),1)};e.push(h);return h}function d(d,e){var h;e=a(e);0===d&&(d=e.length);h=c(O(d),d);void 0!==e?(h.set(e),e.length<d&&P.fill(0,h+e.length,h+d)):P.fill(0,h,h+d);return h}var e=[];b.createPointer=c;b.allocatePointer=function(a){a&&(a=Uint32Array.a(a));return d(4,a)};b.allocateBytes=d;b.freeBytes=function(){for(var a=0,c=e.length;a<c;++a)R(e[a]);e=[]}})();

  return Module;
};
if (typeof module === "object" && module.exports) {
  module['exports'] = Module;
};

},{"fs":undefined,"path":undefined,"randombytes":1}],4:[function(require,module,exports){
// Generated by LiveScript 1.5.0
/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
(function(){
  /**
   * Obtained using `vendor/include/noise/protocol/constants.h` converted to JavaScript and post-processed with Prepack to eliminate runtime computations
   *
   * There are many constants exposed by the library, but only subset of them is used in production, so the rest are still here, uncomment when/if needed
   * for debugging or other purposes
   */
  module.exports = {
    NOISE_CIPHER_NONE: 0,
    NOISE_CIPHER_CHACHAPOLY: 17153,
    NOISE_CIPHER_AESGCM: 17154,
    NOISE_PATTERN_XX_FALLBACK: 20496,
    NOISE_PATTERN_XX_FALLBACK_HFS: 20540,
    NOISE_ROLE_INITIATOR: 20993,
    NOISE_ROLE_RESPONDER: 20994,
    NOISE_ACTION_NONE: 0,
    NOISE_ACTION_WRITE_MESSAGE: 16641,
    NOISE_ACTION_READ_MESSAGE: 16642,
    NOISE_ACTION_FAILED: 16643,
    NOISE_ACTION_SPLIT: 16644,
    NOISE_ERROR_NONE: 0,
    NOISE_ERROR_NO_MEMORY: 17665,
    NOISE_ERROR_UNKNOWN_ID: 17666,
    NOISE_ERROR_UNKNOWN_NAME: 17667,
    NOISE_ERROR_MAC_FAILURE: 17668,
    NOISE_ERROR_NOT_APPLICABLE: 17669,
    NOISE_ERROR_SYSTEM: 17670,
    NOISE_ERROR_REMOTE_KEY_REQUIRED: 17671,
    NOISE_ERROR_LOCAL_KEY_REQUIRED: 17672,
    NOISE_ERROR_PSK_REQUIRED: 17673,
    NOISE_ERROR_INVALID_LENGTH: 17674,
    NOISE_ERROR_INVALID_PARAM: 17675,
    NOISE_ERROR_INVALID_STATE: 17676,
    NOISE_ERROR_INVALID_NONCE: 17677,
    NOISE_ERROR_INVALID_PRIVATE_KEY: 17678,
    NOISE_ERROR_INVALID_PUBLIC_KEY: 17679,
    NOISE_ERROR_INVALID_FORMAT: 17680,
    NOISE_ERROR_INVALID_SIGNATURE: 17681,
    NOISE_MAX_PAYLOAD_LEN: 65535
  };
}).call(this);

},{}],5:[function(require,module,exports){
// Generated by LiveScript 1.5.0
/**
 * @package   noise-c.wasm
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
(function(){
  var constants, lib, allocate, allocate_pointer;
  constants = require('./constants');
  lib = require('../noise-c')();
  module.exports = {
    ready: lib.then,
    constants: constants,
    CipherState: CipherState,
    SymmetricState: SymmetricState,
    HandshakeState: HandshakeState
  };
  allocate = lib.allocateBytes;
  allocate_pointer = lib.allocatePointer;
  function allocate_buffer(data, size){
    var tmp, buffer;
    tmp = allocate_pointer();
    lib._NoiseBuffer_create(tmp, data, size, data.length);
    buffer = tmp.dereference();
    tmp.free();
    return buffer;
  }
  function assert_no_error(error, object_to_free){
    var key, ref$, code;
    if (error === constants.NOISE_ERROR_NONE) {
      return;
    }
    for (key in ref$ = constants) {
      code = ref$[key];
      if (code === error) {
        if (object_to_free) {
          try {
            object_to_free.free();
          } catch (e$) {}
        }
        throw new Error(key);
      }
    }
  }
  /**
   * The CipherState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-cipherstate-object
   *
   * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
   * to call free() method, as it was called for you automatically already
   *
   * @param {string} cipher constants.NOISE_CIPHER_CHACHAPOLY, constants.NOISE_CIPHER_AESGCM, etc.
   */
  function CipherState(cipher){
    var tmp, error;
    if (!(this instanceof CipherState)) {
      return new CipherState(cipher);
    }
    tmp = allocate_pointer();
    error = lib._noise_cipherstate_new_by_id(tmp, cipher);
    assert_no_error(error, tmp);
    this._state = tmp.dereference();
    this._mac_length = lib._noise_cipherstate_get_mac_length(this._state);
    tmp.free();
  }
  CipherState.prototype = {
    /**
     * @param {Uint8Array} key
     */
    InitializeKey: function(key){
      var error;
      key = allocate(0, key);
      error = lib._noise_cipherstate_init_key(this._state, key, key.length);
      key.free();
      assert_no_error(error, this);
    },
    HasKey: function(){
      return lib._noise_cipherstate_has_key(this._state) === 1;
    }
    /**
     * @param {Uint8Array} ad
     * @param {Uint8Array} plaintext
     *
     * @return {Uint8Array}
     */,
    EncryptWithAd: function(ad, plaintext){
      var buffer, error, ciphertext;
      ad = allocate(0, ad);
      plaintext = allocate(plaintext.length + this._mac_length, plaintext);
      buffer = allocate_buffer(plaintext, plaintext.length - this._mac_length);
      error = lib._noise_cipherstate_encrypt_with_ad(this._state, ad, ad.length, buffer);
      ciphertext = plaintext.get();
      ad.free();
      plaintext.free();
      buffer.free();
      assert_no_error(error, this);
      return ciphertext;
    }
    /**
     * @param {Uint8Array} ad
     * @param {Uint8Array} ciphertext
     *
     * @return {Uint8Array}
     */,
    DecryptWithAd: function(ad, ciphertext){
      var buffer, error, plaintext;
      ad = allocate(0, ad);
      ciphertext = allocate(0, ciphertext);
      buffer = allocate_buffer(ciphertext, ciphertext.length);
      error = lib._noise_cipherstate_decrypt_with_ad(this._state, ad, ad.length, buffer);
      plaintext = ciphertext.get().slice(0, ciphertext.length - this._mac_length);
      ad.free();
      ciphertext.free();
      buffer.free();
      assert_no_error(error, this);
      return plaintext;
    }
    /**
     * @return {boolean}
     */,
    Rekey: function(){
      throw 'Not implemented';
    }
    /**
     * Call this when object is not needed anymore to avoid memory leaks
     */,
    free: function(){
      var error;
      error = lib._noise_cipherstate_free(this._state);
      delete this._state;
      delete this._mac_length;
      assert_no_error(error);
    }
  };
  function CipherState_split(state){
    this._state = state;
    this._mac_length = lib._noise_cipherstate_get_mac_length(this._state);
  }
  CipherState_split.prototype = Object.create(CipherState.prototype);
  Object.defineProperty(CipherState_split.prototype, 'constructor', {
    enumerable: false,
    value: CipherState_split
  });
  /**
   * The SymmetricState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-symmetricstate-object
   *
   * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
   * to call free() method, as it was called for you automatically already
   *
   * @param {string} protocol_name The name of the Noise protocol to use, for instance, Noise_N_25519_ChaChaPoly_BLAKE2b
   */
  function SymmetricState(protocol_name){
    var tmp, error, this$ = this;
    if (!(this instanceof SymmetricState)) {
      return new SymmetricState(protocol_name);
    }
    tmp = allocate_pointer();
    protocol_name = allocate(0, protocol_name);
    error = lib._noise_symmetricstate_new_by_name(tmp, protocol_name);
    assert_no_error(error, tmp);
    this._state = tmp.dereference();
    tmp.free();
    protocol_name.free();
    Object.defineProperty(this, '_mac_length', {
      configurable: true,
      get: function(){
        var mac_length;
        mac_length = lib._noise_symmetricstate_get_mac_length(this$._state);
        if (mac_length > 0) {
          this$._mac_length = mac_length;
        }
        return mac_length;
      }
    });
  }
  SymmetricState.prototype = {
    /**
     * @param {Uint8Array} input_key_material
     */
    MixKey: function(input_key_material){
      var error;
      input_key_material = allocate(0, input_key_material);
      error = lib._noise_symmetricstate_mix_key(this._state, input_key_material, input_key_material.length);
      input_key_material.free();
      assert_no_error(error, this);
    }
    /**
     * @param {Uint8Array} data
     */,
    MixHash: function(data){
      var error;
      data = allocate(0, data);
      error = lib._noise_symmetricstate_mix_hash(this._state, data, data.length);
      data.free();
      assert_no_error(error, this);
    }
    /**
     * @param {Uint8Array} input_key_material
     */,
    MixKeyAndHash: function(input_key_material){
      var tmp, length, ck, data;
      this.MixKey(input_key_material);
      tmp = allocate_pointer();
      length = lib._SymmetricState_get_ck(this._state, tmp);
      ck = tmp.dereference(length);
      tmp.free();
      data = ck.get();
      ck.free();
      this.MixHash(data);
    }
    /**
     * @param {Uint8Array} plaintext
     *
     * @return {Uint8Array}
     */,
    EncryptAndHash: function(plaintext){
      var buffer, error, ciphertext;
      plaintext = allocate(plaintext.length + this._mac_length, plaintext);
      buffer = allocate_buffer(plaintext, plaintext.length - this._mac_length);
      error = lib._noise_symmetricstate_encrypt_and_hash(this._state, buffer);
      ciphertext = plaintext.get();
      plaintext.free();
      buffer.free();
      assert_no_error(error, this);
      return ciphertext;
    }
    /**
     * @param {Uint8Array} ciphertext
     *
     * @return {Uint8Array}
     */,
    DecryptAndHash: function(ciphertext){
      var buffer, error, plaintext;
      ciphertext = allocate(0, ciphertext);
      buffer = allocate_buffer(ciphertext, ciphertext.length);
      error = lib._noise_symmetricstate_decrypt_and_hash(this._state, buffer);
      plaintext = ciphertext.get().slice(0, ciphertext.length - this._mac_length);
      ciphertext.free();
      buffer.free();
      assert_no_error(error, this);
      return plaintext;
    }
    /**
     * @return {CipherState[]}
     */,
    Split: function(){
      var tmp1, tmp2, error, e, cs1, cs2;
      tmp1 = allocate_pointer();
      tmp2 = allocate_pointer();
      error = lib._noise_symmetricstate_split(this._state, tmp1, tmp2);
      try {
        assert_no_error(error);
      } catch (e$) {
        e = e$;
        tmp1.free();
        tmp2.free();
        throw e;
      }
      cs1 = new CipherState_split(tmp1.dereference());
      cs2 = new CipherState_split(tmp2.dereference());
      tmp1.free();
      tmp2.free();
      try {
        this.free();
      } catch (e$) {
        e = e$;
        try {
          cs1.free();
        } catch (e$) {}
        try {
          cs2.free();
        } catch (e$) {}
        throw e;
      }
      return [cs1, cs2];
    }
    /**
     * Call this when object is not needed anymore to avoid memory leaks
     */,
    free: function(){
      var error;
      error = lib._noise_symmetricstate_free(this._state);
      delete this._state;
      delete this._mac_length;
      assert_no_error(error);
    }
  };
  /**
   * The HandshakeState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-handshakestate-object
   *
   * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
   * to call free() method, as it was called for you automatically already
   *
   * @param {string}	protocol_name	The name of the Noise protocol to use, for instance, Noise_N_25519_ChaChaPoly_BLAKE2b
   * @param {number}	initiator		The role for the new object, either constants.NOISE_ROLE_INITIATOR or constants.NOISE_ROLE_RESPONDER
   */
  function HandshakeState(protocol_name, role){
    var tmp, error;
    if (!(this instanceof HandshakeState)) {
      return new HandshakeState(protocol_name, role, prologue, s, e, rs, re, psk);
    }
    tmp = allocate_pointer();
    protocol_name = allocate(0, protocol_name);
    error = lib._noise_handshakestate_new_by_name(tmp, protocol_name, role);
    protocol_name.free();
    assert_no_error(error, tmp);
    this._state = tmp.dereference();
    tmp.free();
  }
  HandshakeState.prototype = {
    /**
     * Must be called after object creation and after switch to a fallback handshake.
     *
     * In case of fallback handshake it is not required to specify values that are the same as in previous Initialize() call, those will be used by default
     *
     * @param {null|Uint8Array}	prologue	Prologue value
     * @param {null|Uint8Array}	s			Local static private key
     * @param {null|Uint8Array}	rs			Remote static public key
     * @param {null|Uint8Array}	psk			Pre-shared symmetric key
     */
    Initialize: function(prologue, s, rs, psk){
      var error, dh;
      prologue == null && (prologue = null);
      s == null && (s = null);
      rs == null && (rs = null);
      psk == null && (psk = null);
      if (prologue) {
        prologue = allocate(0, prologue);
        error = lib._noise_handshakestate_set_prologue(this._state, prologue, prologue.length);
        prologue.free();
        assert_no_error(error, this);
      }
      if (psk && lib._noise_handshakestate_needs_pre_shared_key(this._state) === 1) {
        psk = allocate(0, psk);
        error = lib._noise_handshakestate_set_pre_shared_key(this._state, psk, psk.length);
        psk.free();
        assert_no_error(error, this);
      }
      if (lib._noise_handshakestate_needs_local_keypair(this._state) === 1) {
        if (!s) {
          throw new Error('Local static private key (s) required, but not provided');
        }
        dh = lib._noise_handshakestate_get_local_keypair_dh(this._state);
        s = allocate(0, s);
        error = lib._noise_dhstate_set_keypair_private(dh, s, s.length);
        s.free();
        assert_no_error(error, this);
      }
      if (lib._noise_handshakestate_needs_remote_public_key(this._state) === 1) {
        if (!rs) {
          throw new Error('Remote static private key (rs) required, but not provided');
        }
        dh = lib._noise_handshakestate_get_remote_public_key_dh(this._state);
        rs = allocate(0, rs);
        error = lib._noise_dhstate_set_public_key(dh, rs, rs.length);
        rs.free();
        assert_no_error(error, this);
      }
      error = lib._noise_handshakestate_start(this._state);
      assert_no_error(error, this);
    }
    /**
     * @return {number} One of constants.NOISE_ACTION_*
     */,
    GetAction: function(){
      return lib._noise_handshakestate_get_action(this._state);
    }
    /**
     * Might be called when GetAction() returned constants.NOISE_ACTION_FAILED and switching to fallback protocol is desired
     *
     * @param {number} pattern_id One of constants.NOISE_PATTERN_*_FALLBACK*
     */,
    FallbackTo: function(pattern_id){
      var error;
      pattern_id == null && (pattern_id = constants.NOISE_PATTERN_XX_FALLBACK);
      error = lib._noise_handshakestate_fallback_to(pattern_id);
      assert_no_error(error, this);
    }
    /**
     * @param {null|Uint8Array} payload null if no payload is required
     *
     * @return {Uint8Array} Message that should be sent to the other side
     */,
    WriteMessage: function(payload){
      var message, message_buffer, payload_buffer, error, e, message_length, real_message;
      payload == null && (payload = null);
      message = allocate(constants.NOISE_MAX_PAYLOAD_LEN);
      message_buffer = allocate_buffer(message, 0);
      payload_buffer = null;
      if (payload) {
        payload = allocate(0, payload);
        payload_buffer = allocate_buffer(payload, payload.length);
      }
      error = lib._noise_handshakestate_write_message(this._state, message_buffer, payload_buffer);
      if (payload) {
        payload.free();
        payload_buffer.free();
      }
      try {
        assert_no_error(error, this);
      } catch (e$) {
        e = e$;
        message.free();
        message_buffer.free();
        throw e;
      }
      message_length = lib._NoiseBuffer_get_size(message_buffer);
      real_message = message.get().slice(0, message_length);
      message.free();
      message_buffer.free();
      return real_message;
    }
    /**
     * @param {Uint8Array}	message			Message received from the other side
     * @param {boolean}		payload_needed	false if the application does not need the message payload
     *
     * @return {null|Uint8Array}
     */,
    ReadMessage: function(message, payload_needed){
      var message_buffer, payload_buffer, payload, error, e, real_payload, payload_length;
      payload_needed == null && (payload_needed = false);
      message = allocate(0, message);
      message_buffer = allocate_buffer(message, message.length);
      payload_buffer = null;
      if (payload_needed) {
        payload = allocate(constants.NOISE_MAX_PAYLOAD_LEN);
        payload_buffer = allocate_buffer(payload_buffer);
      }
      error = lib._noise_handshakestate_read_message(this._state, message_buffer, payload_buffer);
      message.free();
      message_buffer.free();
      try {
        assert_no_error(error, this);
      } catch (e$) {
        e = e$;
        if (payload_needed) {
          payload.free();
          payload_buffer.free();
        }
        throw e;
      }
      real_payload = null;
      if (payload_needed) {
        payload_length = lib._NoiseBuffer_get_size(payload);
        real_payload = payload.get().slice(0, payload_length);
        payload.free();
        payload_buffer.free();
      }
      real_payload;
    }
    /**
     * @return {CipherState[]} [send, receive]
     */,
    Split: function(){
      var tmp1, tmp2, error, e, cs1, cs2;
      tmp1 = allocate_pointer();
      tmp2 = allocate_pointer();
      error = lib._noise_handshakestate_split(this._state, tmp1, tmp2);
      try {
        assert_no_error(error, this);
      } catch (e$) {
        e = e$;
        tmp1.free();
        tmp2.free();
        throw e;
      }
      cs1 = new CipherState_split(tmp1.dereference());
      cs2 = new CipherState_split(tmp2.dereference());
      tmp1.free();
      tmp2.free();
      try {
        this.free();
      } catch (e$) {
        e = e$;
        try {
          cs1.free();
        } catch (e$) {}
        try {
          cs2.free();
        } catch (e$) {}
        throw e;
      }
      return [cs1, cs2];
    }
    /**
     * Call this when object is not needed anymore to avoid memory leaks
     */,
    free: function(){
      var error;
      error = lib._noise_handshakestate_free(this._state);
      delete this._state;
      assert_no_error(error);
    }
  };
}).call(this);

},{"../noise-c":3,"./constants":4}]},{},[5])(5)
});