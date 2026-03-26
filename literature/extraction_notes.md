# Extraction Notes & Decision Log

This file documents ambiguities, decisions, and clarifications made during data extraction.

---

## General Decisions

1. **Taxonomic names**: Always use the current accepted name as `species_primary`. Record former names in `species_notes`. Key updates:
   - *Chrysochromulina polylepis* → *Prymnesium polylepis*
   - *Gymnodinium breve* → *Karenia brevis*
   - *Gymnodinium catenatum* → *Alexandrium catenella* (some populations)

2. **Cell density units**: All values standardized to cells/L. If original reports use cells/mL, multiply by 1000.

3. **Fish mortality**: Keep original reported units (individuals or tonnes). Do not convert between units — normalization handled in `R/02_normalize_units.R`.

4. **Economic values**: Record original currency and value. USD conversion filled only when conversion rate is available from a reliable source. Leave `economic_loss_usd` as NA rather than guessing.

5. **Multi-country events**: Create separate entries per country with a shared `event_name` to link them.

6. **Recurrent events** (e.g., Florida red tides): Use `event_status: recurrent`. Each individually catastrophic episode gets its own entry.

---

## Event-Specific Notes

### JPN_1972_001 — Seto Inland Sea Chattonella
- 14.2 million yellowtail killed is well-documented across multiple sources
- Economic loss: ¥7.1 billion JPY (1972) = ~$71M USD at 1972 rates (~100 JPY/USD). Some sources cite ~$90M, likely using different conversion year.
- Start/end dates approximate (July–August 1972); exact dates not in primary source.

### NOR_1988_001 — Scandinavian Chrysochromulina polylepis
- Multi-country event (Norway, Sweden, Denmark). Currently entered as NOR only — consider adding SWE_1988_001 and DNK_1988_001 if sufficient country-specific data found.
- 900 tonnes fish mortality is a combined estimate; breakdown by country exists in some sources.
- $9M USD economic estimate appears to cover only direct fish farm losses; true cost likely much higher.

### CHL_2016_001 — Chile "Godzilla Bloom"
- Two distinct phases: Pseudochattonella (fish kill) then Alexandrium (PSP/shellfish closures).
- 39,000 tonnes is the most commonly cited figure; some estimates range 27,000–40,000 tonnes.
- $800M USD is a widely cited total; breakdown between direct and indirect varies by source.

### USA_2018_001 — 2017-2018 Florida Red Tide
- Duration 516 days is based on continuous detection above background levels.
- No systematic fish mortality count; "millions" of dead fish reported but not quantified.
- Economic impact substantial but not systematically quantified in a single peer-reviewed study.

### NOR_2025_001 — Northern Norway 2025
- Dual-species event: P. pouchetii dominant initially, C. leadbeateri increasing through event.
- 8 million fish and 13,200 tonnes are regional aggregate estimates.
- Economic assessment pending at time of extraction.

### CHL_1988_001 — Chile 1988 Heterosigma
- First HAB fish-killing event in Chilean salmon industry.
- 10,000 tonnes lost = 50% of national fish production at the time.
- Max cell density 100,000 cells/mL = 100,000,000 cells/L (converted per schema rules).
- $11M USD economic loss from Lum et al. 2021.

### NZL_1989_001 — New Zealand 1989 Heterosigma
- First record of Heterosigma in New Zealand.
- Sources vary on economic loss: GlobalHAB Table 1.1 cites NZD 12M, but multiple other sources cite NZD 17M. Used NZD 17M as more commonly reported figure. USD conversion left blank — needs verification.
- Exact tonnage not reported in available sources.

### KOR_1995_001 — Korea 1995 Cochlodinium
- $69.5M USD is well-established across multiple sources (Sakamoto et al. 2021; GlobalHAB 2023).
- Specific fish species and tonnage not reported in available sources.
- Two-month bloom duration (September–October 1995).
- Recurred almost annually from 1995 onwards.

### AUS_1996_001 — Port Lincoln 1996 Chattonella
- 1,700 tonnes of southern bluefin tuna killed (75% of farmed stock).
- AUD 45M loss is well-documented. USD conversion left blank — AUD/USD rate in 1996 was approximately 0.78.
- Bloom at 66,000 cells/L. Storm was a contributing factor.
- Led to relocation of entire tuna farming industry to deeper offshore waters.

### JPN_2010_001 — Yatsushiro Sea 2010 Chattonella
- ¥5.3 billion (JPY) in 2010 alone; combined 2009-2010 losses exceeded ¥8 billion.
- Represents a geographic shift: Chattonella problems moved from Seto Inland Sea to Yatsushiro Sea.
- USD conversion: approximately $53M at 2010 exchange rates (~100 JPY/USD).

### CHN_2012_001 — Fujian 2012 Karenia mikimotoi
- 2.01 billion CNY (~$330M USD) — largest K. mikimotoi loss worldwide.
- Primarily abalone mortality, not finfish, but massive economic impact qualifies.
- Bloom area >300 km² covering most abalone farms in Fujian.
- Note: Fujian produces >75% of China's farmed abalone (China = 90% of global supply).

### CHL_2021_001 — Chile 2021 Heterosigma
- >5,000-6,000 tonnes of salmon lost in Comau Fjord area.
- Used minimum qualifier; some sources cite >6,000 t.
- Economic loss not quantified in available sources.

### KOR_2003_001 — Korea 2003 Cochlodinium
- $7.2M USD — much smaller recurrence compared to 1995.
- Limited detail available; included to document recurrence pattern.

### USA_2015_001 — US West Coast 2015 Pseudo-nitzschia
- Categorized as "economic" rather than "fish_kill" — no direct fish mortality, impact was fishery closures due to domoic acid.
- $97.5M in lost Dungeness crab landings is the most commonly cited figure.
- Additional $40M in tourism losses in Washington state.
- Driven by unprecedented marine heatwave ("the Blob").
- Human syndrome set to ASP (domoic acid) though no major human outbreak occurred due to closures.
