utils = x18n.utils
dict = x18n.dict
t = x18n.t

# Observable triggers events async by default, which makes it harder to write
# tests, so we'll disable it
x18n.__asyncEvents = false

describe 'x18n', ->
	afterEach ->
		dict = x18n.dict = {}
		x18n.chosenLocal = undefined
		x18n.defaultLocal = 'en'
		x18n.availableLocales = []
		x18n.sortLocales()

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
			expect(x18n.on).to.be.a('function')
			expect(x18n.once).to.be.a('function')
			expect(x18n.off).to.be.a('function')
			expect(x18n.trigger).to.be.a('function')

	describe 'register', ->
		it "should create a lang key in the dict if it doesn't exist", ->
			x18n.register 'en', {}
			expect(dict).to.have.property('en').that.is.an('object')

		it 'should fill the dict', ->
			x18n.register 'en', user: 'user'
			expect(dict.en).to.have.property('user', 'user')

		it 'should not replace existing properties, but merge them', ->
			x18n.register 'en', user: 'user'
			x18n.register 'en', login: 'login'
			expect(dict.en).to.eql(user: 'user', login: 'login')

		it 'should trigger the event dict:change', ->
			called = false
			x18n.on 'dict:change', -> called = true
			x18n.register 'en', {}
			expect(called).to.be.true

	describe 'set', ->
		it 'should set @chosenLocal', ->
			x18n.set 'de'
			expect(x18n.chosenLocal).to.equal('de')

	describe 'setDefault', ->
		it 'should set @defaultLocal', ->
			x18n.setDefault 'en'
			expect(x18n.defaultLocal).to.equal('en')

	describe 'similiarLocales', ->
		it 'should detect similiar locales', ->
			x18n.availableLocales = ['en', 'en-us', 'en-AU', 'de', 'fr']
			expect(x18n.similiarLocales('en')).to.eql(['en-us', 'en-AU'])

	describe 'sortLocales', ->
		it 'should set @locales to an array', ->
			x18n.sortLocales()
			expect(x18n.locales).to.be.an('array')

		it 'should trigger lang:change', ->
			x18n.register('test', { a: 'a' })
			x18n.register('en', { a: 'a' })

			called = false
			x18n.on 'lang:change', -> called = true

			x18n.defaultLocal = 'test'
			x18n.sortLocales()

			expect(called).to.be.true

			x18n.defaultLocal = 'en'
			x18n.sortLocales()

		###
		it should contain the chosen local first if set
		it should only contain available locales
		it should not contain duplicate entries
		###

	describe 'interpolate', ->
		it 'should support numeric interpolation', ->
			s = x18n.interpolate('Hello %1', 'World')
			expect(s).to.equal('Hello World')

		it 'should support alpha interpolation', ->
			s = x18n.interpolate('Hello %{s}', s: 'World')
			expect(s).to.equal('Hello World')

		it 'should support several interpolations in one string', ->
			s = x18n.interpolate('Hello %1 and %2', 'a', 'b')
			expect(s).to.equal('Hello a and b')

	describe 't', ->
		it 'should be defined', ->
			expect(x18n).to.have.property('t')

		it 'should return the translation', ->
			x18n.register 'de', user: 'benutzer'
			expect(t('user')).to.equal('benutzer')

		it 'should loop through all available locales and return the first translation', ->
			x18n.register 'de', {}
			x18n.register 'en', user: 'user'
			expect(t('user')).to.equal('user')

		it 'should behave like utils.getByDotNotation', ->
			x18n.register 'en', errors: presence: 'Not found'
			expect(t('errors.presence')).to.equal('Not found')

		it "should populate @missingTranslation if the translation doesn't exist in some language", ->
			x18n.register 'en', {}
			t('register')
			expect(x18n.missingTranslations).to.have.property('en').that.is.an('array').that.include('register')

		it "should trigger the event missing-translation if the translation doesn't exist in some language", ->
			called = false
			x18n.on 'missing-translation', -> called = true
			x18n.register 'en', {}
			t('register')
			expect(called).to.be.true

		it 'should support interpolation', ->
			x18n.register 'en',
				a: 'Hello %1',

			expect(t('a', 'World')).to.equal('Hello World')

		it 'should support multiple interpolations', ->
			x18n.register 'en',
				greeting: 'Hi %1 and %2'

			expect(t('greeting', 'a', 'b')).to.equal('Hi a and b')

		it 'should support explicit interpolation', ->
			x18n.register 'en',
				a: 'Hello %{s}'

			expect(t('a', s: 'World')).to.equal('Hello World')

		it 'should return an object with a plural method when requesting a plural', ->
			x18n.register 'en',
				users:
					1: 'There is 1 user online'
					n: 'There are %1 users online'

			expect(t('users')).to.have.property('plural').that.is.a('function')

		it 'should support pluralisation', ->
			x18n.register 'en',
				users:
					1: 'There is 1 user online'
					n: 'There are %1 users online'

			expect(t('users').plural(1)).to.equal('There is 1 user online')
			expect(t('users').plural(3)).to.equal('There are 3 users online')
