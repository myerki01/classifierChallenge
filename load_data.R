# App Review Data Frame (Load and Format)
data.appReviews.formatDataFrame <- function(dataFrame) {
  # rename author column to name
  colnames(dataFrame)[8] <- "name"
  # create a unique identifier column (to reference each row later)
  dataFrame$ID <- seq.int(nrow(dataFrame))

  return(dataFrame)
}

data.appReviews.getDataFrame <- function(path) {
  appReviewDataFrame <- data.appReviews.formatDataFrame(read.csv(path))
  return(appReviewDataFrame)
}

# Name Data Frame (Load and Format)
data.names.formatDataFrame <- function(dataFrame) {
  # rename columns
  colnames(dataFrame)[2] <- "FirstName"
  colnames(dataFrame)[3] <- "Gender"
  
  # Remove Id column (don't need it)
  dataFrame <- dataFrame[,c(2,3)]
  # Names that belong to both male/female will become problematic
  # later on, so we remove them (there are limitations to this,
  # but for simplicity sake we do it for now)
  dataFrame <- subset(dataFrame, !duplicated(dataFrame[,1]))
  return(dataFrame)
}

data.names.getDataFrame <- function(path) {
  namesDataFrame <- data.names.formatDataFrame(read.csv(path))
  return(namesDataFrame)
}


# Load Blogger.com data 
data.blogs.formatDataFrame <- function(dataFrame) {
  return(dataFrame)
}

data.blogs.getDataFrame <- function(path) {
  blogsDataFrame <- data.blogs.formatDataFrame(read.csv(path, header = TRUE))
  return(blogsDataFrame)
}
