module.exports = (grunt) ->

  grunt.initConfig
    clean:
      app: ['build'],
      temp: ['temp']
    jsonmin:
      app:
        files:
          'build/manifest.json': 'src/manifest.json'
    copy:
      app:
        expand: true
        cwd: 'src'
        src: ['images/**', 'libraries/**', 'pages/**']
        dest: 'build'
        filter: 'isFile'
    coffee:
      app:
        expand: true
        cwd: 'src/scripts'
        src: ['**/*.coffee']
        dest: 'temp/scripts'
        ext: '.js'
    less:
      app:
        expand: true
        cwd: 'src/stylesheets'
        src: ['**/*.less']
        dest: 'build/stylesheets'
        ext: '.css'
    uglify:
      options:
        banner: '/*! Watch on YouTube (<%= grunt.template.today("yyyy-mm-dd") %>) */\n'
      app:
        expand: true
        cwd: 'temp/scripts'
        src: ['**/*.js']
        dest: 'build/scripts'
        ext: '.js'
    watch:
      app:
        files: ['**/*.json', '**/*.coffee', '**/*.less', '**/*.html']
        tasks:  ['clean', 'jsonmin', 'copy', 'coffee', 'uglify', 'less']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-jsonmin'

  # Default task.
  grunt.registerTask 'default', ['clean', 'jsonmin', 'copy', 'coffee', 'uglify', 'less', 'clean:temp']
