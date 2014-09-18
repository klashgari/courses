library(tidyr)
library(dplyr)
library(plyr)

Global.RemoteUrlForDataSet <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
Global.BasePath <- "~/edu/courses/getting-and-cleaning-data/course-project"

folder.create <- function(folderName, basepath=Global.BasePath)
{
  setwd(basepath)
  if (!file.exists(folderName)) 
  {
    message(sprintf("Creating %s folder", folderName))
    dir.create(folderName)    
  }
  file.path(basepath, folderName,  fsep = .Platform$file.sep)
}

url.download <- function(fromUrl, toFolder, unzip=FALSE, lazyLoad=FALSE)
{
  filename <- basename(URLdecode(fromUrl))   
  targetPath <- file.path(toFolder, filename,  fsep = .Platform$file.sep)
  message(sprintf("Downloading from %s", fromUrl))
  
  if ( lazyLoad &&  file.exists(targetPath) )
  {
    message(sprintf("The folder %s exists, will not download again.", targetPath))
    return(NA)
  }

  download.file(fromUrl, destfile=targetPath, method="curl")
  message(sprintf("Downloaded to %s", targetPath))
  if( unzip )
  {
    unzip(targetPath, exdir=toFolder)
    message(sprintf("Unzipped the file '%s' into folder: '%s'", targetPath, toFolder))
  }
}

merge.training.and.test.datasets <- function(basepath=Global.BasePath)
{
  
  "Merges the training and the test sets to create one data set."
  setwd(basepath)
  
  features <- tbl_df( read.table("dataset/UCI HAR Dataset/features.txt"))
  
  
  x <- rbind(read.table("dataset/UCI HAR Dataset/train/X_train.txt"),
             read.table("dataset/UCI HAR Dataset/test/X_test.txt") )
  colnames(x) <- features[,2]
  
  
  activity <- rbind(read.table("dataset/UCI HAR Dataset/train/y_train.txt"),
             read.table("dataset/UCI HAR Dataset/test/y_test.txt"))
  colnames(activity) <- "activity"
  
  subject <- rbind(read.table("dataset/UCI HAR Dataset/train/subject_train.txt"),
                   read.table("dataset/UCI HAR Dataset/test/subject_test.txt"))
  colnames(subject) <- "subject"
    
  list( Subject=tbl_df(subject), Activity=tbl_df(activity), X=tbl_df(x))
}

extract.mean.sd <- function(X)
{
  df <- select( X, matches("-mean()|-std()"))
  df
}

use.descriptive.activitiy.names <-function(activity)
{
  # activity lables:
  #  1 WALKING
  #  2 WALKING_UPSTAIRS
  #  3 WALKING_DOWNSTAIRS
  #  4 SITTING
  #  5 STANDING
  #  6 LAYING
  l <- tbl_df(read.table("dataset/UCI HAR Dataset/activity_labels.txt"))  
  message( sprintf( "There are %d activity labels in the activity_lables.txt file", nrow(l)))
  for( i in 1:nrow(l))
  { 
    print(as.character( l[i,2] ))
    activity[activity == i] = as.character( l[i,2] )
  }
  print(activity)
  activity
}

dataset.with.descriptive.variable.names <- function(subject, activity, x, filename, basepath=Global.BasePath)
{
  cleaned <-  cbind(subject, activity, x)
  
  file <-  file.path(basepath, filename,  fsep = .Platform$file.sep)
  write.table(cleaned, file, sep="\t")
  cleaned 
}

create.tidy.dataset <- function(cleaned, filename, basepath=Global.BasePath)
{
  tidy <- ddply(cleaned, .(subject, activity), numcolwise(mean) )
  
  file <-  file.path(basepath, filename,  fsep = .Platform$file.sep)
  write.table(tidy, file, sep="\t" ,row.names=FALSE )
  tidy
}

main <- function(downloadDataset = TRUE)
{ 
  setwd(Global.BasePath)
  url.download( fromUrl=Global.RemoteUrlForDataSet, 
                toFolder=folder.create("dataset"), 
                unzip=TRUE,
                lazyLoad=downloadDataset)
  

  message("About to merges the training and the test sets to create one data set.")
  list <- merge.training.and.test.datasets()
  
  message("Extracting only the measurements on the mean and standard deviation for each measurement")
  cleaned.x <- extract.mean.sd(list$X)
  message("printing cleaned.x: ")
  head(cleaned.x)
  
  message("Setting descriptive activity names to name the activities in the data set")
  cleaned.activity <- use.descriptive.activitiy.names(list$Activity)  
  message("printing activity: ")
  head(cleaned.activity)
  
  # Appropriately labels the data set with descriptive variable names. 
  cleaned <- dataset.with.descriptive.variable.names(list$Subject, cleaned.activity, cleaned.x, "cleaned.dataset.txt")
  message("\n-----------------------------------\n printing cleaned: ")
  head(cleaned)
  
  # From the data set in step 4, creates a second, independent tidy data set with the average of 
  #each variable for each activity and each subject.
  tidy <- create.tidy.dataset(cleaned, "tidy.txt")
  message("\n-----------------------------------\n printing tidy:")
  head(tidy)
  tail(tidy)
}
