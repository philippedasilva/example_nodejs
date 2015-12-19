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
      #gte: "metric:#{id}"
      #lte: "metric:#{id}"
    rs.on 'data', (data) ->
      [_,_id_batch, _id_metric] = data.key.split ':'
      [_timestamp,_value] = data.value.split ':'

      metrics[i] =
        id_batch: _id_batch,
        id_metric: _id_metric
        timestamp:_timestamp,
        value: _value
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

  save: (id_batch,metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {id_metric,timestamp, value} = m
      ws.write key: "metric:#{id_batch}:#{id_metric}", value: "#{timestamp}:#{value}"
    ws.end()
