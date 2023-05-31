(function () {
	var dict = new Map();
	dict.set(1, "Ein Wert");
	dict.set(2, "Noch ein Wert");
	dict.set("a", 3);
	dict.set(4, {x:1, y:2});

	console.log(dict.get(1));
	console.log(dict.get('a'));
	console.log(dict.get(4));
	console.log(dict.has(5));

	var meinSet = new Set();
	meinSet.add(1);
	meinSet.add(2);
	console.log(meinSet.size);
	meinSet.add(2);
	console.log(meinSet.size);
	meinSet.add(dict);
	console.log(meinSet.size);

	console.log(meinSet);

})();

