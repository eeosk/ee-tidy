switch process.env.NODE_ENV
  when 'production' then require 'newrelic'
  when 'test' then process.env.PORT = 7777
  else process.env.NODE_ENV = 'development'; process.env.PORT = 7000

Hapi          = require 'hapi'
Good          = require 'good'
validate      = require './config/auth/validate'
hourlyTasks   = require './config/tasks/hourly'

server = new Hapi.Server()
server.connection {
  port: process.env.PORT
  routes:
    cors:
      origin: ['*']
      credentials: true
      additionalHeaders: ['X-Requested-With']
}

### Auth ###
server.register require('hapi-auth-jwt'), (err) ->

  server.auth.strategy 'admin_token', 'jwt',
    key: require('./config/auth/private.key')
    validateFunc: validate.admin_token_validation

  server.auth.strategy 'token', 'jwt',
    key: require('./config/auth/private.key')
    validateFunc: validate.token_validation

### ROUTES ###
server.realm.modifiers.route.prefix = '/v0'
server.route require('./config/routes')

### Logging ###
server.register
  register: Good
  options:
    reporters: [
      reporter: require('good-console'),
      args: if process.env.SILENT_OPS then [] else [ { log: '*', response: '*' } ]
    ]
, (err) ->
  if (err) then throw err
  server.start () ->
    server.log 'info', 'Server running at: ' + server.info.uri + ', env: ' + process.env.NODE_ENV

server.stop_run = (cb) ->
  server.stop () ->
    if cb then cb()
    server.log 'info', 'Server stopped'

server.start_run = (cb) ->
  server.start () ->
    if cb then cb()
    server.log 'info', 'Server running at: ' + server.info.uri

module.exports = server
