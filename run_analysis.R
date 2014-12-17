library(data.table)
library(dplyr)
library(reshape2)

#Download the data (if required)

if (!file.exists("gettingdata.zip")) {
   download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                 destfile="gettingdata.zip")
}

#Extract the data

unzip("gettingdata.zip",files=c("UCI HAR Dataset/train/X_train.txt",
                                "UCI HAR Dataset/test/X_test.txt",
                                "UCI HAR Dataset/features.txt",
                                "UCI HAR Dataset/test/subject_test.txt",
                                "UCI HAR Dataset/train/subject_train.txt",
                                "UCI HAR Dataset/train/y_train.txt",
                                "UCI HAR Dataset/test/y_test.txt",
                                "UCI HAR Dataset/activity_labels.txt"),
      junkpaths=T)

#load the train data
train <- read.table("x_train.txt")

#Add subject ids
ids <- read.table("subject_train.txt")
train$subject <- ids$V1

#Add activity ids
activities <- read.table("y_train.txt")
train$activityId <- activities$V1

#Repeat for the test data
test <- read.table("x_test.txt")
ids <- read.table("subject_test.txt")
test$subject <- ids$V1
activities <- read.table("y_test.txt")
test$activityId <- activities$V1

#Tidy up a bit
rm("ids")
rm("activities")

#Combine the data
combined <- rbind(train,test)

#Tidy up
rm("test")
rm("train")

#Load headers
headers <- read.table("features.txt")

#Turns out we have some duplicates that need renaming
#Let's add the row number to the label for now
headers <- mutate(headers,name=paste0(V1,"_",V2))

#Add descriptive column headers
colnames(combined) <- c(headers$name,"subject","activityId")

#Apply descriptive activity labels
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("activityId","activity")
combined <- merge(combined,activity_labels,by="activityId")

#Tidy up
rm("headers")
rm("activity_labels")

#Extract the columns we want
msd <- select(combined,subject,activity,contains("mean()"),contains("std()"))

#Tidy Up
rm("combined")

#Revert to original column headers as we have got rid of the duplicates
colnames(msd) <- sub("\\d*_","",colnames(msd))

#Melt the data

#Get the list of names we want to use for the measure
vars <- setdiff(names(msd),c("subject","activity"))

msdMelt <- melt(msd,id=c("subject","activity"),measure.vars=vars)

#Group by subject, activity, variable & add the mean
tidy <- summarize(group_by(msdMelt,subject,activity,variable),mean=mean(value))

#Write out the tidy data
write.table(tidy,file="tidy.txt",row.names=F)
