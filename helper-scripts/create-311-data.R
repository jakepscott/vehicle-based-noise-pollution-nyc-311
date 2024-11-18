# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(tigris)
library(sf)

# Load 311
t11_raw <- read_csv(here("data/created/clean-noise-complaints.csv"))

# Clean 311
t11 <- t11_raw %>% 
  select(created_date, closed_date, descriptor, 
         location_type, resolution_description, latitude, longitude) %>% 
  mutate(lonlat = paste0(longitude,latitude)) 

# Make 311 spatial
t11_geo <- t11 %>%
  filter(!is.na(latitude) & !is.na(longitude)) %>% 
  st_as_sf(coords = c("longitude", "latitude")) 