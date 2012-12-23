(function() {
  var dict, utils;

  utils = X18n.utils;

  dict = X18n.dict;

  describe('X18n', function() {
    afterEach(function() {
      return dict = X18n.dict = {};
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
      return describe('filter', function() {
        return it('should return an array with the filtered values', function() {
          var a;
          a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          a = utils.filter(a, function(n) {
            return n % 2 === 0;
          });
          return expect(a).to.eql([2, 4, 6, 8]);
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
    return describe('setDefault', function() {
      return it('should set @defaultLocal', function() {
        X18n.setDefault('en');
        return expect(X18n.defaultLocal).to.equal('en');
      });
    });
  });

}).call(this);
