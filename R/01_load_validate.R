# ==============================================================================
# 01_load_validate.R — Load and validate the HAB event catalog
# ==============================================================================

source(here::here("R", "00_setup.R"))

# --- Load catalog -------------------------------------------------------------

catalog <- read_csv(
  file.path(path_raw, "event_catalog.csv"),
  col_types = cols(
    event_id              = col_character(),
    event_name            = col_character(),
    event_category        = col_character(),
    year                  = col_integer(),
    start_date            = col_date(format = ""),
    end_date              = col_date(format = ""),
    duration_days         = col_integer(),
    event_status          = col_character(),
    country_iso3          = col_character(),
    country_name          = col_character(),
    region_level1         = col_character(),
    region_level2         = col_character(),
    water_body            = col_character(),
    lat_centroid          = col_double(),
    lon_centroid          = col_double(),
    affected_area_km2     = col_double(),
    environment_type      = col_character(),
    species_primary       = col_character(),
    species_primary_authority = col_character(),
    species_secondary     = col_character(),
    species_tertiary      = col_character(),
    taxonomic_class       = col_character(),
    species_notes         = col_character(),
    max_cell_density      = col_double(),
    cell_density_depth_m  = col_double(),
    max_chlorophyll_ug_L  = col_double(),
    bloom_visible         = col_logical(),
    bloom_color           = col_character(),
    fish_affected_type    = col_character(),
    fish_species_affected = col_character(),
    fish_killed_n         = col_double(),
    fish_killed_n_qualifier = col_character(),
    fish_killed_tonnes    = col_double(),
    fish_killed_tonnes_qualifier = col_character(),
    farms_affected_n      = col_integer(),
    fish_mortality_notes  = col_character(),
    human_cases           = col_integer(),
    human_deaths          = col_integer(),
    human_syndrome        = col_character(),
    human_health_notes    = col_character(),
    ecological_impact_level = col_character(),
    wildlife_mortality    = col_logical(),
    wildlife_species_affected = col_character(),
    benthic_impact        = col_logical(),
    ecological_notes      = col_character(),
    economic_loss_value   = col_double(),
    economic_loss_currency = col_character(),
    economic_loss_year    = col_integer(),
    economic_loss_usd     = col_double(),
    economic_loss_type    = col_character(),
    economic_loss_qualifier = col_character(),
    economic_sectors_affected = col_character(),
    fishery_closures      = col_logical(),
    beach_closures        = col_logical(),
    desalination_affected = col_logical(),
    economic_notes        = col_character(),
    mitigation_attempted  = col_logical(),
    mitigation_methods    = col_character(),
    mitigation_effectiveness = col_character(),
    monitoring_preexisting = col_logical(),
    warning_issued        = col_logical(),
    response_notes        = col_character(),
    source_doi_primary    = col_character(),
    source_dois_secondary = col_character(),
    source_type           = col_character(),
    data_quality          = col_character(),
    extraction_confidence = col_character(),
    extraction_date       = col_date(format = ""),
    extraction_agent      = col_character(),
    verification_status   = col_character(),
    notes                 = col_character()
  )
)

cat("Loaded", nrow(catalog), "events from catalog.\n")

# --- Validation ---------------------------------------------------------------

# Load controlled vocabularies
vocabs <- jsonlite::fromJSON(
  file.path(path_schema, "controlled_vocabularies.json")
)$vocabularies

validate_catalog <- function(df) {
  issues <- character()

  # 1. Required fields present
  required <- c(
    "event_id", "event_category", "year", "event_status",
    "country_iso3", "country_name", "environment_type",
    "species_primary", "taxonomic_class", "fish_affected_type",
    "source_doi_primary", "source_type",
    "data_quality", "extraction_confidence",
    "extraction_date", "extraction_agent", "verification_status"
  )
  for (fld in required) {
    na_rows <- which(is.na(df[[fld]]))
    if (length(na_rows) > 0) {
      issues <- c(issues, sprintf("Missing required field '%s' in rows: %s",
                                   fld, paste(na_rows, collapse = ", ")))
    }
  }

  # 2. event_id format
  bad_ids <- df$event_id[!grepl("^[A-Z]{3}_[0-9]{4}_[0-9]{3}$", df$event_id)]
  if (length(bad_ids) > 0) {
    issues <- c(issues, sprintf("Invalid event_id format: %s",
                                 paste(bad_ids, collapse = ", ")))
  }

  # 3. Numeric fields non-negative
  numeric_cols <- c("fish_killed_n", "fish_killed_tonnes", "max_cell_density",
                    "economic_loss_value", "economic_loss_usd", "human_cases",
                    "human_deaths", "affected_area_km2")
  for (col in numeric_cols) {
    if (col %in% names(df)) {
      neg <- which(!is.na(df[[col]]) & df[[col]] < 0)
      if (length(neg) > 0) {
        issues <- c(issues, sprintf("Negative values in '%s' at rows: %s",
                                     col, paste(neg, collapse = ", ")))
      }
    }
  }

  # 4. Dates valid: start_date <= end_date
  if (all(c("start_date", "end_date") %in% names(df))) {
    date_check <- which(!is.na(df$start_date) & !is.na(df$end_date) &
                          df$start_date > df$end_date)
    if (length(date_check) > 0) {
      issues <- c(issues, sprintf("start_date > end_date in rows: %s",
                                   paste(date_check, collapse = ", ")))
    }
  }

  # 5. Controlled vocabulary compliance
  vocab_checks <- list(
    event_category    = c("fish_kill", "human_health", "economic", "mixed"),
    event_status      = c("resolved", "recurrent"),
    environment_type  = c("marine_coastal", "marine_offshore", "estuarine", "brackish", "fjord", "freshwater_lake", "freshwater_river"),
    taxonomic_class   = c("Dinophyceae", "Raphidophyceae", "Dictyochophyceae",
                          "Prymnesiophyceae", "Bacillariophyceae", "Cyanophyceae", "Other"),
    fish_affected_type = c("farmed", "wild", "both", "unknown"),
    human_syndrome    = c("PSP", "DSP", "ASP", "NSP", "CFP", "AZP", "respiratory", "dermal", "other", "none", "cyanotoxin"),
    data_quality      = c("high", "medium", "low"),
    extraction_confidence = c("high", "medium", "low"),
    source_type       = c("peer_reviewed", "government_report", "news", "industry", "database", "personal_comm"),
    extraction_agent  = c("human", "claude", "claude_verified"),
    verification_status = c("unverified", "verified", "disputed")
  )
  for (fld in names(vocab_checks)) {
    if (fld %in% names(df)) {
      vals <- unique(na.omit(df[[fld]]))
      bad <- vals[!vals %in% vocab_checks[[fld]]]
      if (length(bad) > 0) {
        issues <- c(issues, sprintf("Invalid values in '%s': %s",
                                     fld, paste(bad, collapse = ", ")))
      }
    }
  }

  # 6. DOI format
  bad_dois <- df$source_doi_primary[
    !is.na(df$source_doi_primary) &
    !grepl("^10\\.\\d{4,}/.*$", df$source_doi_primary)
  ]
  if (length(bad_dois) > 0) {
    issues <- c(issues, sprintf("Invalid DOI format: %s",
                                 paste(bad_dois, collapse = ", ")))
  }

  # Report
  if (length(issues) == 0) {
    cat("VALIDATION PASSED: All", nrow(df), "entries are valid.\n")
  } else {
    cat("VALIDATION ISSUES FOUND:\n")
    for (issue in issues) {
      cat("  -", issue, "\n")
    }
  }

  invisible(issues)
}

issues <- validate_catalog(catalog)

# --- Summary ------------------------------------------------------------------

cat("\n--- Catalog Summary ---\n")
cat("Total events:", nrow(catalog), "\n")
cat("Year range:", min(catalog$year), "-", max(catalog$year), "\n")
cat("Countries:", paste(sort(unique(catalog$country_iso3)), collapse = ", "), "\n")
cat("Taxonomic classes:", paste(sort(unique(catalog$taxonomic_class)), collapse = ", "), "\n")
cat("Event categories:", paste(sort(unique(catalog$event_category)), collapse = ", "), "\n")
