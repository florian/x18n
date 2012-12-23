class X18n

	@dict: {}

	@defaultlocal: 'en'
	@chosenLocal: undefined

	@availableLocales: []
	@locales = []

	eventSystem = new Observable
	@__observable = eventSystem.__observable
	@on = eventSystem.on
	@once = eventSystem.once
	@off = eventSystem.off
	@trigger = eventSystem.trigger

	@utils:
		merge: (one, two) ->
			for k, v of two
			   if typeof v is 'object' and typeof one[k] is 'object'
			     @merge(one[k], v)
			   else
			     one[k] = v

		filter: (arr, fn) ->
			v for v in arr when fn(v)

		unique: (arr) ->
			ret = {}
			ret[v] = v for v in arr
			v for k, v of ret

		getByDotNotation: (obj, key) ->
			keys = key.split('.')

			until keys.length is 0 or obj is undefined
				obj = obj[keys[0]]
				keys.shift()

			obj

	@register: (local, dict) ->
		unless local of @dict
			@dict[local] = {}
			@availableLocales.push(local)

		@utils.merge(@dict[local], dict)

		@trigger('dict:change')

	@set: (local) ->
		@chosenLocal = local
		@sortLocales()

	@setDefault: (local) ->
		@defaultLocal = local
		@sortLocales()

	@detectLocal: -> navigator.userLanguage || navigator.language

	@similiarLocales: (local) ->
		local = String(local).slice(0, 2).toLowerCase()
		@utils.filter @availableLocales, (l) ->
			return false if local is l
			l.toLowerCase().indexOf(local) is 0

	@sortLocales: ->
		_locales = [
			@chosenLocal
			@similiarLocales(@chosenLocal)...
			@detectLocal(),
			@similiarLocales(@detectLocal)...
			@defaultlocal,
			@similiarLocales(@defaultlocal)
			'en'
			@similiarLocales('en')...,
		]

		_locales.shift() unless @chosenLocal

		locales = []
		locales.push(local) for local in locales when local in @availableLocales

		locales.push(@availableLocales...)

		@trigger('lang:change')

		@locales = @utils.unique(locales)

	oldT = window.t

	@t: (key, interpolation) =>
		tr = ''
		for local in @locales
			tr = @utils.getByDotNotation(@dict[local], key)
			break if tr
		tr


	@t.noConflict = ->
		window.t = oldT
		X18n.t

	window.t = @t

	@on 'dict:change', -> X18n.sortLocales()

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> X18n
else if exports?
	module.exports = X18n
else
	window.X18n = X18n