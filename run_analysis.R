library(dplyr)

##Download file from website
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "CourseDataset.zip",mode='wb')
unzip("CourseDataset.zip")
setwd("./UCI HAR Dataset")

##Set file name
y_test <- read.table("./test/y_test.txt", header = F)
y_train <- read.table("./train/y_train.txt", header = F)
x_test <- read.table("./test/X_test.txt", header = F)
x_train <- read.table("./train/X_train.txt", header = F)
subject_test <- read.table("./test/subject_test.txt", header = F)
subject_train <- read.table("./train/subject_train.txt", header = F)

#Set Activity Labels
activity.labels <- read.table("./activity_labels.txt", header = F)

#Set Feature Names
features <- read.table("./features.txt", header = F)

##Merges the training and the test sets to create one data set.
x_total <- rbind(x_train,x_test)
y_total<- rbind(y_train,y_test)
subject_total <- rbind(subject_train,subject_test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
new_features <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total      <- x_total[,new_features[,1]]

#Uses descriptive activity names to name the activities in the data set
colnames(y_total)   <- "activity"
colnames(subject_total) <- "subject"

#Appropriately labels the data set with descriptive variable names.
colnames(x_total)   <- new_features[,2]

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
total_data <- cbind(subject_total, y_total,x_total)
final_data <-aggregate(. ~subject+activity,total_data,mean)
final_data <- final_data[order(final_data$subject, final_data$activity), ]

#Export file as .txt
write.table(final_data, "tidy_data.txt", row.names = FALSE)
