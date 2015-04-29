Routes  = {}
_       = require 'lodash'

Routes.prefix = 'v0'
validate = require '../auth/validate'

### Sleep if testing ###
Routes.test_delay = [
  (request, reply) ->
    if process.env.NODE_ENV is 'development'
      n = 1
      console.log 'sleeping for ' + n + ' seconds'
      require('sleep').usleep(n*1000000)
      reply()
    else
      reply()
]

### Messages ###

Routes.deleted_message =
  statusCode: 200
  message: "deleted"

Routes.bad_request_message =
  statusCode: 400
  error: "Bad Request"
  message: "Bad Request"

Routes.unauthorized_message =
  statusCode: 401
  error: "Unauthorized"
  message: "Unauthorized"

Routes.forbidden_message =
  statusCode: 403
  error: "Forbidden"
  message: "Forbidden"

Routes.not_found_message =
  statusCode: 404
  error: "Not Found"
  message: "Not Found"

### Reply Methods ###

Routes.basic_auth = (request, reply) ->
  token = request.headers.authorization
  if !token or token.indexOf('Basic ') isnt 0 then Routes.unauthorized reply; return
  validate.validate_basic(token)
  .then (res) -> reply res
  .catch (err) ->
    if typeof err is 'object' then err = 'Invalid email or password'
    Routes.bad_request err, reply

Routes.found = (record, reply) ->
  [message, code] = if !record then [Routes.not_found_message, 404] else [record, 200]
  reply(message).code(code)

Routes.found_with_token = (record, reply) ->
  reply({ user: record, token: record.getBearerToken() }).code(200)

Routes.error = (err, reply) -> reply(err).code(err.statusCode)

Routes.deleted      = (reply) -> Routes.error(Routes.deleted_message, reply)
Routes.unauthorized = (reply) -> Routes.error(Routes.unauthorized_message, reply)
Routes.forbidden    = (reply) -> Routes.error(Routes.forbidden_message, reply)
Routes.not_found    = (reply) -> Routes.error(Routes.not_found_message, reply)
Routes.bad_request  = (err, reply) ->
  res = _.clone Routes.bad_request_message
  res.message = err
  if typeof err is 'object' and err.name is 'SequelizeUniqueConstraintError' then res.message = err.fields[0] + ' already in use'
  if typeof err isnt 'string' && !!err.errors && !!err.errors[0] then res.message = err.errors[0].message
  Routes.error res, reply

### Comparison Methods ###

Routes.wrong_user_id = (request) ->
  # request.params.id is a string; request.auth.credentials.user.id is an integer
  +request.params.id != request.auth.credentials.user.id

# Routes.restrict_to_seller = (model, request, reply) ->

module.exports = Routes
