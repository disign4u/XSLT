"use strict";

(function () {
	"use strict";

	function addiereZahle(zahl1, zahl2) {
		var result = zahl1 + zahl2;
		for (var i = 2; i < arguments.length; i++) {
			result = result + arguments[i];
		}
		return result;
	}
	addiereZahle(2, 5);
})();