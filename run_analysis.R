#Project:Coursera get-data
#Author: Al Acosta
#
#Description: The purpose of this project is to demonstrate your ability to collect, work with, 
#             and clean a data set. 
#             The goal is to prepare tidy data that can be used for later analysis.
#Code: run_analysis.R
#The code performs the following as defined in the final project:
#0. Setup environment and Extract data
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#   each activity and each subject.

#0. Setup environment and Extract data
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")  
}
if (!require("dplyr")) {
  install.packages("dplyr")  
}

require("data.table")
require("reshape2")
require("dplyr")

# set the URL location
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
subFolder <-"./UCI HAR Dataset" #Subdirectory location of txt and csv files
# Local data file
ZIPFile <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"


# filename o the clean/tidy data
tidyDataFile <- "./tidy-UCI-HAR-dataset1.txt"
# filename of the clean/tidy data (average)
tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG1.txt"

# Check if zip file exist. If none existent download the file
if (file.exists(ZIPFile) == FALSE) {
  download.file(fileURL, destfile = ZIPFile)
}

# Unzip the file
if (file.exists(subFolder) == FALSE) {
  unzip(ZIPFile)
}

#read features
# Read features labels
features <- read.table("./UCI HAR Dataset/features.txt")

#read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Extract only the measurements on the mean and standard deviation for each measurement.
#extract_features <- grepl("mean|std", features)


## 1. Merges the training and the test sets to create one data set.
## Get the train data (x,y,subject)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)


## Get the test data (x,y,subject)
#x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
#y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
#subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)


# Combine train vs test by rows for x,y and subject
#xfile <- rbind(x_train, X_test)
#yfile <- rbind(y_train, y_test)
#subjectfile <- rbind(subject_train, subject_test)
#Read file and combine for x,y and subject
xfile <- rbind(read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE), 
               read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE))
yfile <- rbind(read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE),
               read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE))
subjectfile <- rbind(read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE),
                     read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE))


#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Friendly names tos column
features <- rename(features, feat_id = V1, feat_name = V2)

# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
#index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
#extract_features <- grepl("mean|std", features)

extract_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
xfile  <- xfile[, extract_features] 
# Replaces all matches of a string features 
names(xfile) <- gsub("\\(|\\)", "", (features[extract_features, 2]))

#3. Uses descriptive activity names to name the activities in the data set

#4. Appropriately labels the data set with descriptive variable names. 
# Friendly names to activities column
#names(activity_labels) <- c('act_id', 'act_name')
activity_labels <- rename(activity_labels, act_id = V1, act_name = V2)
yfile[, 1] = activity_labels[yfile[, 1], 2]

names(yfile) <- "Activity"
names(subjectfile) <- "Subject"


# Combines data table by columns
tidyDataSet <- cbind(subjectfile, yfile, xfile)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#   each activity and each subject.
p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"


# Write csv (tidy data set) file
write.table(tidyDataSet, tidyDataFile,row.name=FALSE)
# Write csv (tidy data set) file
write.table(tidyDataAVGSet, tidyDataFileAVGtxt,row.name=FALSE)