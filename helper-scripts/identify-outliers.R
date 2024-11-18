# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)
library(tigris)
library(sf)


# Load data ---------------------------------------------------------------
# Load 311
t11_raw <- read_csv(here("data/created/clean-noise-complaints.csv"))

t11_clean <- t11_raw %>% 
  mutate(lonlat = paste0(longitude,latitude))  
  

longlat_agg <- t11_clean %>% 
  count(longitude, latitude, lonlat, sort = T)

# <0.01% have >87 complaints
longlat_agg %>% 
  pull(n) %>% 
  quantile(probs = seq(0,1,.001))

top_001_per <- longlat_agg %>% 
  filter(n > longlat_agg %>% 
           pull(n) %>% 
           quantile(probs = .999))

t11_clean %>% 
  select(latitude, longitude) %>%
  write_csv(here("data/created/311-remove-outliers.csv"))

# Removing these top 0.01 percenters leaves 41,632 rows
# t11_clean %>%
#   filter(!lonlat %in% c(top_001_per %>% 
#                          pull(lonlat)))
#   
# 
# # The top 0.01 percenters have 3,994 rows
# t11_clean %>%
#   filter(lonlat %in% c(top_001_per %>% 
#                           pull(lonlat)))
