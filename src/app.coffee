met = [
    {
      timestamp: 3,
      value: 27
    }
]

express = require 'express'
jade = require 'jade'
metrics = require './metrics'
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

##app.get '/hello/:name'##


app.post 'metric/:id.json', (req,res) ->
  metric.save req.param.id req.body, (err) ->
    if err then res.status(500).json err
    res.status(200).send "Matrics saved"

app.use require('body-parser')()
app.get '/',(req,res) ->
  res.render 'index'
   #locals:
     #title: 'Test Page'

app.get '/metrics.json', (req, res) ->
  res.status(200).send metrics.get()

app.get '/hello/:name', (req, res) ->
  res.status(200).send req.params.name

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, met, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

 app.listen app.get('port'),(req,res) ->
  console.log "Server started"


### TO USE NODEMON on Windows
  node ./node_modules/nodemon/bin/nodemon
###
