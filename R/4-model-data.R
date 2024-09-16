# SUMMARY ######################################################################
# This script models the data required for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)
library(tidyr)

# > Scripts ====================================================================
source(here("R/3-prep-data.R"))

# FLAT DATA ####################################################################
data <- 
  lad_cln %>% 
  left_join(pop_cln,
            by = "lad21cd") %>% 
  left_join(foi_cln,
            by = "lad21cd") %>% 
  left_join(rec_cln,
            by = "wa21cd") %>% 
  left_join(rgn_cln,
            by = "lad21cd") %>% 
  left_join(shp_cln,
            by = "lad21cd") %>% 
  select(-geometry) %>% 
  replace_na(
    list(
      in_lad = "N",
      in_rec = "N",
      in_foi = "N"
    )
  ) %>% 
  mutate(
    household_collected_per_cap = household_collected / population
  )

# EXPLORATORY ANALYSIS #########################################################
x <- data %>% 
  select(local_authority,
         waste_authority,
         population,
         collection_type,
         household_collected,
         household_recycled,
         household_not_recycled,
         household_rejects) %>%
  group_by(collection_type) %>% 
  summarise(sample_size = n(),
            household_collected = sum(household_collected),
            household_recycled = sum(household_recycled),
            household_not_recycled = sum(household_not_recycled),
            recycling_rate = household_recycled / household_collected,
            rejects_per_capita = sum(household_rejects) / sum(population)) %>% 
  ungroup()