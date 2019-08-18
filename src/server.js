'use strict'

const express = require('express')
const config = require('../config')
const logic = require('./business-logic')

const app = express()

app.get('/version', (req, res) => {
  const response = logic.getResponse()
  res.send(response)
})

app.get('/ready', (req, res) => {
  res.send(200)
})

app.get('/health', (req, res) => {
  res.send(200)
})

app.listen(config.app.port, config.app.host)
console.log(`Running on http://${config.app.host}:${config.app.port}`)
