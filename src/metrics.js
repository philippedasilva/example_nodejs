// Generated by CoffeeScript 1.10.0
(function() {
  var db;

  db = require('./db')(__dirname + "/../db/metrics");

  module.exports = {

    /*
    `get()`
    ------
    Returns some hard coded metrics
     */
    get: function(id, callback) {
      var i, metrics, rs;
      metrics = [];
      i = 0;
      rs = db.createReadStream();
      rs.on('data', function(data) {
        var _, _id, _timestamp, ref;
        ref = data.key.split(':'), _ = ref[0], _id = ref[1], _timestamp = ref[2];
        metrics[i] = {
          id: _id,
          timestamp: _timestamp,
          value: data.value
        };
        return i++;
      });
      rs.on('error', callback);
      return rs.on('close', function() {
        return callback(null, metrics);
      });
    },

    /*
    `save(id, metrics, cb)`
    ------------------------
    Save some metrics with a given id
    Parameters:
    `id`: An integer defining a batch of metrics
    `metrics`: An array of objects with a timestamp and a value
    `callback`: Callback function takes an error or null as parameter
     */
    save: function(id, metrics, callback) {
      var j, len, m, timestamp, value, ws;
      ws = db.createWriteStream();
      ws.on('error', callback);
      ws.on('close', callback);
      for (j = 0, len = metrics.length; j < len; j++) {
        m = metrics[j];
        timestamp = m.timestamp, value = m.value;
        ws.write({
          key: "metric:" + id + ":" + timestamp,
          value: value
        });
      }
      return ws.end();
    }
  };

}).call(this);
