library(data.table)
library(dplyr)

## Downloading and extracting the zip files
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
zipdf <- unzip(temp, list = TRUE)


#reading the activity label and features table
features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
activity_label <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))

#reading the test data
subject_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
X_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))

#reading the training data
subject_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
X_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))

#binding the X and Y
X<-rbind(X_test, X_train)
Y<-rbind(y_test, y_train)
Subject<-rbind(subject_test, subject_train)

#Uses descriptive activity names to name the activities in the data set
Y[,1] <- activity_label[Y[,1],2]

#changing the variable names of columns 
names(X) <- features[,2]
names(Y) <- "activity"
names(Subject) <- "SubjectID"


index<-grep("mean\\(\\)|std\\(\\)", features[,2])
X<-X[,index] ## getting only variables with mean/stdev


FinalData<-cbind(Subject, Y, X) ## combining the dataset

## features average by Subject and by activity
FinalData<-data.table(FinalData)
FinalTidyData <- FinalData[, lapply(.SD, mean), by = 'SubjectID,activity'] 


unlink(temp)