# Code Book

## Data
The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the data contains 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data was downloaded from:

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
 
The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

## Variables

Each record contains:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Input data-set

The data-set includes the following:
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels (activities corresponding to the training set).
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels (activities corresponding to the test set).
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
 
## Transformations

- features.txt is read into featureNames.
- activity_labels.txt is read into activityLabels.
- subject_train.txt is read into subjectTrain.
- y_train.txt is read into activityTrain.
- X_train.txt is read into featuresTrain.
- subject_test.txt is read into subjectTest.
- y_test.txt is read into activityTest.
- X_test.txt is read into featuresTest.

- subjectTrain and subjectTest are merged into subject
- activityTrain and activityTest are merged into activity
- featuresTrain and featuresTest are merged into features
- column names of features are named according to featureNames
- column names of activity and subject are named "Activity" and "Subject"
- features, activity and subject are merged into dataMerged

- clMeanStd extracts column names of only measurements of mean and standard deviation for each measurement
- selectedColumns uses only clMeanStd, "Activity" and "Subject"
- selectedData extracts only data based on selectedColumns

- Activity column in selectedData is updated with descriptive activity names to name the activities in the dataset

- variable names in selectedData are renamed and acronyms are replaced with descriptive names 

- Activity and Subject columns are expressed as factor variables
- tidyData is created with average for each activity and subject 
- tidyData is written into tidyData.txt




