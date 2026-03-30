# ==============================================================================
# 02_normalize_units.R — Unit harmonization and derived columns
# Reads raw catalog, produces data/processed/event_catalog_normalized.csv
# ==============================================================================

source(here::here("R", "00_setup.R"))

# --- Load raw catalog using base R for robust CSV parsing --------------------

catalog <- read.csv(
  file.path(path_raw, "event_catalog.csv"),
  stringsAsFactors = FALSE,
  na.strings = c("", "NA")
)
cat("Loaded", nrow(catalog), "events from raw catalog.\n")

# --- Clean known data quality issues -----------------------------------------

# Fix human_syndrome: some rows have merged syndrome + notes
catalog$human_syndrome <- sapply(catalog$human_syndrome, function(x) {
  if (is.na(x)) return(NA_character_)
  valid <- c("PSP","DSP","ASP","NSP","CFP","AZP","respiratory","dermal","other","none","cyanotoxin")
  if (x %in% valid) return(x)
  # Try splitting on first comma
  parts <- strsplit(x, ", ", fixed = FALSE)[[1]]
  if (length(parts) > 1 && parts[1] %in% valid) return(parts[1])
  # Numeric values are shifted human_deaths — set to NA
  if (grepl("^\\d+$", x)) return(NA_character_)
  # Text values are leaked notes — set to NA
  if (nchar(x) > 20) return(NA_character_)
  return(x)
}, USE.NAMES = FALSE)

# Fix fish_affected_type: ensure valid enum
valid_fat <- c("farmed", "wild", "both", "unknown")
catalog$fish_affected_type[!catalog$fish_affected_type %in% valid_fat] <- NA_character_

# Ensure numeric columns are numeric
num_cols <- c("fish_killed_n", "fish_killed_tonnes", "economic_loss_value",
              "economic_loss_usd", "human_cases", "human_deaths",
              "max_cell_density", "affected_area_km2", "max_chlorophyll_ug_L")
for (col in num_cols) {
  if (col %in% names(catalog)) {
    catalog[[col]] <- suppressWarnings(as.numeric(catalog[[col]]))
  }
}

cat("Data cleaning complete.\n")

# --- 1. Economic loss USD conversion -----------------------------------------

fx_rates <- data.frame(
  currency = c("NZD", "AUD", "AUD", "HKD", "GBP"),
  year     = c(1989,   1996,  2012,  1998,  2013),
  rate     = c(0.59,   0.78,  1.03,  0.13,  1.56),
  stringsAsFactors = FALSE
)

catalog$usd_conversion_note <- NA_character_
n_converted <- 0

for (i in seq_len(nrow(catalog))) {
  if (is.na(catalog$economic_loss_usd[i]) &&
      !is.na(catalog$economic_loss_value[i]) &&
      !is.na(catalog$economic_loss_currency[i])) {

    cur <- catalog$economic_loss_currency[i]
    yr  <- catalog$economic_loss_year[i]

    match <- fx_rates[fx_rates$currency == cur & fx_rates$year == yr, ]
    if (nrow(match) == 1) {
      catalog$economic_loss_usd[i] <- catalog$economic_loss_value[i] * match$rate[1]
      catalog$usd_conversion_note[i] <- sprintf(
        "converted from %s at %.2f; %s mid-year rate", cur, match$rate[1], as.character(yr)
      )
      n_converted <- n_converted + 1
    }
  }
}
cat("USD conversions applied:", n_converted, "\n")

# --- 2. Fish mortality harmonization -----------------------------------------

catalog$fish_killed_tonnes_derived <- NA_real_
catalog$fish_tonnes_source <- "unavailable"

for (i in seq_len(nrow(catalog))) {
  if (!is.na(catalog$fish_killed_tonnes[i])) {
    catalog$fish_killed_tonnes_derived[i] <- catalog$fish_killed_tonnes[i]
    catalog$fish_tonnes_source[i] <- "reported"
  } else if (!is.na(catalog$fish_killed_n[i])) {
    fat <- catalog$fish_affected_type[i]
    sp  <- tolower(catalog$fish_species_affected[i] %||% "")

    # Skip seabird/wildlife events
    if (grepl("scoter|murre|loon|grebe|pelican|seabird|bird", sp) ||
        grepl("sea lion|manatee", sp)) {
      next
    }

    # Estimate using species-appropriate conversion
    n <- catalog$fish_killed_n[i]
    if (!is.na(fat) && fat == "farmed") {
      if (grepl("salmon", sp)) {
        catalog$fish_killed_tonnes_derived[i] <- n / 250  # 4 kg/fish
      } else if (grepl("yellowtail|amberjack|seriola", sp)) {
        catalog$fish_killed_tonnes_derived[i] <- n / 333  # 3 kg/fish
      } else {
        catalog$fish_killed_tonnes_derived[i] <- n / 250  # default farmed
      }
      catalog$fish_tonnes_source[i] <- "estimated_from_n"
    } else if (!is.na(fat) && fat %in% c("wild", "both")) {
      catalog$fish_killed_tonnes_derived[i] <- n / 2000  # 0.5 kg/fish
      catalog$fish_tonnes_source[i] <- "estimated_from_n"
    }
    # unknown fish_affected_type: leave as NA
  }
}

n_reported  <- sum(catalog$fish_tonnes_source == "reported", na.rm = TRUE)
n_estimated <- sum(catalog$fish_tonnes_source == "estimated_from_n", na.rm = TRUE)
cat("Fish tonnes — reported:", n_reported, "estimated:", n_estimated, "\n")

# --- 3. Economic loss magnitude classification --------------------------------

catalog$economic_magnitude <- case_when(
  is.na(catalog$economic_loss_usd)             ~ "unknown",
  catalog$economic_loss_usd < 1e6              ~ "<1M",
  catalog$economic_loss_usd < 1e7              ~ "1-10M",
  catalog$economic_loss_usd < 1e8              ~ "10-100M",
  catalog$economic_loss_usd < 1e9              ~ "100M-1B",
  catalog$economic_loss_usd >= 1e9             ~ ">1B",
  TRUE                                         ~ "unknown"
)

cat("Economic magnitude distribution:\n")
print(table(catalog$economic_magnitude, useNA = "ifany"))

# --- 4. Decade classification ------------------------------------------------

catalog$decade <- floor(catalog$year / 10) * 10
cat("Decade distribution:\n")
print(table(catalog$decade))

# --- 5. Region classification ------------------------------------------------

region_lookup <- c(
  NOR="Northern Europe", SWE="Northern Europe", DNK="Northern Europe",
  GBR="Northern Europe", IRL="Northern Europe", FIN="Northern Europe",
  ESP="Southern Europe / Mediterranean", ITA="Southern Europe / Mediterranean",
  TUR="Southern Europe / Mediterranean",
  CHL="Latin America", MEX="Latin America", GTM="Latin America",
  NIC="Latin America", CRI="Latin America", BRA="Latin America",
  PYF="Pacific Islands",
  JPN="East Asia", KOR="East Asia", CHN="East Asia",
  USA="North America", CAN="North America",
  AUS="Australasia / Pacific", NZL="Australasia / Pacific",
  PHL="Southeast Asia", MYS="Southeast Asia", IDN="Southeast Asia",
  IND="South Asia",
  ZAF="Africa", MAR="Africa",
  ARE="Middle East / Indian Ocean", OMN="Middle East / Indian Ocean",
  DEU="Northern Europe", POL="Northern Europe"
)

catalog$region_broad <- region_lookup[catalog$country_iso3]
catalog$region_broad[is.na(catalog$region_broad)] <- "Other"

cat("Region distribution:\n")
print(table(catalog$region_broad))

# --- 6. Write output ---------------------------------------------------------

write.csv(catalog, file.path(path_processed, "event_catalog_normalized.csv"),
          row.names = FALSE, na = "")

cat("\nNormalized catalog written to", file.path(path_processed, "event_catalog_normalized.csv"), "\n")
cat("Rows:", nrow(catalog), "Cols:", ncol(catalog), "\n")
cat("\n=== 02_normalize_units.R COMPLETE ===\n")
