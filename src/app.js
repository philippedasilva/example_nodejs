// Generated by CoffeeScript 1.10.0
(function() {
  var LevelStore, app, authCheckHome, authCheckUser, express, jade, metrics, metrics_users, session, users;

  express = require('express');

  jade = require('jade');

  metrics = require('./metrics');

  users = require('./users');

  metrics_users = require('./metrics_users');

  session = require('express-session');

  LevelStore = require('level-session-store')(session);

  app = express();

  app.set('port', 1889);

  app.set('views', __dirname + "/../views");

  app.set('view engine', 'jade');

  app.use('/', express["static"](__dirname + "/../public"));


  /*
  app.use stylus.static
    src: "#{__dirname}/../public/css"
    compress: true
   */

  app.use(session({
    secret: 'Sec',
    store: new LevelStore(__dirname + "/../db/sessions"),
    resave: true,
    saveUnintialized: true
  }));

  app.use(require('body-parser')());


  /*
  app.get '/', (req,res)->
    res.render 'index'
  
  app.get '/user',(req,res) ->
    res.render 'user'
   */

  authCheckHome = function(req, res, next) {
    if (req.session.loggedIn === true) {
      return res.redirect('/user');
    } else {
      return next();
    }
  };

  app.get('/', authCheckHome, function(req, res) {
    return res.render('index');
  });

  authCheckUser = function(req, res, next) {
    if (req.session.loggedIn === void 0) {
      return res.redirect('/');
    } else {
      return next();
    }
  };

  app.get('/user', authCheckUser, function(req, res) {
    return res.render('user');
  });

  app.get('/username.json', function(req, res) {
    return res.status(200).json(req.session.username);
  });

  app.get('/users.json', function(req, res) {
    return users.get("root2", function(err, data) {
      if (err) {
        throw err;
      }
      return res.status(200).send(data);
    });
  });

  app.get('/metrics.json', function(req, res) {
    return metrics.get(1, function(err, data) {
      return res.status(200).send(data);
    });
  });

  app.get('/metrics_users.json', function(req, res) {
    if (req.session.loggedIn === void 0) {
      return res.status(200).send("Non loggé");
    } else {
      return metrics_users.get(req.session.username, function(err, data) {
        return res.status(200).send(data);
      });
    }
  });

  app.get('/metricsbyuser.json', function(req, res) {
    var i, j, tab;
    if (req.session.loggedIn === void 0) {
      return res.status(200).send("Non loggé");
    } else {
      tab = [];
      i = 0;
      j = 0;
      return metrics_users.get(req.session.username, function(err, data) {
        return metrics.get(1, function(err, met) {
          var d, k, l, len, len1, m;
          for (k = 0, len = data.length; k < len; k++) {
            d = data[k];
            for (l = 0, len1 = met.length; l < len1; l++) {
              m = met[l];
              if (d.id_metric === m.id) {
                tab[i] = m;
              }
            }
            i++;
          }
          return res.status(200).send(tab);
        });
      });
    }
  });

  app.post('/metric/save.json', function(req, res) {
    var met;
    met = [
      {
        timestamp: req.body.timestamp,
        value: req.body.value
      }
    ];
    return metrics.save(req.body.id, met, function(err) {
      if (err) {
        return res.status(500).json(err);
      } else {
        return metrics_users.save(req.session.username, req.body.id, function(err) {
          if (err) {
            return res.status(500).json(err);
          } else {
            return res.redirect('/user');
          }
        });
      }
    });
  });

  app.post('/inscrire', function(req, res) {
    return users.save(req.body.username_inscrire, req.body.password_inscrire, req.body.name_inscrire, req.body.email_inscrire, function(err) {
      if (err) {
        return res.status(500).json(err);
      } else {
        req.session.loggedIn = true;
        req.session.username = req.body.username_inscrire;
        return res.redirect('/user');
      }
    });
  });

  app.post('/login', function(req, res) {
    var password, username;
    username = req.body.login;
    password = req.body.password;
    return users.get(username, function(err, data) {
      if (err) {
        res.status(200).send("Authentifacation failed (username introuvable en bdd)");
      }
      if (data.password !== password) {
        return res.redirect('/');
      } else {
        req.session.loggedIn = true;
        req.session.username = username;
        return res.redirect('/user');
      }
    });
  });

  app.post('/disconnect', function(req, res) {
    delete req.session.loggedIn;
    delete req.session.username;
    return res.redirect('/');
  });

  app.get('/session', function(req, res) {
    var logged, loguser;
    if (req.session.loggedIn === true) {
      logged = "LoggedIn = true";
      loguser = req.session.username;
    } else {
      logged = "LoggedIn = false";
    }
    return res.status(200).send(logged + '\n' + loguser);
  });

  app.post('/delete_metrics', function(req, res) {
    return res.status(200).send(req.params);
  });

  app.listen(app.get('port'), function(req, res) {
    return console.log("Server started");
  });

}).call(this);
