# NIE EDYTOWAĆ *****************************************************************
dsn_database = "wbauer_adb_2023"   # Specify the name of  Database
dsn_hostname = "pgsql-196447.vipserv.org"  # Specify host name 
dsn_port = "5432"                # Specify your port number. 
dsn_uid = "wbauer_adb"         # Specify your username. 
dsn_pwd = "adb2020"        # Specify your password.

library(DBI)
library(RPostgres)
library(testthat)

con <- dbConnect(Postgres(), dbname = dsn_database, host=dsn_hostname, port=dsn_port, user=dsn_uid, password=dsn_pwd)
# ******************************************************************************

film_in_category <- function(category)
{
  # Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego:
  #     - id: jeżeli categry jest integer
  #     - name: jeżeli category jest character, dokładnie taki jak podana wartość
  # Przykład wynikowej tabeli:
  # |   |title          |languge    |category|
  # |0	|Amadeus Holy	|English	|Action|
  # 
  # Tabela wynikowa ma być posortowana po tylule filmu i języku.
  # 
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  # 
  # Parameters:
  # category (integer,character): wartość kategorii po id (jeżeli typ integer) lub nazwie (jeżeli typ character)  dla którego wykonujemy zapytanie
  # 
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania

  if (is.numeric(category) && category %% 1 == 0)
    category <- as.integer(category)
  else if (is.character(category))
    category <- gsub(" ", "", category)
  else
    return(NULL)


  if (is.integer(category))
    choice <- paste0(" ct.category_id = '", toString(category), "' ")
  else if (is.character(category))
    choice <- paste0(" ct.name LIKE '", category, "' ")


  query1 <- "
  SELECT
    f.title as title, ln.name as languge, ct.name as category
  FROM
    category ct
  JOIN
    film_category fct
    ON
      ct.category_id = fct.category_id
  JOIN
    film f
    ON
      fct.film_id = f.film_id
  JOIN
    language ln
    ON
      f.language_id = ln.language_id
  WHERE"

  query2 <- "
  GROUP BY
    f.title, ln.name, ct.name
  ORDER BY
    f.title, ln.name
  "
  query <- paste0(query1, choice, query2)
  result <- dbGetQuery(con, query)
  return(result)
}


film_in_category_case_insensitive <- function(category)
{
  #  Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego:
  #     - id: jeżeli categry jest integer
  #     - name: jeżeli category jest character
  #  Przykład wynikowej tabeli:
  #     |   |title          |languge    |category|
  #     |0	|Amadeus Holy	|English	|Action|
  #     
  #   Tabela wynikowa ma być posortowana po tylule filmu i języku.
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.

  #   Parameters:
  #   category (integer,str): wartość kategorii po id (jeżeli typ integer) lub nazwie (jeżeli typ character)  dla którego wykonujemy zapytanie
  #
  #   Returns:
  #   DataFrame: DataFrame zawierający wyniki zapytania

  if (is.integer(category))
    category <- as.integer(category)
  else if (is.character(category))
    category <- gsub(" ", "", category)
  else
    return(NULL)

  if (is.integer(category))
    choice <- paste0(" ct.category_id = '", toString(category), "' ")
  else if (is.character(category))
    choice <- paste0(" ct.name ILIKE '", category, "' ")


  query1 <- "
  SELECT
    f.title as title, ln.name as languge, ct.name as category
  FROM
    category ct
  JOIN
    film_category fct
    ON
      ct.category_id = fct.category_id
  JOIN
    film f
    ON
      fct.film_id = f.film_id
  JOIN
    language ln
    ON
      f.language_id = ln.language_id
  WHERE"

  query2 <- "
  GROUP BY
    f.title, ln.name, ct.name
  ORDER BY
    f.title, ln.name
  "
  query <- paste0(query1, choice, query2)
  result <- dbGetQuery(con, query)
  return(result)
}

film_cast <- function(title)
{
  # Funkcja zwracająca wynik zapytania do bazy o obsadę filmu o dokładnie zadanym tytule.
  # Przykład wynikowej tabeli:
  #     |   |first_name |last_name  |
  #     |0	|Greg       |Chaplin    | 
  #     
  # Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  # Parameters:
  # title (character): wartość id kategorii dla którego wykonujemy zapytanie
  #     
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.character(title))
    return(NULL)

  query1 <- "
    SELECT
      a.first_name, a.last_name
    FROM
      film f
    JOIN
      film_actor fa
      ON
        f.film_id = fa.film_id
    JOIN
      actor a
      ON
        fa.actor_id = a.actor_id
    WHERE "

  query2 <- paste0(" f.title LIKE '", title, "' ")

  query3 <- "
  GROUP BY
    a.first_name, a.last_name
  ORDER BY
    a.last_name, a.first_name
  "
  query <- paste0(query1, query2, query3)
  result <- dbGetQuery(con, query)

  return(result)
}


film_title_case_insensitive <- function(words)
{
  # Funkcja zwracająca wynik zapytania do bazy o tytuły filmów zawierających conajmniej jedno z podanych słów z listy words.
  # Przykład wynikowej tabeli:
  #     |   |title              |
  #     |0	|Crystal Breaking 	| 
  #     
  # Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  # 
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  # Parameters:
  # words(list[character]): wartość minimalnej długości filmu
  #     
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  #

  pattern <- NULL
  for (word in words) {
    if (!is.character(word))
      return(NULL)
    pattern <- paste0(pattern, "^", word, " | ", word, " | ", word, "$|")
  }
  pattern <- substring(pattern, 1, nchar(pattern) - 1)

  query <- paste0("SELECT title FROM film WHERE title ~* '", pattern, "' ORDER BY title")
  resutl <- dbGetQuery(con, query)
  return(resutl)
}


# NIE EDYTOWAĆ *****************************************************************
test_dir('tests/testthat')
# ******************************************************************************


# Zadanie 1
query <- "SELECT country FROM country WHERE country ~* '^P' ORDER BY country"
result <- dbGetQuery(con, query)
result


# Zadanie 2
query <- "SELECT country FROM country WHERE country ~ '^P' and country ~* 's$' ORDER BY country"
result <- dbGetQuery(con, query)
result


# Zadanie 3
query <- "SELECT title FROM film WHERE title ~ '[0-9]' ORDER BY title"
result <- dbGetQuery(con, query)
result


# Zadanie 4
query <- "SELECT first_name, last_name FROM staff WHERE first_name ~ ', ' OR last_name ~ '-' "
result <- dbGetQuery(con, query)
result


# Zadanie 5
query <- "SELECT first_name, last_name FROM actor WHERE last_name ~ '^[CP][a-z].{3}$' "
result <- dbGetQuery(con, query)
result


# Zadanie 6
query <- "SELECT title FROM film WHERE title ~ 'Trip|Alone'"
result <- dbGetQuery(con, query)
result


# Zadanie 7
# pierwszy pattern bedzie szukal imion zaczynajacych sie od Al a nastepne znaki moga byc z przedzialu a-z lub 1-9
# drugi pattern bedzie szukal imion zaczynajaych sie od al a nastepne znaki moga byc z przedzialu a-z lub 1-9 ale wielkosc znaku nie ma znaczenia