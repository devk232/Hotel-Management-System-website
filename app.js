const express = require('express');
const expressLayouts = require('express-ejs-layouts');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();

app.use(expressLayouts);
app.set('view engine', 'ejs');

app.use(express.static('public'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }))

app.use(session({
  secret: 'seCReT',
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 600000 }
}));

app.use('/', require('./routes/index.js'));

app.use('/users', require('./routes/users.js'));

app.get('*', (req, res) => {
  res.status(404);
  res.render('404');
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, console.log(`Server started on port ${PORT}`));
