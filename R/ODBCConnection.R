# Re-define RODBC class as S4
setOldClass("RODBC")

#' Class ODBCConnection.
#'
#' \code{ODBCConnection} objects are usually created by \code{\link[DBI]{dbConnect}}
#' @include RODBCDBI.R
#' @keywords internal
#' @export
setClass(
  "ODBCConnection",
  contains="DBIConnection",
  slots=list(odbc="RODBC")
)

#' @export
#' @rdname odbc-query
setMethod("dbSendQuery", "ODBCConnection", function(conn, statement, ...) {
  statement <- enc2utf8(statement)  
  new("ODBCResult", connection=conn, sql=statement, is_done=FALSE)
})

#' @export
#' @rdname ODBCConnection-class
setMethod("dbGetInfo", "ODBCConnection", function(dbObj, ...) {odbcGetInfo(dbObj@odbc)})


#' List fields in specified table.
#' 
#' @param conn An existing \code{\linkS4class{RODBCConnection}}
#' @param name a length 1 character vector giving the name of a table.
#' @export
#' @examples
#' con <- dbConnect(RODBCDBI::ODBC())
#' dbWriteTable(con, "iris", iris)
#' dbListFields(con, "iris")
#' dbDisconnect(con)
setMethod("dbListFields", c("ODBCConnection", "character"), function(conn, name) {
  sqlColumns(conn@odbc, name)$COLUMN_NAME
})

#' List available ODBC tables.
#' 
#' @param conn An existing \code{\linkS4class{ODBCConnection}}
#' @export
setMethod("dbListTables", "ODBCConnection", function(conn){
  sqlTables(conn@odbc)$TABLE_NAME
})

#' Write a local data frame or file to the database.
#' 
#' @export
#' @rdname dbWriteTable
#' @param con,conn a \code{\linkS4class{ODBCConnection}} object, produced by \code{\link[DBI]{dbConnect}}
#' @param name a character string specifying a table name. ODBCConnection table names 
#'   are \emph{not} case sensitive, e.g., table names \code{ABC} and \code{abc} 
#'   are considered equal.
#' @param value a data.frame (or coercible to data.frame) object or a 
#'   file name (character).  when \code{value} is a character, it is interpreted as a file name and its contents imported to ODBC.
#' @export
#' @examples
#' con <- dbConnect(RODBCDBI::ODBC())
#' dbWriteTable(con, "mtcars", mtcars)
#' dbReadTable(con, "mtcars") 
#' dbDisconnect(con)
setMethod("dbWriteTable", c("ODBCConnection", "character", "data.frame"), function(conn, name, value) {
  sqlSave(conn@odbc, dat=value, tablename=name)
})

#' Does the table exist?
#' 
#' @param conn An existing \code{\linkS4class{SQLiteConnection}}
#' @param name String, name of table. Match is case insensitive.
#' @export
setMethod("dbExistsTable", c("ODBCConnection", "character"), function(conn, name) {
  tolower(name) %in% tolower(dbListTables(conn))
})

#' Remove a table from the database.
#' 
#' Executes the SQL \code{DROP TABLE}.
#' 
#' @param conn An existing \code{\linkS4class{ODBCConnection}}
#' @param name character vector of length 1 giving name of table to remove
#' @export
setMethod("dbRemoveTable", c("ODBCConnection", "character"), function(conn, name) {
  sqlDrop(conn@odbc, "USArrests")
  invisible(TRUE)
})
