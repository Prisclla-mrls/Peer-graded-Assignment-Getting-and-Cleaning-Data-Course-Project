library(data.table)
library(dplyr)
setwd <-("C:/Users/Priscilla Morales/Documents/Coursera")

filename <- "Coursera_DS3_Final.zip"

# Does archive exists?
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="libcurl")
}  

# Does folder exists?
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

#assigning data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merge data sets

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# Extract mean and std dev for each measurement
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#naming
TidyData$code <- activities[TidyData$code, 2]

# Group by avg and subject
FinalData <- TidyData %>%
  group_by(subject, code) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)

#print final data
FinalData