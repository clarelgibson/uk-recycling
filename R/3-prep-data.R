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

# > LAD Shapefile ==============================================================
shp_cln <- shp_src %>% 
  clean_names() %>% 
  select(
    lad21cd,
    bng_e:lat,
    geometry
  )

# > Regions ====================================================================
rgn_cln <- rgn_src %>% 
  clean_names() %>% 
  select(-c(fid,
            lad21nm),
         region = rgn21nm)
  
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
  mutate(
    in_rec = "Y",
    household_recycle_rate = household_recycled / household_collected
  )

# > FOI Recycling Systems ======================================================
foi_cln <- foi_src %>% 
  clean_names() %>% 
  mutate(
    collection_type = case_when(
      collection_type_1 == "Two Stream Plus Textiles" ~ "Two Stream",
      collection_type_1 == "Co-Mingled Plus Textiles" ~ "Co-Mingled",
      TRUE ~ collection_type_1
    ),
    collection_type_sort = case_when(
      collection_type == "Co-Mingled" ~ 1,
      collection_type == "Two Stream" ~ 2,
      collection_type == "Multi-Stream" ~ 3,
      TRUE ~ 4
    ),
    in_foi = "Y"
  ) %>% 
  select(
    lad21cd = ons_no,
    collection_type,
    collection_type_sort,
    in_foi
  )

# > Population =================================================================
pop_cln <- pop_src %>%
  clean_names() %>% 
  select(lad21cd = code,
         population = mid_2021)
