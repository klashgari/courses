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
  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
  "Create a logical vector that identifies the households on greater than 10 acres who sold more "
  "than $10,000 worth of agriculture products. Assign that logical vector to the variable"
  "agricultureLogical. Apply the which() function like this to identify the rows of the data frame "
  "where the logical vector is TRUE. which(agricultureLogical) What are the first 3 values that result?"
  
  # from https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
  #ACR 1
  #Lot size
  #b .N/A (GQ/not a one-family house or mobile home)
  #1 .House on less than one acre
  #2 .House on one to less than ten acres
  # ->  3 .House on ten or more acres
  
  #AGS 1
  #Sales of Agriculture Products
  #b .N/A (less than 1 acre/GQ/vacant/
  #          .2 or more units in structure)
  #1 .None
  #2 .$ 1 - $ 999
  #3 .$ 1000 - $ 2499
  #4 .$ 2500 - $ 4999
  #5 .$ 5000 - $ 9999
  #6 .$10000+ 
  
  setwd(Global.BasePath)
  targetPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
                          toFolder=CreateFolder("quiz3"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)
  message( sprintf("targetPath: %s", targetPath)) 
  df <- read.csv(targetPath)
  agricultureLogical <- df$ACR==3 & df$AGS ==6
  which(agricultureLogical)[1:3]
  # 125, 238,262
}

Q2 <- function(lazyLoad = TRUE)
{
  "Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?"
  "(some Linux systems may produce an answer 638 different for the 30th quantile)"
  
  setwd(Global.BasePath)
  targetPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", 
                          toFolder=CreateFolder("quiz3"), 
                          unzip=FALSE,
                          lazyLoad=lazyLoad)
  message( sprintf("targetPath: %s", targetPath)) 
  image <- readJPEG(targetPath, native = TRUE)
  quantile(image, probs=c(0.3,0.8))
  # -15259150 -10575416 
}

Q345 <- function(lazyLoad = TRUE)
{
  "Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in "
  "descending order by GDP rank (so United States is last). "
  "What is the 13th country in the resulting data frame? "
  setwd(Global.BasePath)
  # Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
  gdpPath <- Download( fromUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                       toFolder=CreateFolder("quiz3"), 
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
  colnames(df) <- c("shortcode" , "Rank", "countryName", "GDP")
  
  df <- df[complete.cases(df),] #assign to a new data.frame
  df <- df[1:190,] ## only select countries
  df$Rank <- as.numeric(df$Rank)
  df$GDP <- as.integer(gsub("," , "" , df$GDP) ) 
  df <-arrange(df, desc(Rank)) 
  
  message("What is the 13th country in the resulting data frame? ")
  print( df[1:13,] )
  #as.data.frame(df)
  # as.data.frame (df.orig)
  # 13       KNA  178            St. Kitts and Nevis 767

  # Q4  "What is the average GDP ranking for the \"High income: OECD\" and \"High income: nonOECD\" group? "
 
  
  fedStatus <- read.csv(countryPath, stringsAsFactors = FALSE)
  m <- merge(df, fedStatus, by.x = "shortcode", by.y = "CountryCode", all = FALSE)
  avgGdpRanking <- c(  mean(m[m$Income.Group=="High income: OECD",]$Rank)
                      ,mean(m[m$Income.Group=="High income: nonOECD",]$Rank) )
  
  message("What is the average GDP ranking for the \"High income: OECD\" and \"High income: nonOECD\" group? ")
  print(avgGdpRanking )
  
  q <- quantile(df$GDP , probs=c(0.2,0.4, 0.6, 0.8, 1))
  nationsWithHighestGDP <- q[4]
  result <- m[m$Income.Group=="Lower middle income" & m$GDP > nationsWithHighestGDP,]
  print( nrow(result) )
}
