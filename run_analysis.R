# Programming Assignment 
# Getting and Cleaning Data Course Project
# Task:
#the purpose of this project is to demonstrate your ability to collect, 
#work with, and clean a data set. The goal is to prepare tidy data that 
#can be used for later analysis. You will be graded by your peers on a 
#series of yes/no questions related to the project. You will be required 
#to submit: 1) a tidy data set as described below, 2) a link to a Github
#repository with your script for performing the analysis, and 3) a code 
#book that describes the variables, the data, and any transformations or 
#work that you performed to clean up the data called CodeBook.md. 
#You should also include a README.md in the repo with your scripts. 
#This repo explains how all of the scripts work and how they are connected.

#One of the most exciting areas in all of data science right now is wearable 
#computing - see for example this article . Companies like Fitbit, Nike, 
#and Jawbone Up are racing to develop the most advanced algorithms to 
#attract new users. The data linked to from the course website represent 
#data collected from the accelerometers from the Samsung Galaxy S smartphone. 
#A full description is available at the site where the data was obtained:
        
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
        
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#1)Merges the training and the test sets to create one data set.
#2)Extracts only the measurements on the mean and standard deviation 
#        for each measurement.
#3)Uses descriptive activity names to name the activities in the data set
#4)Appropriately labels the data set with descriptive variable names.
#5)From the data set in step 4, creates a second, independent 
#        tidy data set with the average of each variable for each 
#        activity and each subject.

library(dplyr)
library(plyr)
# The Place where to store the data
DestinationFile = "./data/DataSet.zip"

# function loadData:
# Load the data from the URL and saves the Zip file locally that it can be read faster
# Returns a timestamp if re-read or a notice that the local file is used
# To initiate the re-read delete the local file

loadData <- function (){
        url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"       
        if(!file.exists("./data")) {
                dir.create("./data")
        }
        if (file.exists(DestinationFile)) return("File not downloaded again")
        download.file(url,destfile=DestinationFile)
        return(timestamp())
        
}

# Function readFiles
# This function reads the file from thge local .zif file, unzips and add descriptions
# it returns a DataFrame with the test or train data, and the columns are
# adjusted to the corresponding file

readFiles <- function(filename) {
        print(paste("Reading" , filename))
        X = paste("UCI HAR Dataset/",filename,"/X_",filename,".txt",sep="")
        Y = paste("UCI HAR Dataset/",filename,"/y_",filename,".txt",sep="")
        S = paste("UCI HAR Dataset/",filename,"/subject_",filename,".txt",sep="")
        tX <- read.table(unz(DestinationFile,X))
        tY <- read.table(unz(DestinationFile,Y))
        subject<- read.table(unz(DestinationFile,S))
        # Adjust DF 
        colnames(tX) <- features$Description
        
        t <- data.frame(subject$V1,tX)
        names(t)[1]<-paste("Subject")
        t <- data.frame(tY$V1,t)
        names(t)[1]<-paste("Activity")
        t["Type"] <- filename
        return(t)
}

# main procedure
setwd("~/CloudStation/Data Scientist/Getting and Cleaning Data/Assignment/")
downloadDate <- loadData()
# after download, we read the activity Labels used for ask 4
print("Reading activity Labels")
activityLabels <- read.table(unz(DestinationFile, "UCI HAR Dataset/activity_labels.txt"))
colnames(activityLabels) <- c("Index", "Description")
features <- read.table(unz(DestinationFile,"UCI HAR Dataset/features.txt"))
colnames(features) <- c("Index", "Description")
# Here w fullfil question 1 and put the result in Ask1
# it reads train and test information in, adds description to the columns and
# binds it together
Ask1 <- rbind(readFiles("train"),readFiles("test"))
print(" Ask 1 is done....")
# Here is Ask2 where we selet all the columns with mean and standard deviation 
# result is in Ask2
IndexMeanStd <- sort(c(grep("mean", names(Ask1), ignore.case=T),grep("std", names(Ask1), ignore.case=T)))
Ask2 <- Ask1[IndexMeanStd]
print(" Ask 2 is done....")
# Here Ask 3 we change the numbers to the activity description and stor it in Ask3
Ask3 <- Ask1
s <- Ask3$Activity
Activity <- activityLabels$Description[s]
Ask3$Activity <- NULL
Ask3 <- data.frame(Activity,Ask3)
print(" Ask 3 is done....")
# Ask4 is done already in Ask1 since we put labels in the first place to 
#have an easier going
Ask4 <- Ask3 #Was done already in Ask1
print(" Ask 4 is done....")
#5)From the data set in step 4, creates a second, independent 
#        tidy data set with the average of each variable for each 
#        activity and each subjectstr()
# here we group and calculate the mean in columns in one step the result will be
# stored in Ask5 the result is 180 obs with 563 variables in two groups with 
# groping 1 has 30 and group 2 has 6 levels
Ask5 <- ddply(Ask4, .(Subject,Activity), numcolwise(mean))
print(" Ask 5 is done....")
write.csv(Ask1,"./data/ask1.csv")
write.csv(Ask2,"./data/ask2.csv")
write.csv(Ask3,"./data/ask3.csv")
write.csv(Ask4,"./data/ask4.csv")
write.csv(Ask5,"./data/ask5.csv")
print("All file are written to disk... Task done....")
