# ==============================================================================
# 07_tables_for_manuscript.R — Formatted tables for manuscript
# Uses kableExtra (fallback if gt unavailable)
# ==============================================================================

source(here::here("R", "00_setup.R"))

norm_file <- file.path(path_processed, "event_catalog_normalized.csv")
if (!file.exists(norm_file)) source(here::here("R", "02_normalize_units.R"))
cat <- read.csv(norm_file, stringsAsFactors = FALSE, na.strings = c("", "NA"))
cat("Loaded", nrow(cat), "events.\n")

has_gt <- requireNamespace("gt", quietly = TRUE)

# --- Table 1: Top 20 events by economic impact --------------------------------

econ_events <- cat[!is.na(cat$economic_loss_usd), ]
econ_events <- econ_events[order(-econ_events$economic_loss_usd), ]
top20 <- head(econ_events, 20)

top20_out <- data.frame(
  event_id = top20$event_id,
  year = top20$year,
  country = top20$country_name,
  species = top20$species_primary,
  category = top20$event_category,
  economic_usd = sapply(top20$economic_loss_usd, function(x) {
    if (is.na(x)) return("")
    if (x >= 1e9) return(sprintf("$%.1fB", x / 1e9))
    if (x >= 1e6) return(sprintf("$%.1fM", x / 1e6))
    return(sprintf("$%.0fK", x / 1e3))
  }),
  fish_tonnes = round(top20$fish_killed_tonnes_derived),
  human_deaths = top20$human_deaths,
  data_quality = top20$data_quality,
  usd_note = ifelse(is.na(top20$usd_conversion_note), "", top20$usd_conversion_note),
  stringsAsFactors = FALSE
)

write.csv(top20_out, file.path(path_tables, "main", "table1_top20_economic.csv"),
          row.names = FALSE)

if (has_gt) {
  gt_tbl <- gt(top20_out) %>%
    tab_header(title = "Table 1: Top 20 HAB Events by Economic Impact")
  gtsave(gt_tbl, file.path(path_tables, "main", "table1_top20_economic.html"))
} else {
  # Use kableExtra
  html_tbl <- kableExtra::kbl(top20_out, format = "html",
                               caption = "Table 1: Top 20 HAB Events by Economic Impact") %>%
    kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))
  writeLines(as.character(html_tbl),
             file.path(path_tables, "main", "table1_top20_economic.html"))
}
cat("Saved table1_top20_economic.csv and .html\n")

# --- Table 2: Human health events summary -------------------------------------

hh <- cat[!is.na(cat$human_cases) & cat$human_cases > 0 |
          !is.na(cat$human_deaths) & cat$human_deaths > 0, ]
hh <- hh[order(-hh$human_deaths, -hh$human_cases), ]

hh_out <- data.frame(
  event_id = hh$event_id,
  year = hh$year,
  country = hh$country_name,
  species = hh$species_primary,
  syndrome = hh$human_syndrome,
  cases = hh$human_cases,
  deaths = hh$human_deaths,
  cfr_pct = ifelse(is.na(hh$human_cases) | hh$human_cases == 0, NA,
                   round(100 * hh$human_deaths / hh$human_cases, 1)),
  stringsAsFactors = FALSE
)

write.csv(hh_out, file.path(path_tables, "main", "table2_human_health.csv"),
          row.names = FALSE)

html_tbl2 <- kableExtra::kbl(hh_out, format = "html",
                              caption = "Table 2: Human Health HAB Events") %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))
writeLines(as.character(html_tbl2),
           file.path(path_tables, "main", "table2_human_health.html"))
cat("Saved table2_human_health.csv and .html\n")

# --- Table 3: Events by region and decade (cross-tab) -------------------------

cross_tab <- table(cat$region_broad, cat$decade)
cross_df <- as.data.frame.matrix(addmargins(cross_tab))

write.csv(cross_df, file.path(path_tables, "supplementary", "tableS1_region_decade.csv"))

html_tbl3 <- kableExtra::kbl(cross_df, format = "html",
                              caption = "Table S1: Events by Region and Decade") %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))
writeLines(as.character(html_tbl3),
           file.path(path_tables, "supplementary", "tableS1_region_decade.html"))
cat("Saved tableS1_region_decade.csv and .html\n")

# --- Table 4: Data completeness audit -----------------------------------------

audit <- data.frame(
  event_id = cat$event_id,
  year = cat$year,
  category = cat$event_category,
  has_econ_usd = ifelse(!is.na(cat$economic_loss_usd), "Y", "N"),
  has_fish_tonnes = ifelse(!is.na(cat$fish_killed_tonnes), "Y", "N"),
  has_lat_lon = ifelse(!is.na(cat$lat_centroid) & !is.na(cat$lon_centroid), "Y", "N"),
  has_human_cases = ifelse(!is.na(cat$human_cases), "Y", "N"),
  extraction_confidence = cat$extraction_confidence,
  verification_status = cat$verification_status,
  stringsAsFactors = FALSE
)

# Flag events needing attention
audit$needs_attention <- FALSE
# Low confidence
audit$needs_attention[grepl("low", audit$extraction_confidence, ignore.case = TRUE)] <- TRUE
# Missing key fields for category
audit$needs_attention[audit$category == "human_health" & audit$has_human_cases == "N"] <- TRUE
audit$needs_attention[audit$category %in% c("fish_kill", "economic") & audit$has_econ_usd == "N"] <- TRUE

write.csv(audit, file.path(path_tables, "supplementary", "tableS2_data_completeness.csv"),
          row.names = FALSE)
cat("Saved tableS2_data_completeness.csv\n")
cat("Events flagged needing attention:", sum(audit$needs_attention), "\n")

cat("\n=== 07_tables_for_manuscript.R COMPLETE — 4 tables written ===\n")
