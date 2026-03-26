# HAB Catastrophic Events Review — Claude Code Quick Start

## Project Context

This is a systematic review of global catastrophic harmful algal bloom (HAB) events spanning the 20th and 21st centuries. The project lead is Kristof Möller (IAEA Marine Environment Laboratories, Monaco).

**Target journal:** Harmful Algae

## Scope Summary

- **Event types:** Fish kills (farmed + wild), human health (PSP/DSP/CFP), economic-only (desalination, tourism)
- **Temporal:** ~1970s through 2025 (resolved events only — no ongoing events)
- **Geographic:** Global
- **Threshold:** ≥$1M loss OR ≥100k fish OR ≥100t OR ≥10 human cases OR major infrastructure disruption

## Your First Tasks

### 1. Initialize the GitHub Repository

Create a new repository `hab-catastrophic-review` with the structure defined in `HAB_Review_Schema_Specification.md` Section 2.

### 2. Create Schema Files

Generate:
- `data/schema/event_catalog_schema.json` — JSON Schema from Section 3
- `data/schema/controlled_vocabularies.json` — Enums from Section 4

### 3. Import Pilot Data

The file `event_catalog_pilot.csv` contains 9 validated pilot events. Import this as `data/raw/event_catalog.csv`.

### 4. Create Reference Tables

Generate:
- `data/reference/species_taxonomy.csv` — Current accepted names for HAB species
- `data/reference/country_codes.csv` — ISO 3166-1 alpha-3 codes

### 5. Set Up R Infrastructure

Create:
- `R/00_setup.R` — Package loading
- `R/functions/plotting_theme.R` — Consistent ggplot2 theme (see Section 7.2)
- `R/01_load_validate.R` — Load and validate the event catalog

### 6. Begin Literature Extraction

Using the reference list in `HAB_Review_References.md`, systematically extract additional events following the workflow in Section 6.

**Priority sources:**
1. Hallegraeff et al. (2023) GlobalHAB White Paper — contains comprehensive event tables
2. Karlson et al. (2021) — Northern Europe events
3. Sakamoto et al. (2021) — East Asia events (especially Japan Chattonella history)

## Key Files

| File | Purpose |
|------|---------|
| `HAB_Review_Schema_Specification.md` | Complete project specification & schema |
| `HAB_Review_References.md` | 85 key references with DOIs |
| `event_catalog_pilot.csv` | 8 validated pilot events ready for import |
| `references_seed.bib` | 15 core BibTeX entries |
| `CLAUDE_CODE_INIT_PROMPT.md` | Full initiation prompt for Claude Code |

## Decision Log

Document any ambiguities or decisions in `literature/extraction_notes.md`.

## Questions?

If anything is unclear, flag it. The project lead can clarify via conversation history.
