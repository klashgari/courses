# setup for Ubuntu 

# how to configure and load the xlsx in ubuntu
# http://tuxette.nathalievilla.org/?p=1380&lang=en
# install java first, sudo apt-get install openjdk-7-*
# update-alternatives --config java
# sudo R CMD javareconf
# sudo apt-get install r-cran-rjava
# in  R do: install.packages("xlsx")
library(xlsx)

# we need the following:
# sudo apt-get install libcurl4-openssl-dev
# sudo apt-get install libxml2-dev
# install.packages("XML")
library(XML)

# install.packages("data.table")
library(data.table)

setwd("~/edu/courses/getting-and-cleaning-data")
Global.HousingFilePath <- "~/edu/courses/getting-and-cleaning-data/data/2006HousingData.csv"
Global.GovNgpaXlsxFilePath <- "~/edu/courses/getting-and-cleaning-data/data/getdata-Fdata-FDATA.gov_NGAP.xlsx"
Global.RestaurantsFilePath <- "~/edu/courses/getting-and-cleaning-data/data/getdata-Fdata-Frestaurants.xml"
Global.Fss06pidFilePath <- "~/edu/courses/getting-and-cleaning-data/data/getdata-Fdata-Fss06pid.csv"

downloadCsv <- function(){
  
  if( !file.exists("./data")){
    dir.create("./data")
  }
  
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
  download.file(fileUrl, destfile = Global.HousingFilePath , method = "curl")
  list.files("./data") 
  
  return ("done")
  
}

downloadExcelData <- function(){
  
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
  download.file(fileUrl, destfile = Global.GovNgpaXlsxFilePath , method = "curl")
  list.files("./data") 
  
  return ("done")
  
}

downloadXmlData <- function(){
  
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
  download.file(fileUrl, destfile = Global.RestaurantsFilePath , method = "curl")
  list.files("./data") 
  return ("done")  
}

downloadFss06pidFilePath <- function(){
  
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
  download.file(fileUrl, destfile = Global.Fss06pidFilePath , method = "curl")
  list.files("./data") 
  
  dateDownloaded <- date()
  print(dateDownloaded)
  
  return ("done")  
}

question1 <- function(){
  
  d <- read.csv( Global.HousingFilePath , header = TRUE, stringsAsFactors=FALSE) 
  
  overMillion <- d$VAL[d$VAL == 24] 
  data <- overMillion[complete.cases(overMillion)] # remove NA
  data
 length(data)
}

question2 <- function(){
  
  d <- read.csv( Global.HousingFilePath , header = TRUE, stringsAsFactors=FALSE) 
  
  d <- d$FES[ complete.cases(d$FES)]
  
}

question3 <- function(){
  # (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)
  # Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:  dat
  rowIndex <- 18:23
  colIndex <- 7:15
  dat <- read.xlsx( Global.GovNgpaXlsxFilePath , sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex) 
  head(dat)
  sum(dat$Zip*dat$Ext,na.rm=T) 
  # 36534720
}

question4 <- function(){
  # How many restaurants have zipcode 21231? 
  doc <- xmlTreeParse(  Global.RestaurantsFilePath ,useInternal=TRUE) 
  rootNode <- xmlRoot(doc)
  xmlName(rootNode)
  #names(rootNode)
  z <- xpathSApply( rootNode, "//zipcode[text()='21231']", xmlValue)
  length(z)
}

question5 <- function(){
  
  DT <- fread(input=Global.Fss06pidFilePath , sep=",")
  
  
  t <-system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
  print(t)
  
  t <- system.time(tapply(DT$pwgtp15,DT$SEX,mean))
  print(t)
  
  t <- system.time(DT[,mean(pwgtp15),by=SEX])
  print(t)
  
  t< - system.time(mean(DT[DT$SEX==1,]$pwgtp15)) + system.time( mean(DT[DT$SEX==2,]$pwgtp15))
  print(t)
  
  t <- system.time(mean(DT$pwgtp15,by=DT$SEX))
  print(t)
  
  t <- system.time(y <- rowMeans(DT)[DT$SEX == 1]) + system.time(rowMeans(DT)[DT$SEX ==2])
  print(t)
}

options(error = NULL)  # restore to default