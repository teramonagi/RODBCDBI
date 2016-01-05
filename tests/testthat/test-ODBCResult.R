context("ODBCResult")
#Common functions
make_test_connection <- function()
{
  USER <- 'sa'
  PASSWORD <- 'Password12!'
  dbConnect(RODBCDBI::ODBC(), dsn='test', user=USER, password=PASSWORD)
}

test_that("DB source name should be test", {
  con <- make_test_connection()
  dbWriteTable(con, "iris", iris, overwrite=TRUE)
  res <- dbSendQuery(con, "SELECT * FROM iris")
  expect_true(dbGetInfo(res)$sourcename=="test")
  dbRemoveTable(con, "iris")
  dbDisconnect(con)
})

test_that("All rows and columns should be returned", {
  con <- make_test_connection()
  dbWriteTable(con, "iris", iris, overwrite=TRUE, rownames=FALSE)
  res <- dbSendQuery(con, "SELECT * FROM iris")
  df <- dbFetch(res)
  expect_true(nrow(df)==nrow(iris))
  expect_true(ncol(df)==ncol(iris))
  dbRemoveTable(con, "iris")
  dbDisconnect(con)
})
