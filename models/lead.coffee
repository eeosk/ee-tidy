Sequelize = require 'sequelize'
sequelize = require '../config/sequelize/setup.coffee'
_         = require 'lodash'
utils     = require './model.utils'

Lead = sequelize.define 'Lead',

  etsy_user_id:       type: Sequelize.INTEGER,  unique: true
  notes:              type: Sequelize.TEXT
  ignored:            type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
  sent_at:            type: Sequelize.DATE
  message_id:         type: Sequelize.INTEGER
  has_contact_info:   type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
,
  underscored: true
  classMethods: {}

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
