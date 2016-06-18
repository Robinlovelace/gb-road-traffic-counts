# Download minor roads count stats
library(readr)
library(dplyr)

# # Download data and save as rds
# url = "http://data.dft.gov.uk/gb-traffic-matrix/Raw_count_data_minor_roads.zip"
# download.file(url = url, destfile = "data.zip")
# unzip("data.zip")
# rc = read_csv("Raw-count-data-minor-roads.csv")
# saveRDS(object = rc, file = "data/rc.Rds")

rc = readRDS("data/rc.Rds")

# Pre-processing
rc$`Region Name (GO)`[rc$`Region Name (GO)` == "Yorkshire & the Humber"] =
  "Yorkshire"

# summary stats on cycling
rc = rename(rc, cycles = PC)
summary(rc$cycles)

# which row has highest n. cycling
sel = which.max(rc$cycles)
rc[sel,]

# cycling by region
ag = group_by(rc, `Region Name (GO)`) %>% 
  summarise(Total = sum(cycles)) %>% 
  arrange(Total)

barplot(height = ag$Total, names.arg = ag$`Region Name (GO)`)
ag$`Region Name (GO)` = factor(
  ag$`Region Name (GO)`, levels = ag$`Region Name (GO)`)

library(ggplot2)
ggplot(ag) +
  geom_bar(aes(`Region Name (GO)`, Total), stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0, hjust = 1)
  )

