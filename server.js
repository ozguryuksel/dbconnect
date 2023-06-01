const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const { Client } = require('pg');




const app = express();
const port = 3000;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: '03120312',
  port: 5432,
  schema: 'chat' // Şema adını burada belirtin
});
app.use(cors({
  origin: (origin, callback) => {
    if (origin === 'http://localhost:8080') {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  }
}));
app.listen(8080, () => {
  console.log('Server is listening on port 8080');
});

app.use(express.json());

// Örnek bir GET endpoint'i
app.get('/messages', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM chat.messages');
    const messages = result.rows;
    client.release();
    res.json(messages);
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).json({ error: 'An error occurred' });
  }
});

// Örnek bir POST endpoint'i
app.post('/messages', async (req, res) => {
  const { content } = req.body;

  try {
    const client = await pool.connect();
    await client.query('INSERT INTO chat.messages (content) VALUES ($1)', [content]);
    client.release();
    res.sendStatus(201);
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).json({ error: 'An error occurred' });
  }
});

app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
