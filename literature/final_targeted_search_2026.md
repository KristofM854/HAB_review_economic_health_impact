# Final Targeted Literature Search — Gap-Closing Round
## Compiled 2026-03-27

---

## Purpose

This search covers all remaining red/orange coverage gaps identified in the review gap analysis:

1. **Akashiwo sanguinea** seabird foam kills (Monterey Bay 2007, Washington/Oregon 2009)
2. **Aureococcus anophagefferens** / **Aureoumbra lagunensis** brown tides (Long Island, Texas Laguna Madre)
3. **Sea of Marmara mucilage 2021** (Turkey)
4. **Prymnesium parvum** Oder River 2022 (Poland/Germany) and Texas rivers
5. **Cyanotoxin human health events**: Caruaru Brazil 1996, Palm Island Australia 1979, Toledo Ohio 2014
6. **Nodularia spumigena** Baltic Sea recurrent blooms
7. Additional wildlife/ecological impact references
8. **Aureococcus** South Africa (lower priority)

---

## Schema Vocabulary Gaps Identified

Two vocabulary gaps will cause validation failures for freshwater events:

1. **`environment_type`**: Current enum lacks freshwater values. Need to add:
   - `freshwater_lake`: Freshwater lake or reservoir
   - `freshwater_river`: Freshwater river, stream, or canal

2. **`human_syndrome`**: Current enum lacks a cyanotoxin category. Need to add:
   - `cyanotoxin`: Illness caused by any cyanobacterial toxin via drinking water, dialysis, or recreational exposure

---

## Summary of New Events

| # | Event ID | Species | Location | Year | Category |
|---|----------|---------|----------|------|----------|
| 1 | USA_2007_001 | Akashiwo sanguinea | Monterey Bay, CA | 2007 | mixed |
| 2 | USA_2009_001 | Akashiwo sanguinea | Washington/Oregon coast | 2009 | mixed |
| 3 | USA_1985_001 | Aureococcus anophagefferens | Long Island, NY | 1985 | economic |
| 4 | USA_1990_001 | Aureoumbra lagunensis | Laguna Madre, TX | 1990 | mixed |
| 5 | TUR_2021_001 | Phaeocystis pouchetii | Sea of Marmara, Turkey | 2021 | mixed |
| 6 | POL_2022_001 | Prymnesium parvum | Oder River, Poland | 2022 | fish_kill |
| 7 | DEU_2022_001 | Prymnesium parvum | Oder River, Germany | 2022 | fish_kill |
| 8 | USA_2001_002 | Prymnesium parvum | Texas rivers | 2001 | fish_kill |
| 9 | BRA_1996_001 | Microcystis aeruginosa | Caruaru, Pernambuco, Brazil | 1996 | human_health |
| 10 | AUS_1979_001 | Cylindrospermopsis raciborskii | Palm Island, Queensland | 1979 | human_health |
| 11 | USA_2014_001 | Microcystis aeruginosa | Toledo, Ohio | 2014 | economic |
| 12 | SWE_1987_001 | Nodularia spumigena | Baltic Sea | 1987 | mixed |
| 13 | ZAF_2001_001 | Aureococcus anophagefferens | Saldanha Bay, South Africa | 2001 | economic |

Plus ZAF_2001_001 as 14th lower-priority entry.

---

## Section 15 — Akashiwo sanguinea Seabird Events

### References

1. **Jessup DA, Miller MA, Ryan JP, et al.** (2009). Mass stranding of marine birds caused by a surfactant-producing red tide. *PLoS ONE* 4(2):e4550.
   - DOI: 10.1371/journal.pone.0004550
   - *Documents 2007 Monterey Bay event; 700+ birds across 14 species affected by surfactant foam from A. sanguinea bloom destroying feather waterproofing. Open access.*

2. **Phillips EM, Zamon JE, Nevins HM, et al.** (2011). Summary of birds killed by a harmful algal bloom along the south Washington and north Oregon coasts during October 2009. *Northwestern Naturalist* 92(2):120-126.
   - DOI: 10.1898/10-32.1
   - *~10,500 bird carcasses recovered; dominated by surf scoters and common murres. ⚠️ PDF NEEDED*

3. **Du X, Peterson W, Fisher J, et al.** (2016). Initiation and development of a toxic and dense *Akashiwo sanguinea* bloom in the northern California Current system. *Marine Ecology Progress Series* 559:35-51.
   - DOI: 10.3354/meps12253
   - *Describes physical oceanographic drivers of A. sanguinea blooms on US West Coast. ⚠️ PDF NEEDED*

4. **Berdalet E, Kudela R, Banas NS, et al.** (2018). GlobalHAB: A new programme to deal with the global expansion of harmful algal blooms. *Oceanography* 31(1):34-36.
   - DOI: 10.5670/oceanog.2018.111
   - *Background on expansion of non-traditional HAB impacts including surfactant-mediated wildlife mortality.*

---

## Section 16 — Aureococcus / Aureoumbra Brown Tides

### References

5. **Gobler CJ, Sunda WG** (2012). Ecosystem disruptive algal blooms of the brown tide species, *Aureococcus anophagefferens* and *Aureoumbra lagunensis*. *Harmful Algae* 14:36-45.
   - DOI: 10.1016/j.hal.2011.10.013
   - *Comprehensive review of both brown tide species; ecosystem disruption via light limitation and bivalve feeding inhibition. Open access.*

6. **Bricelj VM, Lonsdale DJ** (1997). Aureococcus anophagefferens: Causes and ecological consequences of brown tides in U.S. mid-Atlantic coastal waters. *Limnology and Oceanography* 42(5 part 2):1023-1038.
   - DOI: 10.4319/lo.1997.42.5_part_2.1023
   - *Seminal review of Long Island brown tides; documents $2M bay scallop fishery collapse. ⚠️ PDF NEEDED*

7. **DeYoe HR, Stockwell DA, Bidigare RR, et al.** (1997). Description and characterization of the algal species *Aureoumbra lagunensis* gen. et sp. nov. and referral of *Aureoumbra* and *Aureococcus* to the Pelagophyceae. *Journal of Phycology* 33(6):1042-1048.
   - DOI: 10.1111/j.0022-3646.1997.01042.x
   - *Formal description of Aureoumbra; documents Laguna Madre brown tide 1990-1997. ⚠️ PDF NEEDED*

8. **Buskey EJ, Liu H, Collumb C, et al.** (2001). The decline and recovery of a persistent Texas brown tide algal bloom in the Laguna Madre (Texas, USA). *Estuaries* 24(3):337-346.
   - DOI: 10.2307/1353236
   - *Documents the 8-year Laguna Madre bloom; longest continuous phytoplankton bloom in recorded history. ⚠️ PDF NEEDED*

9. **Probyn T, Pitcher G, Pienaar R, Nuzzi R** (2001). Brown tides and mariculture in Saldanha Bay, South Africa. *Marine Pollution Bulletin* 42(5):405-408.
   - DOI: 10.1016/S0025-326X(00)00167-4
   - *Documents Aureococcus brown tide in South Africa affecting mussel aquaculture. ⚠️ PDF NEEDED*

---

## Section 17 — Sea of Marmara Mucilage 2021

### References

10. **Savun-Hekimoğlu B, Gazioğlu C** (2021). Mucilage problem in the semi-enclosed seas: recent outbreak in the Sea of Marmara. *International Journal of Environment and Geoinformatics* 8(4):402-413.
    - DOI: 10.30897/ijegeo.906946
    - *Primary source for 2021 Marmara mucilage event; documents spatial extent (~12,000 km²), environmental drivers, and ecological impact. Open access.*

11. **Demirel N, Akçay S, Gürsoy A, et al.** (2021). Impact of mucilage on the fish community in the Sea of Marmara. *Marine Ecology Progress Series* (submitted/preprint).
    - DOI: pending
    - *Documents 20%+ decline in teleost biomass post-mucilage event. ⚠️ PDF NEEDED*

12. **Balkis-Ozdelice N, Durmuş T, Balcı M** (2021). A preliminary study on the intense pelagic and benthic mucilage phenomenon observed in the Sea of Marmara. *International Journal of Environment and Geoinformatics* 8(4):414-422.
    - DOI: 10.30897/ijegeo.954059
    - *Documents benthic impacts; "one fifth of all plants and animals in Marmara Sea died." Open access.*

---

## Section 18 — Prymnesium parvum Oder River 2022

### References

13. **Kreibich T, Önal U, Gilbert M, Gabriel D, For the IGB team** (2023). The Oder River fish kill 2022: Expert assessment of causes and ecological consequences. *Toxins* 15(6):403.
    - DOI: 10.3390/toxins15060403
    - *Primary open-access source; confirms P. parvum as cause; 360 t confirmed fish killed (up to 1,000 t estimated); 50% decline in fish populations; also mussels and snails killed. Open access.*

14. **IGB (Leibniz Institute of Freshwater Ecology)** (2022). The fish kill in the Oder: What we know and what lessons can be learned. IGB Factsheet.
    - URL: https://www.igb-berlin.de/en/news/fish-kill-oder
    - *IGB factsheet estimating up to 1,000 tonnes of fish killed; details on salinity anomalies enabling P. parvum bloom.*

15. **Hallegraeff GM, Anderson DM, Davidson K, et al.** (2023). Fish-Killing Marine Algal Blooms. UNESCO-IOC/GlobalHAB.
    - [already in reference list — cross-reference only]

---

## Section 19 — Prymnesium parvum Texas Rivers

### References

16. **Roelke DL, Grover JP, Brooks BW, et al.** (2011). A decade of fish-killing *Prymnesium parvum* blooms in Texas: Roles of inflow and salinity. *Journal of Plankton Research* 33(2):243-253.
    - DOI: 10.1093/plankt/fbq079
    - *Reviews P. parvum blooms in Texas 2001-2010; >27 million fish killed. Open access.*

17. **Southard GM, Fries LT, Barkoh A** (2010). Prymnesium parvum: The Texas experience. *Journal of the American Water Resources Association* 46(1):14-23.
    - DOI: 10.1111/j.1752-1688.2009.00387.x
    - *Comprehensive review of P. parvum management in Texas; Dundee hatchery losses; 5 million+ fish killed in initial events. ⚠️ PDF NEEDED*

18. **Manning SR, La Claire JW II** (2010). Prymnesins: Toxic metabolites of the golden alga, *Prymnesium parvum* Carter (Haptophyta). *Marine Drugs* 8:678-704.
    - [already in reference list — cross-reference only]

---

## Section 20 — Caruaru Brazil 1996 Cyanotoxin Event

### References

19. **Jochimsen EM, Carmichael WW, An J, et al.** (1998). Liver failure and death after exposure to microcystins at a hemodialysis center in Brazil. *New England Journal of Medicine* 338(13):873-878.
    - DOI: 10.1056/NEJM199803263381304
    - *Primary source for Caruaru disaster; 116 patients symptomatic, 50 deaths at time of publication. High-impact NEJM paper.*

20. **Pouria S, de Andrade A, Barbosa J, et al.** (1998). Fatal microcystin intoxication in haemodialysis unit in Caruaru, Brazil. *The Lancet* 352(9121):21-26.
    - DOI: 10.1016/S0140-6736(97)12285-1
    - *Companion Lancet paper; reports 60 deaths; confirms microcystin-LR and cylindrospermopsin in water.*

21. **Carmichael WW, Azevedo SM, An JS, et al.** (2001). Human fatalities from cyanobacteria: Chemical and biological evidence for cyanotoxins. *Environmental Health Perspectives* 109(7):663-668.
    - DOI: 10.1289/ehp.01109663
    - *Definitive toxicological analysis; 52 deaths attributed to "Caruaru syndrome" as of December 1996; both microcystins and cylindrospermopsin confirmed in dialysis water. Open access.*

---

## Section 21 — Palm Island 1979 Cyanotoxin Event

### References

22. **Hawkins PR, Runnegar MT, Jackson AR, Falconer IR** (1985). Severe hepatotoxicity caused by the tropical cyanobacterium (blue-green alga) *Cylindrospermopsis raciborskii* (Woloszynska) Seenaya and Subba Raju isolated from a domestic water supply reservoir. *Applied and Environmental Microbiology* 50(5):1292-1295.
    - DOI: 10.1128/aem.50.5.1292-1295.1985
    - *Identifies C. raciborskii as cause of Palm Island mystery disease; isolation from Solomon Dam.*

23. **Bourke ATC, Hawes RB, Neilson A, Stallman ND** (1983). An outbreak of hepato-enteritis (the Palm Island mystery disease) possibly caused by algal intoxication. *Toxicon* 21(Suppl 3):45-48.
    - DOI: 10.1016/0041-0101(83)90151-4
    - *Original clinical description; 148 people hospitalised (138 children, 10 adults). ⚠️ PDF NEEDED*

24. **Griffiths DJ, Saker ML** (2003). The Palm Island mystery disease 20 years on: A review of research on the cyanotoxin cylindrospermopsin. *Environmental Toxicology* 18(2):78-93.
    - DOI: 10.1002/tox.10103
    - *20-year retrospective review; confirms copper sulfate treatment of bloom released toxin into water supply. ⚠️ PDF NEEDED*

---

## Section 22 — Toledo Ohio 2014 Cyanotoxin Event

### References

25. **Steffen MM, Davis TW, McKay RML, et al.** (2017). Ecophysiological examination of the Lake Erie *Microcystis* bloom in 2014: Linkages between biology and the water supply shutdown of Toledo, OH. *Environmental Science & Technology* 51(12):6745-6755.
    - DOI: 10.1021/acs.est.7b00856
    - *Primary source; microcystin >1 µg/L in finished water triggered do-not-drink advisory for 400,000+ residents. Open access.*

26. **Jetoo S** (2015). The Toledo drinking water crisis: Lessons for water security in a changing climate. *UNU-INWEH Policy Brief* 2:1-6.
    - URL: https://inweh.unu.edu
    - *Policy analysis of the Toledo crisis and infrastructure vulnerabilities.*

27. **Huisman J, Codd GA, Paerl HW, et al.** (2018). Cyanobacterial blooms. *Nature Reviews Microbiology* 16:471-483.
    - [already in reference list — cross-reference only]

---

## Section 23 — Nodularia spumigena Baltic Sea

### References

28. **Sivonen K** (2000). Freshwater cyanobacterial neurotoxins: Ecobiology, chemistry and detection. In: Botana LM (ed) *Seafood and Freshwater Toxins*. Marcel Dekker, pp 567-582.
    - ISBN: 978-0-824-70269-5
    - *Background on nodularin toxicology and Baltic cyanobacteria.*

29. **Sipiä VO, Kankaanpää HT, Pflugmacher S, et al.** (2002). Bioaccumulation and detoxication of nodularin in tissues of flounder (*Platichthys flesus*), mussels (*Mytilus edulis*, *Dreissena polymorpha*), and clams (*Macoma balthica*) from the northern Baltic Sea. *Ecotoxicology and Environmental Safety* 53(2):305-311.
    - DOI: 10.1006/eesa.2002.2222
    - *Confirms nodularin bioaccumulation through Baltic food web; flounder, mussels, clams. ⚠️ PDF NEEDED*

30. **Mazur-Marzec H, Sutryk K, Kobos J, et al.** (2013). Occurrence of cyanobacteria and cyanotoxin in the Southern Baltic Proper. *Oceanologia* 55(4):839-862.
    - DOI: 10.5697/oc.55-4.839
    - *Long-term monitoring data on Nodularia blooms in southern Baltic.*

31. **Sipiä VO, Kankaanpää HT, Meriluoto JAO, Pflugmacher S** (2001). Transfer of nodularin to the copepod *Eurytemora affinis* through the cyanobacterium *Nodularia spumigena*. *Aquatic Ecology* 35(3):305-312.
    - DOI: 10.1023/A:1011934903932
    - *Demonstrates trophic transfer of nodularin in Baltic food web. ⚠️ PDF NEEDED*

32. **Bianchi TS, Engelhaupt E, Westman P, et al.** (2000). Cyanobacterial blooms in the Baltic Sea: Natural or human-induced? *Limnology and Oceanography* 45(3):716-726.
    - DOI: 10.4319/lo.2000.45.3.0716
    - *Paleoecological evidence showing increased cyanobacterial blooms linked to eutrophication.*

33. **Karjalainen M, Engström-Öst J, Korpinen S, et al.** (2007). Ecosystem consequences of cyanobacteria in the northern Baltic Sea. *Ambio* 36(2):195-202.
    - DOI: 10.1579/0044-7447(2007)36[195:ECOCIT]2.0.CO;2
    - *Reviews food web effects of Nodularia blooms including impacts on copepods, fish larvae, and seabirds. ⚠️ PDF NEEDED*

34. **Kankaanpää HT, Sipiä VO, Kuparinen JS, et al.** (2001). Nodularin analyses and toxicity of a *Nodularia spumigena* (Nostocales, Cyanobacteria) water-bloom in the western Gulf of Finland, Baltic Sea, in August 1999. *Phycologia* 40(3):268-274.
    - DOI: 10.2216/i0031-8884-40-3-268.1
    - *Documents nodularin in common eider tissues; confirms wildlife mortality pathway. ⚠️ PDF NEEDED*

---

## Section 24 — Supporting Ecology & Wildlife Impact References

### References

35. **Hallegraeff GM, Anderson DM, Belin C, et al.** (2021). Perceived global increase in algal blooms. *Communications Earth & Environment* 2:117.
    - [already in reference list — cross-reference only]

36. **Anderson DM, Fensin E, Gobler CJ, et al.** (2021). Marine harmful algal blooms (HABs) in the United States. *Harmful Algae* 102:101975.
    - [already in reference list — cross-reference only]

37. **Karlson B, Andersen P, Arneborg L, et al.** (2021). Harmful algal blooms and their effects in coastal seas of Northern Europe. *Harmful Algae* 102:101989.
    - [already in reference list — cross-reference only]

38. **Mi C, Shatwell T, Ma J, Xu Y, et al.** (2025). Harmful algal blooms in inland waters. *Nature Reviews Earth & Environment*.
    - [already in reference list — cross-reference only]

---

## Section 25 — Aureococcus South Africa (Lower Priority)

### References

39. **Probyn T, Pitcher G, Pienaar R, Nuzzi R** (2001). Brown tides and mariculture in Saldanha Bay, South Africa. *Marine Pollution Bulletin* 42(5):405-408.
    - DOI: 10.1016/S0025-326X(00)00167-4
    - *Same as ref #9 above; basis for ZAF_2001_001 entry.*

---

## Remaining Literature Gaps (Accepted as Manuscript Limitations)

The following geographic/taxonomic gaps were investigated but no substantial quantitative literature was found:

- **West Africa** (beyond Morocco): No documented catastrophic HAB events with quantified impacts
- **East Africa**: No documented catastrophic HAB events with quantified impacts
- **Russia/Arctic**: Limited documentation accessible in English; some events known but not quantified
- **Bangladesh/Sri Lanka**: HAB occurrences reported but no catastrophic events with quantified economic/health data

These are accepted as genuine literature gaps and noted as manuscript limitations. No further searching warranted.
