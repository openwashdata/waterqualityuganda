# borehole_visits: Field visits to borehole sources

One row per field visit to a borehole during the monthly monitoring of
drinking water quality in four Ugandan districts (Nakaseke, Kaabong,
Kumi and Luuka), November 2024 to September 2025. Each visit records
where the borehole is and a community member's remarks on the taste,
smell and colour of its water. The water sample(s) taken at the visit
are in
[samples](https://openwashdata.github.io/waterqualityuganda/reference/samples.md),
linked through `visit_id`.

## Usage

``` r
borehole_visits
```

## Format

A tibble with 477 rows and 9 variables

- visit_id:

  Unique identifier of the field visit (one survey submission). Integer,
  assigned over all field visits sorted by district, date and submission
  time, so no id occurs in both borehole_visits and household_visits.
  Key for samples\$visit_id.

- date_sampled:

  Date of the field visit and of sample collection (YYYY-MM-DD).

- region:

  Region of Uganda where the visit took place: Central Region, Karamoja
  Region, Teso Region or Busoga Region.

- district:

  District where the visit took place: Nakaseke (Central), Kaabong
  (Karamoja), Kumi (Teso) or Luuka (Busoga).

- community:

  Name of the community (village, parish or trading centre) where the
  visit took place, as entered by the enumerator and converted to title
  case.

- source_name:

  Name of the borehole sampled. Spelling variants were merged within
  each district; NA where the entry was not a source name.

- water_taste:

  Remark by a community member on the taste of the borehole water (free
  text; whitespace, case and obvious typos normalised, no semantic
  recoding).

- water_smell:

  Remark by a community member on the smell of the borehole water (free
  text; whitespace, case and obvious typos normalised, no semantic
  recoding).

- water_colour:

  Description of the colour of the sampled borehole water (free text;
  whitespace, case and obvious typos normalised, no semantic recoding).

## Source

Maji Health / Whave Solutions Limited monitoring programme, field survey
collected with mWater. Data provided by Cecilia Nansiimbi.
