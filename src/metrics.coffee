db = require('./db') "#{__dirname}/../db/metrics"

module.exports =
  ###
  `get()`
  ------
  Returns some hard coded metrics
  ###

  get: () ->
    return [
      timestamp: new Date('2015-12-01 10:30 UTC').getTime(),
      value: 26
    ,
      timestamp: new Date('2015-12-01 10:35 UTC').getTime(),
      value: 23
    ,
      timestamp: new Date('2015-12-01 10:40 UTC').getTime(),
      value: 20
    ,
      timestamp: new Date('2015-12-01 10:45 UTC').getTime(),
      value: 19
    ,
      timestamp: new Date('2015-12-01 10:50 UTC').getTime(),
      value: 18
    ,
      timestamp: new Date('2015-12-01 10:55 UTC').getTime(),
      value: 20
    ,
      timestamp: new Date('2015-12-01 11:00 UTC').getTime(),
      value: 22
    ,
      timestamp: new Date('2015-12-01 11:15 UTC').getTime(),
      value: 25  
]
    ###
    rs = db.createReadStream()
    key = ''
    value= ''
    #rs.on 'data', console.log
    rs.on 'data', (chunk) ->
        key += chunk.key
        value += chunk.value
        #console.log data.key, " = ",data.value
        #d = "#{data.key} = #{data.value};"

    rs.on 'error', (err) ->
      if err then throw err

    rs.on 'end', () ->
        console.log "#{key} : #{value}"

    return [
       key : "#{key}",
       value : "#{value}"
    ]
    ###


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
