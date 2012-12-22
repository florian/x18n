class X18n

	@dict: {}
	@prefetch: ['en']
	@defaultLang: 'en'
	@setLang: undefined
	@availableLangs: []
	@langs = []

if typeof define is 'function' and define.amd
	define ['Observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n