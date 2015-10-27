

testdata.appReviews.getUnNamedUsers <- function(appReviewsDF) {
  # Get all reviews that have names
  # Subset by popular apps
  basketBallApp <- 'net.mobilecraft.realbasketball'
  starbucksApp <- 'com.starbucks.mobilecard'
  duckHuntApp <- 'com.bigduckgames.flow'
  fashionApp <- 'com.crowdstar.covetfashion'

  appReviewsDF <- (subset(appReviewsDF, name == "A Google User" |
                            ref_no == basketBallApp |
                            ref_no == starbucksApp |
                            ref_no == duckHuntApp |
                            ref_no == fashionApp, 
                          select=c(ID, ref_no, title, body, name, stars)))
  # Clean up emojis
  appReviewsDF$ref_no <- sapply(appReviewsDF$ref_no, function(row) iconv(row, "latin1", "ASCII", sub=""))
  appReviewsDF$body <- sapply(appReviewsDF$body, function(row) iconv(row, "latin1", "ASCII", sub=""))
  
  # Remove puncuation
  appReviewsDF$ref_no <- gsub("[?.;!¡¿·']", "", appReviewsDF$ref_no)
  
  # Drop all observations formatted incorrectly (we assume anything more than 40
  # characters was formatted incorrectly...might want to later come up with more 
  # optimal way to determine this heuristic)
  appReviewsDF <- subset(appReviewsDF, nchar(as.character(appReviewsDF$ref_no)) <= 40 )
  
  appReviewsDF$body <- as.character(appReviewsDF$body)
  appReviewsDF$ref_n <- as.character(appReviewsDF$ref_no)
  
  appReviewsDF$gender <- ''

  return(appReviewsDF)
}