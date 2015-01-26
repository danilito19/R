library(ff)
setwd('/Users/Dana/Dropbox/dataScience/R')

data <- read.csv.ffdf(file="MedicareLARGE.csv", header=TRUE, VERBOSE=TRUE, first.rows=10000, next.rows=50000, colClasses=NA)
head(data, n = 2)
data2 <- data[-1,]

#disable scipen so I don't see exponential values
options(scipen=999)

#lloks good but each row is not unique. That is, there isn't a 
#primary key. We have to arrange the data so that npi and hcpcs become the primary key to identify
#each event

library(data.table)
#so we create a data.table, which is a library that extends the features of base R's data.frame
#with speed of many R features. Seems like a good choice for big data sets


data2 = data.table(data2)
data3 = subset(data2, nppes_entity_code != ".")

phys_summ = data3[
  ,
  list(
    service_total=sum(line_srvc_cnt),
    ben_total=sum(bene_unique_cnt),
    M_payment_to_dr=sum(average_Medicare_payment_amt * line_srvc_cnt),
    dr_charged=sum(average_submitted_chrg_amt * line_srvc_cnt),
    allowed=sum(average_Medicare_allowed_amt * line_srvc_cnt),
    unique_services_per_patient=sum(bene_day_srvc_cnt)/sum(bene_unique_cnt),
    duplicates_per_service=sum(line_srvc_cnt)/sum(bene_day_srvc_cnt),
    services_per_patient=sum(line_srvc_cnt)/sum(bene_unique_cnt)
  ),
  by= "npi"
  ]

phys_summ$code = ifelse(data3$nppes_entity_code == "I", "I", "O")

##The above code will transform our data so that npi is unique. 
##sums total services performed by doctor : sum(type service *number of times for serv)
#sums total benef
#sums total Medicare payments   for all services
#sums total doc charge for all 

# sums lalowed charged for all services
#unique total services per patient
#total services per patient 

#filter out by doctor v. organization so we can determine doctor income inequality
docs = phys_summ[code=="I"]
orgs = phys_summ[code=="O"]

phys_ord = docs[order(docs$M_payment_to_dr),c("npi", "M_payment_to_dr"), with = FALSE]
phys_ord$pay_cumulative = cumsum(phys_ord$M_payment_to_dr)
split_dist = floor(nrow(phys_ord)/20)
groups = as.numeric(lapply(1:20, function(x){
  phys_ord$pay_cumulative[split_dist * x]
}))
groups = (groups/groups[20]) * 100

#plot percent of doctors and cumulative payment percentage



##additional study:
  #name of top services performed
  #doctors who charged the most
  #services medicare paid the most for
  #male v. female doctor income