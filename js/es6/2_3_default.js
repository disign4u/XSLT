(function () {
	function BerechenBruttoBetrag(netto, mwst = 19) {
		/*if(mwst === undefined){
		 mwst = 19;
		 }*/
		console.log(arguments);
		return netto * (mwst / 100 + 1);
	};

})();

