# ==============================================================================
# 03_summary_statistics.R — Descriptive statistics and summary tables
# ==============================================================================

source(here::here("R", "00_setup.R"))

# --- Load normalized catalog -------------------------------------------------

norm_file <- file.path(path_processed, "event_catalog_normalized.csv")
if (!file.exists(norm_file)) {
  cat("Running 02_normalize_units.R first...\n")
  source(here::here("R", "02_normalize_units.R"))
}
cat <- read.csv(norm_file, stringsAsFactors = FALSE, na.strings = c("", "NA"))
cat("Loaded", nrow(cat), "events from normalized catalog.\n\n")

# --- 1. Overall counts -------------------------------------------------------

cat("=== OVERALL COUNTS ===\n")
cat("Total events:", nrow(cat), "\n")
cat("Year range:", min(cat$year, na.rm = TRUE), "-", max(cat$year, na.rm = TRUE), "\n")
cat("Unique countries:", length(unique(cat$country_iso3)), "\n")
cat("Unique species:", length(unique(cat$species_primary)), "\n\n")

# --- 2. Events by decade and category ----------------------------------------

decade_cat <- table(cat$decade, cat$event_category)
cat("=== EVENTS BY DECADE × CATEGORY ===\n")
print(addmargins(decade_cat))
write.csv(as.data.frame.matrix(addmargins(decade_cat)),
          file.path(path_tables, "supplementary", "summary_by_decade_category.csv"))
cat("\n")

# --- 3. Events by region -----------------------------------------------------

region_tbl <- as.data.frame(table(cat$region_broad), stringsAsFactors = FALSE)
names(region_tbl) <- c("Region", "Count")
region_tbl$Pct <- round(100 * region_tbl$Count / sum(region_tbl$Count), 1)
region_tbl <- region_tbl[order(-region_tbl$Count), ]

cat("=== EVENTS BY REGION ===\n")
print(region_tbl, row.names = FALSE)
write.csv(region_tbl, file.path(path_tables, "supplementary", "summary_by_region.csv"),
          row.names = FALSE)
cat("\n")

# --- 4. Events by taxonomic class --------------------------------------------

taxon_summary <- do.call(rbind, lapply(split(cat, cat$taxonomic_class), function(d) {
  data.frame(
    TaxonomicClass = d$taxonomic_class[1],
    Count = nrow(d),
    MeanEconUSD = round(mean(d$economic_loss_usd, na.rm = TRUE)),
    MedianEconUSD = round(median(d$economic_loss_usd, na.rm = TRUE)),
    MaxEconUSD = max(d$economic_loss_usd, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}))
taxon_summary <- taxon_summary[order(-taxon_summary$Count), ]

cat("=== EVENTS BY TAXONOMIC CLASS ===\n")
print(taxon_summary, row.names = FALSE)
write.csv(taxon_summary, file.path(path_tables, "supplementary", "summary_by_taxon.csv"),
          row.names = FALSE)
cat("\n")

# --- 5. Human health summary -------------------------------------------------

hh <- cat[!is.na(cat$human_cases) & cat$human_cases > 0 |
          !is.na(cat$human_deaths) & cat$human_deaths > 0, ]

cat("=== HUMAN HEALTH SUMMARY ===\n")
cat("Events with human cases/deaths:", nrow(hh), "\n")
cat("Total human cases:", sum(hh$human_cases, na.rm = TRUE), "\n")
cat("Total human deaths:", sum(hh$human_deaths, na.rm = TRUE), "\n")
cat("Syndromes:\n")
print(table(hh$human_syndrome, useNA = "ifany"))

hh_out <- hh[, c("event_id", "year", "country_name", "species_primary",
                  "human_syndrome", "human_cases", "human_deaths")]
hh_out <- hh_out[order(-hh_out$human_deaths, -hh_out$human_cases), ]
write.csv(hh_out, file.path(path_tables, "supplementary", "summary_human_health.csv"),
          row.names = FALSE)
cat("\n")

# --- 6. Fish mortality summary -----------------------------------------------

cat("=== FISH MORTALITY SUMMARY ===\n")
cat("Total fish killed (individuals, sum):", format(sum(cat$fish_killed_n, na.rm = TRUE), big.mark = ","), "\n")
cat("Total fish killed (tonnes, reported):", format(sum(cat$fish_killed_tonnes, na.rm = TRUE), big.mark = ","), "\n")
cat("Total fish killed (tonnes, derived):", format(sum(cat$fish_killed_tonnes_derived, na.rm = TRUE), big.mark = ","), "\n")
cat("Breakdown by fish_affected_type:\n")
print(table(cat$fish_affected_type, useNA = "ifany"))
cat("\n")

# --- 7. Economic impact summary ----------------------------------------------

econ <- cat[!is.na(cat$economic_loss_usd), ]

cat("=== ECONOMIC IMPACT SUMMARY ===\n")
cat("Events with USD values:", nrow(econ), "\n")
cat("Total economic loss (USD):", format(sum(econ$economic_loss_usd, na.rm = TRUE), big.mark = ","), "\n")
cat("Mean:", format(mean(econ$economic_loss_usd, na.rm = TRUE), big.mark = ","), "\n")
cat("Median:", format(median(econ$economic_loss_usd, na.rm = TRUE), big.mark = ","), "\n")
cat("Max:", format(max(econ$economic_loss_usd, na.rm = TRUE), big.mark = ","), "\n")
cat("Events with no economic quantification:", sum(is.na(cat$economic_loss_usd)), "\n")
cat("Events above $100M:", sum(econ$economic_loss_usd >= 1e8, na.rm = TRUE), "\n")

econ_out <- data.frame(
  Metric = c("Events with USD values", "Total (USD)", "Mean (USD)",
             "Median (USD)", "Max (USD)", "Events unknown", "Events >$100M"),
  Value = c(nrow(econ),
            sum(econ$economic_loss_usd),
            round(mean(econ$economic_loss_usd)),
            round(median(econ$economic_loss_usd)),
            max(econ$economic_loss_usd),
            sum(is.na(cat$economic_loss_usd)),
            sum(econ$economic_loss_usd >= 1e8))
)
write.csv(econ_out, file.path(path_tables, "supplementary", "summary_economic.csv"),
          row.names = FALSE)
cat("\n")

# --- 8. Data quality summary -------------------------------------------------

cat("=== DATA QUALITY SUMMARY ===\n")
cat("Extraction confidence:\n")
print(table(cat$extraction_confidence, useNA = "ifany"))
cat("Verification status:\n")
print(table(cat$verification_status, useNA = "ifany"))

dq_out <- data.frame(
  extraction_confidence = names(table(cat$extraction_confidence)),
  count = as.integer(table(cat$extraction_confidence))
)
write.csv(dq_out, file.path(path_tables, "supplementary", "data_quality_summary.csv"),
          row.names = FALSE)
cat("\n")

# --- 9. Coverage gaps --------------------------------------------------------

cat("=== COVERAGE GAPS ===\n")
gaps_usd <- cat$event_id[is.na(cat$economic_loss_usd)]
gaps_tonnes <- cat$event_id[is.na(cat$fish_killed_tonnes)]
gaps_hh <- cat$event_id[cat$event_category %in% c("human_health", "mixed") &
                        is.na(cat$human_cases)]

cat("Missing USD:", length(gaps_usd), "events\n")
cat("Missing fish tonnes:", length(gaps_tonnes), "events\n")
cat("Missing human_cases (for HH/mixed events):", length(gaps_hh), "events\n")

cat("\n=== 03_summary_statistics.R COMPLETE — 6 tables written ===\n")
