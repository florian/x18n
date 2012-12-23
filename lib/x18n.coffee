class X18n

	@dict: {}

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

		filter: (arr, fn) ->
			v for v in arr when fn(v)

	@register: (local, dict) ->
		unless local of @dict
			@dict[local] = {}
			@availablelocals.push(local)

		@utils.merge(@dict[local], dict)

		@trigger('dict:change')

	@set: (local) ->
		@chosenLocal = local
		@sortLangs()

	@setDefault: (local) ->
		@defaultLocal = local
		@sortLangs()

	@detectLocal: -> navigator.userLanguage || navigator.language

	@similiarLocales: (local) ->
		# local = local.slice(0, 2).toLowerCase()

		[]

	@sortLangs: ->
		locales = [
			@chosenLocal
			@similiarLocales(@chosenLocal)...

			@detectLocal()
			@similiarLocales(@detectLocal)...

			@defaultlocal
			@similiarLocales(@defaultlocal)...

			'en'
			@similiarLocales('en')...

			@availablelocals...
		]

		locales.shift() unless @chosenLocal

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n