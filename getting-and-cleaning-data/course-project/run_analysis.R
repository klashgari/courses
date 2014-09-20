library(tidyr)
library(dplyr)
library(plyr)

Global.RemoteUrlForDataSet <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
Global.BasePath <- "~/edu/courses/getting-and-cleaning-data/course-project"

###################################################################
# Main function to collect and clean the dataset 
# CAll Usage() for help
###################################################################
Main <- function(lazyLoad = TRUE)
{ 
  setwd(Global.BasePath)
  Download( fromUrl=Global.RemoteUrlForDataSet, 
            toFolder=CreateFolder("dataset"), 
            unzip=TRUE,
            lazyLoad=lazyLoad)
  
  list <- MergeDatasets() # merge.training.and.test.datasets
  
  cleaned.x <- ExtractMeasurements(list$X)
  
  cleaned.activity <- ReplaceActivityNames(list$Activity)  
  
  # Appropriately labels the data set with descriptive variable names. 
  cleaned <- WriteDatasetWithDescriptiveVariableNames(list$Subject, 
                                                      cleaned.activity, 
                                                      cleaned.x, 
                                                      "cleaned.dataset.txt")
  
  # From the data set in step 4, creates a second, independent tidy data set with the average of 
  #each variable for each activity and each subject.
  WriteTidyDataset(cleaned, "tidy.txt")
  
}

Usage <- function()
{
  message(" call Main(FALSE) to downlaod the data then clean it. ")
  message(" call Main() or Main(TRUE) to clean a dataset previously downloaded.")
}


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
    return(NA)
  }

  download.file(fromUrl, destfile=targetPath, method="curl")
  message(sprintf("Downloaded to %s", targetPath))
  if( unzip )
  {
    unzip(targetPath, exdir=toFolder)
    message(sprintf("Unzipped the file '%s' \ninto folder: '%s'", targetPath, toFolder))
  }
}

MergeDatasets <- function(basepath=Global.BasePath)
{
  "Merges the training and the test sets to create one data set."
  
  message("About to merges the training and the test sets to create one data set.")
  
  setwd(basepath)
  features <- tbl_df( read.table("dataset/UCI HAR Dataset/features.txt"))
  
  
  x <- rbind(read.table("dataset/UCI HAR Dataset/train/X_train.txt"),
             read.table("dataset/UCI HAR Dataset/test/X_test.txt") )
  
  colnames(x) <- CleanFeatureNames(features[,2])
  
  
  activity <- rbind(read.table("dataset/UCI HAR Dataset/train/y_train.txt"),
                    read.table("dataset/UCI HAR Dataset/test/y_test.txt"))
  colnames(activity) <- "activity"
  
  subject <- rbind(read.table("dataset/UCI HAR Dataset/train/subject_train.txt"),
                   read.table("dataset/UCI HAR Dataset/test/subject_test.txt"))
  colnames(subject) <- "subject"
    
  list( Subject=tbl_df(subject), Activity=tbl_df(activity), X=tbl_df(x))
}

CleanFeatureNames <- function( columnNames )
{
  columnNames <- sapply( columnNames , function(name) name<- gsub("tBody", "TimeDomain-Body-", name) )
  columnNames <- sapply( columnNames , function(name) name<- gsub("fBody", "FrequencyDomain-Body-", name) )
  columnNames <- sapply( columnNames , function(name) name<- gsub("tGravity", "TimeDomain-Gravity-", name) )
  columnNames <- sapply( columnNames , function(name) name<- gsub("fGravity", "FrequencyDomain-Gravity-", name) )
  
  columnNames <- sapply( columnNames , function(name) name<- gsub("mean\\(\\)|mean\\(\\)-", "mean-", name) )
  columnNames <- sapply( columnNames , function(name) name<- gsub("meanFreq\\(\\)|meanFreq\\(\\)-", "meanFreq-", name) )
  columnNames <- sapply( columnNames , function(name) name<- gsub("std\\(\\)|std\\(\\)-", "std-", name) )
 
  columnNames
}

ExtractMeasurements <- function(X)
{
  "Extract only the measurements on the mean and standard deviation for each measurement"
  message("Extracting only the measurements on the mean and standard deviation for each measurement")
  
  df <- select( X, matches("-mean|-std"))  
  df
}

ReplaceActivityNames <-function(activity)
{
  " Replaces activitiy names with descriptive names "
  " activity lables: "
  "  1 WALKING "
  "  2 WALKING_UPSTAIRS "
  "  3 WALKING_DOWNSTAIRS "
  "  4 SITTING "
  "  5 STANDING "
  "  6 LAYING "
  
  message("Setting descriptive activity names to name the activities in the data set")
  
  l <- tbl_df(read.table("dataset/UCI HAR Dataset/activity_labels.txt"))  
  message( sprintf( "There are %d activity labels in the activity_lables.txt file", nrow(l)))
  for( i in 1:nrow(l))
  { 
    #print(as.character( l[i,2] ))
    activity[activity == i] = as.character( l[i,2] )
  }
  #print(activity)
  activity
}

WriteDatasetWithDescriptiveVariableNames <- function(subject, activity, x, filename, basepath=Global.BasePath)
{
  "reates a second, independent tidy data set with the average of each variable for each activity and each subject."
  cleaned <-  cbind(subject, activity, x)
  
  file <-  file.path(basepath, filename,  fsep = .Platform$file.sep)
  write.table(cleaned, file, sep="\t")
  
 # head(cleaned$x)
  
  cleaned 
}

WriteTidyDataset <- function(cleaned, outputFilename, basepath=Global.BasePath)
{
  "Createing a second, independent tidy data set with the average of each variable for each activity and each subject."
  tidy <- ddply(cleaned, .(subject, activity), numcolwise(mean) )
  
  file <-  file.path(basepath, outputFilename,  fsep = .Platform$file.sep)
  write.table(tidy, file, sep="\t" ,row.names=FALSE )
  
  message("\n-----------------------------------\n printing tidy:")
  #head(tidy, n = 3)
  #tail(tidy)
  print( tbl_df(tidy))
 # tidy
}


