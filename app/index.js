const express = require('express');
const knexLib = require('knex');
require('dotenv').config();
const fs = require('fs');

const app = express();
app.use(express.json());

// Create Knex instance
const environment = process.env.NODE_ENV || 'development';
const knexConfig = require('./knexfile')[environment];
const knex = knexLib(knexConfig);

// Run migrations + seeds at startup (with retry)
async function runMigrationsWithRetry(retries = 10, delay = 10000) {
  for (let i = 0; i < retries; i++) {
    try {
      console.log('Running migrations...');
      await knex.migrate.latest();
      console.log('Running seeds...');
      await knex.seed.run();
      console.log('✅ Migrations & seeds applied');
      break;
    } catch (err) {
      console.error(`Migration failed, retrying in ${delay/5000}s`, err.message);
      await new Promise(res => setTimeout(res, delay));
    }
  }
}

// Initialize DB
runMigrationsWithRetry(10,5000);

app.get('/', (req, res) => res.send('Hello from Node.js API 🚀'));

// GET first 5 users
app.get('/users', async (req, res) => {
  try {
    const rows = await knex('users').select('*').limit(5);
    res.json(rows);
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).send('Database error');
  }
});

const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App running on port ${port}`));

module.exports = app;
