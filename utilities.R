library(tm)

utils.complete <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

utils.cleanUpEmojis <- function(dataFrameColumn) {
  dataFrameColumn <- (as.character(dataFrameColumn))
  return(sapply(dataFrameColumn, function(row) iconv(row, "latin1", "ASCII", sub="")))
}

utils.cleanCorpus <- function(corpus) {
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("english")))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stemDocument)
  return(corpus)
}

utils.genTermDocumentMatrix <- function(corpus) {
  tdm <- TermDocumentMatrix(corpus, control=list(minDocFreq=2, wordLengths = c(3, 15)))
  #tdm <- weightBin(tdm)
  return(tdm)
}

utils.genderClassifier.genDataFrame <- function(tdm, gender, genderCode) {
  # Gender must be either 'Male' or 'Female'
  dataList <- list(name = gender, dtm = tdm)
  df.mat <- t(data.matrix(dataList[["dtm"]]))
  f.df <- as.data.frame(df.mat, stringsAsFactors = FALSE)
  f.df <- cbind(f.df, rep(dataList["name"], stringsAsFactors = FALSE))
  # Code the last column we just binded (genderCode can equal 1 or 0)
  f.df[ncol(f.df)] <- genderCode
  colnames(f.df)[ncol(f.df)] <- "targetgender"
  return(f.df)
}
