module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    bower:
      install:
        options:
          targetDir: './src/lib'
          cleanTargetDir: true
          install: true
          copy: false
    concurrent:
      clean: [ 'clean:dist', 'clean:server' ]
      dependencies: [ 'bower:install' ]
      preServer: [ 'compass:server', 'coffee:server', 'copy:server',
                   'handlebars:server' ]
    # preCompile: compile the files to optimize
      preCompile: [ 'copy:building', 'copy:dist',
                    'coffee:building', 'compass:dist', 'handlebars:building' ]
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
      options:
        port: 8000
        base: ['.server', 'src']
        open: 'http://localhost:8000'
        middleware: (connect, options) ->
          options.base = [options.base] unless Array.isArray(options.base)
          middlewares = [require('grunt-connect-proxy/lib/utils').proxyRequest]
          options.base.forEach (base) ->
            middlewares.push(connect.static(base))
          directory = options.directory or options.base[options.base.length - 1]
          middlewares.push(connect.directory(directory))
          middlewares.push (req, res, next) ->
            console.log req.url
            next()
          middlewares
      server:
        proxies: [
          context: '/api'
          host: 'localhost'
          port: 9999
        ]
        options:
          livereload: true
    copy:
      server:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!lib/**/*',
                 '!**/*.{coffee,litcoffee,sass,scss,js,handlebars}' ]
          filter: 'isFile'
          dest: '.server/'
        ,
          expand: true
          cwd: 'src/lib/bootstrap-sass-official/assets/fonts'
          src: [ 'bootstrap/**/*' ]
          dest: '.server/fonts/'
        ]
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*', '!lib/**/*',
                 '!**/*.{coffee,litcoffee,sass,scss,js,handlebars}' ]
          filter: 'isFile'
          dest: 'dist/'
        ,
          expand: true
          cwd: 'src/lib/bootstrap-sass-official/assets/fonts'
          src: [ 'bootstrap/**/*' ]
          dest: 'dist/fonts/'
        ]
      building:
        files: [
          expand: true
          cwd: 'src'
          src: [ '**/*.js' ]
          filter: 'isFile'
          dest: '.building'
        ,
          expand: true
          cwd: 'src/lib/bootstrap-sass-official/assets/fonts'
          src: [ 'bootstrap/**/*' ]
          dest: '.building/fonts/'
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
    watch:
      options:
        spawn: false
        forever: true
        livereload: true
      bower:
        files: 'bower.json'
        tasks: 'concurrent:dependencies'
      html:
        files: 'src/**/*.html'
      jade:
        files: 'src/**/*.jade'
        tasks: 'jade:server'
      compass:
        files: 'src/**/*.+(sass|scss)'
        tasks: 'compass:server'
      coffee:
        files: 'src/**/*.+(coffee|litcoffee)'
        tasks: 'coffee:server'
      handlebars:
        files: 'src/**/*.handlebars'
        tasks: 'handlebars:server'
    handlebars:
      options:
        namespace: 'SK.Templates'
        processName: (path) -> path.replace /^src\/js\/templates\/(.*)\.handlebars$/, '$1'
      server:
        files:
          '.server/js/templates.js': 'src/js/templates/**/*.handlebars'
      building:
        files:
          '.building/js/templates.js': 'src/js/templates/**/*.handlebars'
    filerev:
      dist:
        src: [
          'dist/css/**/*.css'
          'dist/fonts/**/*.*'
          'dist/js/**/*.js'
        ]
    useminPrepare:
      html: [ '+(src|.building)/**/*.html' ]
    usemin:
      html: [ 'dist/**/*.html' ]
      css: [ 'dist/css/**/*.css' ]
      options:
        assetsDirs: [ 'dist', 'dist/fonts', 'dist/img' ]


  grunt.registerTask 'compile', 'Compile & optimize the codes',
                     [ 'concurrent:preCompile', 'optimize' ]

  grunt.registerTask 'optimize', 'Optimize JS files',
                     [ 'useminPrepare', 'copy:usemin', 'concat:generated',
                       'uglify:generated', 'filerev', 'usemin', 'htmlmin' ]

  grunt.registerTask 'build', 'Build the code for production',
                     [ 'concurrent:clean', 'concurrent:dependencies', 'compile',
                       'concurrent:afterBuild' ]

  grunt.registerTask 'server', 'Start a preview server',
                     [ 'concurrent:clean', 'concurrent:preServer',
                       'connect:server', 'watch' ]

  grunt.registerTask 'default', 'UT (when has) & build',
                     [ 'build' ]
