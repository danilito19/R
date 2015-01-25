library(ff)
setwd('/Users/Dana/Dropbox/dataScience/Datasets')

#best way to learn is by mocking people's work and including some of my own thoughts
##huge df with 9 million rows, have to use ff in R to dealwith big data
##had to eliminate row 2 copyright
#lloks good, but as Vik mentions, each row is not unique. That is, there isn't a 
#primary key. We have to arrange the data so that npi and hcpcs become the primary key to identify
#each event
data <- read.csv.ffdf(file="MedicareLARGE.csv", header=TRUE, VERBOSE=TRUE, first.rows=10000, next.rows=50000, colClasses=NA)
head(data, n = 2)