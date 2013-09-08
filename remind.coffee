mongo = require 'mongodb'
express = require 'express'
engines = require 'consolidate'
Twitter = require 'ntwitter'

app = express()

app.configure 'development', ->
  app.use express.logger('dev')
  app.use express.errorHandler()
  app.set 'mongoUri', 'mongodb://localhost/twine-remind'

app.configure 'production', ->
  app.enable 'trust proxy'
  app.set 'mongoUri', process.env.MONGOLAB_URI or process.env.MONGOHQ_URL

app.configure ->
  app.set 'port', 4134
  app.set 'view engine', 'html'
  app.engine 'html', engines.eco
  app.use express.bodyParser()

mongo.Db.connect app.get('mongoUri'), (err, db) ->
  reminders = db.collection 'reminders'

  app.get '/', (req, res) ->
    res.send 'twine-remind'

  app.post '/', (req, res) ->
    res.jsonp req.body

app.listen app.get('port'), ->
  console.log "Server started on port #{app.get 'port'} in #{app.settings.env} mode."
