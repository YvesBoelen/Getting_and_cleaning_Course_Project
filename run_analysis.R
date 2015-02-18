
# Read the README.txt file
# wd = G:/Yves/Data_Science/R_home_directory/03_Getting_cleaning_data/UCI_HAR_Dataset/

###############################################################################################
# 1. merge the training and test set to create one data set
###############################################################################################

# Read the list of all features into table features
# We then only select the second column as the vector with all the column names, 
# needed for the training and test set

features <- read.table("features.txt")
kolomnames_temp1 <- as.vector(features[,2])

# We tidy up the columnames by replacing the - and , signs by underscores
# Furthermore, we remove the ( and ) signs

kolomnames_temp2 <- gsub("-","_",kolomnames_temp1)
kolomnames_temp3 <- gsub(",","_",kolomnames_temp2)
kolomnames_temp4 <- gsub("(","",kolomnames_temp3, fixed = TRUE)
kolomnames       <- gsub(")","",kolomnames_temp4, fixed = TRUE)

# We clean the global environment by removing the temporary variables
rm("kolomnames_temp1","kolomnames_temp2","kolomnames_temp3","kolomnames_temp4")


# Read the training and test data set, as described in the README.txt file
# train/X_train.txt': Training set.
# test/X_test.txt': Test set.

train <- read.table("./train/X_train.txt")
test <- read.table("./test/X_test.txt")

# Read in the labels associated with the test and training data 

train_label <- read.table("./train/Y_train.txt")
test_label <- read.table("./test/Y_test.txt")

# we attach the labels to the test and training data

train_data <- cbind(train_label,train)
test_data <- cbind(test_label,test)

# Merge the training and the test sets to create one data set.
# Columnnames are extracted from features.txt. The first column is the activity
# (= task4 "Appropriately label the data set with descriptive variable names")

all_data <- rbind(train_data,test_data)
colnames(all_data) <- c("activity",kolomnames)

# we clean the global environment by removing some temporary data
rm("train_data","test_data")

# Join the activity labels to the all_data dataset
# (= task3 "Use descriptive activity names to name the activities in the data set")

activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("activity","activity_label")
all_data_withlabels <- merge(activity_labels,all_data, by.x = "activity", by.y = "activity")


###############################################################################################
# 2. Extract only the measurements on the mean and the standard deviation for each measurement
###############################################################################################

# keep only the mean and std variables, not the meanfreq or angle variables!!!

features_mean_or_std <- subset(features, (grepl("mean",tolower(features$V2)) == TRUE | 
                                          grepl("std",tolower(features$V2)) == TRUE) &
                                          grepl("meanfreq",tolower(features$V2)) == FALSE &
                                          grepl("angle",tolower(features$V2)) == FALSE)
mean_or_std_names_temp1 <- as.vector(features_mean_or_std[,2])

# We tidy up the columnames by replacing the - and , signs by underscores
# Furthermore, we remove the ( and ) signs

mean_or_std_names_temp2 <- gsub("-","_",mean_or_std_names_temp1)
mean_or_std_names_temp3 <- gsub(",","_",mean_or_std_names_temp2)
mean_or_std_names_temp4 <- gsub("(","",mean_or_std_names_temp3, fixed = TRUE)
mean_or_std_names       <- gsub(")","",mean_or_std_names_temp4, fixed = TRUE)

# We clean the global environment by removing the temporary variables
rm("mean_or_std_names_temp1","mean_or_std_names_temp2",
   "mean_or_std_names_temp3","mean_or_std_names_temp4")

# Starting from the dataset from step 1, only the mean and std variables are kept, together
#       with the activity and its label
keeps <- c("activity","activity_label",mean_or_std_names)
data_mean_or_std <- all_data_withlabels[,names(all_data_withlabels) %in% keeps]

# We clean the global environment by removing some temporary data and variables
rm("all_data", "all_data_withlabels","features", "features_mean_or_std", "keeps")

###############################################################################################
# 3. Use descriptive activity names to name the activities in the data set
###############################################################################################

# already done...

###############################################################################################
# 4. Appropriately label the data set with descriptive variable names
###############################################################################################

# already done...

###############################################################################################
# 5. Create a second, independent tidy data set with the average of each variable 
#      for each activity and each subject
###############################################################################################

# Read subject data: each row identifies the subject who performed the activity for each 
#       window sample
subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

# we combine subject, activity label and feature info
train_tidy_data <- cbind(subject_train, train_label, train)
test_tidy_data <- cbind(subject_test, test_label, test)

# test and training data set are put together, with its columnnames
all_tidy_data <- rbind(train_tidy_data ,test_tidy_data)
colnames(all_tidy_data) <- c("subject", "activity", kolomnames)

# activity information is merged with the last retrieved dataset
tidy_data_withlabels <- merge(activity_labels,all_tidy_data, by.x = "activity", by.y = "activity")

# only the mean and std variables are kept, together with the activity and its label
keeps_tidy <- c("subject", "activity","activity_label",mean_or_std_names)
tidy_data_mean_or_std <- tidy_data_withlabels[,names(tidy_data_withlabels) %in% keeps_tidy]

# We clean the global environment by removing most of the temporary data and variables
rm("subject_test", "subject_train","train_label", "test_label", "train", "test",
   "all_tidy_data", "tidy_data_withlabels", "keeps_tidy", "activity_labels",
   "train_tidy_data", "test_tidy_data", "data_mean_or_std", "kolomnames",
   "mean_or_std_names")

# The final tidy data set is created with the average of each variable 
#     for each activity and each subject

library(plyr)
results_grp_subject_activity <- ddply(tidy_data_mean_or_std, .(subject, activity, activity_label), colwise(mean))

# upload the data set as a ; delimited txt file  

write.table(results_grp_subject_activity,
            file = "./Getting_cleaning_tidy_dataset.txt",
            sep = ";",
            row.name=FALSE)
