(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.noise_c_wasm = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Module = function(Module) {
  Module = Module || {};
  var Module = Module;

var a;a||(a=eval("(function() { try { return Module || {} } catch(e) { return {} } })()"));var k={},m;for(m in a)a.hasOwnProperty(m)&&(k[m]=a[m]);var n=!1,p=!1,q=!1,t=!1;
if(a.ENVIRONMENT)if("WEB"===a.ENVIRONMENT)n=!0;else if("WORKER"===a.ENVIRONMENT)p=!0;else if("NODE"===a.ENVIRONMENT)q=!0;else if("SHELL"===a.ENVIRONMENT)t=!0;else throw Error("The provided Module['ENVIRONMENT'] value is not valid. It must be one of: WEB|WORKER|NODE|SHELL.");else n="object"===typeof window,p="function"===typeof importScripts,q="object"===typeof process&&"function"===typeof require&&!n&&!p,t=!n&&!q&&!p;
if("function"!==typeof a.locateFile){if(a.memoryInitializerPrefixURL||a.pthreadMainPrefixURL||a.cdInitializerPrefixURL||a.filePackagePrefixURL)throw Error("Module['locateFile'] can't be used together with Module['*PrefixURL'] options; if you need to customize prefix, take a look at Module['scriptDirectory'] option instead");a.scriptDirectory||(a.scriptDirectory=q?__dirname+"/":n&&0!==document.currentScript.src.indexOf("blob:")?document.currentScript.src.split("/").slice(0,-1).join("/")+"/":p?self.location.href.split("/").slice(0,
-1).join("/")+"/":"");a.locateFile=function(b){return a.scriptDirectory+b}}
if(q){a.print||(a.print=console.log);a.printErr||(a.printErr=console.warn);var u,v;a.read=function(b,c){u||(u=require("fs"));v||(v=require("path"));b=v.normalize(b);var d=u.readFileSync(b);return c?d:d.toString()};a.readBinary=function(b){b=a.read(b,!0);b.buffer||(b=new Uint8Array(b));assert(b.buffer);return b};a.load=function(b){aa(read(b))};a.thisProgram||(a.thisProgram=1<process.argv.length?process.argv[1].replace(/\\/g,"/"):"unknown-program");a.arguments=process.argv.slice(2);process.on("uncaughtException",
function(b){if(!(b instanceof w))throw b;});a.inspect=function(){return"[Emscripten Module object]"}}else if(t)a.print||(a.print=print),"undefined"!=typeof printErr&&(a.printErr=printErr),a.read="undefined"!=typeof read?read:function(){throw"no read() available";},a.readBinary=function(b){if("function"===typeof readbuffer)return new Uint8Array(readbuffer(b));b=read(b,"binary");assert("object"===typeof b);return b},"undefined"!=typeof scriptArgs?a.arguments=scriptArgs:"undefined"!=typeof arguments&&
(a.arguments=arguments),"function"===typeof quit&&(a.quit=function(b){quit(b)}),eval("if (typeof gc === 'function' && gc.toString().indexOf('[native code]') > 0) var gc = undefined");else if(n||p)a.read=function(b){var c=new XMLHttpRequest;c.open("GET",b,!1);c.send(null);return c.responseText},p&&(a.readBinary=function(b){var c=new XMLHttpRequest;c.open("GET",b,!1);c.responseType="arraybuffer";c.send(null);return new Uint8Array(c.response)}),a.readAsync=function(b,c,d){var e=new XMLHttpRequest;e.open("GET",
b,!0);e.responseType="arraybuffer";e.onload=function(){200==e.status||0==e.status&&e.response?c(e.response):d()};e.onerror=d;e.send(null)},"undefined"!=typeof arguments&&(a.arguments=arguments),"undefined"!==typeof console?(a.print||(a.print=function(b){console.log(b)}),a.printErr||(a.printErr=function(b){console.warn(b)})):a.print||(a.print=function(){}),p&&(a.load=importScripts),"undefined"===typeof a.setWindowTitle&&(a.setWindowTitle=function(b){document.title=b});else throw"Unknown runtime environment. Where are we?";
function aa(b){eval.call(null,b)}!a.load&&a.read&&(a.load=function(b){aa(a.read(b))});a.print||(a.print=function(){});a.printErr||(a.printErr=a.print);a.arguments||(a.arguments=[]);a.thisProgram||(a.thisProgram="./this.program");a.quit||(a.quit=function(b,c){throw c;});a.print=a.print;a.d=a.printErr;a.preRun=[];a.postRun=[];for(m in k)k.hasOwnProperty(m)&&(a[m]=k[m]);
var k=void 0,y={C:function(b){return tempRet0=b},w:function(){return tempRet0},o:function(){return x},n:function(b){x=b},l:function(b){switch(b){case "i1":case "i8":return 1;case "i16":return 2;case "i32":return 4;case "i64":return 8;case "float":return 4;case "double":return 8;default:return"*"===b[b.length-1]?y.f:"i"===b[0]?(b=parseInt(b.substr(1)),assert(0===b%8),b/8):0}},v:function(b){return Math.max(y.l(b),y.f)},D:16,R:function(b,c){"double"===c||"i64"===c?b&7&&(assert(4===(b&7)),b+=4):assert(0===
(b&3));return b},L:function(b,c,d){return d||"i64"!=b&&"double"!=b?b?Math.min(c||(b?y.v(b):0),y.f):Math.min(c,8):8},h:function(b,c,d){return d&&d.length?a["dynCall_"+b].apply(null,[c].concat(d)):a["dynCall_"+b].call(null,c)},c:[],q:function(b){for(var c=0;c<y.c.length;c++)if(!y.c[c])return y.c[c]=b,2*(1+c);throw"Finished up all reserved function pointers. Use a higher value for RESERVED_FUNCTION_POINTERS.";},B:function(b){y.c[(b-2)/2]=null},b:function(b){y.b.j||(y.b.j={});y.b.j[b]||(y.b.j[b]=1,a.d(b))},
i:{},N:function(b,c){if(b){assert(c);y.i[c]||(y.i[c]={});var d=y.i[c];d[b]||(d[b]=1===c.length?function(){return y.h(c,b)}:2===c.length?function(d){return y.h(c,b,[d])}:function(){return y.h(c,b,Array.prototype.slice.call(arguments))});return d[b]}},M:function(){throw"You must build with -s RETAIN_COMPILER_SETTINGS=1 for Runtime.getCompilerSetting or emscripten_get_compiler_setting to work";},m:function(b){var c=x;x=x+b|0;x=x+15&-16;return c},p:function(b){var c=z;z=z+b|0;z=z+15&-16;return c},u:function(b){var c=
A[B>>2];b=(c+b+15|0)&-16;A[B>>2]=b;if(b=b>=E)F(),b=!0;return b?(A[B>>2]=c,0):c},k:function(b,c){return Math.ceil(b/(c?c:16))*(c?c:16)},Q:function(b,c,d){return d?+(b>>>0)+4294967296*+(c>>>0):+(b>>>0)+4294967296*+(c|0)},e:1024,f:4,F:0};y.addFunction=y.q;y.removeFunction=y.B;var G=0;function assert(b,c){b||H("Assertion failed: "+c)}
function ba(b){var c;c="i32";"*"===c.charAt(c.length-1)&&(c="i32");switch(c){case "i1":return I[b>>0];case "i8":return I[b>>0];case "i16":return J[b>>1];case "i32":return A[b>>2];case "i64":return A[b>>2];case "float":return K[b>>2];case "double":return L[b>>3];default:H("invalid type for setValue: "+c)}return null}
function M(b,c,d){var e,f,h;"number"===typeof b?(f=!0,h=b):(f=!1,h=b.length);var g="string"===typeof c?c:null,l;4==d?l=e:l=["function"===typeof N?N:y.p,y.m,y.p,y.u][void 0===d?2:d](Math.max(h,g?1:c.length));if(f){e=l;assert(0==(l&3));for(b=l+(h&-4);e<b;e+=4)A[e>>2]=0;for(b=l+h;e<b;)I[e++>>0]=0;return l}if("i8"===g)return b.subarray||b.slice?O.set(b,l):O.set(new Uint8Array(b),l),l;e=0;for(var C,Z;e<h;){var r=b[e];"function"===typeof r&&(r=y.O(r));d=g||c[e];if(0===d)e++;else{"i64"==d&&(d="i32");f=l+
e;var D=d,D=D||"i8";"*"===D.charAt(D.length-1)&&(D="i32");switch(D){case "i1":I[f>>0]=r;break;case "i8":I[f>>0]=r;break;case "i16":J[f>>1]=r;break;case "i32":A[f>>2]=r;break;case "i64":tempI64=[r>>>0,(tempDouble=r,1<=+ca(tempDouble)?0<tempDouble?(da(+ea(tempDouble/4294967296),4294967295)|0)>>>0:~~+fa((tempDouble-+(~~tempDouble>>>0))/4294967296)>>>0:0)];A[f>>2]=tempI64[0];A[f+4>>2]=tempI64[1];break;case "float":K[f>>2]=r;break;case "double":L[f>>3]=r;break;default:H("invalid type for setValue: "+D)}Z!==
d&&(C=y.l(d),Z=d);e+=C}}return l}function P(b){var c;if(0===c||!b)return"";for(var d=0,e,f=0;;){e=O[b+f>>0];d|=e;if(0==e&&!c)break;f++;if(c&&f==c)break}c||(c=f);e="";if(128>d){for(;0<c;)d=String.fromCharCode.apply(String,O.subarray(b,b+Math.min(c,1024))),e=e?e+d:d,b+=1024,c-=1024;return e}return a.UTF8ToString(b)}"undefined"!==typeof TextDecoder&&new TextDecoder("utf8");
function ga(b,c,d,e){if(0<e){e=d+e-1;for(var f=0;f<b.length;++f){var h=b.charCodeAt(f);55296<=h&&57343>=h&&(h=65536+((h&1023)<<10)|b.charCodeAt(++f)&1023);if(127>=h){if(d>=e)break;c[d++]=h}else{if(2047>=h){if(d+1>=e)break;c[d++]=192|h>>6}else{if(65535>=h){if(d+2>=e)break;c[d++]=224|h>>12}else{if(2097151>=h){if(d+3>=e)break;c[d++]=240|h>>18}else{if(67108863>=h){if(d+4>=e)break;c[d++]=248|h>>24}else{if(d+5>=e)break;c[d++]=252|h>>30;c[d++]=128|h>>24&63}c[d++]=128|h>>18&63}c[d++]=128|h>>12&63}c[d++]=
128|h>>6&63}c[d++]=128|h&63}}c[d]=0}}function ha(b){for(var c=0,d=0;d<b.length;++d){var e=b.charCodeAt(d);55296<=e&&57343>=e&&(e=65536+((e&1023)<<10)|b.charCodeAt(++d)&1023);127>=e?++c:c=2047>=e?c+2:65535>=e?c+3:2097151>=e?c+4:67108863>=e?c+5:c+6}return c}"undefined"!==typeof TextDecoder&&new TextDecoder("utf-16le");
function ia(b){return b.replace(/__Z[\w\d_]+/g,function(b){var d;a:{var e=a.___cxa_demangle||a.__cxa_demangle;if(e)try{var f=b.substr(1),h=ha(f)+1,g=N(h);ga(f,O,g,h);var l=N(4),C=e(g,0,0,l);if(0===ba(l)&&C){d=P(C);break a}}catch(Z){}finally{g&&Q(g),l&&Q(l),C&&Q(C)}else y.b("warning: build with  -s DEMANGLE_SUPPORT=1  to link in libcxxabi demangling");d=b}return b===d?b:b+" ["+d+"]"})}
function ja(){var b;a:{b=Error();if(!b.stack){try{throw Error(0);}catch(c){b=c}if(!b.stack){b="(no stack trace available)";break a}}b=b.stack.toString()}a.extraStackTrace&&(b+="\n"+a.extraStackTrace());return ia(b)}var buffer,I,O,J,ka,A,la,K,L;
function ma(){a.HEAP8=I=new Int8Array(buffer);a.HEAP16=J=new Int16Array(buffer);a.HEAP32=A=new Int32Array(buffer);a.HEAPU8=O=new Uint8Array(buffer);a.HEAPU16=ka=new Uint16Array(buffer);a.HEAPU32=la=new Uint32Array(buffer);a.HEAPF32=K=new Float32Array(buffer);a.HEAPF64=L=new Float64Array(buffer)}var R,z,na,x,S,oa,B;R=z=na=x=S=oa=B=0;
function F(){H("Cannot enlarge memory arrays. Either (1) compile with  -s TOTAL_MEMORY=X  with X higher than the current value "+E+", (2) compile with  -s ALLOW_MEMORY_GROWTH=1  which allows increasing the size at runtime, or (3) if you want malloc to return NULL (0) instead of this abort, compile with  -s ABORTING_MALLOC=0 ")}var pa=a.TOTAL_STACK||5242880,E=a.TOTAL_MEMORY||16777216;E<pa&&a.d("TOTAL_MEMORY should be larger than TOTAL_STACK, was "+E+"! (TOTAL_STACK="+pa+")");
a.buffer?buffer=a.buffer:"object"===typeof WebAssembly&&"function"===typeof WebAssembly.Memory?(a.wasmMemory=new WebAssembly.Memory({initial:E/65536,maximum:E/65536}),buffer=a.wasmMemory.buffer):buffer=new ArrayBuffer(E);ma();A[0]=1668509029;J[1]=25459;if(115!==O[2]||99!==O[3])throw"Runtime error: expected the system to be little-endian!";a.HEAP=void 0;a.buffer=buffer;a.HEAP8=I;a.HEAP16=J;a.HEAP32=A;a.HEAPU8=O;a.HEAPU16=ka;a.HEAPU32=la;a.HEAPF32=K;a.HEAPF64=L;
function T(b){for(;0<b.length;){var c=b.shift();if("function"==typeof c)c();else{var d=c.K;"number"===typeof d?void 0===c.g?a.dynCall_v(d):a.dynCall_vi(d,c.g):d(void 0===c.g?null:c.g)}}}var qa=[],ra=[],sa=[],ua=[],va=[],U=!1;function wa(){var b=a.preRun.shift();qa.unshift(b)}function xa(b){var c=Array(ha(b)+1);ga(b,c,0,c.length);return c}Math.imul&&-5===Math.imul(4294967295,5)||(Math.imul=function(b,c){var d=b&65535,e=c&65535;return d*e+((b>>>16)*e+d*(c>>>16)<<16)|0});Math.P=Math.imul;
if(!Math.fround){var ya=new Float32Array(1);Math.fround=function(b){ya[0]=b;return ya[0]}}Math.J=Math.fround;Math.clz32||(Math.clz32=function(b){b=b>>>0;for(var c=0;32>c;c++)if(b&1<<31-c)return c;return 32});Math.H=Math.clz32;Math.trunc||(Math.trunc=function(b){return 0>b?Math.ceil(b):Math.floor(b)});Math.trunc=Math.trunc;var ca=Math.abs,fa=Math.ceil,ea=Math.floor,da=Math.min,V=0,za=null,W=null;function Aa(){V++;a.monitorRunDependencies&&a.monitorRunDependencies(V)}
function Ba(){V--;a.monitorRunDependencies&&a.monitorRunDependencies(V);if(0==V&&(null!==za&&(clearInterval(za),za=null),W)){var b=W;W=null;b()}}a.preloadedImages={};a.preloadedAudios={};var X=null;
(function(){function b(b){var c=a.usingWasm?65536:16777216;0<b%c&&(b+=c-b%c);var c=a.buffer,d=c.byteLength;if(a.usingWasm)try{return-1!==a.wasmMemory.grow((b-d)/65536)?a.buffer=a.wasmMemory.buffer:null}catch(e){return null}else return h.__growWasmMemory((b-d)/65536),a.buffer!==c?a.buffer:null}function c(){return a.wasmBinary||!n&&!p||"function"!==typeof fetch?new Promise(function(b){var c;a:{try{var d;if(a.wasmBinary)d=a.wasmBinary,d=new Uint8Array(d);else if(a.readBinary)d=a.readBinary(e);else throw"on the web, we need the wasm binary to be preloaded and set on Module['wasmBinary']. emcc.py will do that for you when generating HTML (but not JS)";
c=d;break a}catch(f){H(f)}c=void 0}b(c)}):fetch(e,{t:"same-origin"}).then(function(b){if(!b.ok)throw"failed to load wasm binary file at '"+e+"'";return b.arrayBuffer()})}function d(b,d){function g(b){h=b.exports;if(h.memory){b=h.memory;var c=a.buffer;b.byteLength<c.byteLength&&a.printErr("the new buffer in mergeMemory is smaller than the previous one. in native wasm, we should grow memory here");var c=new Int8Array(c),d=new Int8Array(b);X||c.set(d.subarray(a.STATIC_BASE,a.STATIC_BASE+a.STATIC_BUMP),
a.STATIC_BASE);d.set(c);a.buffer=buffer=b;ma()}a.asm=h;a.usingWasm=!0;Ba()}function l(b){g(b.instance)}function ta(b){c().then(function(b){return WebAssembly.instantiate(b,f)}).then(b).catch(function(b){a.printErr("failed to asynchronously prepare wasm: "+b);H(b)})}if("object"!==typeof WebAssembly)return a.printErr("no native wasm support detected"),!1;if(!(a.wasmMemory instanceof WebAssembly.Memory))return a.printErr("no native wasm Memory in use"),!1;d.memory=a.wasmMemory;f.global={NaN:NaN,Infinity:Infinity};
f["global.Math"]=b.Math;f.env=d;Aa();if(a.instantiateWasm)try{return a.instantiateWasm(f,g)}catch(La){return a.printErr("Module.instantiateWasm callback failed with error: "+La),!1}a.wasmBinary||"function"!==typeof WebAssembly.A?ta(l):WebAssembly.A(fetch(e,{t:"same-origin"}),f).then(l).catch(function(b){a.printErr("wasm streaming compile failed: "+b);a.printErr("falling back to ArrayBuffer instantiation");ta(l)});return{}}a.wasmJSMethod=a.wasmJSMethod||"native-wasm";a.locateFile(a.wasmTextFile||"noise-c.wast");
var e=a.locateFile(a.wasmBinaryFile||"noise-c.wasm");a.locateFile(a.asmjsCodeFile||"noise-c.temp.asm.js");var f={global:null,env:null,asm2wasm:{"f64-rem":function(b,c){return b%c},"f64-to-int":function(b){return b|0},"i32s-div":function(b,c){return(b|0)/(c|0)|0},"i32u-div":function(b,c){return(b>>>0)/(c>>>0)>>>0},"i32s-rem":function(b,c){return(b|0)%(c|0)|0},"i32u-rem":function(b,c){return(b>>>0)%(c>>>0)>>>0},"debugger":function(){debugger}},parent:a},h=null;a.asmPreload=a.asm;var g=a.reallocBuffer;
a.reallocBuffer=function(c){return"asmjs"===l?g(c):b(c)};var l="";a.asm=function(b,c){if(!c.table){var e=a.wasmTableSize;void 0===e&&(e=1024);var f=a.wasmMaxTableSize;c.table="object"===typeof WebAssembly&&"function"===typeof WebAssembly.Table?void 0!==f?new WebAssembly.Table({initial:e,maximum:f,element:"anyfunc"}):new WebAssembly.Table({initial:e,element:"anyfunc"}):Array(e);a.wasmTable=c.table}c.memoryBase||(c.memoryBase=a.STATIC_BASE);c.tableBase||(c.tableBase=0);return d(b,c)}})();R=y.e;
z=R+42992;ra.push();X=0<=a.wasmJSMethod.indexOf("asmjs")||0<=a.wasmJSMethod.indexOf("interpret-asm2wasm")?"noise-c.js.mem":null;a.STATIC_BASE=R;a.STATIC_BUMP=42992;var Ca=z;z+=16;function Y(){Y.a||(Y.a=[]);Y.a.push(y.o());return Y.a.length-1}B=M(1,"i32",2);na=x=y.k(z);S=na+pa;oa=y.k(S);A[B>>2]=oa;a.wasmTableSize=68;a.wasmMaxTableSize=68;
a.r={Math:Math,Int8Array:Int8Array,Int16Array:Int16Array,Int32Array:Int32Array,Uint8Array:Uint8Array,Uint16Array:Uint16Array,Uint32Array:Uint32Array,Float32Array:Float32Array,Float64Array:Float64Array,NaN:NaN,Infinity:Infinity};
a.s={abort:H,assert:assert,enlargeMemory:function(){F()},getTotalMemory:function(){return E},abortOnCannotGrowMemory:F,invoke_iiiiii:function(b,c,d,e,f,h){try{return a.dynCall_iiiiii(b,c,d,e,f,h)}catch(g){if("number"!==typeof g&&"longjmp"!==g)throw g;a.setThrew(1,0)}},invoke_i:function(b){try{return a.dynCall_i(b)}catch(c){if("number"!==typeof c&&"longjmp"!==c)throw c;a.setThrew(1,0)}},invoke_vi:function(b,c){try{a.dynCall_vi(b,c)}catch(d){if("number"!==typeof d&&"longjmp"!==d)throw d;a.setThrew(1,
0)}},invoke_vii:function(b,c,d){try{a.dynCall_vii(b,c,d)}catch(e){if("number"!==typeof e&&"longjmp"!==e)throw e;a.setThrew(1,0)}},invoke_iiii:function(b,c,d,e){try{return a.dynCall_iiii(b,c,d,e)}catch(f){if("number"!==typeof f&&"longjmp"!==f)throw f;a.setThrew(1,0)}},invoke_viii:function(b,c,d,e){try{a.dynCall_viii(b,c,d,e)}catch(f){if("number"!==typeof f&&"longjmp"!==f)throw f;a.setThrew(1,0)}},invoke_iii:function(b,c,d){try{return a.dynCall_iii(b,c,d)}catch(e){if("number"!==typeof e&&"longjmp"!==
e)throw e;a.setThrew(1,0)}},_noise_rand_bytes:function(b,c){var d;d=require("./src/randombytes");O.set(d(c),b)},_llvm_stacksave:Y,___setErrNo:function(b){a.___errno_location&&(A[a.___errno_location()>>2]=b);return b},_emscripten_memcpy_big:function(b,c,d){O.set(O.subarray(c,c+d),b);return b},_llvm_stackrestore:function(b){var c=Y.a[b];Y.a.splice(b,1);y.n(c)},___assert_fail:function(b,c,d,e){G=!0;throw"Assertion failed: "+P(b)+", at: "+[c?P(c):"unknown filename",d,e?P(e):"unknown function"]+" at "+
ja();},DYNAMICTOP_PTR:B,tempDoublePtr:Ca,ABORT:G,STACKTOP:x,STACK_MAX:S};var Da=a.asm(a.r,a.s,buffer);a.asm=Da;a._noise_symmetricstate_split=function(){return a.asm._noise_symmetricstate_split.apply(null,arguments)};a.runPostSets=function(){return a.asm.runPostSets.apply(null,arguments)};a.stackSave=function(){return a.asm.stackSave.apply(null,arguments)};a._NoiseBuffer_get_size=function(){return a.asm._NoiseBuffer_get_size.apply(null,arguments)};
a._noise_cipherstate_decrypt_with_ad=function(){return a.asm._noise_cipherstate_decrypt_with_ad.apply(null,arguments)};a.getTempRet0=function(){return a.asm.getTempRet0.apply(null,arguments)};a._noise_cipherstate_encrypt_with_ad=function(){return a.asm._noise_cipherstate_encrypt_with_ad.apply(null,arguments)};a.setTempRet0=function(){return a.asm.setTempRet0.apply(null,arguments)};
a._noise_handshakestate_get_local_keypair_dh=function(){return a.asm._noise_handshakestate_get_local_keypair_dh.apply(null,arguments)};a._noise_handshakestate_free=function(){return a.asm._noise_handshakestate_free.apply(null,arguments)};a._sbrk=function(){return a.asm._sbrk.apply(null,arguments)};a._noise_handshakestate_needs_remote_public_key=function(){return a.asm._noise_handshakestate_needs_remote_public_key.apply(null,arguments)};
a._noise_dhstate_set_public_key=function(){return a.asm._noise_dhstate_set_public_key.apply(null,arguments)};a._noise_symmetricstate_get_mac_length=function(){return a.asm._noise_symmetricstate_get_mac_length.apply(null,arguments)};a._noise_cipherstate_get_mac_length=function(){return a.asm._noise_cipherstate_get_mac_length.apply(null,arguments)};a._noise_handshakestate_read_message=function(){return a.asm._noise_handshakestate_read_message.apply(null,arguments)};
a._noise_dhstate_set_keypair_private=function(){return a.asm._noise_dhstate_set_keypair_private.apply(null,arguments)};a._memset=function(){return a.asm._memset.apply(null,arguments)};a._noise_handshakestate_needs_pre_shared_key=function(){return a.asm._noise_handshakestate_needs_pre_shared_key.apply(null,arguments)};a._noise_cipherstate_has_key=function(){return a.asm._noise_cipherstate_has_key.apply(null,arguments)};
a._noise_cipherstate_free=function(){return a.asm._noise_cipherstate_free.apply(null,arguments)};a._memcpy=function(){return a.asm._memcpy.apply(null,arguments)};a._noise_handshakestate_set_prologue=function(){return a.asm._noise_handshakestate_set_prologue.apply(null,arguments)};a.stackAlloc=function(){return a.asm.stackAlloc.apply(null,arguments)};a._noise_handshakestate_new_by_name=function(){return a.asm._noise_handshakestate_new_by_name.apply(null,arguments)};
a._noise_handshakestate_fallback_to=function(){return a.asm._noise_handshakestate_fallback_to.apply(null,arguments)};a._noise_handshakestate_get_fixed_hybrid_dh=function(){return a.asm._noise_handshakestate_get_fixed_hybrid_dh.apply(null,arguments)};a._noise_handshakestate_split=function(){return a.asm._noise_handshakestate_split.apply(null,arguments)};a._noise_handshakestate_start=function(){return a.asm._noise_handshakestate_start.apply(null,arguments)};
a.stackRestore=function(){return a.asm.stackRestore.apply(null,arguments)};a._noise_handshakestate_write_message=function(){return a.asm._noise_handshakestate_write_message.apply(null,arguments)};a._llvm_bswap_i16=function(){return a.asm._llvm_bswap_i16.apply(null,arguments)};a._emscripten_get_global_libc=function(){return a.asm._emscripten_get_global_libc.apply(null,arguments)};
a._noise_handshakestate_get_remote_public_key_dh=function(){return a.asm._noise_handshakestate_get_remote_public_key_dh.apply(null,arguments)};a._noise_symmetricstate_encrypt_and_hash=function(){return a.asm._noise_symmetricstate_encrypt_and_hash.apply(null,arguments)};a._noise_symmetricstate_mix_key=function(){return a.asm._noise_symmetricstate_mix_key.apply(null,arguments)};a._noise_cipherstate_new_by_id=function(){return a.asm._noise_cipherstate_new_by_id.apply(null,arguments)};
a._llvm_bswap_i32=function(){return a.asm._llvm_bswap_i32.apply(null,arguments)};a._NoiseBuffer_create=function(){return a.asm._NoiseBuffer_create.apply(null,arguments)};a._SymmetricState_get_ck=function(){return a.asm._SymmetricState_get_ck.apply(null,arguments)};a._noise_symmetricstate_mix_hash=function(){return a.asm._noise_symmetricstate_mix_hash.apply(null,arguments)};a._noise_handshakestate_needs_local_keypair=function(){return a.asm._noise_handshakestate_needs_local_keypair.apply(null,arguments)};
var Q=a._free=function(){return a.asm._free.apply(null,arguments)};a._noise_handshakestate_get_fixed_ephemeral_dh=function(){return a.asm._noise_handshakestate_get_fixed_ephemeral_dh.apply(null,arguments)};a.setThrew=function(){return a.asm.setThrew.apply(null,arguments)};a.establishStackSpace=function(){return a.asm.establishStackSpace.apply(null,arguments)};a._noise_symmetricstate_free=function(){return a.asm._noise_symmetricstate_free.apply(null,arguments)};
a._noise_symmetricstate_new_by_name=function(){return a.asm._noise_symmetricstate_new_by_name.apply(null,arguments)};a._noise_handshakestate_get_action=function(){return a.asm._noise_handshakestate_get_action.apply(null,arguments)};a._noise_handshakestate_get_handshake_hash=function(){return a.asm._noise_handshakestate_get_handshake_hash.apply(null,arguments)};var N=a._malloc=function(){return a.asm._malloc.apply(null,arguments)};
a._noise_symmetricstate_decrypt_and_hash=function(){return a.asm._noise_symmetricstate_decrypt_and_hash.apply(null,arguments)};a._noise_cipherstate_init_key=function(){return a.asm._noise_cipherstate_init_key.apply(null,arguments)};a._noise_handshakestate_set_pre_shared_key=function(){return a.asm._noise_handshakestate_set_pre_shared_key.apply(null,arguments)};a.dynCall_iiiiii=function(){return a.asm.dynCall_iiiiii.apply(null,arguments)};a.dynCall_i=function(){return a.asm.dynCall_i.apply(null,arguments)};
a.dynCall_vi=function(){return a.asm.dynCall_vi.apply(null,arguments)};a.dynCall_vii=function(){return a.asm.dynCall_vii.apply(null,arguments)};a.dynCall_iiii=function(){return a.asm.dynCall_iiii.apply(null,arguments)};a.dynCall_viii=function(){return a.asm.dynCall_viii.apply(null,arguments)};a.dynCall_iii=function(){return a.asm.dynCall_iii.apply(null,arguments)};y.m=a.stackAlloc;y.o=a.stackSave;y.n=a.stackRestore;y.I=a.establishStackSpace;y.C=a.setTempRet0;y.w=a.getTempRet0;a.asm=Da;
if(X)if(X=a.memoryInitializerPrefixURL?a.memoryInitializerPrefixURL+X:a.locateFile(X),q||t){var Ea=a.readBinary(X);O.set(Ea,y.e)}else{var Ga=function(){a.readAsync(X,Fa,function(){throw"could not load memory initializer "+X;})};Aa();var Fa=function(b){b.byteLength&&(b=new Uint8Array(b));O.set(b,y.e);a.memoryInitializerRequest&&delete a.memoryInitializerRequest.response;Ba()};if(a.memoryInitializerRequest){var Ha=function(){var b=a.memoryInitializerRequest;200!==b.status&&0!==b.status?(console.warn("a problem seems to have happened with Module.memoryInitializerRequest, status: "+
b.status+", retrying "+X),Ga()):Fa(b.response)};a.memoryInitializerRequest.response?setTimeout(Ha,0):a.memoryInitializerRequest.addEventListener("load",Ha)}else Ga()}a.then=function(b){if(a.calledRun)b(a);else{var c=a.onRuntimeInitialized;a.onRuntimeInitialized=function(){c&&c();b(a)}}return a};function w(b){this.name="ExitStatus";this.message="Program terminated with exit("+b+")";this.status=b}w.prototype=Error();w.prototype.constructor=w;
var Ia=null,W=function Ja(){a.calledRun||Ka();a.calledRun||(W=Ja)};a.callMain=a.G=function(b){function c(){for(var b=0;3>b;b++)e.push(0)}b=b||[];U||(U=!0,T(ra));var d=b.length+1,e=[M(xa(a.thisProgram),"i8",0)];c();for(var f=0;f<d-1;f+=1)e.push(M(xa(b[f]),"i8",0)),c();e.push(0);e=M(e,"i32",0);try{var h=a._main(d,e,0);Ma(h,!0)}catch(g){g instanceof w||("SimulateInfiniteLoop"==g?a.noExitRuntime=!0:((b=g)&&"object"===typeof g&&g.stack&&(b=[g,g.stack]),a.d("exception thrown: "+b),a.quit(1,g)))}finally{}};
function Ka(b){function c(){if(!a.calledRun&&(a.calledRun=!0,!G)){U||(U=!0,T(ra));T(sa);if(a.onRuntimeInitialized)a.onRuntimeInitialized();a._main&&Na&&a.callMain(b);if(a.postRun)for("function"==typeof a.postRun&&(a.postRun=[a.postRun]);a.postRun.length;){var c=a.postRun.shift();va.unshift(c)}T(va)}}b=b||a.arguments;null===Ia&&(Ia=Date.now());if(!(0<V)){if(a.preRun)for("function"==typeof a.preRun&&(a.preRun=[a.preRun]);a.preRun.length;)wa();T(qa);0<V||a.calledRun||(a.setStatus?(a.setStatus("Running..."),
setTimeout(function(){setTimeout(function(){a.setStatus("")},1);c()},1)):c())}}a.run=a.run=Ka;function Ma(b,c){if(!c||!a.noExitRuntime){if(!a.noExitRuntime&&(G=!0,x=void 0,T(ua),a.onExit))a.onExit(b);q&&process.exit(b);a.quit(b,new w(b))}}a.exit=a.exit=Ma;var Oa=[];
function H(b){if(a.onAbort)a.onAbort(b);void 0!==b?(a.print(b),a.d(b),b=JSON.stringify(b)):b="";G=!0;var c="abort("+b+") at "+ja()+"\nIf this abort() is unexpected, build with -s ASSERTIONS=1 which can give more information.";Oa&&Oa.forEach(function(d){c=d(c,b)});throw c;}a.abort=a.abort=H;if(a.preInit)for("function"==typeof a.preInit&&(a.preInit=[a.preInit]);0<a.preInit.length;)a.preInit.pop()();var Na=!0;a.noInitialRun&&(Na=!1);a.noExitRuntime=!0;Ka();
(function(){function b(b){if(b&&b.buffer instanceof ArrayBuffer)b=new Uint8Array(b.buffer,b.byteOffset,b.byteLength);else if("string"===typeof b){for(var c=b.length,d=new Uint8Array(c+1),e=0;e<c;++e)d[e]=b.charCodeAt(e);return d}return b}function c(d,h){var g;g=new Number(d);g.length=h;g.get=function(b){b=b||Uint8Array;return(new b(buffer,g,h/b.BYTES_PER_ELEMENT)).slice()};g.dereference=function(b){b=b||4;return c(g.get(Uint32Array)[0],b)};g.set=function(c){c=b(c);if(c.length>h)throw RangeError("invalid array length");
O.set(c,g)};g.free=function(){Q(g);e.splice(e.indexOf(g),1)};e.push(g);return g}function d(d,e){var g;e=b(e);0===d&&(d=e.length);g=c(N(d),d);void 0!==e?(g.set(e),e.length<d&&O.fill(0,g+e.length,g+d)):O.fill(0,g,g+d);return g}var e=[];a.createPointer=c;a.allocatePointer=function(b){b&&(b=Uint32Array.a(b));return d(4,b)};a.allocateBytes=d;a.freeBytes=function(){for(var b=0,c=e.length;b<c;++b)Q(e[b]);e=[]}})();

  return Module;
};
if (typeof module === "object" && module.exports) {
  module['exports'] = Module;
};

},{"./src/randombytes":4,"fs":undefined,"path":undefined}],2:[function(require,module,exports){
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

},{}],3:[function(require,module,exports){
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
    HandshakeState: HandshakeState,
    _lib_internal: lib
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
   * to call free() method, as it was called for you automatically already (except in EncryptWithAd and DecryptWithAd)
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
      assert_no_error(error);
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
      assert_no_error(error);
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
  Object.defineProperty(CipherState.prototype, 'constructor', {
    enumerable: false,
    value: CipherState
  });
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
  Object.defineProperty(SymmetricState.prototype, 'constructor', {
    enumerable: false,
    value: SymmetricState
  });
  /**
   * The HandshakeState object, API is close to the spec: http://noiseprotocol.org/noise.html#the-handshakestate-object
   *
   * NOTE: If you ever get an exception with Error object, whose message is one of constants.NOISE_ERROR_* keys, object is no longer usable and there is no need
   * to call free() method, as it was called for you automatically already (except in ReadMessage with fallback_supported == true)
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
     * Might be called when GetAction() returned constants.NOISE_ACTION_FAILED and switching to fallback protocol is desired, don't forget to call Initialize()
     * after FallbackTo()
     *
     * @param {number} pattern_id One of constants.NOISE_PATTERN_*_FALLBACK*
     */,
    FallbackTo: function(pattern_id){
      var error;
      pattern_id == null && (pattern_id = constants.NOISE_PATTERN_XX_FALLBACK);
      error = lib._noise_handshakestate_fallback_to(this._state, pattern_id);
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
     * @param {Uint8Array}	message				Message received from the other side
     * @param {boolean}		payload_needed		false if the application does not need the message payload
     * @param {boolean}		fallback_supported	true if application is ready to switch to fallback pattern (will throw, but without free() call on read failure)
     *
     * @return {null|Uint8Array}
     */,
    ReadMessage: function(message, payload_needed, fallback_supported){
      var message_buffer, payload_buffer, payload, error, e, real_payload, payload_length;
      payload_needed == null && (payload_needed = false);
      fallback_supported == null && (fallback_supported = false);
      message = allocate(0, message);
      message_buffer = allocate_buffer(message, message.length);
      payload_buffer = null;
      if (payload_needed) {
        payload = allocate(constants.NOISE_MAX_PAYLOAD_LEN);
        payload_buffer = allocate_buffer(payload, payload.length);
      }
      error = lib._noise_handshakestate_read_message(this._state, message_buffer, payload_buffer);
      message.free();
      message_buffer.free();
      try {
        assert_no_error(error, fallback_supported ? undefined : this);
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
        payload_length = lib._NoiseBuffer_get_size(payload_buffer);
        real_payload = payload.get().slice(0, payload_length);
        payload.free();
        payload_buffer.free();
      }
      return real_payload;
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
  Object.defineProperty(HandshakeState.prototype, 'constructor', {
    enumerable: false,
    value: HandshakeState
  });
}).call(this);

},{"../noise-c":1,"./constants":2}],4:[function(require,module,exports){
module.exports = function (size) {
	var array = new Uint8Array(size);
	crypto.getRandomValues(array);
	return array;
};

},{}]},{},[3])(3)
});