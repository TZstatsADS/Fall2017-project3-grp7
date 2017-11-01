######################################################
### Fit the classification model with testing data ###
######################################################

### Authors: Qian Shi, Yijia Li
### Project 3
### ADS Fall2017_GROUP7


## GBM
gbm_test<- function(fit_model, dat_test){
  
  library("gbm")
  pred <- predict.gbm(fit_model$model, 
                      dat_test, 
                      n.trees=fit_model$ntrees, 
                      type="response")
  pred_lab<- apply(pred, 1, which.max) - 1
  return(pred_lab)
}

## Xgboost
xgb_test<- function(model, x){
  
  library("xgboost")
  pred <- predict(model, as.matrix(x))
  pred <- matrix(pred, ncol=3, byrow=TRUE)
  pred_labels <- max.col(pred) - 1
  return(pred_labels)
}