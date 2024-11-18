# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(sf)
library(tidycensus)
library(tigris)
library(gganimate)
windowsFonts(`Roboto Condensed`=windowsFont("Roboto Condensed"))

# Load county border data --------------------------------------------------------
raw_county_boundaries <- get_acs(geography = "county", year = 2022,
                         variables = "B01003_001", geometry = T, 
                         state = c("New York"), county = c("Kings", "Queens", 
                                                           "Bronx", "New York",
                                                           "Richmond"))

# Remove water
county_boundaries <- raw_county_boundaries %>% 
  erase_water()

# Load data ---------------------------------------------------------------
# Load 311
t11_raw <- read_csv(here("data/created/clean-noise-complaints.csv"))

# Clean 311
t11_clean <- t11_raw %>%
  separate(created_date, into = c("date", "time"), sep = " ") %>% 
  mutate(id = row_number(),
         date = mdy(date), 
         week = week(date))

# Static map --------------------------------------------------------------
(map <- t11_clean %>%
   ggplot() +
   geom_sf(data = county_boundaries, color = "white", fill = "grey20") +
   geom_point(aes(longitude, latitude, group = id),
              alpha = .1,
              color = "white") +
   labs(title = "Cars make New York noisy, with >45,000\nvehicle-based noise complaints lodged in 2024",
        subtitle = "Week {round(frame_along, 0)} of 2024") + 
   theme_void(base_size = 12,
              base_family = "Roboto Condensed") +
   theme(plot.title = element_text(size = rel(1.5), 
                                   face = "bold", 
                                   color = "white", 
                                   vjust = -15),
         plot.subtitle = element_text(size = rel(1),
                                      face = "italic",
                                      color = "white", 
                                      vjust = -30),
         panel.background = element_rect(fill = "black")))

# Animate the static map over time (using week column)
anim <- map + 
  transition_reveal(along = week) +
  enter_grow()

# Render the animation
animate(anim, height = 715, width = 600, nframes = 45, end_pause = 5) 

# Save animation
anim_save(here("figures/complaints-appearing.gif"), bg = "black")
