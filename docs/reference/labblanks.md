# labblanks: Laboratory blanks run alongside the water samples

One row per laboratory blank: a sterile-water control that the
laboratory filtered and incubated in the same session as the field
samples in
[samples](https://openwashdata.github.io/waterqualityuganda/reference/samples.md),
to detect contamination introduced by the laboratory procedure itself. A
blank with zero colonies supports the validity of that session's
results.

## Usage

``` r
labblanks
```

## Format

A tibble with 134 rows and 7 variables

- blank_id:

  Unique identifier of the laboratory blank. Integer.

- date_incubation:

  Date on which the blank was filtered and incubation started.

- date_result:

  Date on which the colonies on the blank were counted and the
  laboratory form was submitted.

- region:

  Region of Uganda whose samples were analysed in the same laboratory
  session as the blank: Central Region, Karamoja Region, Teso Region or
  Busoga Region.

- district:

  District whose samples were analysed in the same laboratory session as
  the blank: Nakaseke, Kaabong, Kumi or Luuka.

- petri_dish_number:

  Petri dish label of the blank as written by the laboratory technician
  (e.g. 'B1', '12').

- ecoli_cfu:

  Number of E. coli colonies counted on the blank filter (sterile water
  processed like a sample, 100 mL). 0 indicates no contamination
  introduced by the laboratory procedure; 101 means more than 100
  colonies (too numerous to count).

## Source

Maji Health / Whave Solutions Limited monitoring programme, laboratory
survey collected with mWater. Data provided by Cecilia Nansiimbi.
