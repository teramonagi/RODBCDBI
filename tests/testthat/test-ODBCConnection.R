context("ODBCConnection")

test_that("Connection should be established", {
  con <- dbConnect(RODBCDBI::ODBC(), dsn='test', user='sa', password='Password12!')
  expect_true(!(is.null(con)))
})