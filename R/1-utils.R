# SUMMARY ######################################################################
# This script stores custom functions for the project

# SETUP ########################################################################
# > Packages ===================================================================
library(here)

# FUNCTIONS ####################################################################
# Read file from Google Drive ==================================================
read_drive_file <- function(folder, filename) {
  require(googledrive)
  require(tidyr)
  require(dplyr)
  require(readr)
  require(googlesheets4)
  require(readxl)

  files <- drive_ls(folder) %>% 
    unnest_wider(drive_resource, names_sep = "_") %>% 
    select(name,
           id,
           extension = drive_resource_fileExtension,
           mime = drive_resource_mimeType)
  
  rurl <- "https://drive.google.com/uc?export=download&id="
  file_meta <- files %>% 
    filter(name == filename)
  
  file_id   <- file_meta$id
  file_ext  <- file_meta$extension
  file_mime <- file_meta$mime
  file_type <- 
    case_when(grepl("csv", file_ext) ~ "csv",
              grepl("xls", file_ext) ~ "excel",
              grepl("google-apps.spreadsheet", file_mime) ~ "sheet",
              TRUE ~ "Other")
  
  url <- paste0(rurl,file_id)
  
  df <- 
    if(file_type == "csv") {
      read_csv(url)
    } else if(file_type == "excel") {
      read_excel(url)
    } else if(file_type == "sheet") {
      read_sheet(file_id)
    } else "XX"
  
  return(df)
}