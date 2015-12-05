// Generated by CoffeeScript 1.10.0
(function() {
  var exec, should;

  exec = require('child_process').exec;

  should = require('should');

  describe("metrics", function() {
    var metrics;
    metrics = null;
    before(function(next) {
      return exec("rm -rf " + __dirname + "/../db/metrics && mkdir " + __dirname + "/../db/metrics", function(err, stdout) {
        metrics = require('../lib/metrics');
        return next(err);
      });
    });
    return it("get a metric", function(next) {
      return metrics.save('1', [
        {
          timestamp: (new Date('2015-11-04 14:00 UTC')).getTime(),
          value: 23
        }, {
          timestamp: (new Date('2015-11-04 14:10 UTC')).getTime(),
          value: 56
        }
      ], function(err) {
        if (err) {
          return next(err);
        }
        return metrics.get('1', function(err, metrics) {
          if (err) {
            return next(err);
          }
          return next();
        });
      });
    });
  });

}).call(this);
