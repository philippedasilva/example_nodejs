db = require('./db') "#{__dirname}/../db/metrics_users"

module.exports =
  ###
`  get()`
  ------
  Returns some hard coded metrics
  ###
  get: (username,callback) ->
    metrics_users = []
    i=0
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      [_, _username,_id_metric] = data.key.split ':'
      if _username == username
        metrics_users[i] =
          username: _username,
          id_metric: _id_metric,
          value: data.value
        i++
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics_users

  ###
  `save(username, id_metric)`
  ------------------------
  Save some metrics with a given username
  Parameters:
  `username`
  `id_metric`
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (username,id_metric,callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback

    ws.write key: "metrics_users:#{username}:#{id_metric}", value: ""
    ws.end()
