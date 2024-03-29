const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const routes = require('./routes/api');
const path = require('path');
require('dotenv').config();

const cors = require('cors');

let corsOptions = {
  origin: process.env.WEB_ORIGIN || '*'
};

let app = express();
app.use(cors(corsOptions));
app.disable("x-powered-by");

const port = process.env.PORT || 5001;

//connect to the database
// mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true })
mongoose.connect(process.env.DB, { useNewUrlParser: true,
  // useUnifiedTopology: true,
  maxIdleTimeMS: 80000,
  socketTimeoutMS: 0,
  connectTimeoutMS: 0 })
.then(() => console.log(`Database connected successfully`))
.catch(err => console.log(err));

//since mongoose promise is depreciated, we overide it with node's promise
mongoose.Promise = global.Promise;

app.use((_req, res, next) => {

res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use(bodyParser.json());

app.use('/api', routes);

app.use((err, _req, _res, next) => {
console.log(err);
next();
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});