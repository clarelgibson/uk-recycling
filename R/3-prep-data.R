# SUMMARY ######################################################################
# This script cleans the data required for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)
library(janitor)

# > Scripts ====================================================================
source(here("R/2-get-data-local.R"))

# CLEAN DATA ###################################################################
# > Local Authority Districts ==================================================
lad_cln <- lad_src %>% 
  clean_names() %>% 
  select(
    lad21cd,
    lad21nm
  ) %>% 
  mutate(in_lad = "Y") %>% 
  # Map to correct waste authority codes
  mutate(
    wa21cd = case_when(
      lad21cd == "E06000060" ~ "E10000002", # Bucks
      lad21cd == "E07000008" ~ "E50000008", # Cambs City
      lad21cd == "E07000012" ~ "E50000008", # Cambs South
      lad21cd == "E07000187" ~ "E50000009", # Mendip
      lad21cd == "E07000188" ~ "E50000009", # Sedgemoor
      lad21cd == "E07000189" ~ "E50000009", # South Somerset
      lad21cd == "E07000200" ~ "E07000203", # Babergh
      lad21cd == "E07000246" ~ "E50000009", # Somerset W/Taunton
      TRUE ~ lad21cd
    )
  )
  
# > Recycling Rates ============================================================
rec_cln <- rec_src %>% 
  clean_names() %>% 
  filter(financial_year == "2021-22") %>% 
  rename(wa21cd = ons_code,
         waste_authority = local_authority) %>% 
  mutate(in_rec = "Y")

# > Recycling Systems ==========================================================
sys_cln <- sys_src %>% 
  clean_names() %>% 
  select(-lad21nm) %>% 
  mutate(in_sys = "Y")