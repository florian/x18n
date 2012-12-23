(function() {
  var dict, utils;

  utils = X18n.utils;

  dict = X18n.dict;

  describe('X18', function() {
    afterEach(function() {
      return dict = X18n.dict = {};
    });
    describe('utils', function() {
      return describe('merge', function() {
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
    });
    return describe('register', function() {
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
  });

}).call(this);
