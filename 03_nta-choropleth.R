# Load libs ---------------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)
library(tigris)
library(sf)
library(viridis)
library(RColorBrewer)
library(ggrepel)
windowsFonts(`Roboto Condensed`=windowsFont("Roboto Condensed"))


# Load data ---------------------------------------------------------------
# Load 311 data
source(here("helper-scripts/create-311-data.R"))
source(here("helper-scripts/identify-outliers.R"))

# Load NTA
nta_raw <- read_sf(here("data/raw/2020 Neighborhood Tabulation Areas (NTAs)/geo_export_ca14d746-5dd0-43ba-95bb-fc0d2a1a9f4f.shp"))
nta <- nta_raw %>% 
  select(ntaname) %>% 
  erase_water()


# Clean data --------------------------------------------------------------
# Join NTA and 311 data
joined <- t11_geo %>% 
  st_set_crs(st_crs(nta)) %>% 
  st_join(nta) %>% 
  mutate(outlier = ifelse(lonlat %in% top_001_per$lonlat, T, F))

# Aggregate data ------------------------------------------------------------
agg <- joined %>% 
  as_tibble() %>%
  filter(!outlier) %>% 
  count(ntaname, sort = T) 

write_csv(agg, here("data/created/complaints-by-nta.csv"))


#### NOT USED

# Plot --------------------------------------------------------------------
nta %>% 
#   left_join(agg %>% 
#               as_tibble(), by = "ntaname") %>% 
#   ggplot() +
#   geom_sf(aes(fill = n)) +
#   scale_fill_viridis(option = "magma") +
#   labs(fill = "Number of vehicle-based noise complaints submitted to 311") +
#   guides(fill = guide_legend(title.position="top", 
#                              title.hjust = 0.5)) +
#   theme_void(base_size = 12,
#              base_family = "Roboto Condensed") +
#   theme(legend.position = "bottom")
# 
# 
# ggsave(here("figures/exploratory/nta-choropleth-no-outliers.png"),
#        dpi = 600, height = 6, width = 6, units = "in", bg = "white")


# Explore -----------------------------------------------------------------
joined %>% 
  as_tibble() %>% 
  count(ntaname, sort = T)

joined %>% 
  as_tibble() %>% 
  filter(!outlier) %>% 
  count(ntaname, sort = T)

