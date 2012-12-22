module.exports = function (grunt) {

	grunt.initConfig({

		meta: {
			banner: '// ' + grunt.file.read('LICENSE').split("\n")[0]
		},

		coffee: {
			compile: {
				files: {
					'lib/x18n.js': ['lib/observable.coffee', 'lib/x18n.coffee'],
					'spec/spec.js': 'spec/spec.coffee'
				}
			}
		},

		concat: {
			dist: {
				src: ['<banner>', 'lib/x18n.js'],
				dest: 'lib/x18n.js'
			}
		}

	});

	grunt.loadNpmTasks('grunt-contrib-coffee');

	grunt.registerTask('release', 'coffee concat');
	grunt.registerTask('default', 'release');

};