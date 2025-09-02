const express = require('express');
require('dotenv').config();
const fs = require('fs');
const db = require('./db'); // import the centralized Knex instance

const app = express();
app.use(express.json());

// Run migrations + seeds at startup (with retry)
async function runMigrationsWithRetry(retries = 10, delay = 10000) {
  for (let i = 0; i < retries; i++) {
    try {
      console.log('Running migrations...');
      await db.migrate.latest();
      console.log('Running seeds...');
      await db.seed.run();
      console.log('✅ Migrations & seeds applied');
      break;
    } catch (err) {
      console.error(`Migration failed, retrying in ${delay/1000}s`, err.message);
      await new Promise(res => setTimeout(res, delay));
    }
  }
}

// Initialize DB
runMigrationsWithRetry(10, 5000);

app.get('/', (req, res) => res.send('Hello from Node.js API 🚀'));

// GET first 5 users
app.get('/users', async (req, res) => {
  try {
    const rows = await db('users').select('*').limit(5);
    res.json(rows);
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).send('Database error');
  }
});

const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App running on port ${port}`));

module.exports = app;
