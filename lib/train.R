#########################################################
### Train a classification model with training images ###
#########################################################

### Authors: Qian Shi, Yijia Li
### Project 3
### ADS Fall2017_GROUP7


## GBM
gbm_train<- function(data_train, label_train, shrink, ntrees){
  library("gbm")
  gbm_model <- gbm(label_train~., 
                 data=data_train,
                 interaction.depth=3, 
                 shrinkage=shrink,
                 n.trees=ntrees,
                 distribution="multinomial")
  return(list(model=gbm_model, ntrees=gbm_model$n.trees))
}


source("../lib/cross_validation.R")
train_gbm_para<- function(data_train, label_train, shrinks_range, trees_range, K){
  library("gbm")
  acu_mat<- matrix(nrow=length(shrinks_range), ncol=length(trees_range))
  colnames(acu_mat)<- trees_range
  rownames(acu_mat)<- shrinks_range
  
  for (i in 1:length(shrinks_range)){
    for(j in 1:length(trees_range)){
      acu_mat[i, j]<- cv_gbm(data_train, label_train, shrinks_range[i], trees_range[j], K)
    }
  }
  if (max(acu_mat)<0.8){
    best_row<- which(acu_mat == max(acu_mat), arr.ind=TRUE)[1]
    best_col<- which(acu_mat == max(acu_mat), arr.ind=TRUE)[2]
    best_shrink<- shrinks_range[best_row]
    best_trees<- trees_range[best_col]
  }
  else{
    # Avoid overfitting
    # Choose the second max
    best_row<- which(acu_mat == max(acu_mat[acu_mat != max(acu_mat)]), arr.ind=TRUE)[1]
    best_col<- which(acu_mat == max(acu_mat[acu_mat != max(acu_mat)]), arr.ind=TRUE)[2]
    best_shrink<- shrinks_range[best_row]
    best_trees<- trees_range[best_col]
  }
}



## Xgboost
xgb_train<- function(x, y, params){
  library("xgboost")
  dtrain = xgb.DMatrix(data=data.matrix(x),label=y)
  set.seed(11)
  bst <- xgb.train(data=dtrain, params = params, nrounds = 100)
  return(bst)
}


xgb_para <- function(dat_train,label_train,K){
  library("xgboost")
  dtrain = xgb.DMatrix(data=data.matrix(dat_train),label=label_train)
  max_depth<-c(3,5,7)
  eta<-c(0.1,0.3,0.5)
  best_params <- list()
  best_err <- Inf 
  para_mat = matrix(nrow=3, ncol=3)
  
  for (i in 1:3){
    for (j in 1:3){
      my.params <- list(max_depth = max_depth[i], eta = eta[j])
      set.seed(11)
      cv.output <- xgb.cv(data=dtrain, params=my.params, 
                          nrounds = 100, gamma = 0, subsample = 0.5,
                          objective = "multi:softprob", num_class = 3,
                          nfold = K, nthread = 2, early_stopping_rounds = 5, 
                          verbose = 0, maximize = F, prediction = T)
      
      min_err <- min(cv.output$evaluation_log$test_merror_mean)
      para_mat[i,j] <- min_err
      #print(min_err)
      
      if (min_err < best_err){
        best_params <- my.params
        best_err <- min_err
      }
    }
  }
  return(list(para_mat, best_params, best_err))
}









