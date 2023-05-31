(function () {
	"use strict";
	function addiereZahle(zahl1, zahl2, ...zahlen) {
		var result = zahl1 + zahl2;
		/*for (var i = 2; i < arguments.length; i++){
			result = result+arguments[i];
		}*/
		for(var index=0; index < zahlen.length; index++){
			result = result + zahlen[index];
		}
		return result;
	}
	console.log(addiereZahle(2,5));
	console.log(addiereZahle(1,2,3,4,5));
})();

