(function() {
  var dict, utils;

  utils = x18n.utils;

  dict = x18n.dict;

  describe('x18n', function() {
    afterEach(function() {
      dict = x18n.dict = {};
      x18n.chosenLocal = void 0;
      x18n.defaultLocal = 'en';
      x18n.availableLocales = [];
      return x18n.sortLocales();
    });
    describe('utils', function() {
      describe('merge', function() {
        it('should be able to merge a single object', function() {
          var a, b;
          a = {
            a: 1
          };
          b = {
            b: 2
          };
          utils.merge(a, b);
          return expect(a).to.eql({
            a: 1,
            b: 2
          });
        });
        return it('should be able to deep merge objects', function() {
          var a, b;
          a = {
            a: {
              a: 1
            }
          };
          b = {
            a: {
              b: 2
            }
          };
          return utils.merge({
            a: {
              a: 1,
              b: 2
            }
          });
        });
      });
      describe('filter', function() {
        return it('should return an array with the filtered values', function() {
          var a;
          a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          a = utils.filter(a, function(n) {
            return n % 2 === 0;
          });
          return expect(a).to.eql([2, 4, 6, 8]);
        });
      });
      describe('unique', function() {
        return it('should remove duplicate entries', function() {
          var a;
          a = utils.unique([1, 2, 1, 3, 1, 2]);
          return expect(a).to.eql([1, 2, 3]);
        });
      });
      return describe('getByDotNotation', function() {
        it('should return the specified value', function() {
          var v;
          v = utils.getByDotNotation({
            a: {
              b: {
                c: 1
              }
            }
          }, 'a.b.c');
          return expect(v).to.equal(1);
        });
        return it('should never throw an error', function() {
          var fn;
          fn = function() {
            return utils.getByDotNotation({
              a: 1
            }, 'b.c');
          };
          return expect(fn).not.to["throw"]();
        });
      });
    });
    describe('event system', function() {
      return it('should be available', function() {
        expect(x18n.__observable).to.be.an('object');
        expect(x18n.on).to.be.a('function');
        expect(x18n.once).to.be.a('function');
        expect(x18n.off).to.be.a('function');
        return expect(x18n.trigger).to.be.a('function');
      });
    });
    describe('register', function() {
      it("should create a lang key in the dict if it doesn't exist", function() {
        x18n.register('en', {});
        return expect(dict).to.have.property('en').that.is.an('object');
      });
      it('should fill the dict', function() {
        x18n.register('en', {
          user: 'user'
        });
        return expect(dict.en).to.have.property('user', 'user');
      });
      it('should not replace existing properties, but merge them', function() {
        x18n.register('en', {
          user: 'user'
        });
        x18n.register('en', {
          login: 'login'
        });
        return expect(dict.en).to.eql({
          user: 'user',
          login: 'login'
        });
      });
      return it('should trigger the event dict:change', function() {
        var called;
        called = false;
        x18n.on('dict:change', function() {
          return called = true;
        });
        x18n.register('en', {});
        return expect(called).to.be["true"];
      });
    });
    describe('set', function() {
      return it('should set @chosenLocal', function() {
        x18n.set('de');
        return expect(x18n.chosenLocal).to.equal('de');
      });
    });
    describe('setDefault', function() {
      return it('should set @defaultLocal', function() {
        x18n.setDefault('en');
        return expect(x18n.defaultLocal).to.equal('en');
      });
    });
    describe('similiarLocales', function() {
      return it('should detect similiar locales', function() {
        x18n.availableLocales = ['en', 'en-us', 'en-AU', 'de', 'fr'];
        return expect(x18n.similiarLocales('en')).to.eql(['en-us', 'en-AU']);
      });
    });
    describe('sortLocales', function() {
      it('should set @locales to an array', function() {
        x18n.sortLocales();
        return expect(x18n.locales).to.be.an('array');
      });
      return it('should trigger lang:change', function() {
        var called;
        called = false;
        x18n.on('lang:change', function() {
          return called = true;
        });
        x18n.sortLocales();
        return expect(called).to.be["true"];
      });
      /*
      		it should contain the chosen local first if set
      		it should only contain available locales
      		it should not contain duplicate entries
      */

    });
    describe('interpolate', function() {
      it('should support numeric interpolation', function() {
        var s;
        s = x18n.interpolate('Hello %1', 'World');
        return expect(s).to.equal('Hello World');
      });
      it('should support alpha interpolation', function() {
        var s;
        s = x18n.interpolate('Hello %{s}', {
          s: 'World'
        });
        return expect(s).to.equal('Hello World');
      });
      return it('should support several interpolations in one string', function() {
        var s;
        s = x18n.interpolate('Hello %1 and %2', 'a', 'b');
        return expect(s).to.equal('Hello a and b');
      });
    });
    return describe('t', function() {
      it('should be defined in the global and x18n scope', function() {
        expect(window).to.have.property('t');
        return expect(x18n).to.have.property('t');
      });
      it('should return the translation', function() {
        x18n.register('de', {
          user: 'benutzer'
        });
        return expect(t('user')).to.equal('benutzer');
      });
      it('should loop through all available locales and return the first translation', function() {
        x18n.register('de', {});
        x18n.register('en', {
          user: 'user'
        });
        return expect(t('user')).to.equal('user');
      });
      it('should behave like utils.getByDotNotation', function() {
        x18n.register('en', {
          errors: {
            presence: 'Not found'
          }
        });
        return expect(t('errors.presence')).to.equal('Not found');
      });
      it("should populate @missingTranslation if the translation doesn't exist in some language", function() {
        x18n.register('en', {});
        t('register');
        return expect(x18n.missingTranslations).to.have.property('en').that.is.an('array').that.include('register');
      });
      it("should trigger the event missing-translation if the translation doesn't exist in some language", function() {
        var called;
        called = false;
        x18n.on('missing-translation', function() {
          return called = true;
        });
        x18n.register('en', {});
        t('register');
        return expect(called).to.be["true"];
      });
      it('should support interpolation', function() {
        x18n.register('en', {
          a: 'Hello %1',
          b: 'Hello %{s}'
        });
        expect(t('a', 'World')).to.equal('Hello World');
        return expect(t('b', {
          s: 'World'
        })).to.equal('Hello World');
      });
      return describe('noConflict', function() {
        return it('should restore the old t and return t', function() {
          var t;
          t = window.t.noConflict();
          expect(t).to.equal(x18n.t);
          return window.t = t;
        });
      });
    });
  });

}).call(this);
