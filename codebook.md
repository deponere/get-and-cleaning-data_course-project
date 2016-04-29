#The Codebook for the data adjustment process
This codebook describes the steps and functions to come to the datasets asked in the Assesmnet.

Please note: The code uses the library from dplyr and plyr

##function loadData
This function reads the named file from the web an stores it locally for faster/better usage of the information process
it only reads the data if the file does not exist. It returns a timestamp if it has read it or a commnt if it has found one on disk already
Please note: The directory .data is created if missing

##function readFiles
In this function the information is stored in local variables. The files are extracted on demand from the .zip file and returned as a data.frame
The function takes one arguments to specify whether the train or test data is read from the .zip file
Also it add the column names from the features file, which was read in in the main script.
the first two columns are named based on the description to "Subject" and "Activity", so all columns have descriptions
It returns a data.frame corresponding to the data in the .zip file with the right column lables.

##main script flow
reading the activity lables first and stroe it in activitaLabel-variable
### Question 1)
using rbind to combind the test and train information loaded with the function readFiles
Store the result in Ask1 as data.frame *(Merges the training and the test sets to create one data set)*

### Question 2)
Next we use the function grep to find in the columnnames the "mean" and "std" to construct a new data.frame 
only with the mean and standard deviation the result will be sorted and put in the variable Ask2 as a data.frame
*(Extracts only the measurements on the mean and standard deviation for each measurement)*

###Question 3)
Next we change the Activity numbers with the descriptions read from the file and stored already in the variable activityLabels
The result is stored in Ask3 as a data.frame
*(Uses descriptive activity names to name the activities in the data set)*

##Question 4)
Next we copy the Ask3 data.frame to Ask4.as a data.frame, because we already have gave it in the first step the descriptive column names for easier of use
*(Appropriately labels the data set with descriptive variable names)*

##Question 5)
Next we leverage the ddply function to *group* the dataframe and calculate the means column wise for each activity. 
the result are 30 objects with 6 activities and result in a data.frame with 180 obs. and 563 columns
we store that in Ask5 as a data.frame
*(From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject)*

Last we save Ask1-Ask5 to sidk as .csv for further coding
