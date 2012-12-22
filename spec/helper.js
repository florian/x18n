// testem
if (location.href.indexOf('http://localhost:7357') == 0) {
    document.write('<script src="/testem.js"><\/script>');
}

var expect = chai.expect;

mocha.setup({
    ui: 'bdd',
    ignoreLeaks: true
});

$(function () {
    mocha.run();
});