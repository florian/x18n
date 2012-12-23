// Copyright (c) 2012 Florian H., https://github.com/js-coder/X18n

(function() {
  var Observable;

  Observable = (function() {
    var utils;

    utils = {
      isPlainObject: function(value) {
        return !!value && Object.prototype.toString.call(value) === '[object Object]';
      },
      isArray: function(value) {
        return Object.prototype.toString.call(value) === '[object Array]';
      },
      toArray: function(value) {
        if (utils.isArray(value)) {
          return value;
        } else {
          return [value];
        }
      }
    };

    function Observable() {
      this.__observable = {
        lastIds: {},
        events: {}
      };
    }

    Observable.prototype.on = function(topics, fn, once) {
      var id, ids, topic, _base, _base1, _i, _len, _results;
      if (utils.isPlainObject(topics)) {
        once = fn;
        _results = [];
        for (topic in topics) {
          fn = topics[topic];
          _results.push(this.on(topic, fn, once));
        }
        return _results;
      } else {
        topics = utils.toArray(topics);
        ids = [];
        for (_i = 0, _len = topics.length; _i < _len; _i++) {
          topic = topics[_i];
          (_base = this.__observable.lastIds)[topic] || (_base[topic] = 0);
          id = "" + topic + ";" + (String(++this.__observable.lastIds[topic]));
          if (once) {
            id += ' once';
          }
          ids.push(id);
          (_base1 = this.__observable.events)[topic] || (_base1[topic] = {});
          this.__observable.events[topic][id] = fn;
        }
        if (ids.length === 1) {
          return ids[0];
        } else {
          return ids;
        }
      }
    };

    Observable.prototype.once = function(topics, fn) {
      return this.on(topics, fn, true);
    };

    Observable.prototype.off = function(ids) {
      var id, topic, _i, _len;
      ids = utils.toArray(ids);
      for (_i = 0, _len = ids.length; _i < _len; _i++) {
        id = ids[_i];
        if (typeof id !== 'string') {
          continue;
        }
        topic = id.substr(0, id.lastIndexOf(';')).split(' ')[0];
        if ((this.__observable.events[topic] != null) && (this.__observable.events[topic][id] != null)) {
          delete this.__observable.events[topic][id];
        }
      }
      return this;
    };

    Observable.prototype.trigger = function(topic, args) {
      var fn, id, _ref;
      if (this.__observable.events[topic] == null) {
        return this;
      }
      _ref = this.__observable.events[topic];
      for (id in _ref) {
        fn = _ref[id];
        fn.apply(null, args);
        if (id.lastIndexOf(' once') === id.length - 1) {
          this.off(id);
        }
      }
      return this;
    };

    return Observable;

  })();

  if (typeof define === 'function' && define.amd) {
    define('observable', function() {
      return Observable;
    });
  } else if (typeof exports !== 'undefined') {
    module.exports = Observable;
  } else {
    window.Observable = Observable;
  }

}).call(this);

(function() {
  var X18n,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  X18n = (function(_super) {

    __extends(X18n, _super);

    function X18n() {
      return X18n.__super__.constructor.apply(this, arguments);
    }

    X18n.dict = {};

    X18n.prefetch = ['en'];

    X18n.defaultLang = 'en';

    X18n.setLang = void 0;

    X18n.availableLangs = [];

    X18n.langs = [];

    X18n.utils = {
      merge: function(one, two) {
        var k, v, _results;
        _results = [];
        for (k in two) {
          v = two[k];
          if (typeof v === 'object') {
            _results.push(merge(one[k], v));
          } else {
            _results.push(one[k] = v);
          }
        }
        return _results;
      }
    };

    X18n.register = function(lang, dict) {
      if (!(lang in this.dict)) {
        this.dict[lang] = {};
      }
      this.utils.merge(this.dict[lang], dict);
      return X18n.trigger('dict:change');
    };

    return X18n;

  })(new Observable);

  if (typeof define === 'function' && define.amd) {
    define('x18n', ['observable'], function() {
      return X18n;
    });
  } else if (typeof exports !== "undefined" && exports !== null) {
    module.exports = X18n;
  } else {
    window.X18n = X18n;
  }

}).call(this);
