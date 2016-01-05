#' Class ODBCDriver
#'
#' This driver is for implementing the R database (DBI) API.
#' This driver never needs to be unloaded and hence \code{dbUnload()} is a null-op.
#' This class should always be initialized with the \code{ODBC()} function.
#' ODBC driver does nothing for ODBC connection. It just exists for S4 class compatibility with DBI package. 
#'
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

#' Get ODBCDriver metadata.
#' 
#' Nothing to do for ODBC connection case
#' 
#' @rdname odbc-meta
#' @export
setMethod("dbGetInfo", "ODBCDriver", function(dbObj, ...) {NULL})
