_           = require 'lodash'
Promise     = require 'bluebird'

EtsyUser    = require '../etsy_user'
Lead        = require '../lead'
Message     = require '../message'
Admin       = require '../admin'

if process.env.NODE_ENV isnt 'development'
  console.log "NODE_ENV must be development"
  process.kill()
  return

if process.env.SEED_LEADS is 'true'
  ### NODE_ENV=development SEED_LEADS='true' coffee models/db.utils/db.seed.leads.coffee ###
  # n = if !!process.env.SEED_OFFSET then parseInt(process.env.SEED_OFFSET) else 0
  n = 0
  batch_size = 2500
  process_batch = () ->
    deferreds = []
    EtsyUser.findAll limit: batch_size, offset: n*batch_size, order: 'id DESC'
      .then (etsy_users) ->
        if !etsy_users or etsy_users.length < 1 then return Promise.resolve 'Finished'
        deferreds.push(Lead.findOrCreateFromEtsyUser(etsy_user)) for etsy_user in etsy_users
        Promise.all deferreds
      .then (res) ->
        console.log '---------------------------------------------------------------------------------------'
        console.log 'finished ' + res.length + ' records (offset: ' + n + '): ' + _.map(res, (lead) -> lead[0]?.id).join(', ')
        n += 1
        process_batch()

  process_batch()
  .then (res) -> console.log res
  .catch (err) -> console.log 'error', err
  .finally () -> process.kill()

else
  console.log "No DB seed scenario was matched:"
  console.log 'NODE_ENV', process.env.NODE_ENV
  console.log 'SEED_LEADS', process.env.SEED_LEADS
  process.kill()
