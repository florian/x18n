utils = X18n.utils
dict = X18n.dict

describe 'X18n', ->
	afterEach ->
		dict = X18n.dict = {}
		X18n.chosenLocal = undefined
		X18n.defaultLocal = 'en'
		X18n.availableLocales = []
		X18n.sortLocales()

	describe 'utils', ->
		describe 'merge', ->
			it 'should be able to merge a single object', ->
				a = a: 1
				b = b: 2
				utils.merge(a, b)
				expect(a).to.eql(a: 1, b: 2)

			it 'should be able to deep merge objects', ->
				a = a: a: 1
				b = a: b: 2
				utils.merge(a: a: 1, b: 2)

		describe 'filter', ->
			it 'should return an array with the filtered values', ->
				a = [1..9]
				a = utils.filter a, (n) -> n % 2 == 0
				expect(a).to.eql([2, 4, 6, 8])

		describe 'unique', ->
			it 'should remove duplicate entries', ->
				a = utils.unique([1, 2, 1, 3, 1, 2])
				expect(a).to.eql([1, 2, 3])

		describe 'getByDotNotation', ->
			it 'should return the specified value', ->
				v = utils.getByDotNotation({a: b: c: 1}, 'a.b.c')
				expect(v).to.equal(1)

			it 'should never throw an error', ->
				fn = ->
					utils.getByDotNotation(a: 1, 'b.c')
				expect(fn).not.to.throw()

	describe 'event system', ->
		it 'should be available', ->
			expect(X18n.__observable).to.be.an('object')
			expect(X18n.on).to.be.a('function')
			expect(X18n.once).to.be.a('function')
			expect(X18n.off).to.be.a('function')
			expect(X18n.trigger).to.be.a('function')

	describe 'register', ->
		it "should create a lang key in the dict if it doesn't exist", ->
			X18n.register 'en', {}
			expect(dict).to.have.property('en').that.is.an('object')

		it 'should fill the dict', ->
			X18n.register 'en', user: 'user'
			expect(dict.en).to.have.property('user', 'user')

		it 'should not replace existing properties, but merge them', ->
			X18n.register 'en', user: 'user'
			X18n.register 'en', login: 'login'
			expect(dict.en).to.eql(user: 'user', login: 'login')

		it 'should trigger the event dict:change', ->
			called = false
			X18n.on 'dict:change', -> called = true
			X18n.register 'en', {}
			expect(called).to.be.true

	describe 'set', ->
		it 'should set @chosenLocal', ->
			X18n.set 'de'
			expect(X18n.chosenLocal).to.equal('de')

	describe 'setDefault', ->
		it 'should set @defaultLocal', ->
			X18n.setDefault 'en'
			expect(X18n.defaultLocal).to.equal('en')

	describe 'similiarLocales', ->
		it 'should detect similiar locales', ->
			X18n.availableLocales = ['en', 'en-us', 'en-AU', 'de', 'fr']
			expect(X18n.similiarLocales('en')).to.eql(['en-us', 'en-AU'])

	describe 'sortLocales', ->
		it 'should set @locales to an array', ->
			X18n.sortLocales()
			expect(X18n.locales).to.be.an('array')

		it 'should trigger lang:change', ->
			called = false
			X18n.on 'lang:change', -> called = true
			X18n.sortLocales()
			expect(called).to.be.true

		###
		it should contain the chosen local first if set
		it should only contain available locales
		it should not contain duplicate entries
		###

	describe 't', ->
		it 'should be defined in the global and X18n scope', ->
			expect(window).to.have.property('t')
			expect(X18n).to.have.property('t')

		it 'should return the translation', ->
			X18n.register 'de', user: 'benutzer'
			expect(t('user')).to.equal('benutzer')

		it 'should loop through all available locales and return the first translation', ->
			X18n.register 'de', {}
			X18n.register 'en', user: 'user'
			expect(t('user')).to.equal('user')

		it 'should behave like utils.getByDotNotation', ->
			X18n.register 'en', errors: presence: 'Not found'
			expect(t('errors.presence')).to.equal('Not found')

		it "should populate @missingTranslation if the translation doesn't exist in some language", ->
			X18n.register 'en', {}
			t('register')
			expect(X18n.missingTranslations).to.have.property('en').that.is.an('array').that.include('register')

		describe 'noConflict', ->
			it 'should restore the old t and return t', ->
				t = window.t.noConflict()
				expect(t).to.equal(X18n.t)
				window.t = t