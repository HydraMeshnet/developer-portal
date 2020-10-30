const express = require('express');
const path = require('path');
const fs = require('fs');
const port = process.env.PORT || 3000;
const app = express();

// serve static assets normally
app.use(express.static('static', {}));

// handle every other route with index.html, which will contain
// a script tag to your application's JavaScript file(s).
app.get('*', function (request, response) {
  let file;
  if(request.url.endsWith('.md')) {
    file = request.url.substr(1);
    if(!fs.existsSync(file)) {
      file = '_404.md';
    }
  }
  else {
    file = 'index.html';
  }

  response.sendFile(path.resolve(__dirname, file));
});

app.listen(port);
console.log("server started on port " + port);