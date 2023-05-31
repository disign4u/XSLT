"use strict";

(function () {
	function BerechenBruttoBetrag(netto) {
		var mwst = arguments.length <= 1 || arguments[1] === undefined ? 19 : arguments[1];

		/*if(mwst === undefined){
   mwst = 19;
   }*/
		console.log(arguments);
		return netto * (mwst / 100 + 1);
	};
})();