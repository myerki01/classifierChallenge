library(plyr)
library(dplyr)
library(sqldf)
library(tidyr)

source('utilities.R')

tdata.appReviews.getNamedUsers <- function(appReviewsDF, namesDF) {
  # Get all reviews that have names
  appReviewsDF <- (subset(appReviewsDF, name != "A Google User", 
                          select=c(ID, ref_no, title, body, name, stars)))
  # Clean up emojis
  appReviewsDF$ref_no <- sapply(appReviewsDF$ref_no, function(row) iconv(row, "latin1", "ASCII", sub=""))
  
  # Remove puncuation
  appReviewsDF$ref_no <- gsub("[?.;!¡¿·']", "", appReviewsDF$ref_no)
  
  # Drop all observations formatted incorrectly (we assume anything more than 40
  # characters was formatted incorrectly...might want to later come up with more 
  # optimal way to determine this heuristic)
  appReviewsDF <- subset(appReviewsDF, nchar(as.character(appReviewsDF$ref_no)) <= 40 )
  
  # parse name variable by first and last name 
  appReviewsDF <- extract(appReviewsDF, name, c("FirstName", "LastName"), "([^ ]+) (.*)")
  
  # Match names to male or female
  appReviewsDF <- left_join(appReviewsDF, namesDF, by = "FirstName")
  appReviewsDF <- utils.complete(appReviewsDF, "Gender")
  appReviewsDF$body <- as.character(appReviewsDF$body)
  appReviewsDF$ref_no <- as.character(appReviewsDF$ref_no)

  return(appReviewsDF)
}

tdata.appReviews.subsetByGender <- function(dataFrame, gender) {
  dataFrame <- subset(dataFrame, Gender == gender, select =c(body, Gender))
  genderSample <- data.frame(dataFrame[sample(1:nrow(dataFrame), 10000, replace=FALSE),])
  genderSample$body <- (as.character(genderSample[,1]))
  genderSample$body <- utils.cleanUpEmojis(genderSample$body)
  return(genderSample)
}




