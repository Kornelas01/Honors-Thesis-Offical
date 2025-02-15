# Pull Weather Data for Close to Concord, MA
# EKB, February 2025

#remotes::install_github("ropensci/rnoaa")
library(rnoaa)
library(dplyr)

# API key
options(noaakey = "rPKDOqboLvtJRwAobBIoHefeQJOusyiJ")

# find available stations near Concord, MA
stations <- ncdc_stations(extent = c(42.3476, -71.4594, 42.5310, -71.1888), limit = 1000)
stations_df <- stations$data

bh_field <- ncdc_stations(stationid = "GHCND:USW00014702")
bh_field <- bh_field$data

# pull data from Bedford Hanscom Field
data <- ncdc(datasetid = "GHCND", stationid = "GHCND:USC00190535", 
             startdate = "1971-01-01", enddate = "1971-12-31", 
             datatypeid = c("TMAX", "TMIN"), limit = 1000, add_units = TRUE)
data["data"]

# empty dataframe
temps <- data.frame()

for (station in c("GHCND:USC00190535", "GHCND:USW00014702")) {
  
  for (year in 1960:1994) {
    
    # create start and end dates for each year
    start_date <- paste0(year, "-01-01")
    end_date <- paste0(year, "-12-31")
    
    output <- ncdc(datasetid = "GHCND", stationid = station, 
                   startdate = start_date, enddate = end_date, 
                   datatypeid = c("TMAX", "TMIN"), limit = 1000, add_units = TRUE)
    
    temps <- dplyr::bind_rows(temps, output[["data"]])
    
  }
  
}


