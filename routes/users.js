const express = require("express");
const fileUpload = require('express-fileupload');
const router = express.Router();
const bcrypt = require("bcryptjs");
const mySqlConnection = require("../db/db");


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
        var values = [[fname, lname, email,mobile,pwdHash]];
        mySqlConnection.query(sql, [values], err => {
          if (err) {
            res.status = 500;
            res.send(err);
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
      if (err) res.status(500).send(err);
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
  console.log(req.session.user)
  if(!req.session.user){
    let sql =  `SELECT * FROM 
    hotels JOIN hotels_location
    using(hotel_id)
    JOIN  hotels_contact
    using(hotel_id)
    JOIN hotel_images
    using(hotel_id)
    JOIN rooms using(hotel_id)
    JOIN rooms_category
    using(room_category_id)
    WHERE rooms.unit_price = (SELECT MIN(unit_price) FROM  rooms where hotel_id = hotels.hotel_id)
    ORDER BY rating DESC;`;
    mySqlConnection.query(sql , (err , rows) => {
        if(err){
          throw err;
        }
        else{
          mySqlConnection.query(
          "SELECT * FROM customers WHERE customer_id = ?"
          ,[req.params.id], 
          (err , result) => {
            if(err)
              throw err;
            else{
              customer = result[0];
              res.render('dashboard', {customer, rows: rows});
            }
          });
        }     
    });
  }
  else{
    res.status(401);
    res.redirect('login');
  }
});
// different type of queries to be performed``
// sort by price, rating, popularity, searchbar(REGXP), room_type , no of rooms available etc.

// get request on profile page
router.get("/profile/:id" , (req , res) => {
  if(!req.session.user){
    mySqlConnection.query(
      "SELECT * FROM customers WHERE customer_id = ?"
      ,[req.params.id], 
      (err , result) => {
        if(err)
          throw err;
        else{
          customer = result[0];
          mySqlConnection.query(
          `SELECT * FROM customers WHERE customer_id = ?
           LEFT JOIN bookings
           using(customer_id)
           LEFT JOIN booking_items
           using(booking_id)`,
           [req.params.id],
          (err,rows) =>{
              if(err){
                throw err;
              }
              else{
                let bookings = rows;
                res.render('profile', {customer, bookings : bookings});
              }
          });
        }
      });
    }
  else{
    res.status(400);
    res.redirect('login');
  }
});

// fetch hotel page
router.get('/hotel/:id1/:id2' , (req, res) => {
  if(!req.session.user){
    mySqlConnection.query(
      `SELECT * FROM HOTELS WHERE hotel_id = ?
       JOIN hotels_ contact
       using(hotel_id)
       JOIN hotel_address 
       using(hotel_id)
       JOIN rooms 
       using(hotel_id)
       JOIN rooms_category
       using(room_type_id)`,
       [req.params.id1],
       (err, rows) => {
          if(err){
            throw err;
          }
          else{
            mySqlConnection.query(
              `SELECT * FROM customers 
              WHERE customer_id = ?`,
              [req.params.id2],
              (err, result) => {
                  if(err){
                    throw err;
                  }
                  else{
                    customer = result[0];
                    res.render('hotelpage',{customer, rows: rows});
                  }
              });
          }
      });
  }
  else{
    res.redirect('/login');
  }
});

// post request on hotels page
router.post('/hotel/:id1/:id2', (req , res) => {
  if(!req.session.user){
    const{start_time , end_time, room_category, quantity} = req.body;
    let errors1 = [];
    if(end_time <= start_time)
      errors1.push({msg: 'Please enter valid dates'});

    mySqlConnection.query(
      `SELECT * FROM rooms
        JOIN rooms_category
        using(room_category_id)
        WHERE rooms.hotel_id = ? AND rooms_category.room_category = ${room_category}`
      [req.params.id1], 
      (err, result) => {
        if(err){
          throw err;
        }
        else{
          if(result[0].availble_quantity > quantity){
            errors1.push({msg: 'Please enter valid number of rooms'});
          }
          if (errors.length > 0){
            res.render('hotelpage', {errors});
          }
          else{
            var query = `INSERT INTO bookings(hotel_id,customer_id,start_time,end_time) VALUES ?`;
            var values = [[req.params.id1, req.params.id2,start_time,end_time]];
            mySqlConnection.query(query, [values], (err) => {
              if(err){
                throw err;
              }
              else{
                var query = `INSERT INTO booking_items(booking_id, room_category_id, quantity) VALUES ?`;
                var values = [[]];
                mySqlConnection.query(query, [values], (err) => {
                  if(err){
                    throw err;
                  }
                  else{
                    var query = ``;
                    var values = [[]];
                    mySqlConnection.query(query,[values], (err) =>{
                      if(err){
                        throw err;
                      }
                      else{
                         var query = ``;
                         mySqlConnection.query(query, (err,result) => {
                          if(err){
                            throw err;
                          }
                          else{
                            order = result[0];
                            res.render('suceess', {order});
                          }
                         });
                      }
                    });
                  }
                });
              }
            });
          }
        }
      });
  }
  else{
    res.redirect('/login');
  }
});


// logout 
router.get("/logout", (req, res, next) => {
  if (req.session.user) {
    req.session.destroy(() => {
      res.status = 200;
      res.redirect('/register?logout+success');
    })
  } else {
    res.status(400);
    res.redirect('login');
  }
});


module.exports = router;

