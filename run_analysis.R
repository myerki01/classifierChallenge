rm(list = ls())

# Load src files
source("config.R")
source("load_data.R")
source("training_data.R")
source("test_data.R")
source("utilities.R")
source("classifiers/gender_classifier.R")
#source("classifiers/age_classifier.R")

# Gather data (anything with DF in variable name is a data frame)
appReviewsDF <- data.appReviews.getDataFrame(config.appReviewCSVPath)
namesDF <- data.names.getDataFrame(config.namesCSVPath)
blogDF <- data.blogs.getDataFrame(config.blogsCSVPath)

# Build & get results from a gender classifier using a Naive Bayes Model
appReviewsDF <- genderClassifier.classify(appReviewsDF, namesDF)

# Build & get results from an age classifier using a Naive Bayes Model
# appReviewsDF <- ageClassifier.classify(appReviewsDF, blogDF)

# Save results to csv file
write.csv(appReviewsDF, file=config.outputResultPath)