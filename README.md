# Global Catastrophic HAB Events Review

Systematic review of global catastrophic harmful algal bloom (HAB) events from the 20th and 21st centuries.

**Target journal:** Harmful Algae
**Project lead:** Kristof Möller (IAEA Marine Environment Laboratories)

## Overview

This project compiles a structured event catalog with standardized metrics for catastrophic HAB events worldwide, enabling cross-event comparisons of economic, ecological, and health impacts.

## Scope

- **Temporal:** ~1970s through 2025 (resolved events only)
- **Geographic:** Global (all marine/brackish regions)
- **Event types:** Fish kills, human health events, economic-only impacts
- **Threshold:** ≥$1M loss OR ≥100k fish OR ≥100t OR ≥10 human cases OR major infrastructure disruption

## Repository Structure

```
data/           Raw and processed datasets, schemas, reference tables
literature/     BibTeX references, extraction log, processing queue
R/              Analysis scripts and functions
figures/        Generated figures (main + supplementary)
tables/         Generated tables (main + supplementary)
manuscript/     Rmarkdown manuscript files
docs/           Documentation
```

## Key Files

| File | Description |
|------|-------------|
| `data/raw/event_catalog.csv` | Primary event dataset |
| `data/schema/event_catalog_schema.json` | Formal field definitions |
| `data/schema/controlled_vocabularies.json` | Enum values for categorical fields |
| `HAB_Review_Schema_Specification.md` | Complete project specification |
| `HAB_Review_References.md` | 85 key references with DOIs |

## Getting Started

1. Open the R project and run `R/00_setup.R` to load packages
2. Run `R/01_load_validate.R` to load and validate the catalog
3. See `HAB_Review_Schema_Specification.md` for full schema documentation

## License

CC-BY-4.0
