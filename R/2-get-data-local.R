# SUMMARY ######################################################################
# This script retrieves the data required for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)
library(dplyr)
library(readr)
library(readxl)
library(googledrive)
library(googlesheets4)

# > Scripts ====================================================================
source(here("R/1-utils.R"))

# > Params =====================================================================
folder <- here("data/src/")

# GET DATA #####################################################################
# > LAD ========================================================================
lad_file <- "lad21.xlsx"
lad_src <- read_excel(paste0(folder, lad_file))

# > LAD to Combined Authority ==================================================
cau_file <- "lad21-to-cauth21.xlsx"
cau_src <- read_excel(paste0(folder, cau_file))

# > LAD to Country =============================================================
ctr_file <- "lad21-to-country21.csv"
ctr_src <- read_csv(paste0(folder, ctr_file))

# > LAD to Region ==============================================================
rgn_file <- "lad21-to-region21.csv"
rgn_src <- read_csv(paste0(folder, rgn_file))

# > Recycling Rates ============================================================
rec_file <- "recycling-by-lad-2021.xlsx"
rec_src <- read_excel(
  paste0(folder, rec_file),
  range = "Table_1!A4:W2759"
)

# > Recycling Systems ==========================================================
sys_file <- "systems-by-lad-2021.csv"
sys_src <- read_csv(paste0(folder, sys_file))

# > Survey =====================================================================
srv_file <- drive_ls("~/uk-recycling/") %>%
  filter(name == "system-by-lad-survey") %>%
  pull(id)

srv_src <- read_sheet(srv_file)

# > Population =================================================================
pop_file <- "population-by-lad-2021.xls" 
pop_src <- read_excel(
  paste0(folder, pop_file),
  range = "MYE4!A8:D428"
)