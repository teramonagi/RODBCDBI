context("ODBCConnection")

test_that("Connection should be established", {
  user <- 'sa'
  con <- dbConnect(RODBCDBI::ODBC(), dsn='test', user=user, password='Password12!')
  expect_true(!(is.null(con)))
})