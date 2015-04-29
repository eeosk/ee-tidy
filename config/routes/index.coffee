###
  GET	   /model/id    models#show	    display the one and only model resource
  POST	 /model	      models#create	  create the new model
  PUT    /model	      models#update	  update the one and only model resource
  DELETE /model	      models#destroy  delete the model resource
###

etsy_user_routes  = require './etsy_user.routes'
lead_routes       = require './lead.routes'
message_routes    = require './message.routes'
admin_routes      = require './admin.routes'

Routes    = require './route.utils'
validate  = require '../auth/validate'

status = {
  method: '*'
  path: '/status'
  handler: (request, reply) ->
    reply 'ok'
}

catchall = {
  method: '*'
  path: '/{path*}'
  handler: (request, reply) ->
    Routes.not_found reply
  config:
    description: 'Catchall route'
    notes: 'The catchall route replies 404 if no other routes match'
    tags: ['api', 'catchall']
    pre: Routes.test_delay
}

module.exports = [].concat(etsy_user_routes, lead_routes, message_routes, admin_routes, status, catchall)
