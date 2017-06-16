library(dplyr)
## Load Train Data
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Load Test Data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

##Load variable names
varname <- read.table("./UCI HAR Dataset/features.txt")

## Merge training and test sets (Step #1)
xall <- rbind(xtrain,xtest)
yall <- rbind(ytrain,ytest)
suball <- rbind(subtrain,subtest)

## Get only mean and standard deviation related measurements (Step #2)

vars <- grep(".*mean.*|.*std.*", varname[,2])
vars.selected <- varname[vars,2]
xall.selected <- xall[,vars]

## Assign Descriptive names to activities  (Step #3)
colnames(yall) <- "activity"
actname <- read.table("./UCI HAR Dataset/activity_labels.txt")
yall$actname <- factor(yall$activity,levels = actname[,1], labels = actname[,2])
actlab <- yall[,-1]

##Assign Descriptive labels to the data (Step #4)
colnames(xall.selected) <- vars.selected


##Creating Tidy data with mean for each activity and subject  (Step #5)
colnames(suball) <- "subject"
all <- cbind(xall.selected,actlab,suball)
all_mean <- all %>% group_by (actlab,subject) %>% summarize_each(funs(mean))
write.table(all_mean,file="./UCI HAR Dataset/tidydata.txt",col.names = FALSE,row.names=FALSE)
