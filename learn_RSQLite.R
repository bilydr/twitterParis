library(RSQLite)

# basic usage -------------------------------------------------------------


library(DBI)
# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), ":memory:")

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), "HPI_CardTrx.sqlite")


dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)

dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while(!dbHasCompleted(res)){
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}
# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)

# datasets database----------------------------------------------------------------
## RSQLite includes one SQLite database (accessible from datasetsDb() that contains 
# all data frames in the datasets package.
# Below is the code that created it.

tables <- unique(data(package = "datasets")$results[, 3])
tables <- tables[!grepl("(", tables, fixed = TRUE)]

con <- dbConnect(SQLite(), "inst/db/datasets.sqlite")
for(table in tables) {
  df <- getExportedValue("datasets", table)
  if (!is.data.frame(df)) next
  
  message("Creating table: ", table)
  dbWriteTable(con, table, as.data.frame(df), overwrite = TRUE)
}

# nycflights13 ------------------------------------------------------------

require(nycflights13)
db <- nycflights13_sqlite(path = '/home/ulxb524/SQLite')
con <- db$con
dbListTables(con)
dbListFields(con, 'airlines')

res <- dbSendQuery(con, "SELECT * FROM airlines")
(df <- dbFetch(res))
# useful commands ---------------------------------------------------------

# check the schema
dbGetQuery(con, "select * from sqlite_master")
# check specific table
dbGetQuery(con, "select * from sqlite_master where tbl_name = 'airlines'")

# twitter database ----------------------------------------------------------------

require(twitteR)

setwd("~/data/tweets")
con <- dbConnect(RSQLite::SQLite(), "tweets.sqlite")
register_db_backend(con)
# maximum 5000 new tweets
search_twitter_and_store("#ParisAttacks", table_name = "tweets", lang ='en')
