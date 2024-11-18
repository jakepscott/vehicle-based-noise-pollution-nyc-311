# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Load data ---------------------------------------------------------------
t11_raw <- read_csv(here("data/raw/311_Service_Requests_from_2010_to_Present_20241111.csv"))

t11 <- t11_raw %>% 
  clean_names() %>% 
  filter(str_detect(descriptor, "Car|Truck|Engine|Vehicle")) %>% 
  filter(descriptor %in% c("Car/Truck Horn",
                           "Car/Truck Music",
                           "Engine Idling"))


# Save data ---------------------------------------------------------------
write_csv(t11, here("data/created/clean-noise-complaints.csv"))



