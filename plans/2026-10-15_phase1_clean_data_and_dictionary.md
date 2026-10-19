# Plan: waterqualityuganda data package (phase 1: clean data + dictionary)

## Context

`waterqualityuganda` is an empty `usethis`-style package skeleton
(DESCRIPTION/NAMESPACE placeholders, empty `R/`) that must become an
openwashdata data package following the GHE data publishing guide and the
`washr` workflow. The raw data in `data-raw/` comes from Cecilia Nansiimbi's
capstone project (Whave Solutions / Maji Health): monthly E. coli monitoring,
Nov 2024 to Sep 2025, of borehole water and of the transport (jerrycan) and
storage containers of three households per borehole, in four Ugandan
districts (Nakaseke/Central, Kaabong/Karamoja, Kumi/Teso, Luuka/Busoga).

Two mWater survey exports:

| file                                  | rows      | content                |
|---------------------------------------|-----------|------------------------|
| `data-raw/Sample_collection.xlsx`     | 1630 x 42 | field survey, 1 row    |
|                                       |           | per visit (see below)  |
| `data-raw/Sample_E.coliresults.xlsx`  | 2679 x 32 | lab survey, 1 row per  |
|                                       |           | analysed bottle        |

- Field survey: a borehole visit records 1 bottle (+ optional duplicate
  bottle); a household visit records 2 bottles (transport container and
  storage container).
- Lab survey: membrane filtration, 100 mL, 101 = too numerous to count; 135
  rows additionally carry a laboratory-blank result (a sterile-water control
  run alongside the real samples to detect contamination in the lab).

The user asked to: (1) **strictly start** with cleaning the data and writing
the dictionary, (2) use tidyverse, (3) use `washr` + the guide, (4) read the
project site and `data-raw/README.md` for context, but **not trust the
existing code** in `data-raw/data_processing.R` (the committed version is the
capstone script; the working tree has it deleted back to the washr template).
Website/README/roxygen come after the dictionary is reviewed.

The user chose a **four-table tidy design**: borehole visits, household
visits, samples and lab blanks. Each observational unit gets its own table,
so household-level variables are not repeated per sample and no column is
empty by design for a whole class of rows.

**Every step ends with a commit** (via the `ghe-skills:commit` skill), as
the guide prescribes.

## Findings that drive the design (verified by profiling the raw files)

- **Join key** between files is `(district, incubation-start date, bottle
  number)`. Bottle numbers restart every sampling day. Exact match: 2355 of
  2660 in-window lab rows match a field record (2332 unique, 23 match two
  field rows); 305 lab rows have no field record (mostly Luuka Nov 2024,
  before field surveys started there); 365 field samples have no lab row.
  In the lab file, 73 keys occur twice (147 rows); these are mostly two
  different plates (different dish and count) that were given the same
  bottle number. A +/-1 day tolerance only creates false matches, so exact
  date match is correct (as the capstone did).
- **Four lab results were submitted twice** within minutes (identical
  district, dates, bottle, dish and count), three times in order to add a
  laboratory blank. One submission is kept, preferring the one with the
  blank.
- **The capstone code swapped two bottle columns**: it named the question
  "Take a sample from the transportation container" `storage_num` and the
  storage-container question `tp_num`. Our assignment follows the question
  text, so the capstone's Table 1 labels for storage and transport are
  reversed relative to this package. Flag in README.
- **District spelling differs by file**: field uses `Kaabong`, `Luuka`; lab
  uses `Kaboong`, `Kamuli`. Region to district is 1:1 in this study, so the
  lab's region reliably gives the district. Lab also has 13 rows with
  multi-select garbage ("Kaboong, Nakaseke", "Busoga Region, Central Region,
  Teso Region") and 3 NA districts, all resolvable from the region/district
  combination. The capstone mapped Busoga to Kamuli; the field survey and the
  project abstract say **Luuka**, so **Luuka** is used (assumption, flagged
  in README).
- **Pre-study rows**: 35 field rows (30-31 Oct 2024, no region/survey type)
  and 19 lab rows before 1 Nov 2024 are pilot/training rows and are dropped
  (the capstone did the same via a date filter).
- **Lab blanks**: "Is this a laboratory blank? = Yes" rows (135, 134 in the
  study window) contain *both* a blank result (own dish number + colony
  count, mostly 0) and a normal sample result. They are not separate rows,
  so the blank info is split off into its own table and the sample result
  stays in `samples`.
- **Colony count**: the form says enter 101 for >100, but 101-200 appear
  (28 x 200). The "re-enter" field disagrees in 354 rows, almost all 101 vs
  200 (both mean TNTC). Decision: keep the recorded count, add logical `tntc`
  (`> 100`), drop the re-entry column, document.
- **Volume**: 100 mL for all but one row, where "Other" was selected with
  no value; that row stays NA. A note "only 50 mL analysed" sits on a
  different row that recorded 100 mL; the recorded value is kept and the
  note remains visible in `lab_notes`.
- **Incubation start**: one typo year 2034, corrected to 2024. The result
  reading datetime is normally incubation + 1 day; about 25 rows have odd
  gaps and are left as recorded.
- **Dish numbers**: some junk (88888, 8888888). Kept as recorded (lab
  bookkeeping), documented.
- **Storage container** "Other (please specify)" free text is recoded to
  `Drum` (Plastic drum/DRUM/Big dram/Small drum), `Bucket` (Bucket/Backet/
  BUCKET/Big bucket/Cylinder/Cylinder bucket) and `Pot` (POT). Transport
  container "Other" takes the specify text (Quad, Watering can, Bucket,
  Water bottle, Jerrycan and watering can). The capstone mapped
  "PLASTIC DRUM" to Bucket (an error); not reproduced. The recode must
  keep NA as NA (borehole visits have no container fields).
- **Source/borehole names**: heavy case/spelling variation (Akalabai
  Okengo/okengo, Moruese/Moru-ese, Ojie TC/Tc/tc, St Marys Chapel variants).
  Decision: `str_squish()` + `str_to_title()` + an explicit recode list of
  about 60 obvious within-district variants. Junk values ("Dff", "Good",
  "02", "20", "Ka", an enumerator name) become NA.
- **Taste/smell/colour** are free text, present on borehole visits only.
  Whitespace/case normalised and obvious typos fixed (Notbad, Odourkess,
  Cclear, Tastless, ...), keyboard noise set to NA; no semantic recoding.
- **Cleaning frequency** columns are numeric "how often" with values like
  1, 3, 7, 14, 30 (days); -3 becomes NA. Days water is kept in the transport
  container ranges 1-11.
- **Personal/metadata columns dropped**: enumerator, sampler/tester names,
  IP address, photo URLs, mWater bookkeeping (Deployment, Status, Response
  Code, Drafted/Submitted/Modified, Approval, Rejection, Edits, Draft Name),
  `HH_ID` (all NA), "please specify volume" (all NA).
- `washr` installed is 1.0.2 (CRAN); the guide targets >= 1.1.0
  (`setup_ci()`, `update_metadata()`, `use_brand()` exist only on GitHub
  `openwashdata/washr`, v1.1.1). Not needed for phase 1; install from GitHub
  before the documentation/website phase.

## Output datasets (four-table tidy design)

Observational units: a **borehole visit** (one survey submission at a water
source), a **household visit** (one survey submission at a household), a
**sample** (one bottle of water, whether or not it was analysed), and a
**laboratory blank** (one sterile-water control). One table each. All
column names are snake_case.

`visit_id` is a single id space shared by both visit tables: ids are
assigned over all field submissions sorted by district, date and submission
time, so no id occurs in both tables. `samples$visit_id` therefore points
to exactly one row in one of the two visit tables, and `sample_type` says
which table that is. `samples |> left_join(household_visits, by =
"visit_id")` works directly; borehole samples simply get NAs.

**1. `borehole_visits`**: one row per borehole visit, about 477 rows.

| column                        | type | meaning                             |
|-------------------------------|------|-------------------------------------|
| `visit_id`                    | int  | key (shared id space, see above)    |
| `date_sampled`                | Date | field sampling date                 |
| `region`, `district`          | chr  | harmonised, 4 pairs                 |
| `community`                   | chr  | field, title case                   |
| `source_name`                 | chr  | borehole sampled, harmonised        |
| `water_taste`, `water_smell`  | chr  | community member's remarks          |
| `water_colour`                | chr  | enumerator's description            |

**2. `household_visits`**: one row per household visit, about 1118 rows.

| column                        | type | meaning                             |
|-------------------------------|------|-------------------------------------|
| `visit_id`                    | int  | key (shared id space)               |
| `date_sampled`                | Date | field sampling date                 |
| `region`, `district`          | chr  | harmonised, 4 pairs                 |
| `community`                   | chr  | field, title case                   |
| `source_name`                 | chr  | borehole the household uses,        |
|                               |      | harmonised                          |
| `storage_container`           | chr  | Pot / Sauce pan / Jerry can / Drum  |
|                               |      | / Bucket                            |
| `transport_container`         | chr  | Jerry can / Bucket / Quad / ...     |
| `days_in_transport_container` | dbl  | reported by household               |
| `boils_water`                 | lgl  |                                     |
| `storage_cleaning_days`,      | dbl  | reported cleaning interval (unit    |
| `transport_cleaning_days`     |      | assumed days)                       |
| `storage_cleaning_method`,    | chr  | free text                           |
| `transport_cleaning_method`   |      |                                     |

No `survey_type` column: the table itself carries that information.

**3. `samples`**: one row per bottle. Union of the field bottles (2744:
477 borehole, 31 borehole duplicate, 1118 transport, 1118 storage) and the
lab results, matched on `(district, date, bottle_number)`. Field bottles
without a lab result keep NA result columns; lab results without a field
record keep NA `visit_id` and `sample_type`.

| column                   | type   | meaning                               |
|--------------------------|--------|---------------------------------------|
| `sample_id`              | int    | key                                   |
| `visit_id`               | int    | foreign key to `borehole_visits` or   |
|                          |        | `household_visits` (by sample_type);  |
|                          |        | NA when no field record               |
| `region`, `district`     | chr    | harmonised; part of the join key, so  |
|                          |        | kept here                             |
| `date_sampled`           | Date   | field date, or lab incubation date    |
|                          |        | for lab-only rows                     |
| `sample_type`            | chr    | `borehole`, `borehole_duplicate`,     |
|                          |        | `transport_container`,                |
|                          |        | `storage_container`, NA if unknown    |
| `bottle_number`          | int    | bottle label, restarts daily          |
| `date_incubation`        | Date   | lab: incubation start                 |
| `date_result`            | Date   | lab: colonies read                    |
| `petri_dish_number`      | chr    | lab bookkeeping, as recorded          |
| `ecoli_cfu`              | dbl    | colonies on the filter; 101 = TNTC    |
| `tntc`                   | lgl    | `ecoli_cfu > 100`                     |
| `volume_ml`              | dbl    | 100 (one row NA)                      |
| `contamination_category` | factor | ordered, 5 project levels (below)     |
| `lab_notes`              | chr    | lab free text                         |
| `match_status`           | chr    | `matched`, `no lab result`,           |
|                          |        | `no field record`, `ambiguous key`    |

Contamination levels (from the project): Safe (0), Slightly contaminated
(1-10), Moderately contaminated (11-50), Highly contaminated (51-100),
Unsafe (>100).

Matching rule: a field bottle and a lab result are linked only when the key
is unique on **both** sides (one field bottle, one lab result). Keys that
occur twice on either side are **not** linked: both sides stay as separate
rows with `match_status = "ambiguous key"`, so no result is double counted
and no guess is made. Expected counts after the duplicate-submission
clean-up: 2187 matched, 443 no lab result, 295 no field record, 278
ambiguous key (3203 rows). The README reports these counts.

**4. `labblanks`**: one row per laboratory blank (134): `blank_id`,
`date_incubation`, `date_result`, `region`, `district`,
`petri_dish_number`, `ecoli_cfu`.

## Implementation steps (phase 1), one commit each

0. **Commit the plan** together with the two pre-existing uncommitted
   changes (processing script reset to the washr template, raw-data
   README). Message along the lines of "Add phase 1 plan".
1. **`data-raw/data_processing.R`**: rewrite the Tidy-data section (keep the
   washr template header and export block). tidyverse + readxl + janitor
   only. Structure:
   - read both xlsx files, `clean_names()`, `rename()` to short names,
     `filter()` to dates >= 2024-11-01;
   - field: recode region/district, harmonise containers (NA stays NA),
     sources and sensory text; `arrange()` and assign `visit_id` over all
     submissions; split into `borehole_visits` (survey type borehole, source
     and sensory columns) and `household_visits` (survey type household,
     container and practice columns); `pivot_longer()` the 4 bottle columns
     into `sample_type` + `bottle_number`, drop NA bottles, giving the field
     side of `samples`;
   - lab: fix the 2034 year, derive district from region, add `tntc` and
     `volume_ml`; drop exact duplicate submissions (keep the one with the
     blank); split blank columns into `labblanks`;
   - matching: count key occurrences on each side, link only unique-unique
     pairs with an `inner_join()` on `district`, date and `bottle_number`
     (`relationship = "one-to-one"`), bind the unmatched rows of both sides,
     set `match_status`, derive `contamination_category`, `arrange()`, add
     `sample_id`, `relocate()`;
   - sanity checks with `stopifnot()` (see Verification);
   - export the four objects with `usethis::use_data()` and to
     `inst/extdata/<name>.csv` and `.xlsx` (template block, looped over the
     four names).
   - Lookup tables (source-name recodes, sensory typos) live inline as a
     `tribble()` / named vector so the script is self-contained.
   Run the script, then **commit** the script, `data/`, `inst/extdata/` and
   the DESCRIPTION lines that `use_data()` adds (`Depends`, `LazyData`).
2. **`data-raw/dictionary.csv`**: `washr::setup_dictionary()` (needs `data/`
   to exist), then fill every `description` (units, allowed values, NA
   meaning, TNTC convention, key relationships, assumptions). The
   descriptions live in a `tribble()` in a final "Dictionary" section of
   `data_processing.R`, which creates the CSV if absent and fills only empty
   description cells, so later manual edits to the CSV are kept. Run,
   then **commit** the dictionary and the script change.
3. Nothing else is touched in phase 1 (README, `R/` docs are phase 2).

## Later phases (after you review the dictionary; not executed now)

- Install `washr` >= 1.1 from GitHub; `setup_roxygen()`, then write titles
  in `R/borehole_visits.R`, `R/household_visits.R`, `R/samples.R` and
  `R/labblanks.R`; `devtools::document()` and `devtools::check()`. Commit.
- DESCRIPTION: title, description, authors (Cecilia Nansiimbi as `aut` with
  ORCID 0009-0006-9788-9732; your role, `cre`?, to confirm),
  `update_description()`, `X-schema.org-*` keywords/coverage (`Uganda`,
  `2024-11-01/2025-09-16`), `update_metadata()`. Commit.
- `setup_readme()`: README with project context, the four-table structure
  and the join example, limitations (unmatched and ambiguous rows, TNTC,
  Luuka/Kamuli, the capstone's swapped storage/transport labels), example
  plot; then `setup_website()`, `use_brand()`, `setup_ci()`,
  `update_citation()`. One commit per step.

## Verification

- `Rscript data-raw/data_processing.R` runs end to end without warnings.
  `stopifnot()` checks: `visit_id` unique across `borehole_visits` and
  `household_visits` combined; every non-NA `visit_id` in `samples` exists
  in exactly one of the two visit tables, and the table agrees with
  `sample_type`; no NA `district`, `date_sampled` or `bottle_number` in
  `samples`; `sample_type` NA only when `visit_id` is NA; `ecoli_cfu` >= 0;
  `contamination_category` non-NA wherever `ecoli_cfu` is non-NA; each lab
  result and each field bottle appears in exactly one `samples` row; no
  all-NA columns in either visit table.
- Row-count reconciliation printed: `borehole_visits` 477,
  `household_visits` 1118, `samples` 3203 with `count(match_status)` equal
  to the expected counts above, `labblanks` 134.
- `dictionary.csv` has one row per column of each of the four datasets and
  no empty descriptions; the `inst/extdata` CSV files round-trip through
  `readr::read_csv()`.
- Compare category counts per `sample_type` against the capstone's Table 1
  with its storage and transport labels exchanged (capstone "Storage"
  188/144/114/62/465 corresponds to our transport container, capstone
  "Transport" 183/97/128/51/510 to our storage container; Borehole
  112/116/61/26/91). Differences come from the stricter ambiguous-key
  handling and the duplicate-submission clean-up.
