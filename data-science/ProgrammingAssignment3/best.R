#  The function reads the outcome-of-care-measures.csv file and returns a character vector
#  with the name of the hospital that has the best (i.e. lowest) 30-day mortality 
# 
# Args:
#    state is the 2 char state naem
#    outcome name
# Example:
#   best("BB", "heart attack")
#   best("TX", "heart attack")
# DATA: 
#     2. Hospital Name: varchar (50) Lists the name of the hospital.
#     7. State: varchar (2) Lists the 2 letter State code in which the hospital is located.
#     11. Hospital 30-Day Death (Mortality) Rates from Heart Attack: Lists 
#         the risk adjusted rate (percentage) for each hospital.
best <- function( state, outcome ){

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

  minData <- stateData[(stateData[, outcomeColIndex] == min(stateData[, outcomeColIndex])), ]
  
  ## Retrun hospital name in the state with lowest 30-day death rate
  minData$Hospital.Name
  
  
  
}

options(error = NULL)  # restore to default


# cr <- cbind(filterdData[, "State"] , filterdData[, outcomeNumericColNum])   
#colnames(cr) <- c("state", outcomeColName)