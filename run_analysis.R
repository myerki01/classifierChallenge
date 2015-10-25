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
source("utilities.R")

# Gather data (anything with DF in variable name is a data frame)
appReviewsDF <- data.appReviews.getDataFrame(config.appReviewCSVPath)
namesDF <- data.names.getDataFrame(config.namesCSVPath)

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
