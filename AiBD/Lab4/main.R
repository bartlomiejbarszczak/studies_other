# NIE EDYTOWAĆ *****************************************************************
dsn_database <- "wbauer_adb_2023"   # Specify the name of  Database
dsn_hostname <- "pgsql-196447.vipserv.org"  # Specify host name
dsn_port <- "5432"                # Specify your port number.
dsn_uid <- "wbauer_adb"         # Specify your username.
dsn_pwd <- "adb2020"        # Specify your password.

library(DBI)
library(RPostgres)
library(testthat)

con <- dbConnect(Postgres(), dbname = dsn_database, host = dsn_hostname, port = dsn_port, user = dsn_uid, password = dsn_pwd)
# ******************************************************************************


film_in_category <- function(category_id) {
  # Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego id kategorii.
  # Przykład wynikowej tabeli:
  # |   |title          |language    |category|
  # |0	|Amadeus Holy	|English	|Action|
  #
  # Tabela wynikowa ma być posortowana po tylule filmu i języku.
  #
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL
  #
  # Parameters:
  # category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  #
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  #

  if (is.character(category_id))
    return(NULL)
  category_id <- as.double(category_id)
  if (!is.integer(category_id) && category_id %% 1 != 0)
    return(NULL)

  value <- toString(category_id)

  query1 <-
    "SELECT
      f.title as title, ln.name as language, ct.name as category
    FROM
      category ct
    LEFT JOIN
      film_category fct
      ON
        ct.category_id = fct.category_id
    LEFT JOIN
      film f
      ON
        fct.film_id = f.film_id
    LEFT JOIN
      language ln
      ON
        f.language_id = ln.language_id
    WHERE
      ct.category_id = '"

  query2 <- "'
    GROUP BY
      f.title, ln.name, ct.name
    ORDER BY
      f.title, ln.name
    "
  query <- paste(query1, value, query2)
  result <- dbGetQuery(con, query)

  return(result)
}


number_films_in_category <- function(category_id) {
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów w zadanej kategori przez id kategorii.
  #     Przykład wynikowej tabeli:
  #     |   |category   |count|
  #     |0	|Action 	|64	  |
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  #
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(category_id))
    return(NULL)
  category_id <- as.double(category_id)
  if (!is.integer(category_id) && category_id %% 1 != 0)
    return(NULL)

  value <- toString(category_id)

  query1 <-
    "SELECT
      ct.name as category, COUNT (ct.name) as count
    FROM
      category ct
    LEFT JOIN
      film_category fct
      ON
        ct.category_id = fct.category_id
    LEFT JOIN
      film f
      ON
        fct.film_id = f.film_id
    WHERE
      ct.category_id = '"

  query2 <- "'
    GROUP BY
      ct.name
    "

  query <- paste(query1, value, query2)
  result <- dbGetQuery(con, query)

  return(result)
}


number_film_by_length <- function(min_length, max_length) {
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów dla poszczegulnych długości pomiędzy wartościami min_length a max_length.
  #     Przykład wynikowej tabeli:
  #     |   |length     |count|
  #     |0	|46 	    |64	  |
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     min_length (int,double): wartość minimalnej długości filmu
  #     max_length (int,double): wartość maksymalnej długości filmu
  #
  #     Returns:
  #     pd.DataFrame: DataFrame zawierający wyniki zapytania

  if (is.character(min_length))
    return(NULL)
  min_length <- toString(min_length)

  if (is.character(max_length))
    return(NULL)
  max_length <- toString(max_length)

  query1 <- "
  SELECT
    length, COUNT (length) as count
  FROM
    film
  WHERE
    length BETWEEN '"
  query2 <- "
    ' AND '"
  query3 <- "'
  GROUP BY
    length
  "
  query <- paste(query1, min_length, query2, max_length, query3)
  result <- dbGetQuery(con, query)

  if (nrow(result) == 0)
    return(NULL)

  return(result)
}


client_from_city <- function(city) {
  #   Funkcja zwracająca wynik zapytania do bazy o listę klientów z zadanego miasta przez wartość city.
  #     Przykład wynikowej tabeli:
  #     |   |city	    |first_name	|last_name
  #     |0	|Athenai	|Linda	    |Williams
  #
  #     Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     city (character): nazwa miaste dla którego mamy sporządzić listę klientów
  #
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.character(city))
    return(NULL)
  city <- gsub(" ", "", city)

  query1 <- "
  SELECT
    ct.city as city, cs.first_name as first_name, cs.last_name as last_name
  FROM
    city ct
  LEFT JOIN
    address ad
    ON
      ct.city_id = ad.city_id
  LEFT JOIN
    customer cs
    ON
      ad.address_id = cs.address_id
  WHERE
    ct.city = '"

  query2 <- "'
  "
  query <- paste0(query1, city, query2)
  result <- dbGetQuery(con, query)


  return(result)
}


avg_amount_by_length <- function(length) {
  #   Funkcja zwracająca wynik zapytania do bazy o średnią wartość wypożyczenia filmów dla zadanej długości length.
  #     Przykład wynikowej tabeli:
  #     |   |length |avg
  #     |0	|48	    |4.295389
  #
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     length (integer,double): długość filmu dla którego mamy pożyczyć średnią wartość wypożyczonych filmów
  #
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(length))
    return(NULL)
  length <- toString(length)

  query1 <- "
  SELECT
    f.length, AVG(pm.amount)
  FROM
    film f
  LEFT JOIN
    inventory iv
    ON
      f.film_id = iv.film_id
  LEFT JOIN
    rental rt
    ON
      iv.inventory_id = rt.inventory_id
  LEFT JOIN
    payment pm
    ON
      rt.rental_id = pm.rental_id
  WHERE
    f.length = '
  "
  query2 <- "'
  GROUP BY
    f.length
  "
  query <- paste0(query1, length, query2)
  result <- dbGetQuery(con, query)

  return(result)

}


client_by_sum_length <- function(sum_min) {
  #   Funkcja zwracająca wynik zapytania do bazy o sumaryczny czas wypożyczonych filmów przez klientów powyżej zadanej wartości .
  #     Przykład wynikowej tabeli:
  #     |   |first_name |last_name  |sum
  #     |0  |Brian	    |Wyman  	|1265
  #
  #     Tabela wynikowa powinna być posortowane według sumy, imienia i nazwiska klienta.
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     sum_min (integer,double): minimalna wartość sumy długości wypożyczonych filmów którą musi spełniać klient
  #
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (is.character(sum_min))
    return(NULL)
  sum_min <- toString(sum_min)

  query1 <- "
  SELECT
    cs.first_name, cs.last_name, SUM(f.length) as sum
  FROM
    film f
  JOIN
    inventory iv
    ON
      f.film_id = iv.film_id
  JOIN
    rental rn
    ON
      iv.inventory_id = rn.inventory_id
  JOIN
    customer cs
    ON
      rn.customer_id = cs.customer_id
  GROUP BY
    cs.last_name, cs.first_name
  HAVING
    SUM(f.length) >= '
  "
  query2 <- "'
  ORDER BY
    SUM(f.length), cs.last_name, cs.first_name
  "
  query <- paste0(query1, sum_min, query2)
  result <- dbGetQuery(con, query)

  return(result)
}


category_statistic_length <- function(name) {
  #   Funkcja zwracająca wynik zapytania do bazy o statystykę długości filmów w kategorii o zadanej nazwie.
  #     Przykład wynikowej tabeli:
  #     |   |category   |avg    |sum    |min    |max
  #     |0	|Action 	|111.60 |7143   |47 	|185
  #
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #
  #     Parameters:
  #     name (character): Nazwa kategorii dla której ma zostać wypisana statystyka
  #
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania

  if (!is.character(name))
    return(NULL)
  name <- toString(name)
  name <- gsub(" ", "", name)

  query1 <- "
  SELECT
    ct.name as category, AVG(f.length) as avg, SUM(f.length) as sum, MIN(f.length) as min, MAX(f.length) as max
  FROM
    category ct
  LEFT JOIN
    film_category fct
    ON
      ct.category_id = fct.category_id
  LEFT JOIN
    film f
    ON
      fct.film_id = f.film_id
  WHERE
    ct.name = '"

  query2 <- "'
  GROUP BY
    ct.name
  "

  query <- paste0(query1, name, query2)
  result <- dbGetQuery(con, query)

  return(result)
}


# NIE EDYTOWAĆ *****************************************************************
test_dir('tests/testthat')
# ******************************************************************************


# Zadanie 1
query <- "
SELECT
  length, title
FROM
  film
ORDER BY
  length
"
result <- dbGetQuery(con, query)
result

# Zadanie 2
query <- "
SELECT
  cs.first_name, cs.last_name, ct.city
FROM
  customer cs
LEFT JOIN
  address ad
  ON
    cs.address_id = ad.address_id
LEFT JOIN
  city ct
  ON
    ad.city_id = ct.city_id
ORDER BY
  ct.city
"
result <- dbGetQuery(con, query)
result

# Zadanie 3
query <- "
SELECT
 AVG(amount)
FROM
  payment
"
result <- dbGetQuery(con, query)
result

# Zadanie 4
query <- "
SELECT
  DISTINCT (ct.name) as category, COUNT(f.title)
FROM
  category ct
LEFT JOIN
  film_category fct
  ON
    ct.category_id = fct.category_id
LEFT JOIN
  film f
  ON
    fct.film_id = f.film_id
GROUP BY
  ct.name
"
result <- dbGetQuery(con, query)
result

# Zadanie 5
query <- "
SELECT
  DISTINCT (cn.country), COUNT (cs.first_name)
FROM
  customer cs
LEFT JOIN
  address ad
  ON
    cs.address_id = ad.address_id
LEFT JOIN
  city ct
  ON
    ad.city_id = ct.city_id
LEFT JOIN
  country cn
  ON
    ct.country_id = cn.country_id
GROUP BY
  cn.country
ORDER BY
  cn.country
"
result <- dbGetQuery(con, query)
# result

# Zadanie 6
query <- "
SELECT
  sf.first_name, sf.last_name, ad.address
FROM
  staff sf
JOIN
  store st
  ON
    sf.store_id = st.store_id
JOIN
  address ad
  ON
    st.address_id = ad.address_id
JOIN
  rental rn
  ON
    sf.staff_id = rn.staff_id
GROUP BY
  ad.address, sf.first_name, sf.last_name
HAVING
  COUNT(rn.customer_id) BETWEEN 100 AND 300
"
result <- dbGetQuery(con, query)
result

# Zadanie 7
query <- "
SELECT
  cs.first_name, cs.last_name, SUM(f.rental_duration)
FROM
  customer cs
JOIN
  rental rn
  ON
    cs.customer_id = rn.customer_id
JOIN
  inventory iv
  ON
    rn.inventory_id = iv.inventory_id
JOIN
  film f
  ON
    iv.film_id = f.film_id
GROUP BY
  cs.first_name, cs.last_name
HAVING
  SUM(f.rental_duration) >= '200'
ORDER BY
  cs.last_name
"
result <- dbGetQuery(con, query)
result

# Zadanie 8



# Zadanie 9
query <- "
SELECT
  DISTINCT (ct.name) as category, AVG(f.length)
FROM
  category ct
LEFT JOIN
  film_category fct
  ON
    ct.category_id = fct.category_id
LEFT JOIN
  film f
  ON
    fct.film_id = f.film_id
GROUP BY
  ct.name
"
result <- dbGetQuery(con, query)
result

# Zadanie 10
query <- "
SELECT
  DISTINCT (ct.name) as category, MAX(f.length)
FROM
  category ct
LEFT JOIN
  film_category fct
  ON
    ct.category_id = fct.category_id
LEFT JOIN
  film f
  ON
    fct.film_id = f.film_id
GROUP BY
  ct.name
"
result <- dbGetQuery(con, query)
result

# Zadanie 11
query <- "
SELECT
  MAX(nf.length)
FROM
  film nf
JOIN (
  SELECT
    MAX(f.length) as max_length
  FROM
    category ct
  LEFT JOIN
    film_category fct
    ON
      ct.category_id = fct.category_id
  LEFT JOIN
    film f
    ON
      fct.film_id = f.film_id
  GROUP BY
    ct.name) subquery
  ON
    nf.length = subquery.max_length
"
result <- dbGetQuery(con, query)
result


