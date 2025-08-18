const http = require('http');
const port = process.env.PORT || 3005;
const server = http.createServer((req, res) => {
  res.end('Hello from Jenkins CI/CD on Kubernetessss!\n');
});
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
