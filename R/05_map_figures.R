# ==============================================================================
# 05_map_figures.R — Spatial figures for manuscript
# ==============================================================================

source(here::here("R", "00_setup.R"))

norm_file <- file.path(path_processed, "event_catalog_normalized.csv")
if (!file.exists(norm_file)) source(here::here("R", "02_normalize_units.R"))
cat <- read.csv(norm_file, stringsAsFactors = FALSE, na.strings = c("", "NA"))
cat("Loaded", nrow(cat), "events.\n")

# Ensure numeric coordinates
cat$lat_centroid <- as.numeric(cat$lat_centroid)
cat$lon_centroid <- as.numeric(cat$lon_centroid)

# Events with coordinates
mapped <- cat[!is.na(cat$lat_centroid) & !is.na(cat$lon_centroid), ]
missing_coords <- cat$event_id[is.na(cat$lat_centroid) | is.na(cat$lon_centroid)]

cat("Events with coordinates:", nrow(mapped), "\n")
cat("Events missing coordinates:", length(missing_coords), "\n")
if (length(missing_coords) > 0) {
  cat("  Missing:", paste(missing_coords, collapse = ", "), "\n")
}

# --- Check for rnaturalearth --------------------------------------------------

has_rne <- requireNamespace("rnaturalearth", quietly = TRUE) &&
           requireNamespace("rnaturalearthdata", quietly = TRUE)

if (!has_rne) {
  cat("\nrnaturalearth not available — using maps package for basemap.\n")
  library(maps)

  # --- Figure 4: Global event map (using maps package) ----------------------

  mapped$taxonomic_class <- factor(mapped$taxonomic_class,
    levels = names(hab_taxon_colors))
  mapped$econ_size <- ifelse(is.na(mapped$economic_loss_usd), 1,
                             log10(pmax(mapped$economic_loss_usd, 1e5)) - 4)
  mapped$econ_size <- pmax(mapped$econ_size, 0.5)

  png(file.path(path_figures, "main", "fig3_global_map.png"),
      width = 14, height = 8, units = "in", res = 300)

  par(mar = c(2, 2, 3, 1))
  map("world", col = "grey85", fill = TRUE, border = "grey70", lwd = 0.3)
  title(main = "Global Distribution of Catastrophic HAB Events (1972–2025)",
        cex.main = 1.2)

  # Plot points
  cols <- hab_taxon_colors[as.character(mapped$taxonomic_class)]
  cols[is.na(cols)] <- "grey50"
  points(mapped$lon_centroid, mapped$lat_centroid,
         pch = 19, col = adjustcolor(cols, alpha.f = 0.75),
         cex = mapped$econ_size)

  # Legend
  legend("bottomleft", legend = names(hab_taxon_colors),
         col = hab_taxon_colors, pch = 19, pt.cex = 1.2,
         cex = 0.7, title = "Taxonomic Class", bg = "white")

  dev.off()
  cat("Saved fig3_global_map.png (maps package fallback)\n")

} else {
  # --- Figure 4: Global event map (rnaturalearth) ---------------------------

  world <- ne_countries(scale = "medium", returnclass = "sf")
  mapped_sf <- st_as_sf(mapped, coords = c("lon_centroid", "lat_centroid"), crs = 4326)

  p4 <- ggplot() +
    geom_sf(data = world, fill = "grey90", color = "grey70", linewidth = 0.2) +
    geom_sf(data = mapped_sf,
            aes(color = taxonomic_class, size = pmax(economic_loss_usd, 1e5, na.rm = TRUE)),
            alpha = 0.75) +
    scale_color_taxon(name = "Taxonomic Class") +
    scale_size_continuous(name = "Economic Loss (USD)",
                          range = c(1, 8), trans = "log10",
                          labels = scales::dollar_format(scale = 1e-6, suffix = "M")) +
    labs(title = "Global Distribution of Catastrophic HAB Events (1972–2025)") +
    theme(legend.position = "bottom")

  ggsave(file.path(path_figures, "main", "fig3_global_map.png"),
         p4, width = 14, height = 8, dpi = 300)
  cat("Saved fig3_global_map.png (rnaturalearth)\n")
}

# --- Figure 5: Regional inset maps -------------------------------------------

# Check which regions have ≥3 events
regions <- list(
  "Norwegian/North Sea" = list(xlim = c(-5, 25), ylim = c(55, 75)),
  "Chilean Patagonia"   = list(xlim = c(-80, -65), ylim = c(-55, -35)),
  "East/SE Asia"        = list(xlim = c(100, 145), ylim = c(0, 45)),
  "US Coastal"          = list(xlim = c(-130, -65), ylim = c(25, 55))
)

# Count events in each region
for (rname in names(regions)) {
  reg <- regions[[rname]]
  n <- sum(mapped$lon_centroid >= reg$xlim[1] & mapped$lon_centroid <= reg$xlim[2] &
           mapped$lat_centroid >= reg$ylim[1] & mapped$lat_centroid <= reg$ylim[2],
           na.rm = TRUE)
  cat(sprintf("  %s: %d events\n", rname, n))
}

# Generate regional maps using base maps
png(file.path(path_figures, "supplementary", "figS2_regional_maps.png"),
    width = 14, height = 10, units = "in", res = 300)

par(mfrow = c(2, 2), mar = c(3, 3, 2, 1))

for (rname in names(regions)) {
  reg <- regions[[rname]]
  sub <- mapped[mapped$lon_centroid >= reg$xlim[1] & mapped$lon_centroid <= reg$xlim[2] &
                mapped$lat_centroid >= reg$ylim[1] & mapped$lat_centroid <= reg$ylim[2], ]

  if (nrow(sub) < 3) {
    plot.new()
    title(main = paste(rname, "- <3 events, skipped"))
    next
  }

  map("world", xlim = reg$xlim, ylim = reg$ylim,
      col = "grey85", fill = TRUE, border = "grey70", lwd = 0.3)
  title(main = paste(rname, sprintf("(%d events)", nrow(sub))))

  cols <- hab_taxon_colors[as.character(sub$taxonomic_class)]
  cols[is.na(cols)] <- "grey50"
  points(sub$lon_centroid, sub$lat_centroid,
         pch = 19, col = adjustcolor(cols, alpha.f = 0.8), cex = 1.5)

  # Label events
  if (nrow(sub) <= 15) {
    text(sub$lon_centroid, sub$lat_centroid, labels = sub$event_id,
         cex = 0.4, pos = 3, offset = 0.3)
  }
}

dev.off()
cat("Saved figS2_regional_maps.png\n")

cat("\n=== 05_map_figures.R COMPLETE ===\n")
