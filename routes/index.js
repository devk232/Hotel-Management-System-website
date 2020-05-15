const express = require('express');
const fileUpload = require('express-fileupload');
const router = express.Router();
const session = require('express-session');

router.get('/', (req, res) => res.redirect('/users/register'));


router.get('/dashboard', (req, res) => {
  if (req.session.user){
    res.render('dashboard', {
      user: req.session.user,
    })}
  else
    res.redirect('/users/login?login+to+view');
});

module.exports = router;
