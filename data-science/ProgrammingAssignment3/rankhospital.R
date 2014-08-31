#  rankhospital takes three arguments: the 2-character abbreviated name of a
# state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
# The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
# of the hospital that has the ranking specied by the num argument. 
# example: rankhospital("MD", "heart failure", 5)
rankhospital <- function( state, outcome , num = "best"){
  
  ## Read outcome data
  f <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  data <- data.frame(f, ignore.case = TRUE)
  
  ## Check that state is valid
  if( !any( data[, "State"] == state)){
    stop("invalid state")
    return
  }
  
  # Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  outcomeColName <- sprintf("^Hospital.30.Day.Death..Mortality..Rates.from.%s$" , gsub("\\s", ".", outcome ))  
  outcomeColIndex <- grep(outcomeColName, names(data), ignore.case=TRUE)
  
  ## Check that outcome is valid
  if( !any(outcomeColIndex) ){
    stop("invalid outcome")
    return
  }
  
  stateData <- subset( data , State == state ) 
  stateData[, outcomeColIndex] <- suppressWarnings( as.numeric(x= stateData[, outcomeColIndex] ) )
  stateData <- stateData[complete.cases(stateData), ] # remove NA
  
  # sort
  sortedData <- stateData[order(stateData[, outcomeColIndex], stateData$Hospital.Name ),]
  rowCount <- nrow(stateData)
 
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
     
   ## Return hospital name in that state with the given rank 30-day death rate
   result <- sortedData[ index , ]$Hospital.Name
   result 
}