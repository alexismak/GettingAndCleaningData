# README 

## Background
The data is available at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
  
The aim of this project is to clean and process the dataset to extract only the required data, by performing the following:
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names. 
- Create a second, independent tidy data set with the average of each variable for each activity and each subject.
    
In [this repository](https://github.com/alexismak/GettingAndCleaningData), you will find:

1. [run_analysis.R](https://github.com/alexismak/GettingAndCleaningData/blob/main/run_analysis.R) : the R-code run on the data set

2. [tidyData.txt](https://github.com/alexismak/GettingAndCleaningData/blob/main/tidyData.txt) : the clean data extracted from the original data using run_analysis.R

3. [CodeBook.md](https://github.com/alexismak/GettingAndCleaningData/blob/main/CodeBook.md) : file describing the variables, the data, and steps followed to clean up the data

4. [README.md](https://github.com/alexismak/GettingAndCleaningData/blob/main/README.md) : file explaining the analysis files



## Analysis file explained

### Working directory
The run_analysis.R file assumes that the dataset has been extracted and the working directory is set to "getdata_projectfiles_UCI HAR Dataset"

### Libraries
The libraries used are data.table and dplyr. 
- data.table efficiently handles large data as tables. 
- dplyr is used to aggregate variables to create the tidy data.
```
library(data.table)
library(dplyr)
```
### Read data
#### Reading feature names and activity labels
```
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
```

#### Reading training data (subject, activity, features)
```
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
```
#### Reading test data (subject, activity, features)
```
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE)
```

### Merge data to create one dataset
#### Merge train and test data into `subject` `activity` `features`
```
subject <- rbind(subjectTrain,subjectTest)
activity <- rbind(activityTrain,activityTest)
features <- rbind(featuresTrain,featuresTest)
```
#### Name columns
- features columns named from feature names
- activity and subject columns named Activity and Subject
```
colnames(features) <- t(featureNames[2])
colnames(activity) <- c("Activity")
colnames(subject) <- c("Subject")
```

#### Merge all data ( `subject`, `activity`, `features`) into `dataMerged`
```
dataMerged <- cbind(features,activity,subject)
```

### Extract only mean and standard deviation of each measurement
#### Get names of columns with only mean and std in their name
```
clMeanStd <- grep("mean|std",names(dataMerged),ignore.case = TRUE)
```
#### Include the above but also activity and subject in `selectedColumns`
```
selectedColumns <- c(clMeanStd,562,563)
```
#### Get the selected data based on `selectedColumns` 
```
selectedData <- dataMerged[,selectedColumns]
```

### Use descriptive names for activities
- names are taken from `activityLabels`
```
selectedData$Activity <- as.character(selectedData$Activity)
for (i in 1:6) {
  selectedData$Activity[selectedData$Activity==i] <- as.character(activityLabels[i,2])
}
```

### Appropriately label data set with descriptive variable names
- correcting abbreviations 
- changing first letter to capital
```
names(selectedData) <- gsub("BodyBody","Body",names(selectedData))
names(selectedData) <- gsub("Acc","Accelerometer",names(selectedData))
names(selectedData) <- gsub("Gyro","Gyroscope",names(selectedData))
names(selectedData) <- gsub("Mag","Magnitude",names(selectedData))
names(selectedData) <- gsub("^t","Time",names(selectedData))
names(selectedData) <- gsub("tBody","TimeBody",names(selectedData))
names(selectedData) <- gsub("^f","Frequency",names(selectedData))
names(selectedData) <- gsub("gravity","Gravity",names(selectedData))
names(selectedData) <- gsub("-mean","Mean",names(selectedData))
names(selectedData) <- gsub("angle","Angle",names(selectedData))
names(selectedData) <- gsub("-std","STD",names(selectedData))
```

### Create a second tidy data set with the average of each variable for each activity and subject

#### Make `Activity` and `Subject` factor variables
```
selectedData$Activity <- as.factor(selectedData$Activity)
selectedData$Subject<- as.factor(selectedData$Subject)
```
#### Create `tidyData` with average for each activity and subject
```
selectedData <- data.table(selectedData)
tidyData` <- aggregate(. ~ Activity+Subject,selectedData,mean)
```

#### Order `tidyData` according to `Subject` and `Activity` 
```
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
```
#### Save `tidyData` into `tidyData.txt` file
```
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)
```
