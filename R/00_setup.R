# ==============================================================================
# 00_setup.R — Package loading and project paths
# HAB Catastrophic Events Review
# ==============================================================================

# --- Required packages --------------------------------------------------------

# Core
library(tidyverse)
library(lubridate)

# Visualization
library(ggplot2)
library(scales)
library(patchwork)
library(ggrepel)

# Mapping
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Tables
library(gt)
library(kableExtra)

# Other
library(countrycode)  # ISO code handling
library(janitor)      # Data cleaning

# --- Project paths ------------------------------------------------------------

proj_root <- here::here()

path_raw       <- file.path(proj_root, "data", "raw")
path_processed <- file.path(proj_root, "data", "processed")
path_reference <- file.path(proj_root, "data", "reference")
path_schema    <- file.path(proj_root, "data", "schema")
path_figures   <- file.path(proj_root, "figures")
path_tables    <- file.path(proj_root, "tables")
path_literature <- file.path(proj_root, "literature")

# --- Source helper functions --------------------------------------------------

source(file.path(proj_root, "R", "functions", "plotting_theme.R"))
source(file.path(proj_root, "R", "functions", "validation.R"))
source(file.path(proj_root, "R", "functions", "utils.R"))

# --- Global options -----------------------------------------------------------

options(scipen = 999)  # Avoid scientific notation in outputs
theme_set(theme_hab_review())
