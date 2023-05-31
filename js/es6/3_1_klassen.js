/**
 * Created by Dirk on 08.10.2016.
 */
(function () {

	class BankAccount {
		//Konstruktor
		constructor(accountNumber, holder, balance) {
			this._accountNumber = accountNumber;
			this._holder = holder;
			this._balance = balance;
		}

		// private Variablen zurückgeben
		get balance() {
			return this._balance;
		}

		get accountNumber() {
			return this._accountNumber;
		}

		// Funktionen
		deposit(amount) {
			if (amount < 0) {
				return false;
			}
			this._balance += amount;
		}

		whithdraw(amount) {
			if (amount < 0 || amount > this._balance) {
				return false;
			}
			this._balance -= amount;
		}

		toString() {
			return `Konto: ${this._accountNumber}, Inhaber: ${this._holder}, Kontostand: ${this._balance}`;
		}
	}

	var account = new BankAccount(12345, 'Marvin', 23213.23);

	account.deposit(223);
	account.whithdraw(331);

	console.log(account.toString());

})();

