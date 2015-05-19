sequelize   = require '../../config/sequelize/setup'
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
  etsy_users = []
  deferreds = []
  batch_size = 200
  intervalTask = () ->
    deferreds = []
    sequelize.query 'SELECT * FROM "etsy_users" WHERE id NOT IN(SELECT etsy_user_id FROM "Leads") LIMIT ' + batch_size + ';'
      .then (res) ->
        etsy_users = res[0]
        if !etsy_users or etsy_users.length < 1
          console.log 'Finished'
          process.kill()
        deferreds.push(Lead.findOrCreateFromEtsyUser(etsy_user)) for etsy_user in etsy_users
        Promise.all deferreds
      .then (res) ->
        console.log '---------------------------------------------------------------------------------------'
        console.log 'finished ' + res.length + ' records starting at ' + res[0][0]?.id
      .catch (err) ->
        console.log '---------------------------------------------------------------------------------------'
        console.log 'CAUGHT AN ERROR', err
      .finally () ->
        setTimeout(intervalTask, 2000)

  intervalTask()

if process.env.RANDOM_100 is 'true'
  ### NODE_ENV=development RANDOM_100='true' BATCH='2A' coffee models/db.utils/db.seed.leads.coffee ###
  leads = []
  deferreds = []

  logAndMark = (obj) ->
    Lead.find where: id: obj.id
    .then (lead) ->
      lead.update
        sent_at: new Date()
        notes: "Batch " + process.env.BATCH

  getEmail = (urls) ->
    emails = []
    url_array = urls.split(', ')
    addEmail = (url) -> if url.indexOf('@') > -1 and url.indexOf('flickr') < 0 then emails.push url
    addEmail url for url in url_array
    emails.join(', ')

  printLead = (lead) ->
    console.log lead.id, getEmail(lead.contact_urls)

  sequelize.query 'SELECT * FROM "Leads" WHERE contact_urls like \'%@%\' AND sent_at IS NULL ORDER BY id ASC LIMIT 100;'
  .then (res) ->
    leads = res[0]
    deferreds.push(logAndMark obj) for obj in leads
    Promise.all deferreds
  .then (res) ->
    console.log '---------------------------------------------------------------------------------------'
    _.map leads, (l) -> printLead l
    console.log '---------------------------------------------------------------------------------------'
    console.log 'finished ' + res.length
  .catch (err) ->
    console.log '---------------------------------------------------------------------------------------'
    console.log 'CAUGHT AN ERROR', err
  .finally () ->
    process.kill()

else
  console.log "No DB seed scenario was matched:"
  console.log 'NODE_ENV', process.env.NODE_ENV
  console.log 'SEED_LEADS', process.env.SEED_LEADS
  process.kill()
