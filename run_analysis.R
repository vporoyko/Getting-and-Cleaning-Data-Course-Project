Path<-getwd()
#Path <‐ "C:/Users/Valeriy/Programming-R/3 Getting and Cleaning Data"
setwd(Path)
if(!file.exists("./data3")){dir.create("./data3")}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./data3/Dataset.zip")
unzip(zipfile="./data3/Dataset.zip",exdir="./data3")

library(dplyr)
library(tidyr)
library(data.table)

Path <- file.path(Path, "data3", "UCI HAR Dataset")
setwd(Path)
# subject files
SubjectTrain <- tbl_df(read.table(file.path(Path, "train", "subject_train.txt")))
SubjectTest <- tbl_df(read.table(file.path(Path, "test" , "subject_test.txt" )))
# activity files
ActivityTrain <- tbl_df(read.table(file.path(Path, "train", "Y_train.txt")))
ActivityTest <- tbl_df(read.table(file.path(Path, "test" , "Y_test.txt" )))
# data files.
DataTrain <- tbl_df(read.table(file.path(Path, "train", "X_train.txt" )))
DataTest <- tbl_df(read.table(file.path(Path, "test" , "X_test.txt" )))

#merge the training and the test sets by row
allSubjectData <- rbind(SubjectTrain, SubjectTest)
setnames(allSubjectData, "V1", "subject")
allActivityData<- rbind(ActivityTrain, ActivityTest)
setnames(allActivityData, "V1", "activityNum")
#combine the DATA training and test files
dataTable <- rbind(DataTrain, DataTest)
# name variables according to feature 
dataFeatures <- tbl_df(read.table(file.path(Path, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName
#column names for activity labels
activityLabels<- tbl_df(read.table(file.path(Path, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
# Merge columns
alldSubjectActivity<- cbind(allSubjectData, allActivityData)
dataTable <- cbind(alldSubjectActivity, dataTable)

# Reading "features.txt" and extracting only the mean and standard deviation
FeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) 
# Taking only measurements for the mean and standard deviation and add "subject","activityNum"
FeaturesMeanStd <- union(c("subject","activityNum"), FeaturesMeanStd)
dataTable<- subset(dataTable,select=FeaturesMeanStd)

##enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)
## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean)
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

#Appropriately labels the data set with descriptive variable names.

names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

# Create a tidy data set 
write.table(dataTable, "finalData.txt", row.name=FALSE)
