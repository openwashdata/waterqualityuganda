# Text column normalisation report

Date: 2026-10-23
Scope: the four exported datasets (`borehole_visits`, `household_visits`,
`labblanks`, `samples`), every `character` or `factor` column.
Method: frequency tables, whitespace/case/punctuation checks, near-duplicate
detection within district (Levenshtein distance ≤ 2 and punctuation-insensitive
keys), token frequencies for free-text columns.

This is a report of *possible* normalisations. Nothing has been changed. Each
suggestion is tagged:

- **safe** – mechanical, no judgement needed (whitespace, punctuation, case,
  obvious typos).
- **recode** – adds a new derived column while keeping the original free text.
- **judgement** – merging names or categories that need a field-knowledge check
  before applying.

## Columns that are already clean (all tables)

| Column | Tables | State |
|---|---|---|
| `region` | all four | 4 levels, consistent spelling, 1:1 with `district`. |
| `district` | all four | 4 levels, consistent spelling. |
| `sample_type` | samples | 5 snake_case levels, no variants. |
| `match_status` | samples | 4 levels, no variants. |
| `contamination_category` | samples | ordered factor, 5 levels. |
| `storage_container` | household_visits | 5 levels, clean. |

Minor option for `region`: the suffix " Region" is redundant with the column
name; `Central`, `Karamoja`, `Teso`, `Busoga` would be shorter. Purely cosmetic
(**judgement**, low value).

---

## 1. `borehole_visits` (477 rows)

### 1.1 `community` (203 distinct)

Already title-cased. Remaining issues are spelling and abbreviation variants of
the same place, visible within district:

| District | Variants found | Suggested canonical |
|---|---|---|
| Kaabong | `Moru-Ese`, `Moruese` | `Moruese` (dominant form) |
| Kaabong | `Natumugarae`, `Narumugarae` | `Natumugarae` |
| Kaabong | `Tulyenyang`, `Tulenyang` | `Tulyenyang` |
| Kaabong | `St Marys Chapel`, `St Marys Chalel` | `St Marys Chapel` |
| Kaabong | `Nakasowan`, `Nakosowan`, `Nakosowan 1` | needs check: numbered variant may be a distinct sub-village |
| Kaabong | `Lopelpel`, `Lopelipel`; `Yerun`, `Yaruun` | needs check |
| Luuka | `Ikonia Bufumba A`, `Ikonia Bufumbaa`, `Ikonia Bafumba`, `Ikonia Bafumba A` | `Ikonia Bufumba A` |
| Luuka | `Irongo Sub C`, `Irongo Subc`, `Irongo Sub / C`, `Irongo`, `Irongoc` | `Irongo Sub County` (or `Irongo`) |
| Luuka | `Kibinga Tc`, `Kibinga T/C`, `Kibinga A` | `Kibinga Tc`; `Kibinga A` may be distinct |
| Luuka | `Budhuba A Mosque`, `Budhuaba. A Mosque`, `Budhuuba A Mosque`, `Budhuuba Mosque`, `Budhuba A . Tc` | `Budhuba A` |
| Luuka | `Modern Times Ps`, `Modern Time Ps` | `Modern Times Ps` |
| Luuka | `Nsima`, `Nsiima`; `Nawanyago Bagole`, `Nawanyago Bugole`; `Luzinga Park`, `Lizlnga Park` | dominant spelling |
| Nakaseke | `Namasinda 1`, `Namasinda1` | `Namasinda 1` |
| Nakaseke | `Naluvule T.c`, `Naluvule Tc` | `Naluvule Tc` |
| Nakaseke | `Kakoola Kivumu`, `Kakoola Kivmu`; `Nakazzi Lugo`, `Nakazi Lugo`; `Bulamazzi`, `Bilamazzi`; `Nakitembe`, `Makitembe`; `Kituntu Kasangombe`, `Kitutu Kasangombe` | dominant spelling |
| Kumi | `Kakures. Kituba` | `Kakures Kituba` (stray period) |

Suggested normalisations:

1. **safe** – Standardise abbreviations and strip punctuation inside them:
   `T/C`, `T.c`, `T/ C` → `Tc`; `P/S`, `P/ S` → `Ps`; `Sub C`, `Subc`, `Sub / C`
   → `Sub County`; `C/ U` → `Cu` (Church of Uganda), `H/ C` → `Hc`, `Lc1` keep.
   Remove stray `.` and ` / `. Alternatively expand all of them (`Trading
   Centre`, `Primary School`, `Health Centre`) since the data are for public
   reuse and the abbreviations are Uganda-specific.
2. **safe** – Fix single-letter typos where one variant occurs once and the
   other many times (rows marked "dominant spelling").
3. **judgement** – Merge `Moru-Ese`/`Moruese`, the `Ikonia Bufumba` group, the
   `Irongo` group, the `Budhuba` group.
4. **judgement** – Numbered or lettered suffixes (`Namasinda 1`/`2`, `Nakosowan
   1`, `Kibinga A`, `Butemula A`, `Kifunfugu B`) look like distinct
   sub-communities; do not merge with the base name without confirmation.
5. **judgement** – Rows like `Papa 2 / St Marys Chapel` record two communities.
   Either keep as is and document, or split into a primary community and a note.

Since `community` also appears in `household_visits`, apply one lookup table
(district, raw → canonical) to both tables so the join on community stays
consistent.

### 1.2 `source_name` (201 distinct, 5 NA)

Spelling variants were already merged within district per the documentation, and
the near-duplicate scan confirms almost none remain. Remaining issues are naming
conventions rather than typos:

| Pattern | Examples | Suggestion |
|---|---|---|
| Facility type as suffix, abbreviated | `Kapolin Ps`, `Ojie Tc`, `Kyambogo Lc1`, `Kamuli C/ U Ps Borehole`, `Kikamulo H/ C`, `Kadunda P/ S` | **safe**: same abbreviation standardisation as `community` (`P/ S` → `Ps`, `C/ U` → `Cu`, `H/ C` → `Hc`, `C/ O` → check meaning) |
| Word "Borehole" sometimes included | `Lumpewe Borehole`, `Kiruuli Borehole`, `Christina Borehole`, `Namusisi Borehole Kitutu` (14 in Nakaseke) | **judgement**: drop the word `Borehole` since every source is a borehole, or keep because it distinguishes e.g. `Sakabusolo Borehole` from `Sakabusolo 2` |
| Facility type as a word | `Kakamar Primary School`, `Narube Primary School`, `Kamuli Mosque`, `Martyrs Church`, `Annie's Well` | **judgement**: either keep words or abbreviate consistently with `Ps`, `Tc`; pick one convention |
| Lettered / numbered duplicates | `Kibaale A`/`Kibaale Tc`, `Kifunfugu A`/`B`, `Namasujju A`/`B`, `Namasinda 1`/`2`/`A`/`Namasinda` | **judgement**: `Namasinda A` vs `Namasinda 1`/`2` and bare `Namasinda` are suspicious; confirm which borehole each refers to |
| Apostrophe | `Annie's Well` | **safe**: keep, but ensure consistent straight apostrophe |

Possible **recode**: add `source_type` (borehole at school, trading centre,
church, mosque, health centre, community) parsed from the suffix. This keeps
`source_name` as a label and gives an analysable category.

### 1.3 `water_taste`, `water_smell`, `water_colour`

Distinct values: 19 (2 NA), 18 (1 NA) and 18 (59 NA) respectively.

The documentation states "no semantic recoding", so the raw text should stay.
The useful normalisation is a derived categorical column per variable
(**recode**):

`water_taste` → `taste_category` with levels `no complaint`, `salty`, `other`:

| Raw values | Category |
|---|---|
| `Not bad`, `Good`, `Tasteless`, `Taste good`, `Fine`, `Good taste`, `Has no problem`, `No bad taste`, `No problem`, `Okay`, `Has no bad taste`, `It has no problem`, `No problem noted` | `no complaint` (467 rows) |
| `Salty`, `Salty water` | `salty` (4) |
| `Changed taste in this rainny season`, `Good- little water in dry season`, `Water drops after several strokes` | `other` / keep remark (3) |

`water_smell` → `smell_category` with `no complaint` (`Not bad`, `No smell`,
`Odourless`, `Good`, `Fine`, `No bad smell`, `Good smell`, `Smells good`,
`Okay`, `Has no bad smell`, `Has no problem`, `No problem noted`), `slight
smell` (`Slightly smelly`, `Slightly smelling`, `Mild smell`), `bad smell` (`Not
good`). Note `Colourless` (1 row) is a smell answer that is actually a colour
remark: flag or set NA.

`water_colour` → `colour_category` with `clear` (`Clear`, `Colourless`,
`Colourless water`, `Colourless sample`, `Colourless water sample`, `It is
colour less`, `Colourless no69`, `Good`), `discoloured` (`Brownish.`, `Whitish`,
`Not pure`, the four `redish`/`greenish` time-of-day remarks), `other` (`Not
bad`). `Colourless no69` contains a stray bottle number and `Brownish.` a
trailing period (**safe** fixes to the raw text as well).

Also **safe**: typos `rainny` → `rainy`, `redish` → `reddish`, `it's` → `its`
are consistent with the "obvious typos normalised" rule already applied.

---

## 2. `household_visits` (1118 rows)

### 2.1 `community` (135 distinct) and `source_name` (112 distinct, 2 NA)

Same findings and the same lookup table as section 1.1 and 1.2.
Household-specific additions:

- `source_name` contains compound values with a slash: `Peikale/ Tulyenyang`,
  `People/ Tulyenyang`, `Nachukul/ Tulyenyang`, `Papa 2/ St Marys Chapel`. These
  are households whose own borehole was broken and who fetched from another (the
  lab notes confirm this for Tulyenyang). **judgement**: either keep the source
  actually sampled (second name) in `source_name` and move the home community to
  `community`, or keep as is and document. `People/ Tulyenyang` is a typo for
  `Peikale/ Tulyenyang` (**safe**).
- `Kibinga T/ C`, `Kiklbinga T/ C` → `Kibinga Tc` (**safe**).
- `Irongo Subcounty` vs `Irongo Sub C` in the community column: unify.
- Twelve household source names have no matching borehole visit in the same
  district (`Lokuriana Martha`, `Kasangombe Semagulu`, bare `Mizimbo`,
  `Namasinda`, `Kasangombe`, …). After normalisation re-run this anti-join; the
  leftovers are either genuinely unsampled sources or remaining spelling
  variants.

### 2.2 `transport_container` (6 distinct)

| Raw | Issue | Suggestion |
|---|---|---|
| `Jerry can` (1108) vs `Jerrycan and watering can` (1) | `Jerry can` and `Jerrycan` spelled differently inside the same column | **safe**: `Jerry can and watering can` |
| `Quad` (3) | unclear meaning (probably a local container name) | document in dictionary |

Both container columns use sentence case (`Jerry can`, `Sauce pan`). Fine; just
be consistent across tables (`samples$sample_type` uses snake_case
`transport_container`, which is a different column so acceptable).

### 2.3 `storage_cleaning_method` and `transport_cleaning_method`

Distinct values: 335 and 325 respectively.

These are the columns with the most normalisation potential. The free text is a
list of materials written in many ways:

| Check | storage | transport |
|---|---|---|
| Trailing period | 220 | 83 |
| Space before comma (`Steelwire ,soap`) | 37 | 119 |
| Comma without following space (`Steelwire,soap`) | 57 | 247 |
| Starts with a verb phrase (`Use`, `Using`, `They use`, `Rinse`, `Wash…`) | 156 | 38 |
| Distinct raw values | 335 | 325 |
| Distinct after lower-case, strip punctuation, squish | 269 | 239 |
| Distinct after reducing to a sorted bag of material words | 143 | 145 |

Recurrent spelling variants of the same material:

| Canonical | Variants seen |
|---|---|
| polythene bag | `polythen bag`, `polythene bag`, `polythenebag`, `polythen`, `polythene`, `polythen bage`, `polythrn`, `ploythen bage`, `polithen bag`, `piece of polythene bag` |
| steel wire | `steelwire`, `steel wire`, `stewire` |
| soap | `soap`, `saop` |
| dishwasher (dish soap) | `dish washer`, `dishwasher`, `dish washer`; note Ugandan usage means a washing-up detergent, not an appliance |
| small stones / gravel | `smallstones`, `small stones`, `small tones`, `gravel`, `gavel`, `murram`, `murram stones`, `small soil particles` |
| cavera (plastic bag, Luganda) | `camera`, `cavera`, `acavera`, `an old camera` – `camera` is a mis-hearing of `cavera`, which is itself a polythene bag |
| leaves | `leaves`, `mango leaves`, `banana leaves`, `dry banana leaves`, `bitter leaves`, `lemon grass`, `grass`, `lea6`, `leave` |
| banana peels | `banana peelings`, `banana peels` |
| water | `water`, `watef`, `clean water`, `plain water`, `water only`, `andwater` |
| net | `small net`, `net` |
| arches (ashes) | `arches`, `ashes`, `ash` |
| smoking | `smoking`, `smoke` (treating the pot with smoke, a method not a material) |
| sun drying | `sun dry`, `sun drying`, `dry sun`, `dried` |

Suggested normalisations, in increasing ambition:

1. **safe** – Punctuation: drop trailing periods, normalise `, ` spacing, remove
   doubled commas (`soap,,and sand`), remove `and,`. Fix unambiguous typos
   (`saop`, `watef`, `polythrn`, `ploythen`, `gavel`, `small tones`, `stewire`,
   `lea6`). This alone drops distinct values from 335/325 to roughly 270/240.
2. **safe** – Collapse compound-word variants: `steelwire` → `steel wire`,
   `polythenebag` → `polythene bag`, `smallstones` → `small stones`, `dish
   washer` → `dishwasher`.
3. **recode** (recommended) – Add boolean indicator columns, one per
   material/method, parsed from the normalised text, leaving the free text
   untouched:
   - `clean_water` (always true unless only smoking/drying is mentioned)
   - `clean_soap` (soap, dishwasher)
   - `clean_abrasive` (sand, gravel, small stones, murram, soil particles,
     ashes)
   - `clean_scrubber` (steel wire, sponge, net, polythene bag / cavera, leaves,
     banana peels, grass)
   - `clean_smoking` (smoking with banana leaves or peels)
   - `clean_sun_drying`
   This gives 6 analysable columns instead of 335 strings, is reversible, and
avoids forcing one label on a multi-material answer. A finer split (leaves vs
polythene vs steel wire) is possible if the distinction matters.
4. **recode** alternative – A single `cleaning_method_category` factor built
   from the bag-of-words key (`water only`, `water + soap`, `water + scrubber`,
   `water + soap + scrubber`, `water + abrasive`, `water + soap + abrasive`,
   `smoking`, `other`). Simpler but loses detail; the indicator approach above
   is preferable.
5. **judgement** – Non-answers: `The same method` (1 row, refers to the previous
   column) should be replaced by the storage value or set NA. `Water` alone vs
   `Water only` vs `Rinse with clean water` are the same method and can share
   one normalised string if the free text is rewritten rather than only derived
   from.

---

## 3. `labblanks` (134 rows)

### 3.1 `petri_dish_number` (54 distinct)

| Format | Count | Examples |
|---|---|---|
| `B` + number | 40 | `B1`, `B2`, …, `B12`, `B42` |
| Bare `B` | 22 | `B` |
| Integer | 68 | `2`, `50`, `13`, `150` |
| Zero-padded integer | 4 | `02`, `06` |

Suggestions:

- **safe** – Strip leading zeros (`02` → `2`, `06` → `6`) so the same dish is
  not two labels.
- **judgement** – The `B`-prefix marks "blank" and the integer labels are dish
  positions. Either keep the column as a free label (documented, which it
  already is) or split into `petri_dish_label` (character, as written) and
  `petri_dish_index` (integer, NA for bare `B`). The second helps anyone
  matching blanks to samples by dish number.
- Keep as character; the mixed content means it should not be coerced.

---

## 4. `samples` (3203 rows)

### 4.1 `petri_dish_number` (113 distinct, 557 NA)

All non-NA values are digit strings; one is `0`. Values include placeholders
`88888`, `99999`, `8888888`, and probably `888`, `1204`, `800`, `720`, `551`,
`544`, `400`, `300`, `200` (plausible maximum of real dish numbers is around 200
per the labblanks table and the mode of the distribution).

Suggestions:

- **safe** – Convert to integer; nothing is lost since no letters appear here.
  Document that labblanks keeps a character label because of the `B` prefix, or
  convert labblanks to the two-column form above so both tables agree.
- **recode** – Set the placeholder values (`88888`, `99999`, `8888888`) to NA
  and add `petri_dish_placeholder` (logical) or extend the existing dictionary
  note. Whether `888`, `1204` etc. are placeholders needs a laboratory check
  (**judgement**).

### 4.2 `lab_notes` (62 distinct, 3124 NA)

Genuine free text; most values are unique. Do not rewrite the text, but:

- **safe** – Fix obvious typos: `magot`/`magots` → `maggot(s)`, `micto` →
  `micro`, `visibke` → `visible`, `cilonies` → `colonies`, `squre` → `square`,
  `coverrd` → `covered`, `cottong` → `cotton`, `ver deve…` → check. Remove
  trailing period on `Filter paper was attached to the lid.` for consistency
  with the other notes.
- **safe** – `ecoli` → `E. coli` for consistency with column documentation.
- **recode** (recommended) – Add `lab_note_type`, a factor derived by keyword,
  since the notes fall into a small number of themes:

| Theme | Keyword rule | Example values | n |
|---|---|---|---|
| `sample_origin` | `Household`, `Source`, `Pot from HH`, `Jerrycan from HH`, `Alternative` | `Household`, `Household sample`, `Source`, `From pot of HH3` | ~25 |
| `qa_blank_or_duplicate` | `blank`, `Duplicate`, `validation` | `Field blank`, `Lab blank 2`, `Duplicate sample, bottle 14 and 13` | 6 |
| `counting_method` | `squares`, `square boxes`, `square units`, `colonies visible`, `micro colonies` | `15 squares covered by the yellow ecoli presentation` | ~22 |
| `same_day_collection` | `same day` | `Household fetched water the same day of monitoring` | 6 |
| `contamination_observation` | `maggot`, `dirty`, `pink`, `flooded` | `Visible maggot`, `Showing different bacteria in pink` | ~8 |
| `procedure_deviation` | `interrupted`, `50mls`, `attached to the lid`, `repair`, `chlorinated`, `Unclear` | `Only 50mls was analysed` | ~6 |

- **recode** – The `squares covered` notes encode an alternative count (the
  technician counted grid squares instead of colonies). A `squares_covered`
  integer column extracted with a regex (`^(\d+) squares?`) would make these 10
  or so rows analysable and flag that their `ecoli_cfu` is an approximation.
- **recode** – `Only 50mls was analysed` contradicts `volume_ml` = 100 for that
  row if it was recorded so; check and correct `volume_ml` to 50.

---

## Summary of recommended actions

| Priority | Action | Tables | Type |
|---|---|---|---|
| 1 | One lookup table for `community` and `source_name` abbreviations and typos, applied to both visit tables | borehole_visits, household_visits | safe + judgement |
| 2 | Punctuation and typo clean-up of both cleaning-method columns, then boolean indicator columns per material/method | household_visits | safe + recode |
| 3 | Derived `taste_category`, `smell_category`, `colour_category` | borehole_visits | recode |
| 4 | `petri_dish_number`: strip leading zeros in labblanks, integer plus placeholder flag in samples | labblanks, samples | safe + recode |
| 5 | `lab_notes`: typo fixes and `lab_note_type` | samples | safe + recode |
| 6 | `Jerry can and watering can`; resolve slash-separated source names | household_visits | safe + judgement |

Every **recode** item keeps the original free-text column, so the dictionary
entries that promise "no semantic recoding" stay true, and the derived columns
get their own dictionary rows.

