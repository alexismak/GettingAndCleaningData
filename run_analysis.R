library(data.table)
library(dplyr)
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
# Read training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
# Read test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE)

## 1 Merges the training and the test sets to create one data set.
# binding together
subject <- rbind(subjectTrain,subjectTest)
activity <- rbind(activityTrain,activityTest)
features <- rbind(featuresTrain,featuresTest)
# column names
colnames(features) <- t(featureNames[2])
colnames(activity) <- c("Activity")
colnames(subject) <- c("Subject")
# merge data
dataMerged <- cbind(features,activity,subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

clMeanStd <- grep("mean|std",names(dataMerged),ignore.case = TRUE)
selectedColumns <- c(clMeanStd,562,563)
selectedData <- dataMerged[,selectedColumns]

## 3. Uses descriptive activity names to name the activities in the data set
selectedData$Activity <- as.character(selectedData$Activity)
for (i in 1:6) {
  selectedData$Activity[selectedData$Activity==i] <- as.character(activityLabels[i,2])
}



## 4. Appropriately labels the data set with descriptive variable names. 

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


## 5. From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable for each activity and each subject.
selectedData$Activity <- as.factor(selectedData$Activity)
selectedData$Subject<- as.factor(selectedData$Subject)

selectedData <- data.table(selectedData)
tidyData <- aggregate(. ~ Activity+Subject,selectedData,mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)


