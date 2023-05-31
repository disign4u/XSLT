"use strict";
(function() {
  function BerechenBruttoBetrag(netto) {
    var mwst = arguments[1] !== (void 0) ? arguments[1] : 19;
    console.log(arguments);
    return netto * (mwst / 100 + 1);
  }
  ;
})();
