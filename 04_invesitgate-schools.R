# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(sf)
library(tidycensus)
library(tigris)

# Load data ---------------------------------------------------------------
schools_raw <- read_sf(here('data/created/points-within-school-buffers-2.shp'))

# Clean data --------------------------------------------------------------
schools_clean <- schools_raw %>% 
  as_tibble() %>% 
  janitor::clean_names() %>% 
  filter(bldg_class == "W1") 

# Examine -----------------------------------------------------------------
# 61% with at least one complaint within 200 feet
schools_clean %>% 
  count(numpoints> 0) %>% 
  mutate(total = sum(n),
         per = n/total*100)

# 70% with <=3 complaints
schools_clean %>% 
  pull(numpoints) %>% 
  quantile(probs = seq(0,1,.1))

# 51 with 20+ complaints 
schools_clean %>% 
  filter(numpoints >= 20)  %>% 
  select(address, owner_name, numpoints) %>% 
  arrange(desc(numpoints))

# Which borough are these ones with the most complaints in
schools_clean %>% 
  filter(numpoints >= 20)  %>% 
  count(borough) %>% 
  mutate(per = n/sum(n)*100)

# Save --------------------------------------------------------------------
schools_clean %>% 
  filter(numpoints >= 20)  %>% 
  write_csv(here("data/created/chronic-noise-schools.csv"))
