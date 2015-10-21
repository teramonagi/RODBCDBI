#' @include RODBCDBI.R
NULL

#' Class ODBCConnection.
#'
#' \code{ODBCConnection} objects are usually created by \code{\link[DBI]{dbConnect}}
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
#' library(DBI)
#' con <- dbConnect(RODBCDBI::ODBC(), dsn="test", user="sa", password="Password12!")
#' dbWriteTable(con, "iris", iris, overwrite=TRUE)
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
#' library(DBI)
#' con <- dbConnect(RODBCDBI::ODBC(), dsn="test", user="sa", password="Password12!")
#' dbWriteTable(con, "mtcars", mtcars, overwrite=TRUE)
#' dbReadTable(con, "mtcars") 
#' dbDisconnect(con)
setMethod("dbWriteTable", c("ODBCConnection", "character", "data.frame"), function(conn, name, value, overwrite=FALSE, append=FALSE, ...) {
  sqlSave(conn@odbc, dat=value, tablename=name, safer=!overwrite, append=append, ...)
  invisible(TRUE)
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
  if(dbExistsTable(conn, name)){
    sqlDrop(conn@odbc, name)
  }
  invisible(TRUE)
})

#' Convenience functions for importing/exporting DBMS tables
#' 
#' These functions mimic their R/S-Plus counterpart \code{get}, \code{assign},
#' \code{exists}, \code{remove}, and \code{objects}, except that they generate
#' code that gets remotely executed in a database engine.
#' 
#' @return A data.frame in the case of \code{dbReadTable}; otherwise a logical
#' indicating whether the operation was successful.
#' @note Note that the data.frame returned by \code{dbReadTable} only has
#' primitive data, e.g., it does not coerce character data to factors.
#' 
#' @param conn a \code{\linkS4class{ODBCConnection}} object, produced by \code{\link[DBI]{dbConnect}}
#' @param name a character string specifying a table name.
#' @param check.names If \code{TRUE}, the default, column names will be converted to valid R identifiers.
#' @param select.cols  A SQL statement (in the form of a character vector of 
#'    length 1) giving the columns to select. E.g. "*" selects all columns, 
#'    "x,y,z" selects three columns named as listed.
#' @inheritParams DBI::rownamesToColumn
#' @export
#' @examples
#' library(DBI)
#' con <- dbConnect(RODBCDBI::ODBC(), dsn="test", user="sa", password="Password12!")
#' dbWriteTable(con, "mtcars", mtcars, overwrite=TRUE)
#' dbReadTable(con, "mtcars")
#' dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8")
#' 
#' # Supress row names
#' dbReadTable(con, "mtcars", row.names = FALSE)
#' dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8", row.names = FALSE)
#' 
#' dbDisconnect(con)
setMethod("dbReadTable", c("ODBCConnection", "character"), function(conn, name, row.names = NA, check.names = TRUE, select.cols = "*") {
  out <- dbGetQuery(conn, paste("SELECT", select.cols, "FROM", name), row.names = row.names)
  if (check.names) {
    names(out) <- make.names(names(out), unique = TRUE)
  }  
  out
})

#' @export
setMethod("dbDisconnect", "ODBCConnection", function(conn) {
  if (RODBC:::odbcValidChannel(conn@odbc)){
    odbcClose(conn@odbc)
  } else{
    TRUE
  }
})
