# ==============================================================================
# 00_setup.R — Package loading and project paths
# HAB Catastrophic Events Review
# ==============================================================================

# --- Required packages --------------------------------------------------------

# Helper: load package, skip gracefully if missing
load_pkg <- function(pkg) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  } else {
    message("  Note: package '", pkg, "' not available — some features disabled")
  }
}

# Core
load_pkg("dplyr")
load_pkg("tidyr")
load_pkg("readr")
load_pkg("stringr")
load_pkg("forcats")
load_pkg("purrr")
load_pkg("tibble")
load_pkg("lubridate")

# Visualization
load_pkg("ggplot2")
load_pkg("scales")
load_pkg("patchwork")
load_pkg("ggrepel")

# Mapping (optional — may not be installed)
load_pkg("sf")
load_pkg("rnaturalearth")
load_pkg("rnaturalearthdata")

# Tables
load_pkg("gt")
load_pkg("kableExtra")

# Other
load_pkg("countrycode")
load_pkg("janitor")
load_pkg("jsonlite")

# --- Project paths ------------------------------------------------------------

proj_root <- here::here()

path_raw       <- file.path(proj_root, "data", "raw")
path_processed <- file.path(proj_root, "data", "processed")
path_reference <- file.path(proj_root, "data", "reference")
path_schema    <- file.path(proj_root, "data", "schema")
path_figures   <- file.path(proj_root, "figures")
path_tables    <- file.path(proj_root, "tables")
path_literature <- file.path(proj_root, "literature")

# Ensure output directories exist
for (d in c(path_processed,
            file.path(path_figures, "main"),
            file.path(path_figures, "supplementary"),
            file.path(path_tables, "main"),
            file.path(path_tables, "supplementary"))) {
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

# --- Source helper functions --------------------------------------------------

source(file.path(proj_root, "R", "functions", "plotting_theme.R"))
source(file.path(proj_root, "R", "functions", "validation.R"))
source(file.path(proj_root, "R", "functions", "utils.R"))

# --- Global options -----------------------------------------------------------

options(scipen = 999)  # Avoid scientific notation in outputs
theme_set(theme_hab_review())
