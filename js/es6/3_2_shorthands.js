/**
 @48.1228873,7.7483923,17.25z
 */
(function () {
	var lat = 48.1228873;
	var lon = 7.7483923;
	var zoom = 17.25;

	var pos = {
		lat: lat,
		lon: lon,
		zoom: zoom
	};

	var posPrinter = {
		print: function (p) {
			console.log('Lat:' + p.lat + ', Lon:' + p.lon + ', zoom:' + zoom);
		}
	};

	// posPrinter()
	posPrinter.print(pos);

	/*ES2016*/
	var posES = {lat, lon, zoom};
	var posPrinterES = {
		print(p) {
			console.log(`ES2016 Lat: ${p.lat} Lon: ${p.lon} Zoom: ${p.zoom}`);
		}
	}
	posPrinterES.print(posES);
})();

