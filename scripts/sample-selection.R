library(dplyr)


#call file containing qPCR results from Pam 
qpcr <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/20180521-qPCR-as-of-050818.csv")

#call file containing data for crabs that have three samples per crab and have 20 ng/µL or more of isolated RNA in the sample - note that this is note including the two infected warm-treatment crabs because they only had isolated RNA in 2 out of 3 sample dates. 
RNA <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/goodsamples.csv")

#join the files and align data based on FRP number (FRP is the unique number given to crab individuals)
master <- left_join(RNA, qpcr, by = "FRP")

#A more detailed look at experiment with qPCR data included


install.packages("tidyverse")


library(tidyverse)

master

#listing column name
colnames(master)

master %>% 
  select(FRP, Sample_Day, temperature_treatment.x, infection_status, SQ_Mean, SQ_Std_Dev, Day, Tube) %>% 
  arrange(infection_status,SQ_Mean)

pcrsum2 <- master %>% 
  select(FRP, infection_status, SQ_Mean, temperature_treatment.x, Day) %>% 
  arrange(infection_status,SQ_Mean) %>%
  unique()

pcrsum <- master %>% 
  select(FRP, infection_status, SQ_Mean) %>% 
  arrange(infection_status,SQ_Mean) %>%
  unique()



#The following may not be possible because I have not rearranged the data to be in separate columns based on sample day. How can I rearrange them in R? 

ggplot(data = pcrsum) + 
  geom_histogram(aes(x = )) +
  facet_wrap(~infection_status) 

ggplot(data = pcrsum) + 
  geom_histogram(aes(x = sq_mean_d26)) +
  facet_wrap(~infection_status) 




pcrsum



crdf <- pcrsum %>% 
  group_by(infection_status) %>% 
  mutate(grouped_id = row_number())

# Now Spread
crdf %>% 
  spread(infection_status, FRP) %>% 
  select(-grouped_id)
