# Global Catastrophic HAB Events Review
## Claude Code Project Specification & Event Catalog Schema

**Version:** 1.0  
**Created:** March 2026  
**Target Journal:** Harmful Algae  
**Project Lead:** Kristof Möller (IAEA Marine Environment Laboratories)

---

## 1. PROJECT OVERVIEW

### 1.1 Objective

Create a systematic, quantitative review of global catastrophic harmful algal bloom (HAB) events from the 20th and 21st centuries. This review will:

1. Compile a structured event catalog with standardized metrics
2. Enable cross-event comparisons (economic, ecological, species-level)
3. Identify temporal and spatial trends
4. Assess gaps in monitoring, reporting, and mitigation

### 1.2 Scope

- **Temporal:** First well-documented massive HAB (~1970s) through 2025 (only confirmed/resolved events)
- **Geographic:** Global (all marine/brackish regions)
- **Event types:** This review captures ALL noteworthy HAB events, including:
  - **Fish-killing events** (farmed and/or wild fish mortality)
  - **Human health events** (shellfish poisoning outbreaks, respiratory exposure, etc.)
  - **Economic impact events** (desalination plant closures, tourism losses, fishery closures — even without direct mortality)
- **Event threshold:** Any event meeting ONE OR MORE of:
  - Economic loss ≥ $1M USD (any year)
  - Fish mortality ≥ 100,000 individuals OR ≥ 100 tonnes
  - Human illness cases ≥ 10 OR any deaths
  - Major infrastructure disruption (e.g., desalination plant shutdown)
  - Significant fishery/beach closures affecting tourism or commerce
- **Exclusions:** 
  - Ongoing/unresolved events (wait for confirmation)
  - Events with insufficient documentation to meet data quality standards

### 1.3 Key Outputs

- `event_catalog.csv` — Core structured dataset
- Comparative figures (timelines, maps, species comparisons)
- Summary tables for manuscript
- Supplementary data files

---

## 2. REPOSITORY STRUCTURE

```
hab-catastrophic-review/
├── README.md                           # Project overview, setup instructions
├── LICENSE                             # CC-BY-4.0 recommended for data
├── .gitignore
│
├── data/
│   ├── raw/
│   │   └── event_catalog.csv           # Primary event dataset
│   ├── processed/
│   │   └── event_catalog_normalized.csv # After unit harmonization
│   ├── reference/
│   │   ├── species_taxonomy.csv        # Accepted names, synonyms
│   │   ├── species_ecology.csv         # Temp/salinity optima, toxins
│   │   ├── country_codes.csv           # ISO 3166-1 alpha-3
│   │   └── currency_conversions.csv    # Historical USD conversion factors
│   └── schema/
│       ├── event_catalog_schema.json   # Formal field definitions
│       └── controlled_vocabularies.json # Enum values for categorical fields
│
├── literature/
│   ├── references.bib                  # BibTeX master file
│   ├── extraction_log.csv              # Tracking: which papers extracted
│   ├── dois_to_process.txt             # Queue of papers to extract
│   └── extraction_notes.md             # Ambiguities, decisions made
│
├── R/
│   ├── 00_setup.R                      # Package loading, paths
│   ├── 01_load_validate.R              # Load and validate catalog
│   ├── 02_normalize_units.R            # Harmonize mortality/economic data
│   ├── 03_summary_statistics.R         # Descriptive stats
│   ├── 04_timeline_figures.R           # Temporal visualizations
│   ├── 05_map_figures.R                # Spatial visualizations
│   ├── 06_species_comparisons.R        # Cross-species analysis
│   ├── 07_tables_for_manuscript.R      # Generate formatted tables
│   └── functions/
│       ├── validation.R                # Data validation functions
│       ├── plotting_theme.R            # Consistent ggplot2 theme
│       └── utils.R                     # Helper functions
│
├── figures/
│   ├── main/                           # Figures for main manuscript
│   └── supplementary/                  # Supplementary figures
│
├── tables/
│   ├── main/
│   └── supplementary/
│
├── manuscript/
│   ├── main.Rmd                        # Main manuscript (Rmarkdown)
│   ├── supplementary.Rmd               # Supplementary materials
│   ├── harmful_algae_template.csl      # Citation style
│   └── sections/                       # Individual sections if needed
│
└── docs/
    ├── SCHEMA.md                       # Human-readable schema docs
    ├── EXTRACTION_GUIDE.md             # How to extract data from papers
    └── CHANGELOG.md                    # Version history
```

---

## 3. EVENT CATALOG SCHEMA

### 3.1 Core Identification Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `event_id` | string | Yes | Unique identifier: `{ISO3}_{YYYY}_{NNN}` | `NOR_2019_001` |
| `event_name` | string | No | Common name if established | `"2019 Northern Norway bloom"` |
| `event_category` | enum | Yes | Primary impact type: `fish_kill` / `human_health` / `economic` / `mixed` | `fish_kill` |
| `year` | integer | Yes | Primary year of event | `2019` |
| `start_date` | date (ISO 8601) | No | First detection/mortality: `YYYY-MM-DD` | `2019-05-10` |
| `end_date` | date (ISO 8601) | No | Event conclusion: `YYYY-MM-DD` | `2019-06-25` |
| `duration_days` | integer | No | Calculated or reported duration | `46` |
| `event_status` | enum | Yes | `resolved` / `recurrent` | `resolved` |

### 3.2 Geographic Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `country_iso3` | string | Yes | ISO 3166-1 alpha-3 code | `NOR` |
| `country_name` | string | Yes | Full country name | `Norway` |
| `region_level1` | string | No | State/province/county | `Nordland` |
| `region_level2` | string | No | More specific region | `Lofoten` |
| `water_body` | string | No | Sea, bay, fjord name | `Vestfjorden` |
| `lat_centroid` | numeric | No | Latitude (decimal degrees, WGS84) | `68.41` |
| `lon_centroid` | numeric | No | Longitude (decimal degrees, WGS84) | `15.44` |
| `affected_area_km2` | numeric | No | Spatial extent if reported | `5000` |
| `environment_type` | enum | Yes | `marine_coastal` / `marine_offshore` / `estuarine` / `brackish` / `fjord` | `fjord` |

### 3.3 Causative Species Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `species_primary` | string | Yes | Primary causative species (current accepted name) | `Chrysochromulina leadbeateri` |
| `species_primary_authority` | string | No | Taxonomic authority | `Estep, Davis, Hargraves & Sieburth, 1984` |
| `species_secondary` | string | No | Secondary/co-occurring species | `Phaeocystis pouchetii` |
| `species_tertiary` | string | No | Additional species if relevant | `NA` |
| `taxonomic_class` | enum | Yes | `Dinophyceae` / `Raphidophyceae` / `Dictyochophyceae` / `Prymnesiophyceae` / `Bacillariophyceae` / `Cyanophyceae` / `Other` | `Prymnesiophyceae` |
| `species_notes` | string | No | Taxonomic uncertainties, synonyms | `"Formerly Prymnesium polylepis"` |

### 3.4 Bloom Characteristics

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `max_cell_density` | numeric | No | Maximum reported cell density (cells/L) | `1012605` |
| `cell_density_depth_m` | numeric | No | Depth of cell density measurement | `2` |
| `max_chlorophyll_ug_L` | numeric | No | Maximum chlorophyll-a if reported | `NA` |
| `bloom_visible` | boolean | No | Water discoloration observed? | `TRUE` |
| `bloom_color` | string | No | Reported color | `"milky brown"` |

### 3.5 Fish Mortality Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `fish_affected_type` | enum | Yes | `farmed` / `wild` / `both` / `unknown` | `farmed` |
| `fish_species_affected` | string | No | Comma-separated list | `"Atlantic salmon, rainbow trout"` |
| `fish_killed_n` | numeric | No | Number of individuals killed | `8000000` |
| `fish_killed_n_qualifier` | enum | No | `exact` / `estimated` / `minimum` / `approximate` | `estimated` |
| `fish_killed_tonnes` | numeric | No | Biomass killed (metric tonnes) | `14500` |
| `fish_killed_tonnes_qualifier` | enum | No | `exact` / `estimated` / `minimum` / `approximate` | `estimated` |
| `farms_affected_n` | integer | No | Number of aquaculture sites affected | `60` |
| `fish_mortality_notes` | string | No | Additional context | `"8 million fish across ~60 sites"` |

### 3.6 Human Health Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `human_cases` | integer | No | Number of illness cases | `0` |
| `human_deaths` | integer | No | Number of fatalities | `0` |
| `human_syndrome` | enum | No | `PSP` / `DSP` / `ASP` / `NSP` / `CFP` / `AZP` / `respiratory` / `dermal` / `other` / `none` | `none` |
| `human_health_notes` | string | No | Additional context | `NA` |

### 3.7 Broader Ecological Impact

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `ecological_impact_level` | enum | No | `fish_only` / `multi_trophic` / `ecosystem_wide` | `fish_only` |
| `wildlife_mortality` | boolean | No | Marine mammals, seabirds, etc. affected? | `FALSE` |
| `wildlife_species_affected` | string | No | List if relevant | `NA` |
| `benthic_impact` | boolean | No | Benthic fauna/flora mortality? | `FALSE` |
| `ecological_notes` | string | No | Broader impacts | `NA` |

### 3.8 Economic Impact Fields

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `economic_loss_value` | numeric | No | Reported economic loss (original) | `2900000000` |
| `economic_loss_currency` | string | No | ISO 4217 currency code | `NOK` |
| `economic_loss_year` | integer | No | Year of valuation | `2019` |
| `economic_loss_usd` | numeric | No | Converted to USD (specify conversion year in notes) | `300000000` |
| `economic_loss_type` | enum | No | `direct` / `indirect` / `total` / `unspecified` | `total` |
| `economic_loss_qualifier` | enum | No | `exact` / `estimated` / `minimum` / `range` | `estimated` |
| `economic_sectors_affected` | string | No | Comma-separated: `aquaculture`, `wild_fisheries`, `tourism`, `desalination`, `recreation`, `public_health`, `other` | `"aquaculture, tourism"` |
| `fishery_closures` | boolean | No | Were commercial fisheries closed? | `FALSE` |
| `beach_closures` | boolean | No | Were beaches/recreation areas closed? | `FALSE` |
| `desalination_affected` | boolean | No | Were desalination plants affected? | `FALSE` |
| `economic_notes` | string | No | Methodology, inclusions/exclusions | `"Includes direct mortality + future production loss"` |

### 3.9 Response & Mitigation

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `mitigation_attempted` | boolean | No | Were mitigation measures used? | `TRUE` |
| `mitigation_methods` | string | No | Comma-separated list | `"emergency harvest, cage relocation"` |
| `mitigation_effectiveness` | enum | No | `effective` / `partially_effective` / `ineffective` / `unknown` | `partially_effective` |
| `monitoring_preexisting` | boolean | No | Was HAB monitoring in place? | `TRUE` |
| `warning_issued` | boolean | No | Was early warning issued? | `TRUE` |
| `response_notes` | string | No | Additional context | `NA` |

### 3.10 Data Provenance

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `source_doi_primary` | string | Yes | Primary literature source DOI | `10.1016/j.hal.2022.102287` |
| `source_dois_secondary` | string | No | Additional DOIs (semicolon-separated) | `10.1111/jfd.70162; 10.1038/s43247-025-02421-y` |
| `source_type` | enum | Yes | `peer_reviewed` / `government_report` / `news` / `industry` / `database` / `personal_comm` | `peer_reviewed` |
| `data_quality` | enum | Yes | `high` / `medium` / `low` | `high` |
| `extraction_confidence` | enum | Yes | `high` / `medium` / `low` | `high` |
| `extraction_date` | date | Yes | When data was extracted: `YYYY-MM-DD` | `2026-03-26` |
| `extraction_agent` | string | Yes | Who/what extracted: `human` / `claude` / `claude_verified` | `claude` |
| `verification_status` | enum | Yes | `unverified` / `verified` / `disputed` | `verified` |
| `notes` | string | No | Any additional context | `NA` |

---

## 4. CONTROLLED VOCABULARIES

### 4.1 event_category
- `fish_kill` — Primary impact is fish mortality (farmed or wild)
- `human_health` — Primary impact is human illness/poisoning (PSP, DSP, CFP, etc.)
- `economic` — Primary impact is economic (closures, tourism) without major mortality
- `mixed` — Significant impacts across multiple categories

### 4.2 event_status
- `resolved` — Event has concluded
- `recurrent` — Annual or periodic recurrence (e.g., Florida red tides)

### 4.3 environment_type
- `marine_coastal` — Nearshore marine (<50 km from coast)
- `marine_offshore` — Offshore marine (>50 km from coast)
- `estuarine` — Estuary, river mouth
- `brackish` — Brackish water body
- `fjord` — Fjord system

### 4.4 taxonomic_class
- `Dinophyceae` — Dinoflagellates (Karenia, Alexandrium, Margalefidinium)
- `Raphidophyceae` — Raphidophytes (Chattonella, Heterosigma, Fibrocapsa)
- `Dictyochophyceae` — Dictyochophytes (Pseudochattonella, Vicicitus)
- `Prymnesiophyceae` — Haptophytes (Chrysochromulina, Prymnesium, Phaeocystis)
- `Bacillariophyceae` — Diatoms (Pseudo-nitzschia)
- `Cyanophyceae` — Cyanobacteria (Trichodesmium)
- `Other`

### 4.5 fish_affected_type
- `farmed` — Aquaculture only
- `wild` — Wild populations only
- `both` — Both farmed and wild
- `unknown`

### 4.6 economic_loss_type
- `direct` — Immediate mortality costs only
- `indirect` — Secondary impacts (tourism, processing, etc.)
- `total` — Combined direct + indirect
- `unspecified`

### 4.7 data_quality
- `high` — Peer-reviewed publication with clear methodology
- `medium` — Government report or peer-reviewed with some ambiguity
- `low` — News source, personal communication, or significant uncertainty

### 4.8 extraction_confidence
- `high` — Values clearly stated in source
- `medium` — Values inferred or calculated from source
- `low` — Values uncertain, conflicting sources, or extrapolated

---

## 5. PILOT EVENT ENTRIES

The following events should be populated first to validate the schema:

### 5.1 Japan 1972 — Seto Inland Sea Chattonella

```
event_id: JPN_1972_001
event_category: fish_kill
year: 1972
country_iso3: JPN
country_name: Japan
region_level1: Hyogo/Okayama
water_body: Harima-Nada, Seto Inland Sea
environment_type: marine_coastal
species_primary: Chattonella antiqua
taxonomic_class: Raphidophyceae
fish_affected_type: farmed
fish_species_affected: Yellowtail (Seriola quinqueradiata)
fish_killed_n: 14200000
fish_killed_n_qualifier: estimated
economic_loss_value: 7100000000
economic_loss_currency: JPY
economic_loss_year: 1972
economic_loss_usd: 71000000
economic_notes: "~71M USD at 1972 exchange rates; equivalent to ~90M USD in some sources"
source_doi_primary: 10.1016/j.hal.2011.10.014
source_type: peer_reviewed
data_quality: high
```

### 5.2 Scandinavia 1988 — Chrysochromulina polylepis

```
event_id: NOR_1988_001
year: 1988
start_date: 1988-05-01
end_date: 1988-06-30
country_iso3: NOR
country_name: Norway
region_level1: Skagerrak/Kattegat
water_body: Skagerrak, Kattegat, eastern North Sea
affected_area_km2: 60000
environment_type: marine_coastal
species_primary: Prymnesium polylepis
species_notes: "Formerly Chrysochromulina polylepis; now Prymnesium polylepis"
taxonomic_class: Prymnesiophyceae
fish_affected_type: both
fish_killed_tonnes: 900
ecological_impact_level: ecosystem_wide
wildlife_mortality: TRUE
benthic_impact: TRUE
ecological_notes: "Massive mortality of invertebrates, seabirds; considered ecosystem-disruptive event"
economic_loss_value: 9000000
economic_loss_currency: USD
economic_loss_year: 1988
economic_loss_usd: 9000000
source_doi_primary: 10.1007/978-3-642-75280-3_23
source_type: peer_reviewed
data_quality: high
```

### 5.3 Norway 1991 — Lofoten C. leadbeateri

```
event_id: NOR_1991_001
year: 1991
country_iso3: NOR
country_name: Norway
region_level1: Nordland
region_level2: Lofoten
water_body: Vestfjorden
environment_type: fjord
species_primary: Chrysochromulina leadbeateri
taxonomic_class: Prymnesiophyceae
fish_affected_type: farmed
fish_species_affected: Atlantic salmon
fish_killed_tonnes: 740
fish_killed_tonnes_qualifier: estimated
economic_loss_value: 3500000
economic_loss_currency: USD
economic_loss_year: 1991
economic_loss_usd: 3500000
source_doi_primary: 10.1016/j.hal.2021.101989
source_type: peer_reviewed
data_quality: medium
extraction_confidence: medium
notes: "First documented C. leadbeateri fish-killing event; tonnage estimates vary 600-742t"
```

### 5.4 Norway 2001 — Pseudochattonella Skagerrak

```
event_id: NOR_2001_001
year: 2001
country_iso3: NOR
country_name: Norway
region_level1: Southern coast
water_body: Skagerrak
environment_type: marine_coastal
species_primary: Pseudochattonella farcimen
taxonomic_class: Dictyochophyceae
fish_affected_type: farmed
fish_killed_tonnes: 1100
economic_loss_value: NA
economic_loss_currency: NA
source_doi_primary: 10.1016/j.hal.2016.08.002
source_type: peer_reviewed
data_quality: medium
```

### 5.5 Chile 2016 — Pseudochattonella "Godzilla Bloom"

```
event_id: CHL_2016_001
event_name: "2016 Chile salmon crisis / Godzilla bloom"
year: 2016
start_date: 2016-02-01
end_date: 2016-05-31
country_iso3: CHL
country_name: Chile
region_level1: Los Lagos
region_level2: Chiloé, Reloncaví
water_body: Reloncaví Sound, Gulf of Ancud
environment_type: fjord
species_primary: Pseudochattonella verruculosa
species_secondary: Alexandrium catenella
taxonomic_class: Dictyochophyceae
max_cell_density: 20000000
fish_affected_type: farmed
fish_species_affected: Atlantic salmon
fish_killed_n: 23000000
fish_killed_tonnes: 39000
economic_loss_value: 800000000
economic_loss_currency: USD
economic_loss_year: 2016
economic_loss_usd: 800000000
economic_loss_type: total
economic_notes: "Includes direct mortality + downstream economic impacts"
mitigation_attempted: TRUE
mitigation_methods: "airlift pumping, cage towing, delayed seeding"
mitigation_effectiveness: partially_effective
source_doi_primary: 10.1038/s41598-018-19461-4
source_dois_secondary: 10.1016/j.scitotenv.2020.144383
source_type: peer_reviewed
data_quality: high
notes: "Largest farmed fish HAB mortality ever recorded globally"
```

### 5.6 Florida 2017–2018 — Karenia brevis

```
event_id: USA_2018_001
event_name: "2017-2018 Florida red tide"
year: 2018
start_date: 2017-10-01
end_date: 2019-02-28
duration_days: 516
country_iso3: USA
country_name: United States
region_level1: Florida
region_level2: Southwest Florida
water_body: Gulf of Mexico, Sarasota Bay, Tampa Bay
environment_type: marine_coastal
species_primary: Karenia brevis
taxonomic_class: Dinophyceae
max_cell_density: 90000000
fish_affected_type: wild
ecological_impact_level: multi_trophic
wildlife_mortality: TRUE
wildlife_species_affected: "Manatees, dolphins, sea turtles, seabirds"
human_cases: NA
human_syndrome: respiratory
human_health_notes: "Widespread respiratory irritation from aerosolized brevetoxins"
event_status: recurrent
source_doi_primary: 10.3389/fmars.2021.711114
source_type: peer_reviewed
data_quality: high
notes: "Fifth longest red tide since 1954; affected SW, NW, and E coasts simultaneously"
```

### 5.7 Norway 2019 — Northern Norway C. leadbeateri

```
event_id: NOR_2019_001
event_name: "2019 Northern Norway Chrysochromulina bloom"
year: 2019
start_date: 2019-05-10
end_date: 2019-06-20
country_iso3: NOR
country_name: Norway
region_level1: Nordland, Troms, Finnmark
water_body: Vestfjorden, Lofoten, Tromsø area
lat_centroid: 68.5
lon_centroid: 16.0
environment_type: fjord
species_primary: Chrysochromulina leadbeateri
taxonomic_class: Prymnesiophyceae
max_cell_density: 1012605
fish_affected_type: farmed
fish_species_affected: Atlantic salmon
fish_killed_n: 8000000
fish_killed_n_qualifier: estimated
fish_killed_tonnes: 14500
fish_killed_tonnes_qualifier: estimated
farms_affected_n: 60
economic_loss_value: 2900000000
economic_loss_currency: NOK
economic_loss_year: 2019
economic_loss_usd: 300000000
economic_loss_type: total
economic_notes: "2.3-2.9 billion NOK; includes direct + indirect losses"
mitigation_attempted: TRUE
mitigation_methods: "emergency harvest, early warning, cage sinking"
source_doi_primary: 10.1016/j.hal.2022.102287
source_type: peer_reviewed
data_quality: high
notes: "Largest HAB fish kill in Northern Europe history at the time"
```

### 5.8 Norway 2025 — Northern Norway Dual Bloom

```
event_id: NOR_2025_001
year: 2025
start_date: 2025-04-24
end_date: 2025-05-05
country_iso3: NOR
country_name: Norway
region_level1: Nordland
region_level2: Lødingen, Øksfjorden
water_body: Vestfjorden
lat_centroid: 68.41
lon_centroid: 15.44
environment_type: fjord
species_primary: Chrysochromulina leadbeateri
species_secondary: Phaeocystis pouchetii
species_notes: "P. pouchetii dominant early; C. leadbeateri increasing through event"
taxonomic_class: Prymnesiophyceae
max_cell_density: 4592106
cell_density_depth_m: 2
bloom_visible: TRUE
bloom_color: "milky"
fish_affected_type: farmed
fish_species_affected: Atlantic salmon
fish_killed_n: 8000000
fish_killed_n_qualifier: estimated
fish_killed_tonnes: 13200
fish_killed_tonnes_qualifier: estimated
farms_affected_n: 18
fish_mortality_notes: "401,794 fish (39.47%) mortality at first affected site Fornes; ~8M total regional"
economic_loss_value: NA
economic_loss_currency: NA
economic_notes: "Full economic assessment pending"
mitigation_attempted: TRUE
mitigation_methods: "emergency harvest"
source_doi_primary: 10.1111/jfd.70162
source_type: peer_reviewed
data_quality: high
notes: "Series of local blooms unlike 2019 continuous bloom; ~18 farms affected"
```

---

## 6. LITERATURE EXTRACTION WORKFLOW

### 6.1 Autonomous Extraction Process

For each paper in the literature queue:

1. **Fetch full text** via DOI or URL
2. **Identify extractable events** — Does this paper describe a specific HAB event with quantifiable impacts?
3. **Extract fields** according to schema — Use explicit values where stated; infer with `medium` confidence where necessary
4. **Flag uncertainties** — Note in `notes` field; set `extraction_confidence` accordingly
5. **Check for duplicates** — Same event may be described in multiple papers; use `source_dois_secondary` for additional sources
6. **Commit to catalog** with extraction metadata

### 6.2 Handling Ambiguity

| Situation | Action |
|-----------|--------|
| Multiple values reported for same metric | Use most recent/authoritative; note range in `notes` |
| Units unclear | Flag in notes; leave raw value; resolve in normalization |
| Taxonomic name outdated | Use current accepted name; note synonym in `species_notes` |
| Event spans multiple years | Use primary year; include date range |
| Event spans multiple countries | Create separate entries with shared `event_name` |
| Currency conversion unclear | Record original; leave USD blank for manual conversion |

### 6.3 Priority Papers for Extraction

Start with these sources for systematic extraction:

1. **Hallegraeff et al. (2023)** — GlobalHAB Fish-Killing White Paper (comprehensive event table)
2. **Karlson et al. (2021)** — Northern Europe HAB status (Harmful Algae special issue)
3. **Sakamoto et al. (2021)** — East Asia HAB status (Harmful Algae special issue)
4. **Álvarez et al. (2021)** — Latin America HAB status (Harmful Algae special issue)
5. **HAEDAT database** — http://haedat.iode.org (filter for major events)

---

## 7. R ANALYSIS GUIDANCE

### 7.1 Required Packages

```r
# Core
library(tidyverse)
library(lubridate)

# Visualization
library(ggplot2)
library(scales)
library(patchwork)
library(ggrepel)

# Mapping
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Tables
library(gt)
library(kableExtra)

# Other
library(countrycode)  # ISO code handling
library(janitor)      # Data cleaning
```

### 7.2 Plotting Theme

Create a consistent theme for Harmful Algae manuscript style:

```r
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
```

### 7.3 Key Figures to Generate

1. **Timeline of major events** — x: year, y: economic loss (log scale), color: taxonomic class, size: fish mortality
2. **Global map** — Points at event locations, sized by impact, colored by species
3. **Species comparison** — Faceted comparison of environmental optima vs. event characteristics
4. **Cumulative impact** — Running total of economic losses by decade
5. **Regional breakdown** — Bar chart of events by region over time

---

## 8. VALIDATION RULES

Before committing any entry:

1. **Required fields present:** `event_id`, `year`, `country_iso3`, `country_name`, `species_primary`, `taxonomic_class`, `environment_type`, `fish_affected_type`, `source_doi_primary`, `source_type`, `data_quality`, `extraction_confidence`, `extraction_date`, `extraction_agent`, `verification_status`

2. **event_id format:** `^[A-Z]{3}_[0-9]{4}_[0-9]{3}$`

3. **Numeric fields non-negative:** All mortality, cell density, economic values ≥ 0

4. **Dates valid:** If present, must be valid ISO 8601 dates; `start_date` ≤ `end_date`

5. **Controlled vocabulary compliance:** Enum fields match defined values

6. **DOI format:** Primary DOI should match `^10\.\d{4,}/.*$` pattern (allow exceptions for non-DOI sources)

---

## 9. NEXT STEPS FOR CLAUDE CODE

1. **Initialize repository** with structure defined in Section 2
2. **Create schema files** (`event_catalog_schema.json`, `controlled_vocabularies.json`)
3. **Populate pilot events** (Section 5) into `event_catalog.csv`
4. **Create initial R scripts** with package loading and theme
5. **Begin systematic literature extraction** starting with priority papers (Section 6.3)
6. **Generate first validation report** confirming data integrity

---

*Document version 1.0 — Ready for Claude Code implementation*
