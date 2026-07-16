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
  # feature engineering
  mutate(
    household_collected_per_cap = household_collected / population,
    population_density = population / area_km2
  )

# RECYCLING SYSTEM ANALYSIS DATA ###############################################
data_recycling_system <- 
  data |> 
  select(
    lad21cd,
    local_authority,
    population,
    collection_type,
    household_collected,
    household_recycled,
    household_recycle_rate,
    population_density
  )