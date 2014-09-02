module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      dist: [ 'dist' ]
      server: [ '.server' ]
      building: [ '.building' ]
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
          dest: '.building/'
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
          cwd: '.building'
          src: [ '**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,slim,js}' ]
          filter: 'isFile'
          dest: 'dist/'
        ]
      building:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!**/*.{coffee,litcoffee,sass,scss,jade,slim}' ]
          filter: 'isFile'
          dest: '.building/'
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
      building:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.jade' ]
          dest: '.building/'
          ext: '.html'
          extDot: 'last'
        ,
          expand: true
          cwd: 'src'
          src: [ '**/*.jadebars' ]
          dest: '.building/'
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
      building:
        options:
          sassDir: 'src/css'
          cssDir: '.building/css'
          environment: 'production'
          outputStyle: 'compressed'
    emblem:
      options:
        root: 'src/tpls/'
        dependencies:
          handlebars: 'bower_components/handlebars/handlebars.min.js'
          emblem: 'bower_components/emblem/dist/emblem.min.js'
      server:
        files:
          '.server/js/templates.js': 'src/tpls/**/*.emblem'
      dist:
        files:
          'dist/js/templates.js': 'src/tpls/**/*.emblem'
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
      preCompile: [ 'copy:bootstrap', 'copy:building', 'jade:building', 'compass:building', 'coffee:building', 'emblem:dist' ]  # TODO
      optimize: [ ]  # TODO
      build: [ 'compile', 'copy:dist' ]  # TODO
      afterBuild: [ 'clean:building' ]  # TODO


  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-emblem'

  grunt.regiestTask 'compile', 'Compile & optimize the codes',
      [ 'preCompile', 'optimize' ]  # TODO

  grunt.registerTask 'build', 'Build the code for production',
      [ 'concurrent:clean', 'concurrent:dependencies', 'concurrent:build', 'concurrent:building', 'concurrent:afterBuild' ]

  grunt.registerTask 'quickBuild', 'Quickly build the code w/o cleaning or bower tasks',
      [ 'concurrent:build', 'concurrent:building', 'concurrent:afterBuild' ]

  grunt.registerTask 'server', 'Start a preview server',
      [ 'concurrent:clean', 'bower:copyOnly', 'concurrent:preServer', 'connect:server', 'watch' ]
