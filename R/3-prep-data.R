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

# > CHD Lookup =================================================================
chd_cln <- chd_src |> 
  clean_names() |> 
  # Keep only LAD changes from 2021
  filter(
    year == 2021,
    entitycd %in% c("E06", "E07", "E08", "E09")
  ) |> 
  # Keep only necessary columns
  select(
    lad21cd = geogcd,
    local_authority = geognm,
    lad19cd = geogcd_p
  )

# Make tibble for changes that are missing from the CHD file
chd_add <- tibble(
  lad21cd = rep("E06000060", 4),
  local_authority = rep("Buckinghamshire", 4),
  lad19cd = c("E07000004", "E07000005", "E07000006", "E07000007")
)

# Join chd to additional
chd_cln <- chd_cln |> 
  bind_rows(chd_add)

# > LAD Shapefile ==============================================================
shp_cln <- shp_src %>% 
  clean_names() %>% 
  select(
    lad21cd,
    bng_e:lat,
    geometry
  ) |> 
  # add area
  mutate(
    area_km2 = as.numeric(st_area(geometry) / 1000000)
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

# > Population 2019 ============================================================
pop19_cln <- pop19_src %>%
  clean_names() %>% 
  select(lad19cd = code,
         population = all_ages)

# > Deprivation ================================================================
dep_cln <- dep_src |> 
  clean_names() |> 
  # Keep only necessary columns
  select(
    lad19cd = local_authority_district_code_2019,
    imd_average_score
  ) |> 
  # Map lad21cd from CHD lookup
  left_join(
    select(
      chd_cln,
      lad19cd,
      lad21cd
    ),
    by = join_by(lad19cd)
  ) |> 
  # If nothing found in CHD lookup then lad21cd == lad19cd
  mutate(lad21cd = coalesce(lad21cd, lad19cd)) |> 
  # Add in 2019 population so we can compute weighted mean for groups
  left_join(pop19_cln) |> 
  # Aggregate to LAD 21 entities
  group_by(lad21cd) |> 
  summarise(
    imd_average_score = weighted.mean(imd_average_score, w = population),
    .groups = "drop"
    )

# > Rural-Urban Classification =================================================
ruc_cln <- ruc_src |> 
  clean_names() |> 
  # Keep only necessary columns
  select(
    lad21cd,
    ruc21_settlement_class,
    rurality = proportion_of_population_in_rural_o_as_percent
  ) |> 
  # Convert rurality to decimal percent
  mutate(
    rurality = rurality / 100
  ) |> 
  # Keep only LADs in England
  filter(grepl("^E", lad21cd))
