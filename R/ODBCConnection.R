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