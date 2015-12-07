express = require 'express'
jade = require 'jade'
metrics = require './metrics'
users = require './users'

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
app.get '/',(req,res) ->
  res.render 'index'
   #locals:
     #title: 'Test Page'

app.get '/metrics.json', (req, res) ->
  res.status(200).json metrics.get()

app.get '/users.json', (req,res) ->
  res.status(200).json users.get()

 app.get '/user', (req,res) ->
   res.render 'user'

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, met, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.post '/', (req,res) ->
  if users.login(req.body.login,req.body.password)
    res.redirect '/user'
  else
    res.redirect '/'

 app.listen app.get('port'),(req,res) ->
  console.log "Server started"


### TO USE NODEMON on Windows
  node ./node_modules/nodemon/bin/nodemon
###
