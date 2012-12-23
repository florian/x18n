class X18n extends new Observable

	@dict: {}
	@prefetch: ['en']
	@defaultLang: 'en'
	@setLang: undefined
	@availableLangs: []
	@langs = []

	@utils:
		merge: (one, two) ->
			for k, v of two
			   if typeof v is 'object'
			     merge(one[k], v)
			   else
			     one[k] = v

	@register: (lang, dict) ->
		@dict[lang] = {} unless lang of @dict
		@utils.merge(@dict[lang], dict)

		X18n.trigger('dict:change')

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n