(function () {
	var meinArray = ["Elemnet1", "Element2", "Element3"];
	//itar itin iter

	console.log('For of über ein Array, gibt die Properties aus');
	for (var elem of meinArray) {
		console.log(elem)
	}

	console.log('For in über ein Array, gibt den Index aus');
	for (let elem in meinArray) {
		console.log(elem);
	}

	console.log('For of über eine Map');
	var dict = new Map();
	dict.set(1, "Ein Wert");
	dict.set(2, "Noch ein Wert");
	dict.set("a", 3);
	dict.set(4, {x:1, y:2});

	for (let [key, value] of dict.entries()) {
		//console.log(key +": " + value);
		console.log(`Key: ${key} wert: ${value}`);
	}

	console.log("For of über ein Set (for in geht nicht)");
	var meinSet = new Set();
	meinSet.add('Element1');
	meinSet.add('Element2');
	meinSet.add('Element3');
	
	for (let elem of meinSet) {
		console.log(elem);
	}
})();

