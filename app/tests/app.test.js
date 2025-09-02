const request = require('supertest');
const db = require('../db');
const app = require('../index');

beforeAll(async () => {
  // Use in-memory DB
  process.env.NODE_ENV = 'test';
  await db.migrate.latest();
  await db.seed.run();
});

afterAll(async () => {
  await db.destroy(); // close DB connection
});

describe('API Endpoints', () => {
  test('GET / should return hello message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('Hello from Node.js API');
  });

  test('GET /users should return 5 or fewer users', async () => {
    const res = await request(app).get('/users');
    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBeLessThanOrEqual(5);
  });
});
