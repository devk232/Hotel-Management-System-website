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
    res.redirect("/dashboard?logout+first");
  }
});

router.post("/register", (req, res) => {
  const { fname,lname ,email, mobile,  password, password2} = req.body;
  let errors = [];
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
        customer = rows[0];
      if (customer) {
        const result = bcrypt.compareSync(password, customer.password);
        if(result){
          console.log("sads");
          res.redirect(`dashboard/${customer.customer_id}`);
        }
        else{
          res.render('login');
        }
      } else {
        res.render('login', { error: "This EmailId does not exists" });
      }
    },
  )
});

// fetch dashboard coressponding to given user
router.get("/dashboard/:id", (req, res) => {
  if(!req.session.user){
    // let sql = `SELECT * FROM 
    //            hotels JOIN hotels_location
    //            using(hotel_id)
    //            JOIN 
    //            ORDER BY rating`;
    console.log("gy");
    // mySqlConnection.query(sql , (err , rows) => {
        // if(err)
        //   throw err;
        // else{
          mySqlConnection.query("SELECT * FROM customers WHERE customer_id = ?",[req.params.id], (err , result) => {
            if(err)
              throw err;
            else{
              customer = result[0];
              res.render('dashboard', {customer});
            }
          });
        // }     
    // });
  }
  else{
    res.status(401);
    res.redirect('/login');
  }
});

router.get("/logout", (req, res, next) => {
  if (req.session.user) {
    req.session.destroy(() => {
      res.status = 200;
      res.redirect('/login?logout+success');
    })
  } else {
    res.status(400);
    res.redirect('login');
  }
});


module.exports = router;