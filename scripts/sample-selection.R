library(dplyr)

qpcr <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/20180517-all-runs-qPCR-results.csv")

RNA <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/goodsamples.csv")

master <- left_join(RNA, qpcr, by = "FRP")

#A more detailed look at experiment with qPCR data included


install.packages("tidyverse")


library(tidyverse)

master

#listing column name
colnames(master)

master %>% 
  select(FRP, Sample_Day, temperature_treatment, infection_status, SQ_Mean, SQ_Std_Dev) %>% 
  arrange(infection_status,SQ_Mean)


pcrsum <- master %>% 
  select(FRP, infection_status, SQ_Mean) %>% 
  arrange(infection_status,SQ_Mean) %>%
  unique()



#The following may not be possible becuase I have not rearranged the data to be in separate columns based on sample day. How can I rearrange them in R? 

ggplot(data = pcrsum) + 
  geom_histogram(aes(x = sq_mean_d01)) +
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
