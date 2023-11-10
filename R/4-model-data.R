# SUMMARY ######################################################################
# This script models the data required for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)

# > Scripts ====================================================================
source(here("R/3-prep-data.R"))

# FLAT DATA ####################################################################
data <- 
  lad_cln %>% 
  left_join(sys_cln,
            by = "lad21cd") %>% 
  left_join(rec_cln,
            by = "wa21cd")

# EXPLORATORY ANALYSIS #########################################################
x <- data %>% 
  filter(!is.na(bins)) %>% 
  select(lad21nm,
         waste_authority,
         bins,
         total_waste = household_total_waste_tonnes,
         recycled_waste = household_waste_sent_for_recycling_composting_reuse_tonnes,
         not_recycled_waste = household_waste_not_sent_for_recycling_tonnes) %>% 
  mutate(recycling_rate = recycled_waste / total_waste) %>% 
  group_by(bins) %>% 
  summarise(sample_size = n(),
            total_waste = sum(total_waste),
            recycled_waste = sum(recycled_waste),
            not_recycled_waste = sum(not_recycled_waste),
            recycling_rate = recycled_waste / total_waste) %>% 
  ungroup()
