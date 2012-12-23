class X18n

	@dict: {}
	@prefetch: ['en']
	@defaultLang: 'en'
	@setLang: undefined
	@availableLangs: []
	@langs = []

	eventSystem = new Observable
	@__observable = eventSystem.__observable
	@on = eventSystem.on
	@once = eventSystem.once
	@off = eventSystem.off
	@trigger = eventSystem.trigger

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

		@trigger('dict:change')

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n