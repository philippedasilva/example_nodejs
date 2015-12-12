express = require 'express'
jade = require 'jade'
metrics = require './metrics'
users = require './users'
#morgan = require 'morgan'
#session = require 'express-session'
#LevelStore = require ('level-session-store')(session)

###
app.use session
   secret: 'Sec'
   store: new LevelStore './db/sessions'
   resave:true
   saveUnintialized:true
###

###
router = express.Router()
router.get '/users', (req,res) ->
app.use '/api',router
###

#stylus = require 'stylus'
app = express()

app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"

###
app.use stylus.static(
   src: "#{__dirname}/../public"
   compress: true
)
###

###
app.use stylus.middleware(
  src: __dirname + '/../public'
  dest: __dirname + '/../public'
  debug: true
  force: true)
###
###
app.use require('body-parser')()

app.get '/',(req,res) ->
 res.render 'index',
  locals:
    title: 'Test Page'
app.get 'metrics.xml', (req,res) ->

app.get 'metrics.json', (req,res) ->
  res.json metrics.get()
###

app.use require('body-parser')()

###
authCheck = (req,res,next) ->
  unless req.session.loggedIn == true
  res.redirect '/login'
  else
    next()


app.get '/',authCheck,(req,res) ->
  res.render 'index', name:req.session.username
###
app.get '/',(req,res) ->
  res.render 'index'
   #locals:
     #title: 'Test Page'

app.get '/metrics.json', (req, res) ->
  metrics.get 1, (err, data) ->
    res.status(200).json data[0]

app.get '/users.json', (req,res) ->
  users.get "root", (err,data) ->
    if err then throw err
    res.status(200).json data

 app.get '/user', (req,res) ->
   res.render 'user'

app.post '/metric/save.json', (req, res) ->
  met=[
    timestamp: req.body.timestamp,
    value: req.body.value
  ]

  metrics.save req.body.id, met, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.post '/login', (req,res) ->

  username = req.body.login
  password = req.body.password
  users.get username, (err,data) ->
    if err
      res.status(200).send "Authentifacation failed (username introuvable en bdd)"
    else
      if data.password == password
        res.status(200).send "Authentifacation réussie"
      else
        res.status(200).send "Authentifacation failed (password incorrect)"

app.post '/inscrire', (req,res) ->
  users.save req.body.username_inscrire,req.body.password_inscrire,req.body.name_inscrire,req.body.email_inscrire, (err) ->
      if err then res.status(500).json err
      else res.redirect '/user'

app.listen app.get('port'),(req,res) ->
  console.log "Server started"


### TO USE NODEMON on Windows
  node ./node_modules/nodemon/bin/nodemon
###
