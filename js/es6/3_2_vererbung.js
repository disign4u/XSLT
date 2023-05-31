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
		get holder() {
			return this._holder;
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

	class ChildAccount extends BankAccount {
		constructor(accountNumber, holder, balance, parentName) {
			// den parent constructor aufrufen
			super(accountNumber, holder, balance);
			this.parentName = parentName;
		}

		whithdraw(amount) {
			if (amount > 50) {
				return false;
			}
			// aufruf der parent eigenschaft this._balance -= amount;
			super.withdraw(this, amount);
		}

		toString() {
			return super.toString() + `, Elternteil: ${this.parentName}`;
		}
	}
	var account = new BankAccount(1, 'Marvin', 23213.23);

	account.deposit(223);
	account.whithdraw(331);

	console.log(account.toString());

	var child = new ChildAccount(2, 'kleinMarvin', 70, account.holder);
	child.deposit(70);
	child.whithdraw(331);
	console.log(child.toString());

})();

