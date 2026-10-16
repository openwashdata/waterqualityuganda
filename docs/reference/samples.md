# samples: Water samples and their E. coli results

One row per water sample (bottle) collected during the monthly
monitoring of drinking water quality from borehole sources to household
storage in four Ugandan districts (Nakaseke, Kaabong, Kumi and Luuka),
November 2024 to September 2025. Samples were taken at the borehole
outlet, from the container used to carry water home (usually a jerrycan)
and from the household drinking water storage container, and analysed
for E. coli by membrane filtration of 100 mL. Each row links to the
field visit it belongs to through `visit_id` (see
[borehole_visits](https://openwashdata.github.io/waterqualityuganda/reference/borehole_visits.md)
and
[household_visits](https://openwashdata.github.io/waterqualityuganda/reference/household_visits.md)).
Field records and laboratory results were matched on district, date and
bottle number; `match_status` documents the outcome.

## Usage

``` r
samples
```

## Format

A tibble with 3203 rows and 16 variables

- sample_id:

  Unique identifier of the water sample (one bottle). Integer.

- visit_id:

  Identifier of the field visit during which the sample was collected.
  Links to borehole_visits\$visit_id for sample_type 'borehole' and
  'borehole_duplicate', and to household_visits\$visit_id for
  'transport_container' and 'storage_container'. NA when a laboratory
  result could not be linked to a field record (see match_status).

- region:

  Region of Uganda where the sample was collected: Central Region,
  Karamoja Region, Teso Region or Busoga Region.

- district:

  District where the sample was collected: Nakaseke, Kaabong, Kumi or
  Luuka. The laboratory form used the spellings 'Kaboong' and 'Kamuli'
  for the last two; these were harmonised to the field survey spelling.

- date_sampled:

  Date the sample was collected (YYYY-MM-DD). For laboratory results
  without a field record this is the incubation start date, which in
  this study is the sampling date.

- sample_type:

  What was sampled: 'borehole' (water from the borehole outlet),
  'borehole_duplicate' (second bottle from the same borehole taken for
  quality assurance), 'transport_container' (water from the container
  used to carry water from the borehole to the household),
  'storage_container' (water from the household drinking water storage
  container). NA when the laboratory result has no field record.

- bottle_number:

  Number written on the sample bottle in the field and read by the
  laboratory. Numbering restarts every sampling day, so it identifies a
  sample only together with district and date_sampled.

- date_incubation:

  Date on which the sample was filtered (membrane filtration) and
  incubation started. NA when no laboratory result is linked.

- date_result:

  Date on which the colonies were counted and the laboratory form was
  submitted, normally the day after date_incubation (18-24 h
  incubation). NA when no laboratory result is linked.

- petri_dish_number:

  Petri dish label used by the laboratory for this sample, as recorded.
  Some entries are placeholder values (e.g. 88888). NA when no
  laboratory result is linked.

- ecoli_cfu:

  Number of E. coli colonies (colony forming units) counted on the
  membrane filter after incubating volume_ml of sample. The laboratory
  was instructed to enter 101 when more than 100 colonies were present
  (too numerous to count); a few values above 101 were recorded as
  typed. NA when no laboratory result is linked.

- tntc:

  TRUE when ecoli_cfu is greater than 100, meaning the plate was too
  numerous to count and ecoli_cfu is a censored value rather than an
  exact count. NA when no laboratory result is linked.

- volume_ml:

  Volume of sample water filtered, in millilitres. 100 mL for every
  analysed sample except one, where 'Other' was selected without a value
  (NA). NA when no laboratory result is linked.

- contamination_category:

  Contamination level derived from ecoli_cfu with the thresholds used in
  the project: Safe (0), Slightly contaminated (1-10), Moderately
  contaminated (11-50), Highly contaminated (51-100), Unsafe (more than
  100). Ordered factor. NA when no laboratory result is linked.

- lab_notes:

  Free-text notes written by the laboratory technician about the sample
  (e.g. field blank, duplicate sample, visible maggots, interrupted
  incubation).

- match_status:

  How the field record and the laboratory result were linked on
  district, date and bottle number: 'matched' (exactly one field bottle
  and one laboratory result share the key), 'no lab result' (field
  bottle without a laboratory result), 'no field record' (laboratory
  result without a field record), 'ambiguous key' (the key occurs more
  than once in the field or the laboratory data, so the rows were
  deliberately not linked and remain separate).

## Source

Maji Health / Whave Solutions Limited monitoring programme, field and
laboratory surveys collected with mWater. Data provided by Cecilia
Nansiimbi.
