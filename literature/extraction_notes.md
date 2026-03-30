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

---

## Phase 2 Extraction — Gap-Filling (2026-03-26)

### GTM_1987_001 — Guatemala 1987 PSP
- 187 cases, 26 deaths — highest PSP case fatality rate (14%) in modern literature.
- Children <6 had 50% fatality rate. Clam Amphichaena kindermani was vector.
- First large PSP outbreak recognized in Guatemala.
- Source: Van Dolah 2000 (review); original case study: Rodrigue et al. 1990.

### PHL_1983_001 — Philippines 1983 Pyrodinium PSP
- First HAB occurrence in the Philippines; Pyrodinium bahamense bloom.
- Cumulative 1983-2005: 2,161 cases and 123 deaths across 135 bloom events in 27 coastal waters.
- The 21 deaths figure used here refers to the initial 1983 event cluster; exact count may be higher.
- $5M USD economic loss is approximate. Philippines is hardest-hit country for PSP globally.

### CAN_1987_001 — Canada PEI 1987 Domoic Acid
- Discovery event for amnesic shellfish poisoning (ASP).
- 107 confirmed cases, death toll varies: 3 (NEJM original) vs 4 (later reviews).
- Used 4 as most commonly cited figure in recent literature.
- Pseudo-nitzschia multiseries (then Nitzschia pungens f. multiseries) identified as source.
- Mussel DA peaked at 1500 µg/g wet weight — regulatory limit now 20 µg/g.

### PYF_2007_001 — French Polynesia Ciguatera
- Used 2007 as representative year for endemic burden; ciguatera is chronic/recurrent.
- Incidence rates: 165-251 per 10,000 in remote archipelagos (Tuamotu, Australes, Marquesas).
- 500+ cases/year is conservative; only 2-10% of cases reported to health authorities.
- Gambierdiscus toxicus sensu lato; multiple species now recognized.

### ESP_2004_001 — Canary Islands First Ciguatera
- First confirmed CFP in European waters.
- All outbreaks since 2004 associated with large amberjack consumption from sport fishing.
- ~12 cases/year average — small numbers but significant as emerging range expansion.
- Linked to ocean warming and range expansion of Gambierdiscus.

### USA_2005_001 — New England 2005 Alexandrium Red Tide
- Largest PSP closure event since 1972 in New England.
- $18M lost shellfish sales in MA; $4.9M in ME. With multiplier (4.5x), total ~$46M.
- 40,000 km² offshore closure unprecedented.
- Categorized as economic — no human cases due to effective monitoring/closures.

### ITA_2005_001 — Genoa 2005 Ostreopsis
- 209 people sought medical help from aerosolized ovatoxin exposure.
- Benthic dinoflagellate; not a planktonic bloom. Toxins aerosolized by wave action.
- First recognition that benthic HABs pose health risks in urbanized temperate areas.
- Triggered Italian Ministry of Health guidelines for Ostreopsis monitoring.

### ARE_2008_001 — Arabian Gulf 2008-2009 Cochlodinium
- 8-month bloom; 1,200 km of coastline affected.
- At least 5 UAE desalination plants shut down — SWRO shutdowns lasted up to 4 months.
- 600+ tonnes of fish killed (conservative estimate).
- Water security crisis — some regions had only 1-2 day freshwater reserves.
- Key reference: Richlen et al. 2010.

### USA_1996_001 — Florida 1996 Manatee Die-off
- 149+ manatees killed = approximately 10% of the endangered population.
- Brevetoxin confirmed in lungs and stomach contents.
- Exposure via both inhalation (surfacing to breathe) and ingestion (food web).
- Distinct from USA_2018_001 (which is the 2017-18 red tide).

### IRL_2005_001 — Ireland 2005 K. mikimotoi
- Considered exceptional in scale, persistence, and impact.
- Widespread benthic and pelagic mortality along Atlantic seaboard.
- Latest in series of Irish K. mikimotoi events since first recorded in 1976.

### GBR_2006_001 — Scotland 2006 K. mikimotoi
- Large prolonged bloom June-September 2006.
- Extensive benthic mortality (annelids, molluscs) but no farmed fish deaths.
- Bloom transported by Hebridean slope current; cells injected onto shelf by eddies.
- Key reference: Davidson et al. 2009.

### ZAF_1994_001 — South Africa 1994 Black Tide
- Dense dinoflagellate bloom in St Helena Bay; bacterial decomposition → H2S production.
- 95% reduction of intertidal biomass; 60 tonnes rock lobster killed.
- Worst recorded marine mortality on South African coast.
- "Black tide" term from dark surface waters due to hydrogen sulphide.

### ZAF_2022_001 — South Africa 2022 Lobster Walk-out
- ~500 tonnes of rock lobster stranded on West Coast beaches.
- Anoxia from red tide decomposition drove lobsters ashore.
- Species already heavily depleted from overfishing; walk-outs are recurring.
- Extraction confidence low: exact species identification and economic quantification lacking.

### MEX_2016_001 — Baja California 2016 Tuna Kill
- 9 die-off events May-August 2016 in Todos Santos Bay area.
- First ichthyotoxic bloom ever recorded in this region.
- $42M USD from insurance records of one company; total losses likely higher.
- Linked to marine heatwave: 3°C surface temperature anomalies in 2015.
- Garcia-Mendoza et al. 2018 (Frontiers in Marine Science).

### ESP_1981_001 — Spain 1981 Dinophysis DSP
- Early 1980s Galicia DSP outbreaks; ~5000 cases estimated (non-fatal but incapacitating).
- Case count is approximate — DSP often underreported and misdiagnosed as gastroenteritis.
- D. acuta and D. acuminata both contribute; D. acuta main risk in autumn.
- Galician mussel industry (Rías Baixas) is primary economic victim.

### USA_1998_001 — California 1998 Sea Lion Mortality
- 400+ California sea lions died from domoic acid poisoning.
- First documented marine mammal mortality from domoic acid.
- Pseudo-nitzschia australis bloom; toxin transferred via anchovy food web.
- Led to establishment of marine mammal DA monitoring programs.

### NOR_1984_001 — Norway 1984 First DSP
- First DSP event described in Norway (autumn 1984).
- ~100 cases estimated; triggered 25+ years of Dinophysis monitoring.
- D. acuta main causative species; D. norvegica also contributes.
- DSP became the main phycotoxin problem along the Norwegian coast.

### USA_1987_001 — North Carolina 1987-88 NSP
- 48 confirmed NSP cases from Ptychodiscus brevis (now K. brevis).
- First major NSP event outside Florida.
- $24M+ economic losses from shellfish closures.
- Large persistent bloom lasted fall 1987 through winter 1988.

### PHL_2013_001 — Philippines 2013 Western Samar PSP
- 31 cases, 2 deaths from green mussel broth consumption.
- Saxitoxin confirmed in seawater (Pyrodinium bahamense) and mussels.
- Same region as first 1983 Philippine PSP; cumulative 1985-2018: 2,555 cases, 165 deaths.

### GBR_2013_001 — Shetland 2013 Dinophysis DSP
- 70+ people reported symptoms; actual number likely higher.
- Rapid toxin accumulation within <1 week monitoring window led to contaminated mussels being sold.
- £1.37M/year estimated annual DSP losses for Scottish shellfish; econometric model.

### USA_2018_002 — Florida Red Tide Tourism ($2.7B)
- Separate from USA_2018_001 (same bloom, economic quantification entry).
- $2.7B tourism loss from spline regression model on lodging/restaurant revenue data.
- Represents potential "billion-dollar disaster" HAB category.

### AUS_2012_001 — Tasmania 2012 G. catenatum
- Largest and most significant toxic bloom in Tasmania on record.
- ~AUD $23M total economic loss from prolonged shellfish closures.
- G. catenatum likely introduced via ship ballast water from Japan/Korea post-1972.

### OMN_2008_001 — Oman 2008 Desalination
- Barka desalination plant ceased operations for 55 days.
- Separate entry from ARE_2008_001 (same bloom, different country perspective).
- RO 330,000 + RO 140,000 in documented plant losses (later events).

### NOR_1998_001 and DNK_2019_001 — Pseudochattonella events
- Both from GlobalHAB 2023 Table 1.1; $1.4M USD each.
- Limited detail available; included to document geographic spread of Pseudochattonella problem.

### NZL_2019_001 — New Zealand Pseudochattonella
- 200 tonnes / 15% of stock from GlobalHAB Table 1.1.
- King salmon (Chinook) industry in Marlborough Sounds affected.

### JPN_1980_001 — Japan 1980s Heterosigma
- $135M cumulative 1980-1990 from GlobalHAB Table 1.1.
- Year set to 1985 as mid-decade representative; extraction confidence low.

### USA_2005_002 — Florida 2005 Red Tide Health Costs
- Quantified health cost methodology from Hoagland et al. 2014.
- Counterfactual analysis: ER visits vs K. brevis cell counts; 6 SW FL counties.
- Annual costs $60K-$700K; exceeded $1M in severe 2005 bloom.

---

## Phase 3 Extraction — Targeted Gap-Filling (2026-03-26)

### MYS_2014_001 — Malaysia 2014 Karlodinium Johor Strait
- ~50,000 cage-cultured fish killed on 11 Feb 2014 in West Johor Strait.
- K. australe at 0.31-2.34 × 10⁶ cells/L (68-99% of phytoplankton).
- $2.6M USD from GlobalHAB Table 1.1.
- First report of K. australe mass fish mortality; recurred 2015.
- Many small-scale aquaculturists ceased operations after event.
- Lim et al. 2014 (Harmful Algae 40:51-62).

### CHN_1989_001 — China 1989 Bohai Sea Gymnodinium
- 275 km² bloom area; 240 million RMB (~$30M USD) economic loss.
- Most serious HAB disaster of 1980s China.
- Species identified as Gymnodinium sp. (exact species uncertain).
- From Yu et al. 2023.

### CHN_1998_001 — China 1998 Pearl River Estuary K. mikimotoi
- First K. mikimotoi bloom recorded in China.
- Over 0.3 billion HKD in economic losses in Dapeng/Daya Bay area.
- USD conversion left blank — HKD/USD rate was ~7.75 in 1998.
- From Yu et al. 2023 and Sakamoto et al. 2021.

### CHN_2015_001 — China 2015 Phaeocystis Nuclear Plant Blockage
- Categorized as "economic" — unique infrastructure impact type.
- Mucilaginous P. globosa colonies blocked cooling water filtration of Fangchenggang Nuclear Power Plant.
- First documented case of HAB threatening nuclear power safety globally.
- Bloom Dec 2014 - Feb 2015 in Beibu Gulf.
- PAC-MC (modified clay) successfully used for mitigation.
- No specific dollar figure for economic loss; categorized as major infrastructure disruption.

### NIC_2005_001 — Nicaragua 2005 Pyrodinium PSP
- 45 cases, 1 death on Pacific coast during October 2005 bloom.
- 10% of Maderas Negras Island population affected.
- Concha negra clams were the vector; saxitoxin confirmed.
- First Caribbean/Central America PSP event in catalog.
- Ching et al. 2015 (BMC Research Notes).

### CRI_1989_001 — Costa Rica 1989 Pyrodinium PSP
- ~10 confirmed cases from consuming Spondylus calcifer clams on Pacific coast.
- No deaths reported. Symptoms: numbness, leg paralysis, respiratory distress.
- P. bahamense found in clam intestine.
- Exact case count uncertain; extraction confidence medium.

### IND_2021_001 — India 2021 Gulf of Mannar Noctiluca
- 7.2 tonnes total fish mortality; 0.96 t commercially important fish valued at $5.5M.
- ~9 million damselfish killed (0.83 tonnes) — largest damselfish mass mortality from N. scintillans ever.
- 43 fish genera affected across Pamban to Mundal region.
- Bloom caused hypoxia and ammonia toxicity; NOT direct toxin production.
- Also fills GAP 3 (ecological cascade): shellfishes, sea anemones, sea horses, polychaetes also killed.
- Coral reef impacts documented separately in 2019 event (71% mortality in Acropora/Montipora/Pocillopora).
- First India event in catalog; fills critical South Asia gap.

### MAR_1994_001 — Morocco 1994 PSP Intoxication
- 23 hospitalized, 4 deaths from PSP.
- PSP toxins in mussels at Oualidia Lagoon reached 2,600 µg STX equiv/kg (regulatory limit 800).
- G. catenatum identified as causative species.
- First NW Africa/Morocco event in catalog.
- First case of poisoning in Morocco from algal toxins was 1966; monitoring established 1992.

### MYS_2005_001 — Malaysia 2005 Sabah Cochlodinium
- M. polykrikoides bloom in Kota Kinabalu, Sabah waters.
- Fish kills in cage aquaculture and wild populations.
- Economic losses not quantified in available sources.
- Bloom extended from west coast Sabah southward; recurred 2006.
- Extraction confidence low due to limited quantitative data.

### IDN_1988_001 — Indonesia 1988 Pyrodinium PSP
- Cumulative: 427 PSP cases and 17 deaths from Indonesia (1988-1999 period).
- Third highest PSP burden in SE Asia after Philippines and Malaysia.
- Year set to 1988 as first events reported in late 1980s.
- Extraction confidence low: cumulative data, exact event date uncertain.

### USA_2002_001 — Washington 2002-2003 Razor Clam Closure
- $24.4M estimated expenditures from survey of 240 parties.
- Recreational razor clam fishery generates up to $40M/yr in WA.
- 25.8% of fishing days lost to closures 1991-2008 (23.3% domoic acid, 2.4% PSP).
- Categorized as economic: no fish mortality, impact is fishery closure.
- Key methodology paper: Dyson & Huppert 2010.

---

## Phase 5 Extraction — Final Gap-Closing Round (2026-03-27)

### Schema Vocabulary Amendments

Two controlled vocabulary additions were required before extracting freshwater and cyanotoxin events:

1. **`environment_type`**: Added `freshwater_lake` ("Freshwater lake or reservoir") and `freshwater_river` ("Freshwater river, stream, or canal"). Rationale: the existing enum only covered marine/estuarine/brackish/fjord environments. The Oder River (POL_2022_001, DEU_2022_001), Texas rivers (USA_2001_002), and cyanotoxin events (BRA_1996_001, AUS_1979_001, USA_2014_001) all occur in purely freshwater systems that do not fit any existing category. These were added to both `controlled_vocabularies.json`, `event_catalog_schema.json`, the R validator (`01_load_validate.R`), and the Python CSV validator (`fix_csv_alignment.py`).

2. **`human_syndrome`**: Added `cyanotoxin` ("Illness caused by any cyanobacterial toxin via drinking water, dialysis, or recreational exposure"). Rationale: the existing syndrome enum covers marine shellfish toxin syndromes (PSP, DSP, ASP, NSP, CFP, AZP) and exposure routes (respiratory, dermal), but cyanobacterial toxin exposure via drinking water or dialysis does not fit any of these categories. The Caruaru (microcystin via hemodialysis), Palm Island (cylindrospermopsin via drinking water), and Toledo (microcystin in finished water) events all require this new value.

### Akashiwo sanguinea — Wildlife Mortality Classification

Decision: Classify *Akashiwo sanguinea* events as `fish_affected_type: unknown` rather than creating a new wildlife-specific category. The surfactant-mediated seabird mortality is fundamentally different from ichthyotoxicity — A. sanguinea produces foam that destroys feather waterproofing, causing hypothermia and drowning in seabirds. No fish kills are associated with these events.

Workaround: Seabird mortality is recorded in `wildlife_mortality: TRUE`, `wildlife_species_affected` (listing species and counts), and `fish_mortality_notes` (explaining that impact is on seabirds not fish). The `event_category` is set to `mixed` rather than `fish_kill` to reflect the wildlife/ecological nature of the impact. This avoids schema changes while preserving the data accurately.

### Aureococcus/Aureoumbra — Bivalve Mortality Classification

Decision: Record bivalve mortality (bay scallops, blue mussels) in `fish_species_affected` with a clarifying note in `fish_mortality_notes` rather than creating a new field. Brown tide impacts are primarily on bivalves (feeding inhibition, recruitment failure) and seagrass (light limitation), not finfish. The `fish_affected_type` is set to `unknown` since no finfish mortality occurs.

Rationale: Creating a separate `invertebrate_species_affected` field would require schema changes propagated across all validation scripts and analysis code. The existing fields adequately capture the information when paired with explanatory notes. The `benthic_impact: TRUE` flag captures the ecosystem-level effect.

### Caruaru Death Toll Discrepancy

Three primary sources report different death tolls for the 1996 Caruaru hemodialysis disaster:
- **Jochimsen et al. (1998, NEJM)**: Reports 50 deaths at time of writing (early 1998)
- **Pouria et al. (1998, Lancet)**: Reports 60 deaths
- **Carmichael et al. (2001, EHP)**: Reports 52 deaths attributed to "Caruaru syndrome" as of December 1996

Decision: Use **52** as the catalog value (`human_deaths: 52`). Rationale: Carmichael et al. (2001) provides the most carefully defined figure, specifically attributing deaths to "Caruaru syndrome" with chemical and biological confirmation of cyanotoxin involvement. The Jochimsen figure (50) was preliminary; the Pouria figure (60) may include deaths from other causes in the same patient cohort. All three sources are cited in `source_dois_secondary`.

### Oder River Tonnage Discrepancy

Two estimates exist for total fish mortality in the 2022 Oder River disaster:
- **Confirmed**: 360 tonnes (based on collected carcasses; widely cited including Wikipedia)
- **Estimated maximum**: Up to 1,000 tonnes (IGB factsheet estimate based on population surveys)

Decision: Use **360** as `fish_killed_tonnes` with `fish_killed_tonnes_qualifier: minimum`. The 1,000-tonne high estimate is recorded in `fish_mortality_notes` and `notes`. Rationale: 360 tonnes is the confirmed minimum based on physical collection; 1,000 tonnes is a modeled estimate with greater uncertainty. Using the confirmed figure with a `minimum` qualifier is consistent with our general approach of recording the most conservative defensible number.

### Nodularia Baltic Sea — Multi-Country Recurrent Entry

Decision: Create **SWE_1987_001** as the primary entry for the Baltic Sea *Nodularia spumigena* recurrent summer bloom, anchored to Sweden as the most documented country with the longest monitoring record.

Rationale: The Baltic Nodularia bloom is a multi-country annual phenomenon affecting Sweden, Finland, Germany, Poland, Denmark, Estonia, Latvia, and Lithuania. Creating separate entries for each country would produce 8+ rows for what is essentially a single interconnected bloom system. Sweden was chosen as the anchor country because:
- Swedish monitoring programs (SMHI) have the longest continuous record
- Swedish beach closures are the most consistently documented
- Key toxicological studies (Sipiä, Kankaanpää) were conducted in Finnish/Swedish waters

The multi-country scope is noted in `event_name` ("Baltic Sea Nodularia spumigena recurrent summer blooms") and `notes`. Year 1987 was selected as representative of the period when nodularin was first confirmed as a significant environmental toxin, though blooms have been documented since the 1970s.

### Remaining Literature Gaps — Accepted as Manuscript Limitations

The following geographic gaps were investigated during this final search round and confirmed as genuine literature gaps:

- **West Africa** (beyond Morocco MAR_1994_001): No documented catastrophic HAB events with quantified economic or health impacts found in English-language literature.
- **East Africa**: No documented catastrophic HAB events with quantified impacts. Some Pyrodinium occurrences reported but without quantitative data.
- **Russia/Arctic**: Limited documentation accessible in English. Some events known (e.g., White Sea, Kamchatka) but not quantified to catalog threshold.
- **Bangladesh/Sri Lanka**: HAB occurrences reported in monitoring literature but no catastrophic events with quantified economic or health data meeting inclusion criteria.

Decision: No further searching warranted. These gaps are accepted as manuscript limitations and will be noted in the review's discussion section. The catalog now covers 32 countries across all major HAB-affected regions where quantified impact data exists in the published literature.

---

## Phase 5 Addendum — USA_2012_001 and PDF Extraction Pass (2026-03-30)

### USA_2012_001 — Indian River Lagoon 2012 Aureoumbra Brown Tide

Added as 15th event in the gap-closing round. *Aureoumbra lagunensis* bloom in Indian River Lagoon, Florida — the first confirmed range expansion of this species outside Texas. Chlorophyll-a reached ~200 µg/L (20× historical mean). Classified as `mixed` (ecological disruption primary; >30 fish kill reports in Mosquito Lagoon from near-hypoxic conditions). Primary source: Gobler et al. 2013 (DOI: 10.1016/j.hal.2013.04.004). PDF needed for full quantitative extraction.

### Phase 5 PDF Extraction Pass (2026-03-30)

No PDFs were found in `literature/pdfs/`. PDF extraction pass skipped. The following DOIs require PDF upload before extraction confidence can be upgraded from `low` for the affected events:

- 10.3354/meps12253 → USA_2009_001 (Akashiwo WA/OR seabird mortality)
- 10.1016/S0140-6736(97)12285-1 → BRA_1996_001 (Caruaru Lancet paper)
- 10.1016/S0300-483X(02)00491-2 → BRA_1996_001 (Azevedo toxicology)
- 10.1016/j.hal.2024.102644 → POL_2022_001, DEU_2022_001 (Oder River Mora et al.)
- 10.1002/tox.10103 → AUS_1979_001 (Palm Island review)
- 10.4319/lo.1997.42.5_part_2.1023 → USA_1985_001 (Aureococcus Long Island)
- 10.1111/j.1752-1688.2009.00387.x → USA_2001_002 (Prymnesium Texas)
- 10.1016/j.hal.2011.10.013 → USA_1985_001, USA_1990_001, USA_2012_001, ZAF_2001_001 (Gobler & Sunda brown tide review)
- 10.1016/j.hal.2013.04.004 → USA_2012_001 (Gobler et al. Florida brown tide)
