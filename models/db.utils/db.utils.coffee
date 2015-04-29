sequelize = require '../../config/sequelize/setup'
factories = require '../../test/factories'
validate  = require '../../config/auth/validate'
Promise   = require 'bluebird'

utils = {}

EtsyUser  = sequelize.models.EtsyUser
Lead      = sequelize.models.Lead
Message   = sequelize.models.Message
Admin     = sequelize.models.Admin

utils.EtsyUser  = EtsyUser
utils.Lead      = Lead
utils.Message   = Message
utils.Admin     = Admin

if process.env.NODE_ENV isnt 'production' and process.env.RESET_DATABASE? is true

  ### GENERAL ###

  utils.reset_db = () ->
    models = [EtsyUser, Lead, Message, Admin]
    deferreds = []
    for model in models
      deferreds.push
        model.sync({ force: true, logging: false })
    return Promise.all(deferreds)

  # utils.setup_db = () ->
  #   utils.reset_db()
  #   .then (admin_user) ->
  #     utils.admin_user = admin_user
  #     utils.admin_bearer = admin_user.getBearerToken()
  #     admin_user.update admin: true, validate: false # Manually set admin to true for admin_user
  #   .then () -> User.createWithPassword factories.users.basic_seller, factories.users.basic_seller.password
  #   .then (basic_seller) ->
  #     utils.basic_seller = basic_seller
  #     utils.seller_bearer = basic_seller.getBearerToken()
  #     User.createWithPassword factories.users.basic_supplier, factories.users.basic_supplier.password
  #   .then (basic_supplier) ->
  #     utils.basic_supplier = basic_supplier
  #     utils.supplier_bearer = basic_supplier.getBearerToken()
  #   .catch (err) -> console.log 'Error in db.utils.setup_db', err

  ### USER ###

  # utils.existing_seller =
  #   username: 'db_utils_seller'
  #   email: 'db_utils_seller@foo.bar'
  #   password: 'db_utils_foobar'
  #
  # utils.existing_supplier =
  #   username: 'db_utils_supplier'
  #   email: 'db_utils_supplier@foo.bar'
  #   password: 'db_utils_foobar'
  #   supplier: true
  #
  # utils.create_user = (user_inputs) -> User.createWithPassword(user_inputs, user_inputs.password)

  ### PRODUCT ###

  # utils.existing_product =
  #   supplier_id: dummy_supplier_id
  #   supply_price: 20000
  #   baseline_price: 22000
  #   suggested_price: 30000
  #   title: 'Product from db_utils'
  #
  # utils.create_product = (product_inputs) -> Product.create product_inputs

  ### SELECTION ###

  # utils.existing_selection =
  #   supplier_id: dummy_supplier_id
  #   seller_id: dummy_seller_id
  #   product_id: dummy_product_id
  #   margin: 15
  #   storefront_meta:
  #     categories: ['Uniques']
  #
  # utils.create_selection = (selection_inputs) -> Selection.create selection_inputs

  ### ORDER ###

  # utils.existing_order =
  #   selection_id: dummy_selection_id
  #   product_id: dummy_product_id
  #   supplier_id: dummy_supplier_id
  #   seller_id: dummy_seller_id
  #   identifier: 'EXISTING-ORDER-12345'
  #   selection_snapshot: utils.existing_selection
  #   product_snapshot: utils.existing_product
  #   supplier_snapshot:
  #     id: dummy_seller_id
  #     username: utils.existing_supplier.username
  #     email: utils.existing_supplier.email
  #   seller_snapshot:
  #     id: dummy_seller_id
  #     username: utils.existing_seller.username
  #     email: utils.existing_seller.email
  #   customer_meta:
  #     name: "Some Customer"
  #     address: "Some address hash"
  #
  # utils.create_order = (order_inputs) -> Order.create order_inputs

module.exports = utils
