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
  left_join(sys_cln,
            by = "lad21cd") %>% 
  left_join(rec_cln,
            by = "wa21cd") %>% 
  left_join(ctr_cln,
            by = "lad21cd") %>% 
  left_join(rgn_cln,
            by = "lad21cd") %>% 
  left_join(cau_cln,
            by = "lad21cd") %>% 
  #left_join(srv_count,
  #          by = "lad21cd") %>% 
  replace_na(
    list(
      in_lad = "N",
      in_rec = "N",
      in_sys = "N",
      survey_responses = 0
    )
  )

# EXPLORATORY ANALYSIS #########################################################
x <- data %>% 
  filter(!is.na(bins)) %>% 
  select(local_authority,
         waste_authority,
         population,
         bins,
         household_collected,
         household_recycled,
         household_not_recycled,
         household_rejects) %>%
  group_by(bins) %>% 
  summarise(sample_size = n(),
            household_collected = sum(household_collected),
            household_recycled = sum(household_recycled),
            household_not_recycled = sum(household_not_recycled),
            recycling_rate = household_recycled / household_collected,
            rejects_per_capita = sum(household_rejects) / sum(population)) %>% 
  ungroup()
