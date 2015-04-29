Sequelize = require 'sequelize'
sequelize = require '../config/sequelize/setup.coffee'
_         = require 'lodash'
utils     = require './model.utils'

EtsyUser = sequelize.define 'etsy_user',

  shop_id:                  type: Sequelize.INTEGER
  user_id:                  type: Sequelize.INTEGER
  shop_name:                type: Sequelize.STRING
  login_name:               type: Sequelize.STRING
  announcement:             type: Sequelize.TEXT
  listing_active_count:     type: Sequelize.INTEGER
  policy_seller_info:       type: Sequelize.TEXT
  num_favorers:             type: Sequelize.INTEGER
  about_story_headline:     type: Sequelize.TEXT
  about_story:              type: Sequelize.TEXT
  about_related_links:      type: Sequelize.TEXT
  profile_bio:              type: Sequelize.TEXT
  profile_gender:           type: Sequelize.STRING
  profile_city:             type: Sequelize.STRING
  profile_region:           type: Sequelize.STRING
  profile_image_url_75x75:  type: Sequelize.TEXT
  profile_first_name:       type: Sequelize.STRING
  profile_last_name:        type: Sequelize.STRING
  shop_created_at:          type: Sequelize.DATE
  user_created_at:          type: Sequelize.DATE
  inferred_urls:            type: Sequelize.TEXT
  inferred_emails:          type: Sequelize.TEXT
  external_action_taken:    type: Sequelize.STRING
  external_action_time:     type: Sequelize.DATE
  external_action_status:   type: Sequelize.STRING
,
  underscored: true
  classMethods: {}

  instanceMethods:
    toJSON: () -> _.omit this.get(), EtsyUser.restricted_attrs

  hooks:
    beforeUpdate: (order, options, fn) ->
      utils.assignJsonAttr(order, attr) for attr in EtsyUser.json_attrs
      fn(null, order)

EtsyUser.restricted_attrs = []
EtsyUser.editable_attrs   = []
EtsyUser.json_attrs       = []

module.exports = EtsyUser
