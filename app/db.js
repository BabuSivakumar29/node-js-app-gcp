// app/db.js
const knexLib = require('knex');
const knexConfig = require('./knexfile');

// Choose environment: 'development' or 'test' (set NODE_ENV=test in CI)
const environment = process.env.NODE_ENV || 'development';
const db = knexLib(knexConfig[environment]);

module.exports = db;
