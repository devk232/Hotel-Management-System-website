const express = require("express")
const router = express.Router()
const bcrypt = require("bcryptjs")
const mySqlConnection = require("../db/db")


router.get("/register", (req, res) => {
  if (!req.session.user) {
    res.statusCode = 200
    res.render("register")
  } else {
    res.status = 401;
    res.redirect("/dashboard?logout+first")
  }
});

router.post("/register", (req, res) => {
  const { fname,lname ,email, mobile,  password, password2} = req.body
  let errors = []
  if (password != password2) {
    errors.push({ msg: "Passwords do not match" })
  }
  if (password.length < 6) {
    errors.push({ msg: "Password must be at least 6 characters" })
  }
  mySqlConnection.query(
    "SELECT * FROM customers WHERE email = ?",
    [email],
    (err, rows) => {
      if (err){
        res.status = 500;
        res.send(err);
      }
      if (rows.length)
         errors.push({ msg: "Email already exists" })
      if (errors.length > 0) {
        res.render('register', {errors, fname, lname, email, mobile})
      } else {
        pwdHash = bcrypt.hashSync(password, 10);
        var sql = `INSERT INTO customers (first_name, last_name,email,mobile_number, password) VALUES ?`
        const values = [[fname, lname, email,mobile,pwdHash]]
        mySqlConnection.query(sql, [values], err => {
          if (err) {
            res.status = 500
            res.send(err)
          }
        })
        res.render("login", {msg: "Registered successfully"})
      }
    },
  )
});

router.get("/login", (req, res) => {
  if (!req.session.user) {
    res.statusCode = 200
    res.render("login")
  } else {
    res.status = 401
    res.redirect("/dashboard?logout+first")
  }
});

router.post("/login", (req, res) => {
  const {email, password} = req.body
  mySqlConnection.query(
    "SELECT * FROM customers WHERE email = ?",
    [email],
    (err, rows) => {
      if (err) res.status(500).send(err)
      user = rows[0];
      if (user) {
        const result = bcrypt.compareSync(password, user.password);
        if(result){
          res.render('dashboard');
        }
        else{
          res.render('login');
        }
      } else {
        res.render('login', { error: "Username does not exist" });
      }
    },
  )
});

router.get("/dashboard", (req, res) => {
  res.render('dashboard');
  
});

router.get("/logout", (req, res, next) => {
  if (req.session.user) {
    req.session.destroy(() => {
      res.status = 200;
      res.redirect('/users/login?logout+success');
    })
  } else {
    res.status(400);
    res.redirect('login');
  }
});


module.exports = router;