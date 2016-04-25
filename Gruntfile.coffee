module.exports = (grunt) ->

	grunt.initConfig
		coffee:
			compile:
				files:
					'lib/x18n.js': 'lib/x18n.coffee'
					'spec/spec.js': 'spec/spec.coffee'

		concat:
			options:
				banner: '// ' + grunt.file.read('LICENSE').split("\n")[0] + "\n"
				stripBanners: true
			dist:
				src: ['<banner>', 'node_modules/observable_js/lib/observable.js', 'lib/x18n.js']
				dest: 'lib/x18n_build.js'

		mocha:
			all:
				src: 'spec/index.html'
				run: true

		watch:
			files: ['lib/x18n.coffee', 'spec/spec.coffee']
			tasks: 'release'

	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-mocha')
	grunt.loadNpmTasks('grunt-contrib-concat')

	grunt.registerTask('test', 'mocha')
	grunt.registerTask('release', ['coffee', 'concat'])
	grunt.registerTask('default', 'release')
