const mysql = require('mysql');

const mySqlConnection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "123456",
  database: "website",
});

mySqlConnection.connect((err) => {
  if (err) throw err;
  console.log("Database Connected!");
});

module.exports = mySqlConnection;

