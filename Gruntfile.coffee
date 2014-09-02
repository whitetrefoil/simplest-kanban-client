module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      dist: [ 'dist' ]
      server: [ '.server' ]
      rjs: [ '.tmp' ]
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
      rjs:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.+(coffee|litcoffee)' ]
          dest: '.tmp/'
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
          cwd: '.tmp'
          src: [ '**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,haml,slim,js}' ]
          filter: 'isFile'
          dest: 'dist/'
        ,
          expand: true
          cwd: 'src'
          src: [ 'lib/requirejs/*.js' ]
          dest: 'dist'
        ]
      server:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,haml,slim}' ]
          filter: 'isFile'
          dest: '.server/'
        ]
      rjs:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,haml,slim}' ]
          filter: 'isFile'
          dest: '.tmp/'
        ]
    haml:
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.haml' ]
          dest: 'dist/'
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
      rjs:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.haml' ]
          dest: '.tmp/'
          ext: '.html'
          extDot: 'last'
        ]
    jade:
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.jade' ]
          dest: 'dist/'
          ext: '.html'
          extDot: 'last'
        ,
          expand: true
          cwd: 'src'
          src: [ '**/*.jadebars' ]
          dest: 'dist/'
          ext: '.hbs'
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
        ,
          expand: true
          cwd: 'src'
          src: [ '**/*.jadebars' ]
          dest: '.server/'
          ext: '.hbs'
          extDot: 'last'
        ]
      rjs:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.jade' ]
          dest: '.tmp/'
          ext: '.html'
          extDot: 'last'
        ,
          expand: true
          cwd: 'src'
          src: [ '**/*.jadebars' ]
          dest: '.tmp/'
          ext: '.hbs'
          extDot: 'last'
        ]
    compass:
      dist:
        options:
          sassDir: 'src/css'
          cssDir: 'dist/css'
          environment: 'production'
          outputStyle: 'compressed'
      server:
        options:
          sassDir: 'src/css'
          cssDir: '.server/css'
          outputStyle: 'expanded'
      rjs:
        options:
          sassDir: 'src/css'
          cssDir: '.tmp/css'
          environment: 'production'
          outputStyle: 'compressed'
    requirejs:
      options:
        optimize: 'none'
        baseUrl: '.tmp/js'
        paths:
          lib: '../lib'
          config: '../data/config'
          data: 'utils/data'
          hbs: '../lib/require-handlebars-plugin/hbs'
          jquery: '../lib/jquery/jquery'
          backbone: '../lib/backbone/backbone'
          bootstrap: '../lib/bootstrap-sass-official/js/bootstrap'
        shim:
          bootstrap: [ 'jquery' ]
        packages: [
          name: 'lodash'
          location: '../lib/lodash-amd/modern'
        ,
          name: 'underscore',
          location: '../lib/lodash-amd/underscore'
        ]
      dist:
        options:
          name: 'index'
          out: 'dist/js/index.js'
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
      haml:
        files: 'src/**/*.haml'
        tasks: 'haml:server'
      jade:
        files: 'src/**/*.+(jade|jadebars)'
        tasks: 'jade:server'
      compass:
        files: 'src/**/*.+(sass|scss)'
        tasks: 'compass:server'
      coffee:
        files: './src/**/*.+(coffee|litcoffee)'
        tasks: 'coffee:server'
    concurrent:
      clean: [ 'clean:dist', 'clean:server' ]
      dependencies: [ 'bower:install' ]
      preServer: [ 'copy:bootstrap', 'copy:server', 'haml:server', 'jade:server', 'compass:server', 'coffee:server' ]
      build: [ 'copy:bootstrap', 'copy:rjs', 'haml:rjs', 'jade:rjs', 'compass:rjs', 'coffee:rjs' ]
      rjs: [ 'requirejs', 'copy:dist' ]
      afterBuild: [ 'clean:rjs' ]


  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-haml'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-concurrent'


  grunt.registerTask 'build', 'Build the code for production',
      [ 'concurrent:clean', 'concurrent:dependencies', 'concurrent:build', 'concurrent:rjs', 'concurrent:afterBuild' ]

  grunt.registerTask 'quickBuild', 'Quickly build the code w/o cleaning or bower tasks',
      [ 'clean:dist', 'concurrent:build', 'concurrent:rjs']
      #[ 'concurrent:build', 'concurrent:rjs', 'concurrent:afterBuild']

  grunt.registerTask 'server', 'Start a preview server',
      [ 'concurrent:clean', 'bower:copyOnly', 'concurrent:preServer', 'connect:server', 'watch' ]
