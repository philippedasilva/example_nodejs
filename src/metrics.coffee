db = require('./db') "#{__dirname}/../db/metrics"

module.exports =
  ###
  `get()`
  ------
  Returns some hard coded metrics
  ###

  get: (id,callback) ->
    metrics = []
    i=0
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      #gte: "id:#{id}"
      [_, _id, _timestamp] = data.key.split ':'
      #metrics.push id: id, timestamp: timestamp, value: value
      #metrics.push id: _id, timestamp: _timestamp, value: data.value
      metrics[i] =
        id: _id,
        timestamp:_timestamp,
        value: data.value
      i++
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics

  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id
  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###

  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()
