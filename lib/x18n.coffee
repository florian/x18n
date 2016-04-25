base = (Observable) ->
	class X18n extends Observable
		constructor: ->
			super()

			@dict = {}
			@defaultlocal = 'en'
			@chosenLocal = undefined

			@availableLocales = []
			@locales = []

			@missingTranslations = {}

			@on 'dict:change', => @sortLocales()

		utils:
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

			isPlainObject: (value) ->
				!!value && Object::toString.call(value) is '[object Object]'

		register: (local, dict) ->
			unless local of @dict
				@dict[local] = {}
				@availableLocales.push(local)

			@utils.merge(@dict[local], dict)

			# Todo: Pass the local
			@trigger('dict:change')

		set: (local) ->
			@chosenLocal = local
			@sortLocales()

		setDefault: (local) ->
			@defaultLocal = local
			@sortLocales()

		# Todo: This would throw on node
		detectLocal: -> navigator.userLanguage || navigator.language

		similiarLocales: (local) ->
			local = String(local).slice(0, 2).toLowerCase()
			@utils.filter @availableLocales, (l) ->
				return false if local is l
				l.toLowerCase().indexOf(local) is 0

		sortLocales: ->
			_locales = [
				@chosenLocal
				@similiarLocales(@chosenLocal)...
				@detectLocal(),
				@similiarLocales(@detectLocal())...
				@defaultlocal,
				@similiarLocales(@defaultlocal)...
				'en'
				@similiarLocales('en')...,
			]

			locales = []
			locales.push(local) for local in _locales when local in @availableLocales

			locales.push(@availableLocales...)

			@locales = @utils.unique(locales)

			# Todo: Only trigger if the first language actually changed?
			# Todo: Pass the new first and the old first language
			@trigger('lang:change')

		interpolate: (str, interpolation...) ->
			if @utils.isPlainObject(interpolation[0])
				str = str.replace /%\{([^}]+)\}/g, (_, key) ->
					interpolation[0][key]
			else
				str = str.replace /%(\d+)/g, (_, n) ->
					interpolation[Number(n) - 1]

			str

		t: (key, interpolation...) =>
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
				tr = @interpolate(tr, interpolation...)
			else if tr isnt undefined
				tr.plural = (n) ->
					if n of tr
						tr[n]
					else
						x18n.interpolate(tr.n, n)

			tr

	return new X18n()

if module? and module.exports?
	Observable = require('observable_js')
	module.exports = base(Observable)
else if typeof define is 'function' and define.amd
	define 'x18n', ['observable'], (Observable) -> base(Observable)
else
	window.x18n = base(window.Observable)
