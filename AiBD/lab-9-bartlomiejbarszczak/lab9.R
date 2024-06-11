library(DBI)
library(RMySQL)

db_host <- "mysql.agh.edu.pl"
db_port <- 3306
db_user <- "bbarszcz"
db_password <- "CxMLCxbGA7r4aZob"
db_name <- "bbarszcz"


con <- dbConnect(
  RMySQL::MySQL(),
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_password,
  dbname = db_name
)


sql_statements <- c(
  "CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
  )",

  "CREATE TABLE hosts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
  )",

  "CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(2),
    name VARCHAR(255)
  )",

  "CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(id)
  )",

  "CREATE TABLE places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    host_id INT,
    address VARCHAR(255),
    city_id INT,
    FOREIGN KEY (host_id) REFERENCES hosts(id),
    FOREIGN KEY (city_id) REFERENCES cities(id)
  )",

  "CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    place_id INT,
    start_date DATE,
    end_date DATE,
    price_per_night DECIMAL(10, 2),
    num_nights INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (place_id) REFERENCES places(id)
  )",

  "CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    rating TINYINT,
    review_body TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
  )"
)

for (sql_statement in sql_statements) {
  dbExecute(con, sql_statement)
}

dbDisconnect(con)