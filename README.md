In order to start well with this course project, the readme file - related to the UCI Har Dataset - was read carefully.

1) Merge the training and test set to create one data set

First, all 561features (features.txt) were collected into the dataset features. A vector kolomnames_temp1 with all the column names was made. This vector was tidied up, because the column names contained symbols like - , ( and ). The vector kolomnames is the vector with proper feature names. The temporary column names vectors were afterwards removed from the global environment, as they were not needed anymore.

Secondly, the training (X_train.txt) and test (X_test.txt) dataset were read, together with their labels (Y_train.txt and Y_test.txt). The data and labels were put together, resulting in datasets train_data and test_data. Then, the training and test dataset were merged together into the dataset all_data. The kolomnames vector, made earlier, was used for the feature variable names. 

Thirdly, the activity labels (activity_labels.txt) were merged with the all_data dataset, resulting in the dataset all_data_withlabels.

2) Extract only the measurements on the mean and the standard deviation for each measurement

Starting from all features in step 1, only the mean and standard deviation variables were kept. The meanfreq and angle features (which contain the substring mean) were not taken into account for the selected features dataset features_mean_or_std. Then again, a vector was made and cleaned up, as described earlier in step 1. This results in a tidied up vector mean_or_std_names, containing 66 features.

Using the same methodology as in step 1, a dataset all_data_withlabels was created. Difference with step 1 is that it now only contains features related to mean or standard deviation measures.

Please note that steps3&4 (step3: “Use descriptive activity names to name the activities in the data set”, step4: “Appropriately label the data set with descriptive variable names”) are already covered in steps 1&2.

5) Create a second, independent tidy data set with the average of each variable for each activity and each subject

Both subject data sets (subject_test.txt  and subject_train.txt) were read. They were combined on a row-by-row level with the feature data and the activity label data, resulting into datasets train_tidy_data and test_tidy_data. Then test and training data set are put together, with its columnnames resulting in dataset all_tidy_data. R Code from step 4 has been re-used in order to keep only mean and standard deviation features.

After removing many datasets and vectors from the global environment, the final tidy data set ‘tidy_data_mean_or_std’ was created. 

Finally, the results with the average of each variable for each activity and each subject was extracted and stored into the dataset results_grp_subject_activity. This dataset contains 180 observations: 6 activities for all of the 30 subjects.
This last dataset was stored as a ; separated text file.

Note that the R script was written step by step. This script could most probably have been written shorter and more efficiently. Although knowing this, I hope that the result is what was expected.
