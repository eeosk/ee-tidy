Lead    = require '../../models/lead'
Routes  = require './route.utils'

module.exports = [

  # LEAD findAll
  {
    method: 'GET'
    path: '/leads'
    handler: (request, reply) ->
      query   = request.query
      page    = parseInt(request.query?.page) - 1
      perPage = 100
      offset  = if !!page then page * perPage else 0
      Lead.findAndCountAll
        where:
          contact_urls: not: null
        limit:  perPage
        offset: offset
        order:  'id ASC'
      .then (res) -> Routes.found res, reply
      .catch (err) -> Routes.bad_request(err, reply)
      return
    config:
      pre: Routes.test_delay
  },

  # LEAD update
  {
    method: 'PUT'
    path: '/leads/{id}'
    handler: (request, reply) ->
      Lead.findOne request.params.id
      .then (lead) -> lead.updateAttributes request.payload
      .then (res) ->  Routes.found res, reply
      .catch (err) -> Routes.bad_request(err, reply)
      return
    config:
      pre: Routes.test_delay
  }

]
