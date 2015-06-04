privateKey = if process.env.NODE_ENV is 'production' then process.env.AUTH_KEY else 'foobar'

module.exports = privateKey
