gulp    = require 'gulp'
mocha   = require 'gulp-mocha'

gulp.task 'server-reset', () ->
  server = require './server'
  server.stop_run()
  server.start_run()
  console.log 'server restarted'

gulp.task 'dev', () ->
  process.env.NODE_ENV = 'development'
  server = require './server'
  gulp.watch [
    'server.coffee',
    'config/**',
    'models/**'
  ], ['server-reset']
  return

gulp.task 'test', () ->
  process.env.NODE_ENV = 'test'
  server = require './server'
  gulp.watch [
    'server.coffee',
    'config/**',
    'models/**'
  ], ['server-reset']
  return

gulp.task 'mocha', () ->
  gulp.src './test/*.coffee', { read: false }
    .pipe mocha
      reporter: 'nyan'

gulp.task 'watch-mocha', () ->
  gulp.watch [
    'config/**',
    'test/**',
    'models/**',
    'server.coffee'
  ], ['mocha']
  return
