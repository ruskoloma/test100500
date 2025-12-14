import http from "http";
import pkg from "pg";

const { Client } = pkg;
const port = 3000;

const baseConfig = {
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "postgres",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "postgres",
};

const server = http.createServer(async (req, res) => {
  res.setHeader("Content-Type", "text/plain");

  const path = req.url?.slice(1); // everything after "/"

  if (!path) {
    res.statusCode = 200;
    res.end(
      "Provide DB host IP in URL path.\nExample: http://localhost:3000/10.0.0.1"
    );
    return;
  }

  const client = new Client({
    ...baseConfig,
    host: path,
  });

  try {
    await client.connect();
    await client.query("SELECT 1");
    res.statusCode = 200;
    res.end(`Connection to DB at ${path} successful`);
  } catch (e) {
    console.error(e.message);
    res.statusCode = 500;
    res.end(`Connection to DB at ${path} failed`);
  } finally {
    await client.end().catch(() => {});
  }
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
