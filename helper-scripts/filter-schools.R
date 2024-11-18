# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Load data ---------------------------------------------------------------
pluto_raw <- read_csv(here("data/raw/nyc_pluto_24v3_1_csv/pluto_24v3_1.csv"))

schools <- pluto_raw %>% 
  mutate(is_school = ifelse(str_detect(bldgclass, "W") & !bldgclass %in% c("GW", "RW"),
                            "School", "Not a school")) %>% 
  select(bbl, is_school)

write_csv(schools, here("data/created/schools-pluto.csv"))
