# Claude Code Initiation Prompt for HAB Review Project

Copy and paste this prompt to initiate Claude Code:

---

## PROMPT START

I'm starting a systematic review project on global catastrophic harmful algal bloom (HAB) events for publication in *Harmful Algae*. I've prepared a detailed project specification with schema definitions and pilot data.

**Project repository:** github.com/KristofM854/HAB_review_economic_health_impact

**Your first tasks:**

1. **Clone and review the repository structure** - I've uploaded the following files to the repo:
   - `HAB_Review_Schema_Specification.md` — Complete project spec (read this first!)
   - `event_catalog_pilot.csv` — 8 pilot events ready for import
   - `HAB_Review_References.md` — 85 key references with DOIs
   - `references_seed.bib` — BibTeX entries for core papers
   - `CLAUDE_CODE_QUICKSTART.md` — Quick reference for your tasks

2. **Set up the repository structure** as defined in Section 2 of the schema specification:
   - Create the directory structure (`data/`, `R/`, `literature/`, etc.)
   - Move pilot files to appropriate locations
   - Create `data/schema/event_catalog_schema.json` from Section 3
   - Create `data/schema/controlled_vocabularies.json` from Section 4

3. **Initialize R infrastructure:**
   - Create `R/00_setup.R` with required packages
   - Create `R/functions/plotting_theme.R` with the ggplot2 theme from Section 7.2
   - Create `R/01_load_validate.R` to load and validate the catalog

4. **Begin systematic literature extraction:**
   - Start with the GlobalHAB 2023 White Paper (Hallegraeff et al.) - it contains comprehensive event tables
   - Extract events following the workflow in Section 6
   - Each new event should follow the schema exactly
   - Set `extraction_agent: claude` and `verification_status: unverified`

**Key scope decisions (already incorporated in the spec):**

- **Event types:** Fish kills, human health events (PSP/DSP/CFP outbreaks), AND economic-only events (desalination shutdowns, tourism losses)
- **Includes:** Both farmed AND wild fish events (use `fish_affected_type` field)
- **Ecological impacts:** Captured in dedicated fields, but focus is fish + human health
- **Temporal scope:** ~1970s through 2025 (only resolved/confirmed events — no ongoing events)
- **Cell density units:** Always cells/L
- **Economic data:** Capture original currency + value; USD conversion column filled where available
- **Fish mortality:** Keep original reported units (n or tonnes); normalization will happen later

**Working style:**
- Commit incrementally with clear messages
- Document any ambiguities in `literature/extraction_notes.md`
- Flag uncertainties using the `extraction_confidence` field
- Prioritize peer-reviewed sources; note source type for all entries

Start by reading `HAB_Review_Schema_Specification.md` thoroughly, then proceed with setup tasks.

## PROMPT END

---

## Notes for Kristof

Before pasting this prompt:

1. **Create the GitHub repo** (e.g., `hab-catastrophic-review`)
2. **Upload the files** I've prepared:
   - `HAB_Review_Schema_Specification.md`
   - `event_catalog_pilot.csv`
   - `HAB_Review_References.md`
   - `references_seed.bib`
   - `CLAUDE_CODE_QUICKSTART.md`
3. **Replace** `[INSERT YOUR REPO URL HERE]` with your actual repo URL
4. **Paste the prompt** to Claude Code

Claude Code should then:
- Set up the full directory structure
- Generate JSON schema files
- Create R infrastructure
- Begin extracting events from the literature

You can check progress via Git commits and periodically review `verification_status: unverified` entries.
