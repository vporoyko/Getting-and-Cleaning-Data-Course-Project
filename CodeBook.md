CODEBOOK for Human Activity Recognition Using Smartphones Dataset.
==================================================================
Project uses data of Human Activity Recognition Using Smartphones Dataset Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.
For more information about this dataset contact: activityrecognition@smartlab.ws

Feature Selection: 
=================
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are:
mean(): Mean value
std(): Standard deviation

R script structure
=================================================
#Download and unzip data file. PC version.
```{r}
Path<-getwd()
#Path <‐ "C:/Users/Valeriy/Programming-R/3 Getting and Cleaning Data"
setwd(Path)
if(!file.exists("./data3")){dir.create("./data3")}
Url <‐ "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./data3/Dataset.zip")
unzip(zipfile="./data3/Dataset.zip",exdir="./data3")
```

#Load packages

```{r}
library(dplyr)
library(tidyr)
library(data.table)
```

#Read Train and Test files from "UCI HAR Dataset" folder.

```{r}
Path <‐ file.path(Path, "data3", "UCI HAR Dataset")
setwd(Path)
# subject files
SubjectTrain <‐ tbl_df(read.table(file.path(Path, "train", "subject_train.txt")))
SubjectTest <‐ tbl_df(read.table(file.path(Path, "test" , "subject_test.txt" )))
# activity files
ActivityTrain <‐ tbl_df(read.table(file.path(Path, "train", "Y_train.txt")))
ActivityTest <‐ tbl_df(read.table(file.path(Path, "test" , "Y_test.txt" )))
# data files.
DataTrain <‐ tbl_df(read.table(file.path(Path, "train", "X_train.txt" )))
DataTest <‐ tbl_df(read.table(file.path(Path, "test" , "X_test.txt" )))

```

#1. Merge the training and the test sets.

```{r}
#merge the training and the test sets by row
allSubjectData <‐ rbind(SubjectTrain, SubjectTest)
setnames(allSubjectData, "V1", "subject")
allActivityData<‐ rbind(ActivityTrain, ActivityTest)
setnames(allActivityData, "V1", "activityNum")
#combine the DATA training and test files
dataTable <‐ rbind(DataTrain, DataTest)
# name variables according to feature 
dataFeatures <‐ tbl_df(read.table(file.path(Path, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <‐ dataFeatures$featureName
#column names for activity labels
activityLabels<‐ tbl_df(read.table(file.path(Path, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
# Merge columns
alldSubjectActivity<‐ cbind(allSubjectData, allActivityData)
dataTable <‐ cbind(alldSubjectActivity, dataTable)

```
#2. Extract only the mean and standard deviation for each measurement.
```{r}
# Reading "features.txt" and extracting only the mean and standard deviation
FeaturesMeanStd <‐ grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) 
# Taking only measurements for the mean and standard deviation and add "subject","activityNum"
FeaturesMeanStd <‐ union(c("subject","activityNum"), FeaturesMeanStd)
dataTable<‐ subset(dataTable,select=FeaturesMeanStd)

```
#3. Descriptive activity names are used to name the activities in the data set
```{r}
##enter name of activity into dataTable
dataTable <‐ merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <‐ as.character(dataTable$activityName)
## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <‐ as.character(dataTable$activityName)
dataAggr<‐ aggregate(. ~ subject ‐ activityName, data = dataTable, mean)
dataTable<‐ tbl_df(arrange(dataAggr,subject,activityName))

```

#4. Appropriately labels the data set with descriptive
#variable names.

```{r}
names(dataTable)<‐gsub("std()", "SD", names(dataTable))
names(dataTable)<‐gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<‐gsub("^t", "time", names(dataTable))
names(dataTable)<‐gsub("^f", "frequency", names(dataTable))
names(dataTable)<‐gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<‐gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<‐gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<‐gsub("BodyBody", "Body", names(dataTable))

```
#5. Create a tidy data set using the average of each variable
#for each activity and each subject.
```{r}

write.table(dataTable, "finalData.txt", row.name=FALSE)

```
