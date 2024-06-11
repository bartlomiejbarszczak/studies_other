library(DBI)
library(RPostgres)


dsn_database <- "wbauer_adb_2023"
dsn_hostname <- "pgsql-196447.vipserv.org"
dsn_port <- "5432"
dsn_uid <- "wbauer_adb"
dsn_pwd <- "adb2020"

con <- dbConnect(Postgres(), dbname = dsn_database, host=dsn_hostname, port=dsn_port, user=dsn_uid, password=dsn_pwd)


# ZADANIE 1
query <- paste("SELECT COUNT (DISTINCT category_id) FROM film_category")
result <- dbGetQuery(con, query)
result

# ZADANIE 2
query <- paste("SELECT DISTINCT name FROM category ORDER BY name ASC")
result <- dbGetQuery(con, query)
result

# ZADANIE 3
query <- paste("SELECT array_agg(DISTINCT title) AS titles, MIN(release_year) AS min, MAX(release_year) AS max FROM film ")
result <- dbGetQuery(con, query)
result

# ZADANIE 4
query <- paste("SELECT COUNT (rental_date) FROM rental WHERE rental_date >= '2005-07-01' AND rental_date < '2005-08-01'")
result <- dbGetQuery(con, query)
result

# ZADANIE 5
query <- paste("SELECT COUNT (rental_date) FROM rental WHERE rental_date >= '2010-01-01' AND rental_date < '2011-02-01'")
result <- dbGetQuery(con, query)
result

# ZADANIE 6
query <- paste("SELECT MAX(amount) FROM payment")
result <- dbGetQuery(con, query)
result

# Zadanie 7
query <- paste(
  "SELECT
    c.first_name, c.last_name, cn.country
  FROM
    customer c
  LEFT JOIN
    address a
    ON
      c.address_id = a.address_id
  LEFT JOIN
    city ct
    ON
      a.city_id = ct.city_id
  LEFT JOIN
    country cn
    ON
      ct.country_id = cn.country_id
  GROUP BY
    c.first_name, c.last_name,  cn.country
  HAVING
    cn.country = 'Poland' OR cn.country = 'Nigeria' OR cn.country = 'Bangladesh'
  ")
result <- dbGetQuery(con, query)
result

# Zadanie 8
query <- paste(
  "SELECT
    s.first_name, s.last_name, a.address, ct.city, cn.country
  FROM
    staff s
  LEFT JOIN
    address a
    ON
      s.address_id = a.address_id
  LEFT JOIN
    city ct
    ON
      a.city_id = ct.city_id
  LEFT JOIN
    country cn
    ON
      ct.country_id = cn.country_id
  GROUP BY
    s.first_name, s.last_name, a.address, ct.city, cn.country
  ")
result <- dbGetQuery(con, query)
result

# Zadanie 9
query <- paste(
  "SELECT
  COUNT
    (cn.country)
  FROM
    staff s
  LEFT JOIN
    address a
    ON
      s.address_id = a.address_id
  LEFT JOIN
    city ct
    ON
      a.city_id = ct.city_id
  LEFT JOIN
    country cn
    ON
      ct.country_id = cn.country_id
  GROUP BY
    cn.country
  HAVING
    cn.country = 'Spain' OR cn.country = 'Argentina'
  ")
result <- dbGetQuery(con, query)
result

# Zadanie 10
query <- paste("
  SELECT
  DISTINCT
    (cg.name)
  FROM
    category cg
  LEFT JOIN
    film_category fcg
    ON
      cg.category_id = fcg.category_id
  LEFT JOIN
    film f
    ON
      fcg.film_id = f.film_id
  LEFT JOIN
    inventory i
    ON
      f.film_id = i.film_id
  LEFT JOIN
    rental r
    ON
      i.inventory_id = r.inventory_id
  GROUP BY
    cg.name, r.rental_date
  HAVING
    r.rental_date > '2000-01-01'
")
result <- dbGetQuery(con, query)
result

# Zadanie 11
query <- paste("
  SELECT
  DISTINCT
    cg.name
  FROM
    category cg
  LEFT JOIN
    film_category fcg
    ON
      cg.category_id = fcg.category_id
  LEFT JOIN
    film f
    ON
      fcg.film_id = f.film_id
  LEFT JOIN
    inventory i
    ON
      f.film_id = i.film_id
  LEFT JOIN
    rental r
    ON
      i.inventory_id = r.inventory_id
  LEFT JOIN
    customer c
    ON
      r.customer_id = c.customer_id
  LEFT JOIN
    address a
    ON
      c.address_id = a.address_id
  LEFT JOIN
    city ct
    ON
      a.city_id = ct.city_id
  LEFT JOIN
    country cn
    ON
      ct.country_id = cn.country_id
  GROUP BY
    cg.name, r.rental_date, cn.country
  HAVING
    r.rental_date > '2000-01-01' AND cn.country = 'United States'
")
result <- dbGetQuery(con, query)
result

# Zadanie 12
query <- paste("
  SELECT
    f.title, at.first_name, at.last_name
  FROM
    film f
  LEFT JOIN
    film_actor fa
    ON
      f.film_id = fa.film_id
  LEFT JOIN
    actor at
    ON
      fa.actor_id = at.actor_id
  GROUP BY
    f.title, at.first_name, at.last_name
  HAVING
    (at.first_name = 'Olympia' AND at.last_name = 'Pfeiffer') OR (at.first_name = 'Julia' AND at.last_name = 'Zellweger') OR (at.first_name = 'Ellen' AND at.last_name = 'Presley')
")
result <- dbGetQuery(con, query)
result
