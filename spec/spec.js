(function() {
  var dict, utils;

  utils = X18n.utils;

  dict = X18n.dict;

  describe('X18n', function() {
    afterEach(function() {
      dict = X18n.dict = {};
      X18n.chosenLocal = void 0;
      X18n.defaultLocal = 'en';
      X18n.availableLocales = [];
      return X18n.sortLocales();
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
        expect(X18n.__observable).to.be.an('object');
        expect(X18n.on).to.be.a('function');
        expect(X18n.once).to.be.a('function');
        expect(X18n.off).to.be.a('function');
        return expect(X18n.trigger).to.be.a('function');
      });
    });
    describe('register', function() {
      it("should create a lang key in the dict if it doesn't exist", function() {
        X18n.register('en', {});
        return expect(dict).to.have.property('en').that.is.an('object');
      });
      it('should fill the dict', function() {
        X18n.register('en', {
          user: 'user'
        });
        return expect(dict.en).to.have.property('user', 'user');
      });
      it('should not replace existing properties, but merge them', function() {
        X18n.register('en', {
          user: 'user'
        });
        X18n.register('en', {
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
        X18n.on('dict:change', function() {
          return called = true;
        });
        X18n.register('en', {});
        return expect(called).to.be["true"];
      });
    });
    describe('set', function() {
      return it('should set @chosenLocal', function() {
        X18n.set('de');
        return expect(X18n.chosenLocal).to.equal('de');
      });
    });
    describe('setDefault', function() {
      return it('should set @defaultLocal', function() {
        X18n.setDefault('en');
        return expect(X18n.defaultLocal).to.equal('en');
      });
    });
    describe('similiarLocales', function() {
      return it('should detect similiar locales', function() {
        X18n.availableLocales = ['en', 'en-us', 'en-AU', 'de', 'fr'];
        return expect(X18n.similiarLocales('en')).to.eql(['en-us', 'en-AU']);
      });
    });
    describe('sortLocales', function() {
      it('should set @locales to an array', function() {
        X18n.sortLocales();
        return expect(X18n.locales).to.be.an('array');
      });
      return it('should trigger lang:change', function() {
        var called;
        called = false;
        X18n.on('lang:change', function() {
          return called = true;
        });
        X18n.sortLocales();
        return expect(called).to.be["true"];
      });
      /*
      		it should contain the chosen local first if set
      		it should only contain available locales
      		it should not contain duplicate entries
      */

    });
    return describe('t', function() {
      it('should be defined in the global and X18n scope', function() {
        expect(window).to.have.property('t');
        return expect(X18n).to.have.property('t');
      });
      it('should return the translation', function() {
        X18n.register('de', {
          user: 'benutzer'
        });
        return expect(t('user')).to.equal('benutzer');
      });
      it('should loop through all available locales and return the first translation', function() {
        X18n.register('de', {});
        X18n.register('en', {
          user: 'user'
        });
        return expect(t('user')).to.equal('user');
      });
      it('should behave like utils.getByDotNotation', function() {
        X18n.register('en', {
          errors: {
            presence: 'Not found'
          }
        });
        return expect(t('errors.presence')).to.equal('Not found');
      });
      it("should populate @missingTranslation if the translation doesn't exist in some language", function() {
        X18n.register('en', {});
        t('register');
        return expect(X18n.missingTranslations).to.have.property('en').that.is.an('array').that.include('register');
      });
      return describe('noConflict', function() {
        return it('should restore the old t and return t', function() {
          var t;
          t = window.t.noConflict();
          expect(t).to.equal(X18n.t);
          return window.t = t;
        });
      });
    });
  });

}).call(this);
