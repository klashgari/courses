
Global.BasePath <- "~/edu/courses/data-science"

corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  
  workingFolder <- sprintf("%s/%s", Global.BasePath, directory)
  files <- list.files( path = workingFolder )
  corralations <- c()
  for( file in files)
  {
   # print(file)
    data <- read.csv( sprintf("%s/%s", workingFolder, file) , header = TRUE, stringsAsFactors=FALSE) 
    data <- data[complete.cases(data),]
    #print(data)
    
    if ( nrow(data) > threshold ) {
    
      #print(nrow(data))
      corralations <- c(corralations, cor(data$sulfate, data$nitrate) ) # corralations
    }
  }
  return (corralations)
  
}