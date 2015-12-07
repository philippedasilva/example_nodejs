#db = require('./db') "#{__dirname}/../db/users"

module.exports =
  ###
  `get()`
  ------
  Returns some hard coded metrics
  ###

  get: () ->
    return [
      user: "root",
      password: "root"
    ,
      user: "phil",
      password: "root"
]

  login: (login,password) ->
    tab = this.get()
    i=0
    for users in tab
      if login == "#{users.user}" && password == "#{users.password}"
        i++

    if i==1
      return true
    else
      return false

  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id
  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###

  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()
  ###
