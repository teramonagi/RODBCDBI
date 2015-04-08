context("ODBCConnection")

test_that("Connection should be established", {
  con <- dbConnect(RODBCDBI::ODBC(), dsn='test')
  expect_true(!(is.null(con)))
})