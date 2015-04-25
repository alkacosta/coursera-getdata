#CodeBook.md
# Code Book #

This file describes what the project is all about, original datasource, variables, files, and transformations that have been performed to clean up the data.

----------
# Experiment#
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set (Course project for Coursera's Getting and Cleaning Data) . The goal is to prepare tidy data that can be used for later analysis. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

The “Human Activity Recognition Using Smartphones Dataset” consists of wearable computing recordings from 30 participants. Each person performed six activities (*WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING*) wearing a smartphone. The activity was manually labeled. The obtained dataset has been partitioned into two sets: *training and data*.

**Variables**

The acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ). Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. The angular velocity vector measured by the gyroscope are radians/second. The data was already normalized and bounded within [-1,1]

 Where are set of variables that were estimated from these signals:


- **mean()**: Mean value
- **std()**: Standard deviation
- **mad()**: Median absolute deviation
- **max()**: Largest value in array
- **min()**: Smallest value in array and more


So for example variable tBodyAcc-mean()-Z is "normalized mean body acceleration on Z axis in certain time window"

**Data source**

 A full description is available at the site where the data was obtained: 

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

Here are the data for the project: 

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )

**Files**

Files in consideration:

Main 561-feature vector with time and frequency domain variables

- **'/UCI HAR Dataset/train/X_train.txt'**: Training set.
- **'/UCI HAR Dataset/ test/X_test.txt'**: Test set.

Activity labels.

- **'/UCI HAR Dataset/train/y_train.txt'**: Training labels.
- **'/UCI HAR Dataset/test/y_test.txt'**: Test labels.

An identifier of the subject who carried out the experiment.

- **'/UCI HAR Dataset/train/subject_train.txt'**: Each row identifies the subject who performed the activity
- **'/UCI HAR Dataset/test/subject_test.txt'**

List of all features.

- **'features.txt'**

Links the class labels with their activity name.

- **'activity_labels.txt'**

**Project Steps**

Created a R script called **run_analysis.R** that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


**Cleanup work**

Below discusses (and provided pseudo-code) explaining each steps. Please see run_analysis.R script for full source code

**Merges the training and the test sets to create one data set.**


I merged training and test data as
   
`xfile <- rbind(read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE),             `
`               read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE))               `
`yfile <- rbind(read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE),             `
`               read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE))               `
`subjectfile <- rbind(read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE), ` 
`                     read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE))   `



**Extracts only the measurements on the mean and standard deviation for each measurement.**

`features <- rename(features, feat_id = V1, feat_name = V2)`

**Search for matches to argument mean or standard deviation (sd)  within each element of character vector**

`extract_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name)`
`xfile  <- xfile[, extract_features]` 

Replaces all matches of a string features 
`names(xfile) <- gsub("\\(|\\)", "", (features[extract_features, 2]))`

**Uses descriptive activity names to name the activities in the data set**
`features <- rename(features, feat_id = V1, feat_name = V2)`

**Appropriately labels the data set with descriptive variable names. **
`activity_labels <- rename(activity_labels, act_id = V1, act_name = V2)`
`names(yfile) <- "Activity"`
`names(subjectfile) <- "Subject"`

**Combined all tidy’d data.**
`tidyDataSet <- cbind(subjectfile, yfile, xfile)`

**Aggregation**
Aggregated the data to get the average for each activity and each subject.
`tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)`

<B>Result</B>

Generated the file that calculates the mean and std for each combination of subject (person) and activity (walking, sitting etc).
