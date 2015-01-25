###hourly compensation

Comp <- read.csv("/Users/danilitovsky/Dropbox/dataScience/Datasets/hourly_compensation.csv")


###change data out of wide form, so all countries are repeated with each year comp
Comp_stack <-melt(Comp)

###take out X in years by usuing substrig()
Comp_stack$variable <- as.character(Comp_stack$variable)
Comp_stack$variable <- substring(Comp_stack$variable, 2, nchar(Comp_stack$variable))

###rename columns
library(reshape)
names(Comp_stack)[1] <- "Country"
names(Comp_stack)[2] <- "Year"
names(Comp_stack)[3] <- "Comp"

###change Year column to be year datatype

###drop blank and NA rows by giving blank rows NA first
Comp_stack[Comp_stack ==""] <-NA
Compensation <-na.omit(Comp_stack)

###graph compensation in certain throughout the years
ggplot(aes(x=Year, y = Comp), data = subset(Compensation, Country == "United States")) +
  geom_point()
ggplot(aes(x=Year, y = Comp), data = subset(Compensation, Country == "Mexico")) +
  geom_point()

###make one graph including US and Mexico
ggplot(aes(x=Year, y = Comp), data = subset(Compensation, Country == "Mexico" | Country == "United States")) +
  geom_line(aes(color = Country))

###group_by countries to get mean and median compensations from 1980 to 2006
library(dplyr)
by_country <- group_by(Compensation, Country)
Country_Comp <- summarise(by_country,
                          number = n(),
                          mean_comp = mean(Comp),
                          median_comp = median(Comp))
  