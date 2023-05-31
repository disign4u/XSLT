/**
 * Created by Dirk
 * vanillaJS
 */
// ==UserScript==
// @name         Disign4u
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       D.Gpunkt
// @match        *
// @grant        none
// https://www.sitepoint.com/smooth-scrolling-vanilla-javascript/
// https://github.com/cmpolis/scrollIt.js/blob/master/scrollIt.js
// ==/UserScript==

(function () {
	'use strict';
	window.onload(function () {
			scrollToNav();
		}
	)

	var scrollToNav = (function () {
		var sections = document.querySelectorAll('section');
		var sectionLentgh = sections.length,
			currentSection = 0;
		/*sections.forEach(function(element, index, array){
		 console.log('a[' + index + '] = ' + element );

		 if(element.hasAttributes()) {
		 //das ist ein nameNodeMap
		 var attrs = element.attributes;
		 console.log(attrs);
		 for(var i = 0; i < attrs.length; i++) {
		 console.log(attrs[i]+'--');
		 }
		 }
		 });*/
		console.log('length:' + sectionLentgh);
		console.log(sections[2].offsetTop);
		var pos = sections[2].offsetTop;
		//document.animate();
		//Tastur Event
		window.addEventListener('keydown', function (e) {
			//das event objekt
			//console.log(e);
			//vielleicht mit map() Array mal schauen
			if (e.altKey === true && (e.code == 'Enter')) {
				console.log('ALt und Enter gedrückt');
				addELement();
			}

			showChar(e);
			switch (e.code) {
				case 'ArrowUp':
					console.log('hoch');
					break;
				case 'ArrowDown':
					console.log('runter');
					break;
				default:
					//console.log('error');
					break;
			}
		});

	})();

	function addControllBar() {
	}

	function addElement() {
		// create a new div element
		// and give it some content
		var newDiv = document.createElement("div");
		var newContent = document.createTextNode("Hi there and greetings!");
		newDiv.appendChild(newContent); //add the text node to the newly created div.

		// add the newly created element and its content into the DOM
		var currentDiv = document.getElementById("div1");
		document.body.insertBefore(newDiv);
	}

})();

function scrollToItemId(containerId, srollToId) {

	var scrollContainer = document.getElementById(containerId);
	var item = document.getElementById(scrollToId);

	//with animation
	var from = scrollContainer.scrollTop;
	var by = item.offsetTop - scrollContainer.scrollTop;
	if (from < item.offsetTop) {
		if (item.offsetTop > scrollContainer.scrollHeight - scrollContainer.clientHeight) {
			by = (scrollContainer.scrollHeight - scrollContainer.clientHeight) - scrollContainer.scrollTop;
		}
	}

	var currentIteration = 0;

	/**
	 * get total iterations
	 * 60 -> requestAnimationFrame 60/second
	 * second parameter -> time in seconds for the animation
	 **/
	var animIterations = Math.round(60 * 0.5);

	(function scroll() {
		var value = easeOutCubic(currentIteration, from, by, animIterations);
		scrollContainer.scrollTop = value;
		currentIteration++;
		if (currentIteration < animIterations) {
			requestAnimationFrame(scroll);
		}
	})();

	//without animation
	//scrollContainer.scrollTop = item.offsetTop;

}

//example easing functions
function linearEase(currentIteration, startValue, changeInValue, totalIterations) {
	return changeInValue * currentIteration / totalIterations + startValue;
}
function easeOutCubic(currentIteration, startValue, changeInValue, totalIterations) {
	return changeInValue * (Math.pow(currentIteration / totalIterations - 1, 3) + 1) + startValue;
}