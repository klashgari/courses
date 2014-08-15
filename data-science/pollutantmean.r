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
  
  #------------- kourosh -----------------------------------
  # for each item in the id  
  #   build a new string for a filename 
  #   open the file and load to temp
  #   cbind the temp to data variable.
  
  # if  pollutant is a "sulfate"  then take mean of the "sulfate"
  # if  pollutant is a "nitrate" then take mean of the "nitrate"
  
  #
  
  for( i in id ){
    filename <- formatC(i, width = 3, format = "d", flag = "0")
    path <- paste( directory, "/" ,filename, ".csv" , sep="" )
   # print(path)
    
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
