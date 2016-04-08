module.exports = (grunt) ->

	grunt.initConfig
		meta:
			banner: '// ' + grunt.file.read('LICENSE').split("\n")[0]

		coffee:
			compile:
				files:
					'lib/x18n.js': 'lib/x18n.coffee'
					'spec/spec.js': 'spec/spec.coffee'

		concat:
			dist:
				src: ['<banner>', 'lib/observable/lib/observable.js', 'lib/x18n.js']
				dest: 'lib/x18n.js'

		mocha:
			all:
				src: 'spec/index.html'
				run: true

		watch:
			files: ['lib/x18n.coffee', 'spec/spec.coffee']

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-mocha')

	grunt.registerTask('test', 'mocha')
	grunt.registerTask('release', 'coffee concat')
	grunt.registerTask('default', 'release')
