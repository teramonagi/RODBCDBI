# RODBCDBI

RODBCDBI is an DBI-compliant interface to ODBC database. It's a wrapper of RODBC package.

## Installation

RODBCDBI isn't available from CRAN yet, but you can get it from github with:

```R
# install.packages("devtools")
# install.packages("RODBC")
devtools::install_github("rstats-db/DBI")
devtools::install_github("teramonagi/RODBCDBI")

## Basic usage

```R
# At first, we make a sample table using RODBC package
channel <- odbcConnect("test")
sqlSave(channel, USArrests)
close(channel)

# Connect to sample
library(RODBCDBI)
con <- dbConnect(RODBCDBI::ODBC(), dsn='test')

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM USArrests")
dbFetch(res)

# Or you can get all result at one by dbGetQuery
dbGetQuery(con, "SELECT * FROM USArrests")

# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)
```

## Acknowledgements

Many thanks to Brian D. Ripley, Michael Lapsley since This package is just a wrapper of RODBC package.