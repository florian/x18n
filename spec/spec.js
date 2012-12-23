(function() {
  var utils;

  utils = X18n.utils;

  describe('X18', function() {
    return describe('utils', function() {
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
  });

}).call(this);
