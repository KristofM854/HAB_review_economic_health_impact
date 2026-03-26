# ==============================================================================
# plotting_theme.R — Consistent ggplot2 theme for Harmful Algae manuscript
# ==============================================================================

theme_hab_review <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey90"),
      axis.line = element_line(color = "black", linewidth = 0.3),
      axis.ticks = element_line(color = "black", linewidth = 0.3),
      legend.position = "bottom",
      plot.title = element_text(face = "bold", size = base_size + 2),
      strip.text = element_text(face = "bold")
    )
}

# Colour palette for taxonomic classes
hab_taxon_colors <- c(
  "Dinophyceae"       = "#E41A1C",
  "Raphidophyceae"    = "#FF7F00",
  "Dictyochophyceae"  = "#984EA3",
  "Prymnesiophyceae"  = "#4DAF4A",
  "Bacillariophyceae" = "#377EB8",
  "Cyanophyceae"      = "#A65628",
  "Other"             = "#999999"
)

scale_color_taxon <- function(...) {
  scale_color_manual(values = hab_taxon_colors, ...)
}

scale_fill_taxon <- function(...) {
  scale_fill_manual(values = hab_taxon_colors, ...)
}
