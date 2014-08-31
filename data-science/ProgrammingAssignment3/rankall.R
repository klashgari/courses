# example: 
#     rankhospital("MD", "heart failure", 5)
#     tail(rankall("pneumonia", "worst"), 3)
#
rankall <- function(outcome , num = "best"){

  rank <- function(d, colName) {
    # sort
    sortedData <- d[order(d[colName], d["Hospital.Name"] ),]
    
    rowCount <- nrow(sortedData)    
    if( num == "best"){
      index <- 1
    }
    else if( num == "worst"){
      index <- rowCount 
    }
    else if( is.numeric(x=num) && ( num  < rowCount || num >  0) ){
      index <- as.numeric(x=num) 
    }
    else{
      stop("invalid num")
      return
    }
    
    ## Return hospital name in  state
    result <- sortedData[ index , ]$Hospital.Name
    result 
  }
  
  
  ## Read outcome data
  f <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  data <- data.frame(f, ignore.case = TRUE)
  
  # Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  pattern <- sprintf("^Hospital.30.Day.Death..Mortality..Rates.from.%s$" , gsub("\\s", ".", outcome ))  
  outcomeColIndex <- grep(pattern, names(data), ignore.case=TRUE)
  
  
  ## Check that outcome is valid
  if( !any(outcomeColIndex) ){
    stop("invalid outcome")
    return
  }
  
  data[, outcomeColIndex] <- suppressWarnings( as.numeric(x= data[, outcomeColIndex] ) )
  data <- data[complete.cases(data), ] # remove NA

 
  outcomeColName <- colnames(data)[outcomeColIndex]
  partitionedData<- split( data[, c( "Hospital.Name", "State", outcomeColName )], data$State)
  result <- lapply(partitionedData, rank, outcomeColName)
  
  
  data.frame(hospital = unlist(result), 
             state = names(result), 
             row.names = names(result))
}