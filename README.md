# RODBCDBI [![Build status](https://ci.appveyor.com/api/projects/status/3h11jwc1v7l7nt38/branch/master?svg=true)](https://ci.appveyor.com/project/teramonagi/rodbcdbi/branch/master)

RODBCDBI is an DBI-compliant interface to ODBC database. It's a wrapper of RODBC package.

## Installation

RODBCDBI isn't available from CRAN yet, but you can get it from github with:

```R
# install.packages("devtools")
install.packages("RODBC")
devtools::install_github("rstats-db/DBI")
devtools::install_github("teramonagi/RODBCDBI")
```

## Basic usage

```R
library(DBI)
library(RODBCDBI)
# At first, we make a sample table using RODBC package
con <- dbConnect(RODBCDBI::ODBC(), dsn='test')
dbListTables(con)
dbWriteTable(con, "USArrests", USArrests)

dbWriteTable(con, "iris", iris)
dbListTables(con)

dbListFields(con, "iris")
dbReadTable(con, "iris")
dbReadTable(con, "USArrests")

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM USArrests")
dbFetch(res)

# Or you can get all result at once by dbGetQuery
dbGetQuery(con, "SELECT * FROM USArrests")

# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)
```

## Acknowledgements

Many thanks to Brian D. Ripley, Michael Lapsley since This package is just a wrapper of [RODBC package](http://cran.r-project.org/web/packages/RODBC/index.html).
