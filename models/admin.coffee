Sequelize = require 'sequelize'
sequelize = require '../config/sequelize/setup.coffee'
_         = require 'lodash'
utils     = require './model.utils'

Admin = sequelize.define 'Admin',

  email:    type: Sequelize.STRING,   allowNull: false, unique: true
  ee_uuid:  type: Sequelize.UUID,     allowNull: false, unique: true, defaultValue: Sequelize.UUIDV4
  admin:    type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
,
  paranoid: true
  underscored: true
  classMethods: {}

  instanceMethods:
    toJSON: () -> _.omit this.get(), Admin.restricted_attrs

  hooks:
    beforeUpdate: (order, options, fn) ->
      utils.assignJsonAttr(order, attr) for attr in Admin.json_attrs
      fn(null, order)

Admin.restricted_attrs = []
Admin.editable_attrs = []
Admin.json_attrs = []

module.exports = Admin
