(function() {



}).call(this);

(function() {
  var X18n;

  X18n = (function() {

    function X18n() {}

    X18n.dict = {};

    X18n.prefetch = ['en'];

    X18n.defaultLang = 'en';

    X18n.setLang = void 0;

    X18n.availableLangs = [];

    X18n.langs = [];

    X18n.utils = {
      merge: function(one, two) {}
    };

    X18n.register = function(lang, dict) {};

    return X18n;

  })();

  if (typeof define === 'function' && define.amd) {
    define(['Observable'], function() {
      return X18n;
    });
  } else if (typeof exports !== "undefined" && exports !== null) {
    module.exports = X18n;
  } else {
    window.X18n = X18n;
  }

}).call(this);
