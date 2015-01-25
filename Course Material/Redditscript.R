setwd('/Users/danilitovsky/Dropbox/dataScience/R')
reddit <- read.csv('reddit.csv')
str(reddit)
table(reddit$employment.status)

library(ggplot2)
qplot(data = reddit, x = cheese)
reddit$age.range <- factor(reddit$age.range, levels = c('Under 18', '18-24', '25-34', '35-44', '45-54', '55-60', '65 or Above'))