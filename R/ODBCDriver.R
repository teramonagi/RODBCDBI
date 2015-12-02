#' ODBC driver
#'
#' This driver never needs to be unloaded and hence \code{dbUnload()} is a null-op.
#'
#' @export
#' @import methods DBI
#' @examples
#' \dontrun{
#' #' library(DBI)
#' RODBCDBI::ODBC()
#' }
ODBC <- function() {new("ODBCDriver")}

#' ODBCDriver and methods.
#'
#' @export
#' @keywords internal
setClass("ODBCDriver", contains = "DBIDriver")

#' @export
#' @rdname ODBCDriver-class
setMethod("dbUnloadDriver", "ODBCDriver", function(drv, ...) {NULL})

setMethod(
  "dbConnect", 
  "ODBCDriver", 
  function(drv, dsn, user = NULL, password = NULL, ...){
    uid <- if(is.null(user)) "" else user
    pwd <- if(is.null(password)) "" else password
    connection <- odbcConnect(dsn, uid, pwd, ...)
    new("ODBCConnection", odbc=connection)
  }
)

#' @rdname ODBCDriver-class
#' @export
setMethod("dbIsValid", "ODBCDriver", function(dbObj) {TRUE})