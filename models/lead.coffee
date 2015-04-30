Sequelize = require 'sequelize'
sequelize = require '../config/sequelize/setup.coffee'
_         = require 'lodash'
utils     = require './model.utils'

Lead = sequelize.define 'Lead',

  etsy_user_id:       type: Sequelize.INTEGER,  unique: true
  etsy_meta:          type: Sequelize.JSON
  notes:              type: Sequelize.TEXT
  ignored:            type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
  sent_at:            type: Sequelize.DATE
  message_id:         type: Sequelize.INTEGER
  contact_urls:       type: Sequelize.TEXT
  contact_emails:     type: Sequelize.TEXT
,
  underscored: true
  classMethods:
    findOrCreateFromEtsyUser: (etsy_user) ->
      if !etsy_user or !etsy_user.id then return
      Lead.findOrCreate where: { etsy_user_id: etsy_user.id }, defaults: {
        contact_urls:               etsy_user.inferred_urls
        contact_emails:             etsy_user.inferred_emails
        etsy_meta:
          shop_id:                  etsy_user.shop_id
          user_id:                  etsy_user.user_id
          shop_name:                etsy_user.shop_name
          about_story_headline:     etsy_user.about_story_headline
          about_story:              etsy_user.about_story
          about_related_links:      etsy_user.about_related_links
          profile_image_url_75x75:  etsy_user.profile_image_url_75x75
          profile_bio:              etsy_user.profile_bio
          profile_gender:           etsy_user.profile_gender
          profile_first_name:       etsy_user.profile_first_name
          profile_last_name:        etsy_user.profile_last_name
      }

  instanceMethods:
    toJSON: () -> _.omit this.get(), Lead.restricted_attrs

  hooks:
    beforeUpdate: (order, options, fn) ->
      utils.assignJsonAttr(order, attr) for attr in Lead.json_attrs
      fn(null, order)

Lead.restricted_attrs = []
Lead.editable_attrs   = []
Lead.json_attrs       = []

module.exports = Lead
