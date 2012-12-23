utils = X18n.utils
dict = X18n.dict

describe 'X18', ->
	afterEach ->
		dict = X18n.dict = {}

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