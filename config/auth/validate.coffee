Admin       = require '../../models/admin'
Bcrypt      = require 'bcrypt'
jwt         = require 'jsonwebtoken'
privateKey  = require './private.key'

validate = {}

validate.get_basic = (email, password) ->
  'Basic ' + email + ':' + password

validate.parse_basic = (token) ->
  token.substring(6).split(':')

validate.validate_basic = (token) ->
  err_message = 'Invalid email or password'
  [email, password] = validate.parse_basic(token)
  if !email or !password then throw err_message
  scope = {}
  Admin.find where: { email: email }
  .then (admin) ->
    scope.admin = admin
    Bcrypt.compareAsync password, admin.password_hash
  .then (result) ->
    throw err_message unless result is true
    scope.admin.getBearerToken()
  .then (bearer) ->
    scope.token = bearer
    scope.admin = scope.admin.toJSON()  # strips out unwanted attributes
    return scope
  .catch (err) -> throw err

validate.validate_bearer = (token) -> jwt.verify token.replace('Bearer ', ''), privateKey

validate.login_validation = (email, password, cb) ->
  Admin.find where: { email: email }
    .success (admin) ->
      Bcrypt.compare password, admin.password_hash, (err, isValid) ->
        token = admin.getBearerToken()
        cb err, isValid, { token: token }
    .error (err) -> cb null, false

validate.token_validation = (decodedToken, cb) ->
  Admin.find where: { ee_uuid: decodedToken.token }
    .success (admin) ->
      if !admin then throw 'Invalid credentials'
      cb null, true, {
        admin: admin,
        decodedToken: decodedToken
      }
    .error (err) ->
      cb null, false

validate.admin_token_validation = (decodedToken, cb) ->
  Admin.find where: { ee_uuid: decodedToken.token }
    .success (admin) ->
      if !admin or !admin.admin then throw 'Invalid credentials'
      cb null, true, {
        admin: admin,
        decodedToken: decodedToken
      }
    .error (err) ->
      cb null, false

module.exports = validate
