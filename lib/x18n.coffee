class X18n

	@dict: {}
	@prefetch: ['en']
	@defaultlocal: 'en'
	@chosenLocal: undefined
	@availablelocals: []
	@locals = []

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

	@register: (local, dict) ->
		@dict[local] = {} unless local of @dict
		@utils.merge(@dict[local], dict)

		@trigger('dict:change')

	@set: (local) ->
		@chosenLocal = local
		@sortLangs()

	@setDefault: (local) ->
		@defaultLocal = local
		@sortLangs()

	@detectLocal: -> navigator.userLanguage || navigator.language

	@sortLangs: ->

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n