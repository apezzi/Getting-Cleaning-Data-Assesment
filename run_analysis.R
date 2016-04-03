#Step 1
#creates tables for the train set and it´s labels and subjects

train<-read.table("./Dataset/train/X_train.txt")
trainlabels<-read.table("./Dataset/train/y_train.txt")
trainsubjects<-read.table("./Dataset/train/subject_train.txt")
  
#creates tables for the test set and it´s labels and subjects
test<-read.table("./Dataset/test/X_test.txt")
testlabels<-read.table("./Dataset/test/y_test.txt")
testsubjects<-read.table("./Dataset/test/subject_test.txt")

#merges test and training set in one table
fullset<-rbind(train,test)
#merges test and training labels in one table
labels<-rbind(trainlabels,testlabels)
#merges test and training labels in one tablesubject
subjects<-rbind(trainsubjects,testsubjects)


#Step 2
#read the features
features <- read.table("./Dataset/features.txt")
#get indexes where the features  match mean() and std()
indexes<-grep("mean\\(\\)|std\\(\\)", features[, 2])
#recreates fullset only for the matching std and mean features
fullset<-fullset[,indexes]
#change the fullset names to the selected features
names(fullset) <- gsub("\\(\\)", "", features[indexes, 2])


#Step 3
activity <- read.table("./Dataset/activity_labels.txt")
activityLabel <- activity[labels[, 1], 2]
labels[, 1] <- activityLabel
names(labels) <- "activity"

#Step 4
#combinig the las 3 steps we create the desired table
names(subjects) <- "subject"
desiredtable <- cbind(subjects, labels, fullset)
write.table(desiredtable, "data.txt",row.name=FALSE)

# Step5. 
#load dplyr package
library(dplyr)
data<-tbl_df(desiredtable)
#create a new column concating activity and subject 
data<-mutate(data,act_sub=paste(activity,subject,sep=" "))
#we group by the new column  omiting the first two columns because are redundant
data<-data[,3:length(data)]
groupdata<-group_by(data,act_sub)

#we compute the means of each column in the grouped table.
meandf<-summarize_each(groupdata,funs(mean))
write.table(desiredtable, "group_data.txt",row.name=FALSE)

