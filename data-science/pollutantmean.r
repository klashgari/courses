# 
# usage:   data <- pollutantmean("specdata", "nitrate", 70:72)
#

Global.BasePath <- "~/edu/courses/data-science"

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  
  files <- sprintf("%s/%s/%03d.csv", Global.BasePath, directory, id)
  for( path in files)
  {
    d <- read.csv( path , header = TRUE, stringsAsFactors=FALSE) 
    data <- rbind(data, d) 
  }

  if( pollutant == "sulfate"){
      #print("sulfate")  
      m  <- mean(data$sulfate, na.rm = TRUE)
  }
  if( pollutant == "nitrate"){
       #print("nitrate")
       m  <- mean(data$nitrate,  na.rm = TRUE)
  }
  #trunc(m, digits=6)
  m
}

