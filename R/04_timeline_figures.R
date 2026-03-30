# ==============================================================================
# 04_timeline_figures.R — Temporal figures for manuscript
# ==============================================================================

source(here::here("R", "00_setup.R"))

# --- Load normalized catalog -------------------------------------------------

norm_file <- file.path(path_processed, "event_catalog_normalized.csv")
if (!file.exists(norm_file)) source(here::here("R", "02_normalize_units.R"))
cat <- read.csv(norm_file, stringsAsFactors = FALSE, na.strings = c("", "NA"))
cat("Loaded", nrow(cat), "events.\n")

# Ensure taxonomic_class is a factor with proper levels
cat$taxonomic_class <- factor(cat$taxonomic_class,
  levels = names(hab_taxon_colors))

# --- Figure 1: Event timeline with economic impact ---------------------------

# Events with no USD plotted at floor value
floor_val <- 5e4
cat$econ_plot <- ifelse(is.na(cat$economic_loss_usd), floor_val, cat$economic_loss_usd)
cat$has_econ <- !is.na(cat$economic_loss_usd)

# Top 10 economic events for labeling
top10 <- cat[order(-cat$economic_loss_usd), ][1:10, ]
top10 <- top10[!is.na(top10$economic_loss_usd), ]

p1 <- ggplot(cat, aes(x = year, y = econ_plot)) +
  geom_hline(yintercept = 1e8, linetype = "dashed", color = "grey50", linewidth = 0.3) +
  geom_vline(xintercept = c(1990, 2000, 2010, 2020), linetype = "dashed",
             color = "grey70", linewidth = 0.3) +
  geom_point(aes(color = taxonomic_class,
                 shape = event_category,
                 size = fish_killed_tonnes_derived,
                 alpha = has_econ)) +
  scale_y_log10(labels = scales::dollar_format(scale = 1e-6, suffix = "M"),
                breaks = c(1e5, 1e6, 1e7, 1e8, 1e9, 1e10)) +
  scale_color_taxon(name = "Taxonomic Class") +
  scale_shape_manual(name = "Event Category",
    values = c(fish_kill = 16, human_health = 17, economic = 15, mixed = 18)) +
  scale_size_continuous(name = "Fish killed (tonnes)", range = c(1, 8),
                        trans = "sqrt") +
  scale_alpha_manual(values = c("TRUE" = 0.85, "FALSE" = 0.3), guide = "none") +
  geom_text_repel(data = top10, aes(label = event_id),
                  size = 2.5, max.overlaps = 15, seed = 42) +
  labs(title = "Global HAB Events: Economic Impact Timeline",
       subtitle = "75 catastrophic events (1972–2025); open symbols = no USD estimate",
       x = "Year", y = "Economic Loss (USD, log scale)") +
  coord_cartesian(xlim = c(1970, 2026)) +
  theme(legend.box = "vertical")

ggsave(file.path(path_figures, "main", "fig1_timeline_economic.png"),
       p1, width = 12, height = 6, dpi = 300)
cat("Saved fig1_timeline_economic.png\n")

# --- Figure 2: Events per decade by taxonomic class --------------------------

decade_data <- cat[!is.na(cat$taxonomic_class), ]

p2a <- ggplot(decade_data, aes(x = factor(decade), fill = taxonomic_class)) +
  geom_bar() +
  scale_fill_taxon(name = "Taxonomic Class") +
  labs(title = "A) Events per decade by taxonomic class",
       x = "Decade", y = "Number of Events") +
  theme(legend.position = "right")

# Economic loss per decade
econ_decade <- aggregate(economic_loss_usd ~ decade, data = cat,
                         FUN = function(x) sum(x, na.rm = TRUE),
                         na.action = na.pass)
names(econ_decade) <- c("decade", "total_usd")
# Include all decades even if 0
all_decades <- data.frame(decade = seq(1970, 2020, by = 10))
econ_decade <- merge(all_decades, econ_decade, by = "decade", all.x = TRUE)
econ_decade$total_usd[is.na(econ_decade$total_usd)] <- 0

p2b <- ggplot(econ_decade, aes(x = factor(decade), y = pmax(total_usd, 1))) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  scale_y_log10(labels = scales::dollar_format(scale = 1e-6, suffix = "M")) +
  labs(title = "B) Cumulative economic loss per decade",
       x = "Decade", y = "Total Economic Loss (USD, log scale)")

p2 <- p2a / p2b + plot_layout(heights = c(2, 1))

ggsave(file.path(path_figures, "main", "fig2_decade_taxon.png"),
       p2, width = 10, height = 8, dpi = 300)
cat("Saved fig2_decade_taxon.png\n")

# --- Figure 3: Human health events timeline ----------------------------------

hh <- cat[cat$event_category %in% c("human_health", "mixed") &
          (!is.na(cat$human_cases) & cat$human_cases > 0 |
           !is.na(cat$human_deaths) & cat$human_deaths > 0), ]

hh$deaths_size <- ifelse(is.na(hh$human_deaths) | hh$human_deaths == 0, 1, hh$human_deaths)
hh$label_flag <- (!is.na(hh$human_cases) & hh$human_cases >= 100) |
                 (!is.na(hh$human_deaths) & hh$human_deaths >= 5)

p3 <- ggplot(hh, aes(x = year, y = pmax(human_cases, 1))) +
  geom_point(aes(size = deaths_size, color = human_syndrome), alpha = 0.7) +
  scale_y_log10(labels = scales::comma) +
  scale_size_continuous(name = "Human Deaths", range = c(2, 10)) +
  scale_color_brewer(palette = "Set2", name = "Syndrome") +
  geom_text_repel(data = hh[hh$label_flag, ],
                  aes(label = event_id), size = 2.5, max.overlaps = 10) +
  labs(title = "Human Health HAB Events Timeline",
       x = "Year", y = "Human Cases (log scale)")

ggsave(file.path(path_figures, "supplementary", "figS1_human_health_timeline.png"),
       p3, width = 10, height = 6, dpi = 300)
cat("Saved figS1_human_health_timeline.png\n")

cat("\n=== 04_timeline_figures.R COMPLETE — 3 figures written ===\n")
