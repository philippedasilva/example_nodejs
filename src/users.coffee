db = require('./db') "#{__dirname}/../db/users"

module.exports =
  ###
  `get()`
  ------
  Returns some hard coded metrics
  ###

  get: (username,callback) ->
    user ={}
    rs = db.createReadStream
      gte: "user:#{username}"
      lte: "user:#{username}"
    rs.on 'data', (data) ->
      [_,_username] = data.key.split ':'
      [_name,_password,_email] = data.value.split '.'
      user =
        username: _username
        name:_name
        password: _password
        email: _email
    rs.on 'error',callback
    rs.on 'close', ->
      callback null, user

  save: (username,password,name,email,callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{username}", value: "#{name}.#{password}.#{email}"
    ws.end()
