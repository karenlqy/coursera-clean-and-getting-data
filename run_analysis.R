library(plyr)
#Set working directory
setwd("/Users/Karen/Desktop/Coursera /Getting and cleaning data/UCI HAR Dataset/")

# Step 1
# Merge the training and test sets to create one data set
###############################################################################
#Read in training dataset
xtrain = read.table('./train/X_train.txt',header=FALSE) #imports x_train.txt
ytrain = read.table('./train/y_train.txt',header=FALSE) #imports y_train.txt
subject_train <- read.table("train/subject_train.txt")

xtest = read.table('./test/X_test.txt',header=FALSE)
ytest = read.table('./test/y_test.txt',header=FALSE)
subject_test <- read.table("test/subject_test.txt")

x_data<-rbind(xtrain,xtest)
y_data<-rbind(ytrain,ytest)

subject_data<-rbind(subject_train,subject_test)
# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################
#Read in label names and feature names
labels <- read.table("./activity_labels.txt")
labels[,2]<-as.character(labels[,2])
features <- read.table("./features.txt")
features[,2]<-as.character(features[,2])

featuresWanted <- grep("-(mean|std)\\(\\)", features[,2])

x_data<-x_data[,featuresWanted]
names(x_data)<-features[featuresWanted,2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################
y_data[,1]<-labels[y_data[,1],2]
names(y_data)<-"activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
