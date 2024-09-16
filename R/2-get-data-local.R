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
library(sf)

# > Scripts ====================================================================
source(here("R/1-utils.R"))

# > Params =====================================================================
folder <- here("data/src/")

# GET DATA #####################################################################
# > LAD ========================================================================
lad_file <- "lad21.xlsx"
lad_src <- read_excel(paste0(folder, lad_file))

# > LAD Shapefile ==============================================================
shp_file <- "lad21-shapefile"
shp_src <- read_sf(paste0(folder, shp_file))

# > LAD to Region ==============================================================
rgn_file <- "lad21-to-region21.csv"
rgn_src <- read_csv(paste0(folder, rgn_file))

# > Recycling Rates ============================================================
rec_file <- "recycling-by-lad-2021.xlsx"
rec_src <- read_excel(
  paste0(folder, rec_file),
  range = "Table_1!A4:W2759"
)

# > FOI Recycling Systems ======================================================
foi_file <- "EIR2023_21546.xlsx"
foi_src <- read_excel(
  paste0(folder, foi_file),
  sheet = " Dry data 202122"
)

# > Population =================================================================
pop_file <- "population-by-lad-2021.xls" 
pop_src <- read_excel(
  paste0(folder, pop_file),
  range = "MYE4!A8:D428"
)