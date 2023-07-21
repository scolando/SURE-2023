# Install the RSQLite packages and the NYC flights data ----
#REQ_PKGS <- c("dittodb", "RSQLite", "nycflights13")
#install.packages(REQ_PKGS)
# pak::pkg_install(REQ_PKGS)

# Load the required packages ----
library(RSQLite)
library(nycflights13)
library(dittodb)
library(tidyverse)

# Set up the connection to the NYC flights database ----
NYC_CONN <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# Reads the database from the NYC data ----
dittodb::nycflights13_create_sql(NYC_CONN)

# Helper function to read from a given connection ----
# This removes a lot of the DBI::dbGetQuery code, and allows us to just focus
# directly on the SQL query
fetch_query <- function(query, con = NYC_CONN) {
  return(DBI::dbGetQuery(con, query))
}

# We can now run some custom queries on the NYC flights data ----
fetch_query("SELECT * FROM flights LIMIT 10;")

## select specific column from the data frame and view just 10 rows.
### * means all columns
### ALWAYS add a limit clause when you are just selecting from a table


fetch_query("SELECT dep_time, arr_time, flight FROM flights LIMIT 10;")


# select to resemble mutate()
fetch_query("SELECT flight, distance/(air_time/60) AS speed FROM flights LIMIT 10;")


fetch_query("SELECT min(air_time) AS min_air, max(air_time) AS max_air FROM flights;")


fetch_query("SELECT count(*) AS num_obs FROM flights;")

# aggregations are most effective when working across groups of data

# WHERE query is analogous to filter() in dplyr

fetch_query("SELECT * FROM flights WHERE origin = 'JFK' LIMIT 10;")

fetch_query("SELECT * FROM flights WHERE dest != 'JFK' LIMIT 10;")

fetch_query("SELECT * FROM flights WHERE tailnum IN ('N593JB','N532UA') LIMIT 10;")

# note the special IS NOT NULL

fetch_query("SELECT * FROM weather WHERE wind_gust IS NOT NULL LIMIT 20;")

# GROUP BY

fetch_query("SELECT origin, AVG(arr_delay) AS avd FROM flights GROUP BY origin;")

# HAVING: operates on aggregrating data, WHERE: operates on the whole data 

fetch_query("SELECT engines, COUNT(*) AS tot_num FROM planes GROUP BY engines HAVING tot_num < 200;")

# ORDER BY
