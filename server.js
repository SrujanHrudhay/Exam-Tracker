// Exam Tracker - tiny local server. No npm install needed.
// Run:  node server.js   then open http://localhost:3000
const http = require('http'), fs = require('fs'), path = require('path');
const PORT = process.env.PORT || 3000;
const ROOT = __dirname, DATA = path.join(ROOT, 'data.json');
const TYPES = { '.html':'text/html; charset=utf-8', '.js':'text/javascript', '.css':'text/css',
  '.json':'application/json', '.woff2':'font/woff2', '.svg':'image/svg+xml' };

// Auto-stop: exits when the app window is closed (page says bye) or stops pinging.
let lastPing = Date.now(), byeAt = 0;
const quit = () => { console.log('Window closed - stopping server.'); process.exit(0); };
setInterval(() => { if (Date.now() - lastPing > 150000) quit(); }, 5000);

http.createServer((req, res) => {
  const url = decodeURIComponent(req.url.split('?')[0]);

  if (url === '/api/ping') { lastPing = Date.now(); return res.end('ok'); }
  if (url === '/api/bye') {
    byeAt = Date.now(); res.end('ok');
    return void setTimeout(() => { if (lastPing < byeAt) quit(); }, 4000); // grace for page reloads
  }

  if (url === '/api/data') {
    if (req.method === 'GET') {
      res.setHeader('Content-Type', 'application/json');
      return res.end(fs.existsSync(DATA) ? fs.readFileSync(DATA) : '{"items":null}');
    }
    if (req.method === 'PUT' || req.method === 'POST') {
      let body = '';
      req.on('data', c => { body += c; if (body.length > 5e6) req.destroy(); });
      req.on('end', () => {
        try {
          const parsed = JSON.parse(body);
          if (!Array.isArray(parsed.items)) throw new Error('bad data');
          fs.writeFileSync(DATA + '.tmp', JSON.stringify(parsed, null, 2));
          fs.renameSync(DATA + '.tmp', DATA);
          res.end('{"ok":true}');
        } catch (e) { res.statusCode = 400; res.end('{"ok":false}'); }
      });
      return;
    }
  }

  const file = path.join(ROOT, url === '/' ? 'index.html' : url);
  if (!file.startsWith(ROOT + path.sep) || path.basename(file) === 'server.js' ||
      !fs.existsSync(file) || !fs.statSync(file).isFile()) { res.statusCode = 404; return res.end('Not found'); }
  res.setHeader('Content-Type', TYPES[path.extname(file)] || 'application/octet-stream');
  fs.createReadStream(file).pipe(res);
}).listen(PORT, '127.0.0.1', () => console.log('Exam Tracker running at http://localhost:' + PORT));
