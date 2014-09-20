---
title: Getting and Cleaning Data Course Project
filename: "CodeBook.md"
author: "klashgari"
date: "09/19/2014"
---

#Code Book


#Dataset Description

*Data description* [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )
*Data source:* [UCI Machine Learning repository](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

###For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


###The dataset includes the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.



### Signals Of interest 
The tidy data set extracts only the the mean and standard deviation for each measurement.




# Data Transformation and Clean Up

### Data Transformation Overview
The data set is processed by *run_analysis.R* script.
  

### Data Transformation Steps

#### Merges the training and the test sets to create one data set.

In this step we merge the traing and test data sets and clean the column names.

**Function:** MergeDatasets

**Output of the MergeDatasets function is a list.**


Subject | Activity | X 
------------ | ------------- | -------------
10,299 x 1 | 10,299 x 1 | 10,299 x 561


*Method Signature*
```r
MergeDatasets <- function(basepath=Global.BasePath)
{
 ...
}
```

#### Extracts only the measurements on the mean and standard deviation for each measurement. 

Here we remove columns that are not related to the mean or standard deviation.

**Function:** ExtractMeasurements
**Outputs only the mean and std columns**

*Method Signature* 
```r
ExtractMeasurements <- function(X)
{
...
}
```

#### Uses descriptive activity names to name the activities in the data set
Reads activity_labels.txt and applies descriptive activity names in place of the integer values in the data set

*Method Signature* 
```r
ReplaceActivityNames <-function(activity)
{
  " Replaces activitiy names with descriptive names "
   "Appropriately labels the data set with descriptive variable names. "
   
  " activity lables: "
  "  1 WALKING "
  "  2 WALKING_UPSTAIRS "
  "  3 WALKING_DOWNSTAIRS "
  "  4 SITTING "
  "  5 STANDING "
  "  6 LAYING "
  ...
```

#### Pacakges the appropriately labels the data set with descriptive variable names. 


*Method Signature* 
```r
PacakgeThenWriteCleanedData <- function(subject, activity, x, filename, basepath=Global.BasePath)
{
  "Places the subject, activity and X into a clean vector "
  "Next it write the resulting vector to a file and returns the result"  
  
  ...
}
```

#### Independent tidy data set

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


*Method Signature* 
```r
WriteTidyDataset <- function(cleaned, outputFilename, basepath=Global.BasePath)
{
  "Createing a second, independent tidy data set with the average of each variable for each activity and each subject."
  
...
}
```

Tidy data frame |
----------------
[180 x 81]|

The data set is written to the file 'tidy.txt'







#References 

####Publications
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012