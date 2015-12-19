express = require 'express'
jade = require 'jade'
#stylus = require 'stylus'
metrics = require './metrics'
users = require './users'
metrics_users = require './metrics_users'
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
   store: new LevelStore "#{__dirname}/../db/sessions"
   resave:true
   saveUnintialized:true

app.use require('body-parser')()

###
app.get '/', (req,res)->
  res.render 'index'

app.get '/user',(req,res) ->
  res.render 'user'
###
# -----------------------------------------

##Middleware authCheckHome : permet de renvoyer sur la page d'accueil sauf si le user est connecté alors il sera renvoyer sur sa page user
authCheckHome = (req,res,next) ->
  if req.session.loggedIn == true
    res.redirect '/user'
  else
    next()

#Renvoie sur la page d'accueil si user non connecté sinon sur la page du user
app.get '/',authCheckHome,(req,res) ->
  res.render 'index'

#Middleware authCheckUser : permet de renvoyer le user sur sa page user sinon sur la page d'accueil en fonction de son état (connecté ou non)
authCheckUser = (req,res,next) ->
  if req.session.loggedIn == undefined
    res.redirect '/'
  else
    next()

#Renvoie sur la page user si connecté sinon sur la page d'accueil (avec le middleware authCheckUser)
app.get '/user',authCheckUser,(req,res) ->
  res.render 'user'

#Renvoie le username du user connecté
app.get '/username.json', (req,res) ->
  res.status(200).json req.session.username

# -------------------------------------------

#Renvoie les objets users de la base de données
app.get '/users.json', (req,res) ->
  users.get "test", (err,data) ->
    if err then throw err
    res.status(200).send data

#Renvoie les metrics de la base de données
app.get '/metrics.json', (req, res) ->
  metrics.get 1, (err, data) ->
    res.status(200).send data

#Renvoie les concordances metrics/users de la base de données
app.get '/metrics_users.json', (req,res) ->
  if req.session.loggedIn == undefined
    res.status(200).send "Non loggé"
  else
    metrics_users.get req.session.username, (err,data) ->
      res.status(200).send data
    #res.status(200).send req.session.username

#Renvoie les numeros de batch metrics de l'user
app.get '/batchbyuser.json',(req,res) ->
  if req.session.loggedIn == undefined
    res.status(200).send "Non loggé"
  else
    tab = []
    i=0
    metrics_users.get req.session.username, (err,data) ->
        for mu in data
          tab[i] = mu.id_batch
          i++
        res.status(200).send tab

#Renvoie les metrics propres à chaque user
app.get '/metricsbyuser.json', (req,res) ->
  if req.session.loggedIn == undefined
    res.status(200).send "Non loggé"
  else
    tab = []
    i=0
    metrics_users.get req.session.username, (err,data) ->
      metrics.get 1, (err,met) ->
        for mu in data
          for m in met
            if mu.id_batch == m.id_batch
              tab[i] = m
              i++
        res.status(200).send tab


#Post de metrics (save en bdd)
app.post '/metric/save.json', (req, res) ->
  met=[
    timestamp: req.body.timestamp,
    value: req.body.value
  ]
  metrics.save req.body.id_batch,req.body.id_metric, met, (err) ->
    if err then res.status(500).json err
    else
      metrics_users.save req.session.username, req.body.id_batch, (err) ->
        if err then res.status(500).json err
        #else res.status(200).send "Metrics_users saved"
        else res.redirect '/user'


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
  users.get username, (err, data) ->
    if err
      res.status(200).send "Authentifacation failed (username introuvable en bdd)"
    unless data.password == password
      res.redirect '/'
    else
      req.session.loggedIn = true
      req.session.username = username
      res.redirect '/user'

#Déconnexion (suppression de la session en cours)
app.post '/disconnect', (req,res) ->
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/'

#Tester si session existe (TEST)
app.get '/session', (req,res) ->
  if req.session.loggedIn == true
    logged = "LoggedIn = true"
    loguser = req.session.username
  else
    logged = "LoggedIn = false"
  res.status(200).send logged + '\n' + loguser

#Supprimer une metric user (non fonctionnelle pour le moment)
app.post '/delete_metrics',(req,res) ->
  res.status(200).send req.params

#Ecouter sur le port n°1889 (defini en param)
app.listen app.get('port'),(req,res) ->
  console.log "Server started"
