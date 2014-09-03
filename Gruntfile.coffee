module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    concurrent:
      clean: [ 'clean:dist', 'clean:server' ]
      preServer: [ 'copy:bootstrap', 'haml:server', 'compass:server', 'coffee:server' ]
      # preCompile: compile the files to optimize
      preCompile: [ 'copy:building', 'copy:dist',
                    'coffee:building', 'compass:dist', 'haml:building' ]
      afterBuild: [ 'clean:building', 'clean:cache' ]
    clean:
      dist: [ 'dist' ]
      server: [ '.server' ]
      building: [ '.building', '.tmp' ]
      cache: [ '.sass-cache' ]
    coffee:
      server:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.+(coffee|litcoffee)' ]
          dest: '.server/'
          ext: '.js'
          extDot: 'last'
        ]
      building:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.+(coffee|litcoffee)' ]
          dest: '.building'
          ext: '.js'
          extDot: 'last'
        ]
    compass:
      dist:
        options:
          sassDir: 'src/css'
          cssDir: 'dist/css'
          environment: 'production'
          outputStyle: 'compressed'
          # TODO: bundle has problem on Windows by now.
          #       waiting for the fix.
          #       refer to: [https://github.com/gruntjs/grunt-contrib-compass/issues/176]()
          #bundleExec: true
      server:
        options:
          sassDir: 'src/css'
          cssDir: '.server/css'
          outputStyle: 'expanded'
          # TODO: bundle has problem on Windows by now.
          #       waiting for the fix.
          #       refer to: [https://github.com/gruntjs/grunt-contrib-compass/issues/176]()
          #bundleExec: true
    connect:
      server:
        options:
          base: [ '.server', 'src' ]
          livereload: true
          useAvailablePort: true
    copy:
      bootstrap:
        files: [
          expand: true
          cwd: 'src/lib//bootstrap-sass-official/assets/fonts'
          src: [ 'bootstrap/**/*' ]
          dest: 'src/fonts/'
        ]
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!lib/**/*', '!**/*.{coffee,litcoffee,sass,scss,haml,slim,js}' ]
          filter: 'isFile'
          dest: 'dist/'
        ]
      building:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.js' ]
          filter: 'isFile'
          dest: '.building'
        ]
      usemin:
        files: [
          expand: true
          cwd: '.building'
          src: [ '**/*.html' ]
          filter: 'isFile'
          dest: 'dist'
        ]
    htmlmin:
      options:
        removeComments: true
        removeCommentsFromCDATA: true
        removeCDATASectionsFromCDATA: true
        collapseWhitespace: true
        conservativeCollapse: true
        collapseBooleanAttributes: true
        removeOptionalTags: true
      dist:
        files: [
          expand: true
          cwd: 'dist'
          src: [ '**/*.html' ]
          dest: 'dist'
        ]
    haml:
      options:
        bundleExec: true
      building:
        options:
          style: 'ugly'
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.haml' ]
          dest: '.building'
          ext: '.html'
          extDot: 'last'
        ]
      server:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.haml' ]
          dest: '.server/'
          ext: '.html'
          extDot: 'last'
        ]
    watch:
      options:
        spawn: false
        forever: true
        livereload: true
      haml:
        files: 'src/**/*.haml'
        tasks: 'haml:server'
      compass:
        files: 'src/**/*.+(sass|scss)'
        tasks: 'compass:server'
      coffee:
        files: 'src/**/*.+(coffee|litcoffee)'
        tasks: 'coffee:server'
    filerev:
      dist:
        src: [
          'dist/css/**/*.css'
          'dist/fonts/**/*.*'
          'dist/js/**/*.js'
        ]
    useminPrepare:
      html: [ '.building/**/*.html' ]
    usemin:
      html: [ 'dist/**/*.html' ]
      css: [ 'dist/css/**/*.css' ]
      options:
        assetsDirs: [ 'dist', 'dist/fonts', 'dist/img' ]


  grunt.registerTask 'compile', 'Compile & optimize the codes',
      [ 'concurrent:preCompile', 'optimize' ]

  grunt.registerTask 'optimize', 'Optimize JS files',
      [ 'useminPrepare', 'copy:usemin', 'concat:generated', 'uglify:generated', 'filerev', 'usemin', 'htmlmin' ]

  grunt.registerTask 'build', 'Build the code for production',
      [ 'concurrent:clean', 'copy:bootstrap', 'compile', 'concurrent:afterBuild' ]

  grunt.registerTask 'server', 'Start a preview server',
      [ 'concurrent:clean', 'concurrent:preServer', 'connect:server', 'watch' ]

  grunt.registerTask 'default', 'UT (when has) & build',
      [ 'build' ]
