Sequelize = require 'sequelize'
sequelize = require '../config/sequelize/setup.coffee'
_         = require 'lodash'
utils     = require './model.utils'

Message = sequelize.define 'Message',

  title:  type: Sequelize.STRING
  body:   type: Sequelize.TEXT
,
  underscored: true
  classMethods: {}

  instanceMethods:
    toJSON: () -> _.omit this.get(), Message.restricted_attrs

  hooks:
    beforeUpdate: (order, options, fn) ->
      utils.assignJsonAttr(order, attr) for attr in Message.json_attrs
      fn(null, order)

Message.restricted_attrs = []
Message.editable_attrs   = []
Message.json_attrs       = []

module.exports = Message
