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
    local_authority = lad21nm
  ) %>% 
  # Keep only LADs in England
  filter(grepl("^E", lad21cd)) %>% 
  # Tag to identify record present in this data source
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

# > Countries ==================================================================
ctr_cln <- ctr_src %>% 
  clean_names() %>% 
  select(-c(fid,
            lad21nm),
         country = ctry21nm)

# > Regions ====================================================================
rgn_cln <- rgn_src %>% 
  clean_names() %>% 
  select(-c(fid,
            lad21nm),
         region = rgn21nm)

# > Combined Authorities =======================================================
cau_cln <- cau_src %>% 
  clean_names() %>% 
  select(-lad21nm,
         combined_authority = cauth21nm)
  
# > Recycling Rates ============================================================
rec_cln <- rec_src %>% 
  clean_names() %>% 
  filter(financial_year == "2021-22") %>% 
  select(wa21cd = ons_code,
         waste_authority = local_authority,
         waste_authority_type = authority_type,
         total_collected = total_local_authority_collected_waste_tonnes,
         total_recycled = local_authority_collected_waste_sent_for_recycling_composting_reuse_tonnes,
         total_not_recycled = local_authority_collected_waste_not_sent_for_recycling_tonnes,
         total_rejects = local_authority_collected_estimated_rejects_tonnes,
         household_collected = household_total_waste_tonnes,
         household_recycled = household_waste_sent_for_recycling_composting_reuse_tonnes,
         household_not_recycled = household_waste_not_sent_for_recycling_tonnes,
         household_rejects = household_estimated_rejects_tonnes_see_notes_sheet_for_detail_on_rejects_calculation,
         non_household_collected = non_household_total_waste_tonnes,
         non_household_recycled = non_household_waste_sent_for_recycling_composting_reuse_tonnes,
         non_household_not_recycled = non_household_waste_not_sent_for_recycling_tonnes,
         non_household_rejects = non_household_estimated_rejects_tonnes) %>% 
  mutate(in_rec = "Y")

# > Recycling Systems ==========================================================
sys_cln <- sys_src %>% 
  clean_names() %>% 
  select(-lad21nm) %>% 
  mutate(in_sys = "Y",
         bins_verified = if_else(!is.na(bins), "Y", "N"))

# > Survey =====================================================================
srv_cln <- srv_src %>%
  clean_names() %>%
  # shorten names
  rename(local_authority = 2,
         bin_type = 3,
         bin_count = 4,
         source_url = 5,
         comments = 6) %>%
  # add LAD code
  left_join(select(lad_cln,
                   lad21cd,
                   local_authority)) %>%
  # fix column types
  mutate(bin_count = as.numeric(bin_count)) %>%
  # remove empty/invalid rows
  filter(!is.na(bin_count),
         !is.na(local_authority)) %>%
  # select columns
  select(timestamp,
         lad21cd,
         bin_type,
         bin_count,
         source_url,
         comments) %>%
  # recode bin type values
  mutate(bin_type = case_when(
    grepl("communal", bin_type) ~ "Communal",
    grepl("household", bin_type) ~ "Individual",
    TRUE ~ "Not reported"
  ))

# Build a df to count the number of survey responses by LAD
srv_count <- srv_cln %>%
  count(lad21cd,
        name = "survey_responses")

# > Population =================================================================
pop_cln <- pop_src %>%
  clean_names() %>% 
  select(lad21cd = code,
         population = mid_2021)
