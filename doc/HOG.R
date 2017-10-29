### Load libraries
if(!require(EBImage)){
  source("http://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}
if(!require(OpenImageR)){
  install.packages("OpenImageR")
}
library(OpenImageR)
library(EBImage)

library("dplyr")


img_dir <- "/Users/yijiali/Desktop/training_set/images/"
dir_names <- list.files(img_dir)
num_files <- length(list.files(img_dir))

### test image 1
img0 <- readImage(paste0(img_dir,  dir_names[1]))
h1 <- HOG(img0,cells = 8,orientations = 9)


### store HOG values of images
H <- matrix(NA, num_files,length(h1)) 

for(i in 1:num_files){
  img <- readImage(paste0(img_dir, dir_names[i]))
  H[i,] <- HOG(img,cells = 8,orientations = 9)
}

### output constructed features
write.csv(H, file = "/Users/yijiali/Desktop/hog.csv",row.names = F)

### HOG feature processing
hog_train<- read.csv("/Users/yijiali/Desktop/hog.csv")
hog_train<- as.data.frame(hog_train)
label_train<- read.csv("/Users/yijiali/Desktop/training_set/label_train.csv")
training_y<- matrix(label_train[, 2],ncol=1)
colnames(training_y)<-"y"
training_x<- hog_train
training1<- training_x
training1$y<- training_y
training<- sample_frac(training1, 0.7, replace=FALSE)
testing<- setdiff(training1, training, 'rows')
hog_data<- training1
write.csv(training, file = "/Users/yijiali/Desktop/hog_training.csv", row.names = FALSE)
write.csv(testing, file = "/Users/yijiali/Desktop/hog_testing.csv", row.names = FALSE)
write.csv(hog_data,file="/Users/yijiali/Desktop/hog_feature.csv",row.names = FALSE)


