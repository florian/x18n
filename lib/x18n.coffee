class X18n

	@dict: {}
	@prefetch: ['en']
	@defaultLang: 'en'
	@setLang: undefined
	@availableLangs: []
	@langs = []

	@utils:
		merge: (one, two) ->

	@register: (lang, dict) ->
		# @dict[lang] = {} unless lang of @dict

		@dict[lang] = @utils.merge(@dict[lang] || {}, dict)

		X18n.trigger('dict:change')

if typeof define is 'function' and define.amd
	define ['Observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n

###
Can I drop @?
###