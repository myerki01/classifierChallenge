# Overview
This project uses a Naive Bayes classifier to surface demographic information on app store reviews.

## Data Used
In addition to app review data this project makes use of two external data sets. The first is a dataseet of names provided by the social security website. This data set it used to classify app reviews by gender. The second data set that is used are posts from blogger.com. This data set includes user posts, age, gender, industry and astrological signs. This data will be used to surface additional data on the app store reviews.

## Project organization
To run this project first update the paths of your data files in the `config.R` file. Then run `run_analysis.R`. This will load the data sources, run the classifiers and output the results to a .csv file.

## To Do
- [x] Create gender classifier
- [] Finish age classifier
- [] Create industry classifier
