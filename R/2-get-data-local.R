# SUMMARY ######################################################################
# This script retrieves the data required for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)
library(dplyr)
library(readr)
library(readxl)

# > Scripts ====================================================================
source(here("R/1-utils.R"))

# > Params =====================================================================
folder <- here("data/src/")

# GET DATA #####################################################################
# > LAD ========================================================================
lad_file <- "lad21.xlsx"
lad_src <- read_excel(paste0(folder, lad_file))

# > LAD to Combined Authority ==================================================
lad_cauth_file <- "lad21-to-cauth21.xlsx"
lad_cauth_src <- read_excel(paste0(folder, lad_cauth_file))

# > Recycling Rates ============================================================
rec_file <- "recycling-by-lad-2021.xlsx"
rec_src <- read_excel(
  paste0(folder, rec_file),
  range = "Table_1!A4:W2759"
)

# > Recycling Systems ==========================================================
sys_file <- "systems-by-lad-2021.csv"
sys_src <- read_csv(paste0(folder, sys_file))