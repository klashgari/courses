

Global.BasePath <- "~/edu/courses/data-science"

#
# usage:   complete("specdata", 1:10)
#
complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041 
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  
  
  completeCaseCount <- function(file) {
    d <- read.csv( file , header = TRUE, stringsAsFactors=FALSE) 
    #  complete.cases returns a logical vector indicating which cases are complete, i.e., have no missing values.
    total <- sum(complete.cases(d)) # how many are "ok" ?
    total
  }
  
  
  
  files <- sprintf("%s/%s/%03d.csv", Global.BasePath, directory, id)
  completeCaseCountRows <- sapply( files, completeCaseCount)
  
  rowNames <- sapply( 1:length(id), function(f) sprintf("## %s" , f))
  
  data.frame(id=id, 
             nobs=completeCaseCountRows,
            row.names= rowNames ,
            check.rows = FALSE,
            check.names = TRUE,
            stringsAsFactors = default.stringsAsFactors())
}