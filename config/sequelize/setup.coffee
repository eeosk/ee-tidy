Sequelize = require 'sequelize'

db_name = 'unset'

# Sequelize
if process.env.DATABASE_URL
  sequelize = new Sequelize process.env.DATABASE_URL
else
  db_name = if process.env.NODE_ENV is 'test' then 'ee_db_test' else 'ee_tidy'
  sequelize = new Sequelize db_name, 'tyler', null, {
    host: 'localhost',
    port: 5432,
    dialect: 'postgres',
    logging: console.log if !process.env.SILENT_OPS
  }

sequelize
  .authenticate()
  .complete (err) ->
    # return if process.env.SILENT_OPS
    message = if !!err then 'Unable to connect to the database: ' + err else 'Database connection has been established successfully.'
    console.log message

module.exports = sequelize
