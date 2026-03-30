# ==============================================================================
# 06_species_comparisons.R — Species-level comparison figures
# ==============================================================================

source(here::here("R", "00_setup.R"))

norm_file <- file.path(path_processed, "event_catalog_normalized.csv")
if (!file.exists(norm_file)) source(here::here("R", "02_normalize_units.R"))
cat <- read.csv(norm_file, stringsAsFactors = FALSE, na.strings = c("", "NA"))
cat("Loaded", nrow(cat), "events.\n")

# --- Figure 6: Species impact comparison (lollipop chart) --------------------

# Species with ≥2 events
sp_counts <- table(cat$species_primary)
sp_multi  <- names(sp_counts[sp_counts >= 2])

sp_summary <- do.call(rbind, lapply(sp_multi, function(sp) {
  d <- cat[cat$species_primary == sp, ]
  data.frame(
    species = sp,
    n_events = nrow(d),
    median_econ_usd = median(d$economic_loss_usd, na.rm = TRUE),
    total_tonnes = sum(d$fish_killed_tonnes_derived, na.rm = TRUE),
    total_deaths = sum(d$human_deaths, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}))
sp_summary <- sp_summary[order(-sp_summary$n_events), ]
sp_summary <- head(sp_summary, 20)

# Reshape for faceted plot
sp_long <- reshape(sp_summary,
  varying = list(c("n_events", "median_econ_usd", "total_tonnes", "total_deaths")),
  v.names = "value",
  timevar = "metric",
  times = c("Events", "Median Econ (USD)", "Total Tonnes", "Human Deaths"),
  direction = "long"
)
sp_long$species <- factor(sp_long$species,
  levels = rev(sp_summary$species))

# Replace NA/NaN with 0 for plotting
sp_long$value[is.na(sp_long$value) | is.nan(sp_long$value)] <- 0

p6 <- ggplot(sp_long, aes(x = value, y = species)) +
  geom_segment(aes(x = 0, xend = value, y = species, yend = species),
               color = "grey60") +
  geom_point(size = 3, color = "steelblue") +
  facet_wrap(~ metric, scales = "free_x", nrow = 1) +
  labs(title = "Species Impact Comparison (≥2 catalog entries)",
       x = "", y = "") +
  theme(strip.text = element_text(size = 9))

ggsave(file.path(path_figures, "main", "fig4_species_comparison.png"),
       p6, width = 12, height = 10, dpi = 300)
cat("Saved fig4_species_comparison.png\n")

# --- Figure 7: Environment type × event category heatmap ---------------------

env_cat_tbl <- table(cat$environment_type, cat$event_category)
env_cat_df <- as.data.frame(env_cat_tbl, stringsAsFactors = FALSE)
names(env_cat_df) <- c("environment_type", "event_category", "count")

# Add marginal totals
row_totals <- aggregate(count ~ environment_type, data = env_cat_df, FUN = sum)
col_totals <- aggregate(count ~ event_category, data = env_cat_df, FUN = sum)

p7 <- ggplot(env_cat_df, aes(x = event_category, y = environment_type, fill = count)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = count), size = 4) +
  scale_fill_gradient(low = "white", high = "steelblue", name = "Count") +
  labs(title = "Events by Environment Type × Category",
       x = "Event Category", y = "Environment Type") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

ggsave(file.path(path_figures, "supplementary", "figS3_environment_category_heatmap.png"),
       p7, width = 8, height = 6, dpi = 300)
cat("Saved figS3_environment_category_heatmap.png\n")

cat("\n=== 06_species_comparisons.R COMPLETE — 2 figures written ===\n")
