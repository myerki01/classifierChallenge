rm(list = ls())

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

ageClassifier.classify <- function(appReviewsDF, blogDF) {
  # Subset blogDF
  age.10.19 <- subset(blogDF, age < 20, select=(text))
  age.20.29 <- subset(blogDF, age > 20 & age < 30, select=(text))
  age.30up <- subset(blogDF, age > 30, select=(text))
  
  # Create & clean age corpus
  age.10.19.corpus <- utils.cleanCorpus(Corpus(VectorSource(age.10.19)))
  age.20.29.corpus <- utils.cleanCorpus(Corpus(VectorSource(age.20.29)))
  age.30up.corpus <- utils.cleanCorpus(Corpus(VectorSource(age.30up)))
  
  # Create TermDocument Matricies for ages
  age.10.19.tdm <- utils.genTermDocumentMatrixage(age.10.19.corpus)
  age.20.29.tdm <- utils.genTermDocumentMatrixage(age.20.29.corpus)
  age.30up.tdm <- utils.genTermDocumentMatrixage(age.30up.corpus)
  
  # Prepare Data for Classifier
  
  # Prep training data for model
  
  # Build Naive Bayes Model
  
  # Predict age group using model
}


