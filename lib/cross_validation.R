########################
### Cross Validation ###
########################

### Authors: Qian Shi, Yijia Li
### Project 3
### ADS Fall2017_GROUP7


## GBM
cv_gbm<- function(X_train, y_train, shrink, ntrees, K){
  n<- length(y_train)
  folds<- sample(rep(1:K, each=n/K))
  cv_acu<- c()
  
  for(i in 1:K){
    train<- X_train[folds != i, ]
    train_lab<- y_train[folds != i]
    
    validate<- X_train[folds == i, ]
    validate_lab<- y_train[folds == i]
    
    gbm_fit<- gbm_train(train, train_lab, shrink, ntrees)
    gbm_pred<- gbm_test(gbm_fit, validate)
    
    cv_acu[i]<- sum(gbm_pred == validate_lab)/ length(validate_lab)
  }
  return(mean(cv_acu))
}


## Xgboost
xgb_cv.function <- function(X.train, y.train, K){
  
  n <- length(y.train)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  train_time <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- X.train[s != i,]
    train.label <- y.train[s != i]
    test.data <- X.train[s == i,]
    test.label <- y.train[s == i]
    
    t = proc.time()
    bst <- xgb_train(train.data, train.label, best_para)
    train_time[i] = (proc.time() - t)[3]
    
    pred_label <- xgb_test(bst, test.data)
    cv.error[i] <- sum(pred_label != test.label)/length(test.label)
  }			
  return(c(mean(1-cv.error),mean(train_time)))
}












