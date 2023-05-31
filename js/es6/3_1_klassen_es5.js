"use strict";
(function () {
	var BankKonto = (function () {

		function BankKonto(kontoNummer, kontoInhaber, kontoStand) {
			this._kontoNummer = kontoNummer;
			this._kontoInhaber = kontoInhaber;
			this._kontoStand = kontoStand;
		}

		Object.defineProperty(BankKonto.prototype , "kontoStand", {
			get: function () {
				return this._kontoStand;
			},
			auflistbar: true,
			bearbeitbar:true
		});
		Object.defineProperty(BankKonto.prototype , "kontoNummer", {
			get: function () {
				return this._kontoNummer;
			},
			auflistbar: true,
			bearbeitbar:true
		});

		BankKonto.prototype.einzahlen = function(betrag){
			if (betrag < 0) {
				return false;
			}
			this._kontoStand += betrag;
		};

		BankKonto.prototype.abheben = function (betrag) {
			if(betrag < 0 || this._kontoStand < betrag) {
				return false;
			}
			this._kontoStand -= betrag;
		};

		BankKonto.prototype.toString = function () {
			return "Konto: " + this._kontoNummer +
					", Inhaber:" + this._kontoInhaber+
					", Kontostand:" + this._kontoStand;
		};

		return BankKonto;

	})();

	var konto = new BankKonto(12345, 'Marvin', 10000);
	console.log(konto.toString());
})();