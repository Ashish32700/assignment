# Load required libraries
library(dplyr)

# Check if the dataset is available, otherwise download and unzip it
if (!file.exists("./UCI HAR Dataset")) {
  temp <- tempfile()
  download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip", temp)
  unzip(temp)
  unlink(temp)
}

# Step 1: Merge the training and test sets into one dataset
# Read features and activity labels
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Read training data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Read test data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merge training and test sets
merged_data <- bind_rows(train_data, test_data)
merged_activity <- bind_rows(train_activity, test_activity)
merged_subject <- bind_rows(train_subject, test_subject)

# Step 2: Extract mean and standard deviation measurements
selected_columns <- grep("mean\\(\\)|std\\(\\)", features$functions)
extracted_data <- merged_data[, selected_columns]

# Step 3: Use descriptive activity names
merged_activity$activity <- factor(merged_activity$activity, levels = activity_labels$code, labels = activity_labels$activity)
names(merged_activity) <- "activity"

# Step 4: Label the dataset with descriptive variable names
names(extracted_data) <- features[selected_columns, "functions"]

# Step 5: Create a tidy dataset with the average of each variable for each activity and each subject
tidy_data <- cbind(merged_subject, merged_activity, extracted_data) %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# Write the tidy dataset to a file (optional)
write.table(tidy_data, file = "tidy_dataset.txt", row.names = FALSE)
