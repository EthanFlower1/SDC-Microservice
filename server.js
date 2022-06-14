const express = require('express');
const app = express();
const port = 3000;
const path = require('path');
const reviewRouter = require('./routes');
require('dotenv').config();

app.use('/loaderio-c61a5a16f43554d40c649ca3a82facc7.txt', (req, res) => {
  res.send("./loaderio-c61a5a16f43554d40c649ca3a82facc7.txt")
})
app.use('/reviews', reviewRouter)

app.listen(port, () =>
  console.log(`Example app listening at http://localhost:${port}`)
);
