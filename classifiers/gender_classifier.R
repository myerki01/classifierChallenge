# Load packages
library(plyr)
library(dplyr)
library(sqldf)
library(tm)
library(ggplot2)
library(lsa)
library(topicmodels)
library(SnowballC)
library(rms)
library(tidyr)
library(random)
library(caret)
library(e1071)
library(lme4)

# Load src files
source("config.R")
source("load_data.R")
source("training_data.R")
source("test_data.R")
source("utilities.R")

genderClassifier.classify <- function(appReviewsDF, namesDF) {
  # Setup Training Data (Joining AppReviews and Names)
  namesTrainingData <- tdata.appReviews.getNamedUsers(appReviewsDF, namesDF)
  
  # Subset By Genders
  namesTrainingData.male <- tdata.appReviews.subsetByGender(namesTrainingData, 'M')
  namesTrainingData.female <- tdata.appReviews.subsetByGender(namesTrainingData, 'F')
  
  namesTrainingData.male <- c(namesTrainingData.male$body)
  namesTrainingData.female <- c(namesTrainingData.female$body)
  
  # Create & Clean Corpuses for Male and Female Subsets
  namesTrainingData.male.corpus <- utils.cleanCorpus(Corpus(VectorSource(namesTrainingData.male)))
  namesTrainingData.female.corpus <- utils.cleanCorpus(Corpus(VectorSource(namesTrainingData.female)))
  
  # Create TermDocument Matricies for Male and Female
  namesTrainingData.male.tdm <- utils.genTermDocumentMatrix(namesTrainingData.male.corpus)
  namesTrainingData.female.tdm <- utils.genTermDocumentMatrix(namesTrainingData.female.corpus)
  
  # Get data frames to use as input to Naive Bayes Classifier
  namesTrainingData.male.classiferDF <- utils.genderClassifier.genDataFrame(namesTrainingData.male.tdm, "Male", 1)
  namesTrainingData.female.classiferDF <- utils.genderClassifier.genDataFrame(namesTrainingData.female.tdm, "Female", 0)
  
  # Stack Data Frame for Classifier
  classifierDF <- rbind.fill(namesTrainingData.male.classiferDF, namesTrainingData.female.classiferDF)
  classifierDF[is.na(classifierDF)] <- 0
  classifierDF$targetgender <- factor(classifierDF$targetgender)
  str(classifierDF$targetgender)
  
  # Prepare Training Data for the Classifier
  train.indx <- sample(nrow(classifierDF), ceiling(nrow(classifierDF) * 0.8))
  data.train <- classifierDF[train.indx,]
  
  # Train a naive bayes model
  model <- naiveBayes(targetgender~., data=data.train)
  
  # Prepare data we need to predict
  namesTestDataDF <- testdata.appReviews.getUnNamedUsers(appReviewsDF)
  resultDF <- data.frame("ID"=integer(0), "gender"=character(), stringsAsFactors=FALSE)
  
  # For each 'review' classifiy it as 'M' or 'F' using the model
  for(i in 1:nrow(namesTestDataDF)) {
    x <- namesTestDataDF[i,]
    body <- x[4]
    corpus <- utils.cleanCorpus(Corpus(VectorSource(c(body))))
    tdm <- utils.genTermDocumentMatrix(corpus)
    df.mat <- t(data.matrix(tdm))
    f.df <- as.data.frame(df.mat, stringsAsFactors = FALSE)
    f.df$targetgender <- NULL
    
    # Run predict
    prediction <- predict(model, f.df)
    if(prediction == 1) {
      gender <- 'M'
    } else {
      gender <- 'F'
    }
    resultDF[nrow(resultDF)+1, ] <- c(x[1], gender)
  }

  # Join the predicted values to the original app reviews DF
  appReviewsDF <- left_join(appReviewsDF, resultDF, by = "ID")
  return(appReviewsDF)
}

#mean(predictions == test)
#predictions[90]
#resultTable <- table(actual = test, predictions = predictions)

#(test)
#str(classifierDF)
