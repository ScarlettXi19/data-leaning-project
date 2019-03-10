#1.Merges the training and the test sets to create one data set

library(reshape2,data.table)
activity_labels<-read.table('activity_labels.txt')
features<-read.table("features.txt")

#########################work on the training data
X_train<-read.table('X_train.txt')
y_train<-read.table('y_train.txt')
subject_train<-read.table('subject_train.txt')
names(X_train)<-features[,2]
#2.Extracts only the measurements on the mean and standard deviation for
#each measurement.
ext_features<-grepl('mean|std',features[,2])
X_train<-X_train[,ext_features]


#3.Uses descriptive activity names to name the activities in the data set
y_train[,2]<-activity_labels[y_train[,1],2]
names(y_train)<-c('activity_ID','activity_label')
names(subject_train)<-'subject'
train<-cbind(as.data.frame.table(subject_train),y_train,X_train)


########################work on the test data
X_test<-read.table('X_test.txt')
y_test<-read.table('y_test.txt')
subject_test<-read.table('subject_test.txt')
names(X_test)<-features[,2]
#2.Extracts only the measurements on the mean and standard deviation for
#each measurement.
#4.Appropriately labels the data set with descriptive variable names.
ext_features<-grepl('mean|std',features[,2])
X_test<-X_test[,ext_features]


#3.Uses descriptive activity names to name the activities in the data set
y_test[,2]<-activity_labels[y_test[,1],2]

names(y_test)<-c('activity_ID','activity_label')
names(subject_test)<-'subject'
test<-cbind(as.data.frame.table(subject_test),y_test,X_test)


########################merge the train and test
data<-rbind(train,test)


id_labels<-c("subject", "activity_ID", "activity_label")
data_labels<-setdiff(colnames(data),id_labels)
long<- melt(data, id = id_labels, measure.vars = data_labels)

#5.From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
tidy_data<- dcast(long, subject + activity_label ~ variable,mean)


