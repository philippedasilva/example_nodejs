express = require 'express'
jade = require 'jade'
#stylus = require 'stylus'
metrics = require './metrics'
users = require './users'
#morgan = require 'morgan'
session = require 'express-session'
LevelStore = require('level-session-store')(session)

app = express()

app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"
###
app.use stylus.static
  src: "#{__dirname}/../public/css"
  compress: true
###
app.use session
   secret: 'Sec'
   store: new LevelStore './db/sessions'
   resave:true
   saveUnintialized:true

###
app.use morgan 'dev'

app.get '/myroute',middleware, (req,res) ->
  #route logic
router = express.Router()
router.get '/users', (req,res) ->
app.use '/api',router
###

###
app.use stylus.middleware(
  src: __dirname + '/../public'
  dest: __dirname + '/../public'
  debug: true
  force: true)
###

app.use require('body-parser')()

app.get '/', (req,res)->
  res.render 'index'

app.get '/user',(req,res) ->
  res.render 'user'


# -----------------------------------------

#Si user loggé alors on le renvoie sur page user sinon page daccueil
authCheckUser = (req,res,next) ->
  unless req.session.loggedIn == false
    res.redirect '/'
  else
    next()
#Si user non loggé alors renvoie sur page daccueil sinon page user (inverse)
authCheckHome = (req,res,next) ->
  unless req.session.loggedIn == true
    res.redirect '/user'
  else
    next()

app.get '/user',authCheckUser,(req,res) ->
  res.render 'user', name:req.session.username

app.get '/',authCheckHome,(req,res) ->
  res.render 'index'

# -------------------------------------------

app.get '/metrics.json', (req, res) ->
  metrics.get 1, (err, data) ->
    res.status(200).json data[0]

app.get '/users.json', (req,res) ->
  users.get "root", (err,data) ->
    if err then throw err
    res.status(200).json data

app.post '/metric/save.json', (req, res) ->
  met=[
    timestamp: req.body.timestamp,
    value: req.body.value
  ]

  metrics.save req.body.id, met, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

#Inscription d'un user
app.post '/inscrire', (req,res) ->
  users.save req.body.username_inscrire,req.body.password_inscrire,req.body.name_inscrire,req.body.email_inscrire, (err) ->
      if err then res.status(500).json err
      else
        req.session.loggedIn = true
        req.session.username = req.body.username_inscrire
        res.redirect '/user'

#Login User
app.post '/login', (req,res) ->
  username = req.body.login
  password = req.body.password
  users.get username, (err,data) ->
    if err
      res.status(200).send "Authentifacation failed (username introuvable en bdd)"
    unless data.password == password
      res.redirect '/'
    else
      req.session.loggedIn = true
      req.session.username = data.username
      res.redirect '/user'

#Deconnexion (suppression de la session en cours)
app.post '/disconnect', (req,res) ->
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/'

#Tester si session exist
app.get '/session', (req,res) ->
  if req.session.loggedIn == true
    logged = "LoggedIn = true"
  else
    logged = "LoggedOut = false"
  loguser = req.session.username
  res.status(200).send logged + '\n' + loguser

#Ecouter sur le port n°1889 (defini en param)
app.listen app.get('port'),(req,res) ->
  console.log "Server started"
