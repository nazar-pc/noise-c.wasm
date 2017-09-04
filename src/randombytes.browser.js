module.exports = function (size) {
	var array = new Uint8Array(size);
	crypto.getRandomValues(array);
	return array;
};
