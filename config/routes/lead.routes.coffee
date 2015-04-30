Lead    = require '../../models/lead'
Routes  = require './route.utils'

module.exports = [

  # LEAD findAll
  {
    method: 'GET'
    path: '/leads'
    handler: (request, reply) ->
      Lead.findAll where: { contact_emails: not: null }, limit: 100
      .then (leads) -> Routes.found leads, reply
      .catch (err) -> Routes.bad_request(err, reply)
      return
    config:
      pre: Routes.test_delay
  },

]
