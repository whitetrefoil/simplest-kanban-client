module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      dist: [ 'dist' ]
      server: [ '.server' ]
      building: [ '.building', '.tmp' ]
      cache: [ '.sass-cache' ]
    bower:
      install:
        options:
          targetDir: './src/lib'
          cleanTargetDir: true
          layout: 'byComponent'
      copyOnly:
        options:
          targetDir: './src/lib'
          cleanTargetDir: true
          layout: 'byComponent'
          install: false
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
    copy:
      bootstrap:
        files: [
          expand: true
          cwd: 'bower_components/bootstrap-sass-official/assets/fonts'
          src: [ 'bootstrap/**/*' ]
          dest: 'src/fonts/'
        ]
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!lib/**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,slim,js}' ]
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
    jade:
      building:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.jade' ]
          dest: '.building'
          ext: '.html'
          extDot: 'last'
        ]
      server:
        options:
          pretty: true
          compileDebug: true
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.jade' ]
          dest: '.server/'
          ext: '.html'
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
    emblem:
      options:
        root: 'src/tpls/'
        dependencies:
          handlebars: 'bower_components/handlebars/handlebars.min.js'
          emblem: 'bower_components/emblem/dist/emblem.min.js'
      server:
        files:
          '.server/tpls/tpls.js': 'src/tpls/**/*.emblem'
      building:
        files:
          '.building/tpls/tpls.js': 'src/tpls/**/*.emblem'
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
    connect:
      server:
        options:
          base: [ '.server', 'src' ]
          livereload: true
          useAvailablePort: true
    watch:
      options:
        spawn: false
        forever: true
        livereload: true
      bower:
        files: 'bower.json'
        tasks: 'concurrent:dependencies'
      jade:
        files: 'src/**/*.jade'
        tasks: 'jade:server'
      compass:
        files: 'src/**/*.+(sass|scss)'
        tasks: 'compass:server'
      coffee:
        files: 'src/**/*.+(coffee|litcoffee)'
        tasks: 'coffee:server'
      emblem:
        files: 'src/tpls/**/*.emblem'
        tasks: 'emblem:server'
    concurrent:
      clean: [ 'clean:dist', 'clean:server' ]
      dependencies: [ 'bower:install' ]
      preServer: [ 'copy:bootstrap', 'jade:server', 'compass:server', 'coffee:server', 'emblem:server' ]
      # preCompile: compile the files to optimize
      preCompile: [ 'copy:building', 'copy:dist',
                    'coffee:building', 'compass:dist', 'jade:building', 'emblem:building' ]
      optimize: [ 'optimize' ]
      build: [ 'compile' ]
      afterBuild: [ 'clean:building', 'clean:cache' ]


  grunt.registerTask 'compile', 'Compile & optimize the codes',
      [ 'concurrent:preCompile', 'concurrent:optimize' ]

  grunt.registerTask 'optimize', 'Optimize JS files',
      [ 'useminPrepare', 'copy:usemin', 'concat:generated', 'uglify:generated', 'filerev', 'usemin', 'htmlmin' ]

  grunt.registerTask 'build', 'Build the code for production',
      [ 'concurrent:clean', 'concurrent:dependencies', 'copy:bootstrap', 'concurrent:build', 'concurrent:afterBuild' ]

  grunt.registerTask 'quickBuild', 'Quickly build the code w/o cleaning or bower tasks',
      [ 'concurrent:build', 'concurrent:building', 'concurrent:afterBuild' ]

  grunt.registerTask 'server', 'Start a preview server',
      [ 'concurrent:clean', 'bower:copyOnly', 'concurrent:preServer', 'connect:server', 'watch' ]

  grunt.registerTask 'default', 'UT (when has) & build',
      [ 'build' ]
