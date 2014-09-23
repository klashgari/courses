library(tidyr)
library(dplyr)
library(plyr)

# install.packages(jpeg)
library(jpeg)

Global.BasePath <- "." # ~/edu/courses/getting-and-cleaning-data"

setwd("~/edu/courses/getting-and-cleaning-data")

CreateFolder <- function(folderName, basepath=Global.BasePath)
{
  setwd(basepath)
  if (!file.exists(folderName)) 
  {
    message(sprintf("Creating %s folder", folderName))
    dir.create(folderName)    
  }
  file.path(basepath, folderName,  fsep = .Platform$file.sep)
}

Download <- function(fromUrl, toFolder, unzip=FALSE, lazyLoad=FALSE)
{
  filename <- basename(URLdecode(fromUrl))   
  targetPath <- file.path(toFolder, filename,  fsep = .Platform$file.sep)
  message(sprintf("Downloading from %s", fromUrl))
  
  if ( lazyLoad &&  file.exists(targetPath) )
  {
    message(sprintf("%s exists. Will not download again.", targetPath))
    message(sprintf("'lazyLoad' switch is set to %s.", as.character(lazyLoad)))
    return(targetPath)
  }
  
  download.file(fromUrl, destfile=targetPath, method="curl")
  message(sprintf("Downloaded to %s", targetPath))
  if( unzip )
  {
    unzip(targetPath, exdir=toFolder)
    message(sprintf("Unzipped the file '%s' \ninto folder: '%s'", targetPath, toFolder))
  }
  
  targetPath
}

Q1 <- function(lazyLoad = TRUE)
{
  "Apply strsplit() to split all the names of the data frame on the characters 'wgtp' ."
  "What is the value of the 123 element of the resulting list?"
  
  setwd(Global.BasePath)
  targetPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
                          toFolder=CreateFolder("quiz4-data"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)
  message( sprintf("targetPath: %s", targetPath)) 
  df <- read.csv(targetPath)
  
  
  array <- strsplit( names(df), "wgtp")
  #array <- sapply(names(df), function(s) strsplit(s, "wgtp") )
  array[[123]]
  # result [1] ""   "15"
  
}

Q2 <- function(lazyLoad = TRUE)
{
  "Load the Gross Domestic Product data for the 190 ranked countries in this data set: "
  "Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?"

  
  setwd(Global.BasePath)
  targetPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                          toFolder=CreateFolder("quiz4-data"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)
  message( sprintf("targetPath: %s", targetPath)) 
  df.orig <- tbl_df(read.csv(targetPath, skip=4, stringsAsFactors = FALSE))
  df <- select( df.orig, X:X.1, X.3:X.4)
  colnames(df) <- c("shortcode" , "Rank", "countryName", "GDP")
  
  df <- df[complete.cases(df),] #assign to a new data.frame
  df <- df[1:190,] ## only select countries
  df$Rank <- as.numeric(df$Rank)
  df$GDP <- as.integer(gsub("," , "" , df$GDP) ) 
  mean(df$GDP)
  # [1] 377652.4
 
}

Q3 <- function(lazyLoad = TRUE)
{
  "In the data set from Question 2 what is a regular expression that would allow you to"
  "count the number of countries whose name begins with 'United'? "
  "Assume that the variable with the country names in it is named countryNames. How many countries begin with United? "
  
  
  setwd(Global.BasePath)
  targetPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                          toFolder=CreateFolder("quiz4-data"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)
  message( sprintf("targetPath: %s", targetPath)) 
  df.orig <- tbl_df(read.csv(targetPath, skip=4, stringsAsFactors = FALSE))
  df <- select( df.orig, X:X.1, X.3:X.4)
  colnames(df) <- c("ShortCode" , "Rank", "CountryName", "GDP")
  df <- df[complete.cases(df),] #assign to a new data.frame
  df <- df[1:190,] ## only select countries
  result <- grep( "^United", df$CountryName, value=TRUE)
  result # [1] "United States"        "United Kingdom"       "United Arab Emirates"
}


Q4 <- function(lazyLoad = TRUE)
{
  "Match the data based on the country shortcode. Of the"
  "countries for which the end of the fiscal year is available, how many end in June?  "
  
  setwd(Global.BasePath)
  gdpPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                          toFolder=CreateFolder("quiz4-data"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)

  message( sprintf("gdpPath: %s", gdpPath)) 

  countryPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", 
                           toFolder=CreateFolder("quiz3"), 
                           unzip=FALSE,
                           lazyLoad=lazyLoad)
  message( sprintf("countryPath: %s", countryPath)) 
  
  df.orig <- tbl_df(read.csv(gdpPath, skip=4, stringsAsFactors = FALSE))
  df <- select( df.orig, X:X.1, X.3:X.4)
  colnames(df) <- c("ShortCode" , "Rank", "CountryName", "GDP")
  df <- df[complete.cases(df),] #assign to a new data.frame
  df <- df[1:190,] ## only select countries
  
  fedStatus <- read.csv(countryPath, stringsAsFactors = FALSE)
  fedStatus <- tbl_df(fedStatus)
  
 
  m <- merge(df, fedStatus, by.x = "ShortCode", by.y = "CountryCode", all = FALSE)
  result <- grep( ".*[Ff]iscal year end.*[Jj]une.*",  m$Special.Notes, value=TRUE)
  message("countries for which the end of the fiscal year is available, how many end in June?")
  print(result)
  length(result)
}

Q5 <- function()
{
  
  #  install.packages("quantmod") 
  library(quantmod)
  amzn = getSymbols("AMZN",auto.assign=FALSE)
  sampleTimes = index(amzn) 
  message("How many values were collected in 2012? How many values were collected on Mondays in 2012?")
  
  print(class(sampleTimes))
  w <- weekdays(sampleTimes)
  print(class(w))
  length(w)
   
 
  valuesCollectedIn2012 <- sampleTimes[ format(sampleTimes,"%Y") == "2012"]
  print(length(valuesCollectedIn2012))
  
  mondays <- valuesCollectedIn2012[ weekdays(valuesCollectedIn2012) == "Monday"]
  print(length(mondays))
}
