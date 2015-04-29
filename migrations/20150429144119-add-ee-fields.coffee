"use strict"

module.exports =
  up: (migration, DataTypes, done) ->

    # LEADS
    migration.createTable 'Leads',
      {
        id:                 type: DataTypes.INTEGER,  primaryKey: true, autoIncrement: true
        etsy_user_id:       type: DataTypes.INTEGER
        notes:              type: DataTypes.TEXT
        ignored:            type: DataTypes.BOOLEAN,  allowNull: false, defaultValue: false
        sent_at:            type: DataTypes.DATE
        message_id:         type: DataTypes.INTEGER
        has_contact_info:   type: DataTypes.BOOLEAN,  allowNull: false, defaultValue: false
        etsy_meta:          type: DataTypes.JSON
        created_at:         type: DataTypes.DATE
        updated_at:         type: DataTypes.DATE
      }, {
        engine: 'InnoDB'
        charset: null
        uniqueKeys: [
          { fields: ['etsy_user_id'] }
        ]
      }

    # MESSAGES
    migration.createTable 'Messages',
      {
        id:                 type: DataTypes.INTEGER,  primaryKey: true, autoIncrement: true
        title:              type: DataTypes.STRING
        body:               type: DataTypes.TEXT
        created_at:         type: DataTypes.DATE
        updated_at:         type: DataTypes.DATE
      }, {
        engine: 'InnoDB'
        charset: null
      }

    # ADMINS
    migration.createTable 'Admins',
      {
        id:                 type: DataTypes.INTEGER,  primaryKey: true, autoIncrement: true
        username:           type: DataTypes.STRING,   allowNull: false
        email:              type: DataTypes.STRING,   allowNull: false
        ee_uuid:            type: DataTypes.UUID,     allowNull: false
        admin:              type: DataTypes.BOOLEAN,  allowNull: false, defaultValue: false
        created_at:         type: DataTypes.DATE
        updated_at:         type: DataTypes.DATE
        deleted_at:         type: DataTypes.DATE
      }, {
        engine: 'InnoDB'
        charset: null
        uniqueKeys: [
          { fields: ['username'] },
          { fields: ['email'] },
          { fields: ['ee_uuid'] }
        ]
      }

    done()
    return

  down: (migration, DataTypes, done) ->
    migration.dropTable 'Leads'
    migration.dropTable 'Messages'
    migration.dropTable 'Admins'
    done()
    return
