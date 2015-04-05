#' ODBC driver
#'
#' This driver never needs to be unloaded and hence \code{dbUnload()} is a null-op.
#'
#' @export
#' @import methods DBI
#' @examples
#' library(DBI)
#' RODBCDBI::odbc()
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
  function(drv, dsn, password = NULL, user = NULL, ...) {
    uid <- ifelse(is.null(user), "", user)
    pwd <- ifelse(is.null(password), "", password)
    connection <- odbcConnect(dsn, uid, pwd, ...)
    new("ODBCConnection", odbc=connection)
  }
)