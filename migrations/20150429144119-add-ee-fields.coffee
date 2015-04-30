"use strict"

module.exports =
  up: (migration, DataTypes, done) ->

    # LEADS
    console.log 'Adding Leads'
    migration.createTable('Leads',
      {
        id:                 type: DataTypes.INTEGER,  primaryKey: true, autoIncrement: true
        etsy_user_id:       type: DataTypes.INTEGER
        notes:              type: DataTypes.TEXT
        ignored:            type: DataTypes.BOOLEAN,  allowNull: false, defaultValue: false
        sent_at:            type: DataTypes.DATE
        message_id:         type: DataTypes.INTEGER
        contact_urls:       type: DataTypes.TEXT
        contact_emails:     type: DataTypes.TEXT
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
    )
    .then () ->
      console.log 'Adding Index Leads_contact_urls_key'
      migration.addIndex 'Leads', ['contact_urls'], { indexName: 'Leads_contact_urls_key' }
    .then () ->
      console.log 'Adding Index Leads_contact_emails_key'
      migration.addIndex 'Leads', ['contact_emails'], { indexName: 'Leads_contact_emails_key' }
    .then () ->
      console.log 'Adding Messages'

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

    .then () ->
      console.log 'Adding Admins'

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

      .then () ->
        done()
    return

  down: (migration, DataTypes, done) ->
    migration.dropTable 'Leads'
    migration.dropTable 'Messages'
    migration.dropTable 'Admins'
    migration.removeIndex 'Leads', ['Leads_contact_urls_key']
    migration.removeIndex 'Leads', ['Leads_contact_emails_key']
    done()
    return
