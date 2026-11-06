# Community and source names not in the lookup table

Comparison of the cleaned field data (`field` in `data-raw/data_processing.R`,
1,595 visits) with `data-raw/Lookup table for community and source name.xlsx`.
Companion to `2026-11-02_lookup_table_comparison_report.md`.

## Method

- Each distinct `community` and `source_name` value in the field data was
  compared, **within the same district**, against both lookup columns
  (`Community Names` and `Source Names`).
- Comparison ignores case, spaces and punctuation.
- Spelling variants are excluded: a name is dropped when its edit distance to
  the closest lookup name is at most 20% of its length (e.g. `Nsima` vs
  `Nsiima`, `Tulenyang` vs `Tulyenyang`). A few borderline misspellings remain
  (`Yaruun`, `St Marys Chalel`, `Budhuuba A Mosque`).
- **Overlaps lookup name** marks names that contain, or are contained in, a
  lookup name (e.g. `Mugenyi` / `Mugenyi LC1`). These may be the same place
  written more or less fully rather than a new place.
- Visit counts are the number of borehole and household visits that use the
  name.

## Summary

### Sources

| District | Names | Single borehole visit only |
|---|---:|---:|
| Kaabong | 12 | 6 |
| Kumi | 1 | 0 |
| Luuka | 3 | 0 |
| Nakaseke | 96 | 90 |
| **Total** | **112** | **96** |

### Communities

| District | Names | Single borehole visit only |
|---|---:|---:|
| Kaabong | 18 | 7 |
| Kumi | 11 | 3 |
| Luuka | 8 | 1 |
| Nakaseke | 103 | 76 |
| **Total** | **140** | **87** |

### Observations

- Outside Nakaseke, missing sources are few and mostly longer forms of a lookup
  name (`Budhuba A Mosque`, `Orapada Omatakiria`, `Nabikuyi Dodovico`) or
  combined names in household visits (`Peikale/ Tulyenyang`).
  `St Marys Chapel` (Kaabong, 33 visits) is the largest single gap; the lookup
  only has `St Marys borehole`.
- In Nakaseke, 90 of the 96 missing sources were visited once, as a borehole,
  with no household visits. This looks like a one-off borehole survey that the
  lookup does not cover; to confirm with the data provider.
- Missing communities in Kumi are broader area names (`Atutur`, `Kanyum`,
  `Kamacha`, `Ongino`, `Nyero`), see section 4 of the comparison report.
- Some communities are people's names (`Jane Abonyo`, `Lokut Lucia`,
  `Naloto Maria`, `Nanzige Penina`, `Salongo Kasule`) or placeholders
  (`Nn`, `Good`).

## Sources not in the lookup

| District | Name in data | Borehole visits | Household visits | Overlaps lookup name |
|---|---|---:|---:|---|
| Kaabong | Kakamar Primary School | 1 | 0 |  |
| Kaabong | Kangingetei Kepak | 1 | 0 |  |
| Kaabong | Loit | 1 | 0 |  |
| Kaabong | Lokuriana Martha | 0 | 1 |  |
| Kaabong | Nachukul/ Tulyenyang | 0 | 2 | Nachukul |
| Kaabong | Namamutau | 1 | 0 |  |
| Kaabong | Narionomoru 2 | 1 | 0 |  |
| Kaabong | Narube Primary School | 1 | 0 | Narube |
| Kaabong | Papa 2/ St Marys Chapel | 0 | 4 | Papa 2 |
| Kaabong | Peikale/ Tulyenyang | 0 | 4 | Tulyenyang |
| Kaabong | People/ Tulyenyang | 0 | 1 | Tulyenyang |
| Kaabong | St Marys Chapel | 8 | 25 |  |
| Kumi | Orapada Omatakiria | 1 | 3 | Omatakiria |
| Luuka | Budhuba A Mosque | 3 | 7 | Budhuba A |
| Luuka | Irongo Subcounty | 0 | 6 |  |
| Luuka | Nabikuyi Dodovico | 1 | 3 | Nabikuyi |
| Nakaseke | Annie's Well | 1 | 0 |  |
| Nakaseke | Bambaga | 1 | 0 |  |
| Nakaseke | Bukalegye | 1 | 0 |  |
| Nakaseke | Bukatira Bagala | 1 | 0 |  |
| Nakaseke | Bukeeka P/ S | 1 | 0 |  |
| Nakaseke | Bukoto | 1 | 0 |  |
| Nakaseke | Bukuku | 2 | 0 |  |
| Nakaseke | Bulyake Gitta | 1 | 0 |  |
| Nakaseke | Butikwa Project | 1 | 0 |  |
| Nakaseke | Butonya Borehole | 1 | 0 |  |
| Nakaseke | Buwa | 1 | 0 |  |
| Nakaseke | Christina Borehole | 1 | 0 |  |
| Nakaseke | Kabbubu | 1 | 0 |  |
| Nakaseke | Kadunda P/ S | 1 | 0 |  |
| Nakaseke | Kagango Naguru | 1 | 0 |  |
| Nakaseke | Kalagala Bukokolo | 1 | 0 |  |
| Nakaseke | Kalagi Mulokole | 1 | 0 |  |
| Nakaseke | Kalege 1 | 1 | 0 |  |
| Nakaseke | Kalege Mulokole | 1 | 0 |  |
| Nakaseke | Kaloke Lc1 | 1 | 0 |  |
| Nakaseke | Kamuli C/ U Ps Borehole | 1 | 0 |  |
| Nakaseke | Kamuli Mosque | 1 | 0 |  |
| Nakaseke | Kasangombe | 0 | 1 | Kasangombe Police |
| Nakaseke | Kasiiso Mosque | 1 | 0 |  |
| Nakaseke | Katakala | 1 | 0 |  |
| Nakaseke | Katalekamese B | 1 | 0 |  |
| Nakaseke | Kawuku | 1 | 0 |  |
| Nakaseke | Kibaale A | 1 | 0 |  |
| Nakaseke | Kibira Dongo 2 | 1 | 0 |  |
| Nakaseke | Kibira Dongo Regina | 1 | 0 |  |
| Nakaseke | Kibubu | 1 | 0 |  |
| Nakaseke | Kigege C/ U | 1 | 0 |  |
| Nakaseke | Kijeebejo | 1 | 0 |  |
| Nakaseke | Kikamulo H/ C | 1 | 0 |  |
| Nakaseke | Kikandwa A | 1 | 0 |  |
| Nakaseke | Kikandwa Health Centre | 1 | 0 |  |
| Nakaseke | Kikumango | 1 | 0 |  |
| Nakaseke | Kikumango B | 1 | 0 |  |
| Nakaseke | Kikwata Lc1 | 1 | 0 |  |
| Nakaseke | Kikwata Tc | 1 | 0 |  |
| Nakaseke | Kirema | 1 | 0 |  |
| Nakaseke | Kirinya Borehole | 1 | 0 |  |
| Nakaseke | Kirugga A | 1 | 0 |  |
| Nakaseke | Kirugga B | 1 | 0 |  |
| Nakaseke | Kiruuli Borehole | 1 | 0 |  |
| Nakaseke | Kiryanongo Borehole | 1 | 0 |  |
| Nakaseke | Kisango | 1 | 0 |  |
| Nakaseke | Kisango Borehole | 1 | 0 |  |
| Nakaseke | Kitaweera A | 1 | 0 |  |
| Nakaseke | Kituntu C/ U | 1 | 0 |  |
| Nakaseke | Kitutu B | 1 | 0 |  |
| Nakaseke | Kitutu Mugerwa | 1 | 0 |  |
| Nakaseke | Kivumu | 1 | 2 | Kakoola Kivumu |
| Nakaseke | Kivumu Bulamazzi | 1 | 0 | Bulamazzi |
| Nakaseke | Kokogwanga | 1 | 0 |  |
| Nakaseke | Komamboga | 1 | 0 |  |
| Nakaseke | Kyagatto | 1 | 0 |  |
| Nakaseke | Kyambogo Kikweke | 1 | 0 |  |
| Nakaseke | Kyambogo Lc1 | 1 | 0 |  |
| Nakaseke | Kyampisi | 1 | 0 |  |
| Nakaseke | Kyamuyinula | 1 | 0 |  |
| Nakaseke | Kyetume | 1 | 0 |  |
| Nakaseke | Kyoga T.c | 1 | 0 |  |
| Nakaseke | Lukenku | 1 | 3 |  |
| Nakaseke | Lukunga Butalangu | 1 | 0 |  |
| Nakaseke | Lumpewe Borehole | 1 | 0 |  |
| Nakaseke | Luteete Bongole | 1 | 0 |  |
| Nakaseke | Lwabijogo | 1 | 0 |  |
| Nakaseke | Lwanda | 1 | 0 |  |
| Nakaseke | Mayirikiti | 1 | 0 |  |
| Nakaseke | Mazigo | 1 | 0 |  |
| Nakaseke | Mifunya C/ U | 1 | 0 |  |
| Nakaseke | Mifunya Lc1 | 1 | 0 |  |
| Nakaseke | Mugenyi | 2 | 6 | Mugenyi LC1 |
| Nakaseke | Najooki | 1 | 0 |  |
| Nakaseke | Nakanswa | 1 | 0 |  |
| Nakaseke | Namakokolo | 1 | 0 |  |
| Nakaseke | Namasujju A | 1 | 0 |  |
| Nakaseke | Namasujju B | 1 | 0 |  |
| Nakaseke | Namusaale G | 1 | 0 |  |
| Nakaseke | Namusisi Borehole Kitutu | 1 | 0 |  |
| Nakaseke | Naseeta | 1 | 0 |  |
| Nakaseke | Nongo Shallow | 1 | 0 |  |
| Nakaseke | Nvunanwa Kasaawe | 1 | 0 |  |
| Nakaseke | Sakabusolo 2 | 1 | 0 |  |
| Nakaseke | Sakabusolo Borehole | 1 | 0 |  |
| Nakaseke | Semagulu | 2 | 5 | Kasangombe Semagulu |
| Nakaseke | St Kizito Kasambya | 1 | 0 |  |
| Nakaseke | Sumbwe Borehole | 1 | 0 |  |
| Nakaseke | Timuna Kafene | 1 | 0 |  |
| Nakaseke | Timuna Nakajako | 1 | 0 |  |
| Nakaseke | Twekembe | 1 | 0 |  |
| Nakaseke | Wabitunda | 1 | 0 |  |
| Nakaseke | Wakayamba | 1 | 0 |  |
| Nakaseke | Wakyato Lc | 1 | 0 |  |
| Nakaseke | Wamengo | 1 | 0 |  |

## Communities not in the lookup

| District | Name in data | Borehole visits | Household visits | Overlaps lookup name |
|---|---|---:|---:|---|
| Kaabong | Jane Abonyo | 2 | 0 |  |
| Kaabong | Kakamar | 1 | 0 |  |
| Kaabong | Kamacharkol | 3 | 9 |  |
| Kaabong | Kangingetei Kepak | 1 | 0 |  |
| Kaabong | Kathile | 2 | 6 |  |
| Kaabong | Kayokong | 1 | 0 |  |
| Kaabong | Kotirae | 0 | 1 |  |
| Kaabong | Loit | 1 | 0 |  |
| Kaabong | Lokut Lucia | 0 | 1 |  |
| Kaabong | Morunyang | 0 | 1 |  |
| Kaabong | Nagumalokoringole | 1 | 0 |  |
| Kaabong | Naloto Maria | 0 | 1 |  |
| Kaabong | Namamutau | 1 | 0 |  |
| Kaabong | Narionomoru | 1 | 0 |  |
| Kaabong | Papa 2 / St Marys Chapel | 0 | 1 | Papa 2 |
| Kaabong | St Marys Chalel | 0 | 1 |  |
| Kaabong | St Marys Chapel | 8 | 21 |  |
| Kaabong | Yaruun | 1 | 3 |  |
| Kumi | Atutur | 30 | 89 |  |
| Kumi | Kakures. Kituba | 1 | 0 | Kituba |
| Kumi | Kamacha | 15 | 48 |  |
| Kumi | Kanapa | 1 | 3 |  |
| Kumi | Kanyum | 18 | 54 |  |
| Kumi | Kapolin | 0 | 4 | Kapolin P/S |
| Kumi | Kapolin Ongino | 1 | 0 |  |
| Kumi | Nn | 1 | 0 |  |
| Kumi | Nyero | 4 | 12 |  |
| Kumi | Ongino | 7 | 23 |  |
| Kumi | Ongino Kapolin | 0 | 1 |  |
| Luuka | Budhuaba. A Mosque | 0 | 1 |  |
| Luuka | Budhuba A Mosque | 2 | 3 | Budhuba A |
| Luuka | Budhuuba A Mosque | 0 | 1 |  |
| Luuka | Budhuuba Mosque | 0 | 1 |  |
| Luuka | Bumanha Busige | 0 | 1 |  |
| Luuka | Good | 1 | 0 |  |
| Luuka | Irongo | 0 | 2 | Irongo S/C |
| Luuka | Nabikuyi Dodovico | 1 | 3 | Nabikuyi |
| Nakaseke | Bambaga Kikandwa | 1 | 0 |  |
| Nakaseke | Bukatira | 1 | 0 |  |
| Nakaseke | Bukeeka | 1 | 0 |  |
| Nakaseke | Bukoto Kikamulo | 1 | 0 |  |
| Nakaseke | Bukuku | 1 | 0 |  |
| Nakaseke | Bukuku Kasangombe | 1 | 0 |  |
| Nakaseke | Bulyake | 1 | 0 |  |
| Nakaseke | Butalangu | 1 | 0 |  |
| Nakaseke | Butikwa | 1 | 0 |  |
| Nakaseke | Butonya Kitto | 1 | 0 |  |
| Nakaseke | Buwa | 1 | 0 |  |
| Nakaseke | Kabbubu | 1 | 0 |  |
| Nakaseke | Kadunda Kapeeka | 1 | 0 |  |
| Nakaseke | Kafunda Kikamulo | 0 | 2 | Kafunda |
| Nakaseke | Kagango Naguru | 1 | 0 |  |
| Nakaseke | Kakoola | 2 | 5 | Kakoola C/O |
| Nakaseke | Kakoola Kitto | 0 | 1 |  |
| Nakaseke | Kalagala | 1 | 0 |  |
| Nakaseke | Kalagi | 1 | 0 |  |
| Nakaseke | Kalege | 2 | 0 |  |
| Nakaseke | Kaloke | 1 | 0 |  |
| Nakaseke | Kamuli | 2 | 0 |  |
| Nakaseke | Kapeeka | 2 | 4 | Kapeeka Centre |
| Nakaseke | Kasambya | 1 | 0 |  |
| Nakaseke | Kasangombe | 4 | 12 | Kasangombe Police |
| Nakaseke | Kasiiso | 1 | 0 |  |
| Nakaseke | Katakala | 1 | 0 |  |
| Nakaseke | Katalekamese | 2 | 0 |  |
| Nakaseke | Kibaale | 3 | 5 | Kibaale TC |
| Nakaseke | Kibira Dongo Kigege | 1 | 0 |  |
| Nakaseke | Kibira Kigege | 1 | 0 |  |
| Nakaseke | Kibubu Kikandwa | 1 | 0 |  |
| Nakaseke | Kifunfugu Kasangombe | 2 | 1 |  |
| Nakaseke | Kigege | 1 | 0 |  |
| Nakaseke | Kijeebejo | 1 | 0 |  |
| Nakaseke | Kikamulo | 1 | 0 |  |
| Nakaseke | Kikandwa | 2 | 0 |  |
| Nakaseke | Kikumango | 2 | 0 |  |
| Nakaseke | Kikwata | 1 | 0 |  |
| Nakaseke | Kikwata Tc | 1 | 0 |  |
| Nakaseke | Kirema P/S | 1 | 0 |  |
| Nakaseke | Kirinya | 1 | 0 |  |
| Nakaseke | Kirugga | 1 | 0 |  |
| Nakaseke | Kirugga Kasangombe | 1 | 0 |  |
| Nakaseke | Kiruuli | 1 | 0 |  |
| Nakaseke | Kiryanongo | 1 | 0 |  |
| Nakaseke | Kisango Bulyake | 1 | 0 |  |
| Nakaseke | Kisango Kasangombe | 1 | 0 |  |
| Nakaseke | Kitaweera | 1 | 0 |  |
| Nakaseke | Kituntu Kasangombe | 1 | 0 |  |
| Nakaseke | Kitutu | 1 | 0 |  |
| Nakaseke | Kitutu Kasangombe | 2 | 0 |  |
| Nakaseke | Kivumu | 1 | 3 | Kakoola Kivumu |
| Nakaseke | Kivumu T.c | 1 | 0 |  |
| Nakaseke | Kiwoko | 2 | 6 |  |
| Nakaseke | Kokogwanga Migingye | 1 | 0 |  |
| Nakaseke | Komamboga Transformer | 1 | 0 |  |
| Nakaseke | Kyagatto Kasangombe | 1 | 0 |  |
| Nakaseke | Kyambogo | 2 | 0 |  |
| Nakaseke | Kyampisi | 1 | 0 |  |
| Nakaseke | Kyamuyinula | 1 | 0 |  |
| Nakaseke | Kyetume Mijinje | 1 | 0 |  |
| Nakaseke | Kyoga T.c Kikyusa | 1 | 0 |  |
| Nakaseke | Lukenku | 1 | 3 |  |
| Nakaseke | Lumpewe | 1 | 0 |  |
| Nakaseke | Luteete | 1 | 0 |  |
| Nakaseke | Lwabijogo | 1 | 0 |  |
| Nakaseke | Lwanda Kapeeka | 1 | 0 |  |
| Nakaseke | Mabale | 1 | 0 |  |
| Nakaseke | Mayirikiti | 1 | 0 |  |
| Nakaseke | Mazigo Semuto | 1 | 0 |  |
| Nakaseke | Mifunya | 2 | 0 |  |
| Nakaseke | Mijinje | 1 | 0 |  |
| Nakaseke | Mugenyi | 1 | 3 | Mugenyi LC1 |
| Nakaseke | Mugenyi Kasangombe | 1 | 3 |  |
| Nakaseke | Najooki Semuto T/C | 1 | 0 |  |
| Nakaseke | Nakanswa Kitto | 1 | 0 |  |
| Nakaseke | Nakazzi Semuto | 1 | 0 |  |
| Nakaseke | Nakitembe Semuto | 1 | 0 | Nakitembe |
| Nakaseke | Naluvule | 1 | 4 | Naluvule TC |
| Nakaseke | Naluvule Kapeeka | 1 | 0 |  |
| Nakaseke | Namakokolo Kasangombe | 1 | 0 |  |
| Nakaseke | Namasujju | 1 | 0 |  |
| Nakaseke | Namasujju Kasangombe | 1 | 0 |  |
| Nakaseke | Namusaale | 1 | 0 |  |
| Nakaseke | Namyeso Kitto | 1 | 3 | Namyeso |
| Nakaseke | Nanzige Penina | 0 | 1 |  |
| Nakaseke | Naseeta Kasangombe | 1 | 0 |  |
| Nakaseke | Njagalabwami Musuuza | 1 | 0 |  |
| Nakaseke | Nongo | 1 | 0 |  |
| Nakaseke | Nvunanwa | 1 | 0 |  |
| Nakaseke | Sakabusolo | 2 | 0 |  |
| Nakaseke | Sakabusolo Kasangombe | 1 | 0 |  |
| Nakaseke | Salongo Kasule | 0 | 1 |  |
| Nakaseke | Ssanze Mifunya | 1 | 0 | Ssanze |
| Nakaseke | Sumbwe Kapeeka | 1 | 0 |  |
| Nakaseke | Timuna | 2 | 0 |  |
| Nakaseke | Wabikyakya Kikamulo | 0 | 1 | Wabikyakya |
| Nakaseke | Wabitunda | 1 | 0 |  |
| Nakaseke | Wakayamba | 1 | 0 |  |
| Nakaseke | Wakyato | 1 | 0 |  |
| Nakaseke | Wamengo Semuto | 1 | 0 |  |
| Nakaseke | Zirambwa Kapeeka | 1 | 0 | Zirambwa |
