EtsyUser  = require '../../models/etsy_user'
Routes    = require './route.utils'

module.exports = [

  # ETSY_USER findAll
  {
    method: 'GET'
    path: '/etsy_users'
    handler: (request, reply) ->
      EtsyUser.findAll where: {}, limit: 100
      .then (etsy_users) -> Routes.found etsy_users, reply
      .catch (err) -> Routes.bad_request(err, reply)
      return
    config:
      pre: Routes.test_delay
  },

]
