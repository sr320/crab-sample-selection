library(dplyr)

#Make .csv file for "all crabs" hemolymph sampling data
all_crabs <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/20180522-master-all-crabs-hemo.csv")

#write out all_crabs csv
write_csv(all_crabs, "analyses/all_crabs")

# look at file
(head(all_crabs)) 

#want to add treatment tank data to file based on the letter in Day 12 Holding Tank (C = cold, A = ambient, W = warm)
#or
#"treatment.tank"
#1, 2, 3 --> Cold
#4, 5, 6 --> Warm
#7, 8, 9 --> Ambient


#create new object where create a new column named SR_col in all_crabs object, where if treatment.tank 1 or 2 or 3 - then value = COLD
#if treatment.tank 4 or 5 or 6 then value = WARM, otherwise value = AMBIENT, then piped to filter for row where sample_day == 9
newstart <- mutate(all_crabs, SR_col = ifelse(treatment.tank == 1 | treatment.tank == 2 | treatment.tank == 3, "COLD", ifelse(treatment.tank == 4 | treatment.tank == 5 | treatment.tank == 6, "WARM", "AMBIENT"))) %>%
  filter(sample_day == 9)
 
#look at file
head(newstart)

---







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

pcrsum <- master %>% 
  select(FRP, infection_status, SQ_Mean, temperature_treatment.x, Day) %>% 
  arrange(FRP,infection_status) %>%
  unique()

write.csv(pcrsum, "data/20180522-pcr-table.csv")

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
