#A more detailed look at experiment with qPCR data included

crabdata_pcr <- read.csv("https://raw.githubusercontent.com/RobertsLab/project-crab/master/data/20180517_sequence_samples.csv")

crabdata_pcr

install.packages("dplyr")

library(dplyr)

crabdata_pcr

#listing column name
colnames(crabdata_pcr)

crabdata_pcr %>% 
  select(FRP, Sample_Day, temperature_treatment, infection_status, sq_mean_d01, sq_mean_d26) %>% 
  arrange(infection_status,sq_mean_d01)


pcrsum <- crabdata_pcr %>% 
  select(FRP, infection_status, sq_mean_d01, sq_mean_d26) %>% 
  arrange(infection_status,sq_mean_d01) %>%
  unique()





ggplot(data = pcrsum) + 
  geom_histogram(aes(x = sq_mean.y)) +
  facet_wrap(~infection_status) 

ggplot(data = pcrsum) + 
  geom_histogram(aes(x = sq_mean.x)) +
  facet_wrap(~infection_status) 




pcrsum



crdf <- pcrsum %>% 
  group_by(infection_status) %>% 
  mutate(grouped_id = row_number())

# Now Spread
crdf %>% 
  spread(infection_status, FRP) %>% 
  select(-grouped_id)