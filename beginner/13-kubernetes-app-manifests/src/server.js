const express = require('express');

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(express.json());

// Temporary in-memory storage keeps the first version easy to run.
// We will replace this with PostgreSQL in a later step.
const todos = [];
let nextId = 1;

app.get('/healthz', (_req, res) => {
  res.json({ status: 'ok' });
});

app.get('/readyz', (_req, res) => {
  res.json({ status: 'ready' });
});

app.get('/todos', (_req, res) => {
  res.json(todos);
});

app.post('/todos', (req, res) => {
  const title = typeof req.body.title === 'string' ? req.body.title.trim() : '';
  if (!title) {
    return res.status(400).json({ error: 'title is required' });
  }

  const todo = { id: nextId++, title, completed: false };
  todos.push(todo);
  return res.status(201).json(todo);
});

app.get('/todos/:id', (req, res) => {
  const todo = todos.find((item) => item.id === Number(req.params.id));
  if (!todo) return res.status(404).json({ error: 'todo not found' });
  return res.json(todo);
});

app.put('/todos/:id', (req, res) => {
  const todo = todos.find((item) => item.id === Number(req.params.id));
  if (!todo) return res.status(404).json({ error: 'todo not found' });

  if (typeof req.body.title === 'string') {
    const title = req.body.title.trim();
    if (!title) return res.status(400).json({ error: 'title cannot be empty' });
    todo.title = title;
  }
  if (typeof req.body.completed === 'boolean') {
    todo.completed = req.body.completed;
  }
  return res.json(todo);
});

app.delete('/todos/:id', (req, res) => {
  const index = todos.findIndex((item) => item.id === Number(req.params.id));
  if (index === -1) return res.status(404).json({ error: 'todo not found' });
  todos.splice(index, 1);
  return res.status(204).end();
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Todo API listening on port ${port}`);
});
