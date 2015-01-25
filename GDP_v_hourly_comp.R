###Investigate the relationship between GDP per capita in thel ast 10 years and 
###the hourly compensation.


Comp <- read.csv("/Users/danilitovsky/Dropbox/dataScience/Datasets/hourly_compensation.csv")
GDP <-read.csv("/Users/danilitovsky/Dropbox/dataScience/Datasets/GDP_past_10yrs.csv")

###change data out of wide form, so all countries are repeated with each year comp
Comp_stack <-melt(Comp)
GDP_stack <-melt(GDP)

###take out X in years by usuing substrig()
Comp_stack$variable <- as.character(Comp_stack$variable)
Comp_stack$variable <- substring(Comp_stack$variable, 2, nchar(Comp_stack$variable))

GDP_stack$variable <- as.character(GDP_stack$variable)
GDP_stack$variable <- substring(GDP_stack$variable, 2, nchar(GDP_stack$variable))

###rename columns
library(reshape)
names(Comp_stack)[1] <- "Country"
names(Comp_stack)[2] <- "Year"
names(Comp_stack)[3] <- "Comp"

names(GDP_stack)[1] <- "Country"
names(GDP_stack)[2] <- "Year"
names(GDP_stack)[3] <- "GDP_pc"

###drop blank and NA rows by giving blank rows NA first
Comp_stack[Comp_stack ==""] <-NA
Compensation <-na.omit(Comp_stack)

GDP_stack[GDP_stack ==""] <-NA
GDP <-na.omit(GDP_stack)

###merge two datasets into one
GDP_v_Comp <-merge(GDP, Compensation, by=c("Country", "Year"))

###create graphs of GDP v. Comp

ggplot(aes(x= GDP_pc, y = Year), data= GDP_v_Comp) +
  geom_point() +
  facet_wrap(~Country)

ggplot(aes(x= GDP_pc, y = Comp), data= GDP_v_Comp) +
  geom_point(aes(color = Country)) 

ggplot(aes(x= GDP_pc, y = Comp), data= GDP_v_Comp) +
  geom_point() +
  facet_wrap(~Country)

###calculate correlation

cor.test(GDP_v_Comp$GDP_pc, GDP_v_Comp$Comp)
##Pearson's R turned out to be -0.229, showing a not too
#strong negative relationship between GDP pc and Comp