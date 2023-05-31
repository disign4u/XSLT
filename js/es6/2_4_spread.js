(function () {
	"use strict";
	function addiereZahlen(zahl1, zahl2, zahl3) {
		return zahl1 + zahl2 + zahl3;
	}
	var Zahlen = [1,2,3];
	//console.log(addiereZahlen(Zahlen[0],Zahlen[1],Zahlen[2]));
	//console.log(addiereZahlen.apply(null, Zahlen));
	console.log(addiereZahlen(...Zahlen));

	var andereZahlen = [4,5,6];
	//Array.prototype.push.apply(Zahlen,andereZahlen);
	Zahlen.push(...andereZahlen);
	console.log(Zahlen);

	var arrayLiteral = [23,...Zahlen, 2,5,6];
	console.log(arrayLiteral);
})();