class x18n

	@dict: {}

	@defaultlocal: 'en'
	@chosenLocal: undefined

	@availableLocales: []
	@locales: []

	@missingTranslations: {}

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

		isArray: (value) ->
			Object::toString.call(value) is '[object Array]'

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

	@interpolate: (str, interpolation) ->
		if @utils.isArray(interpolation)
			str = str.replace /%(\d+)/g, (_, n) ->
				interpolation[Number(n) - 1]
		else
			str = str.replace /%\{([^}]+)\}/g, (_, key) ->
				interpolation[key]
		str

	oldT = window.t

	@t: (key, interpolation) =>
		tr = undefined
		for local in @locales
			tr = @utils.getByDotNotation(@dict[local], key)
			if tr
				break
			else
				@missingTranslations[local] = [] unless local of @missingTranslations
				@missingTranslations[local].push(key)
				@missingTranslations[local] = @utils.unique(@missingTranslations[local])
				@trigger('missing-translation', [local, key])

		if typeof tr is 'string'
			tr = @interpolate(tr, interpolation)
		else if tr isnt undefined
			tr.plural = (n) ->
				n = String(n)
				if n of tr
					tr[n]
				else
					x18n.interpolate(tr.n, [n])

		tr

	@t.noConflict = ->
		window.t = oldT
		x18n.t

	window.t = @t

	@on 'dict:change', -> x18n.sortLocales()

if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], -> x18n
else if exports?
	module.exports = x18n
else
	window.x18n = x18n