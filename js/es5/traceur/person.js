"use strict";
var Person = function() {
  function Person(name) {
    this.name = name;
  }
  return ($traceurRuntime.createClass)(Person, {}, {});
}();
