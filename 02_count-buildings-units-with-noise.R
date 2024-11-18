# Load libs ---------------------------------------------------------------
library(tidyverse)
library(here)
library(sf)

# Load data ---------------------------------------------------------------
# Lots with noise
lots_with_noise <- sf::read_sf(here("data/created/lots-with-noise-complaint.shp"))

# PLUTO
pluto_raw <- read_csv(here("data/raw/nyc_pluto_24v3_1_csv/pluto_24v3_1.csv"))



# Calculate ---------------------------------------------------------------
# 3,706,421
pluto_raw %>% 
  summarise(units = sum(unitsres, na.rm = T))

# 2,239,937
lots_with_noise %>% 
  as_tibble() %>% 
  summarise(units = sum(UnitsRes))
