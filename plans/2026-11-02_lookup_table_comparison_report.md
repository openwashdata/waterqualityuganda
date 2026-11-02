# Lookup table comparison report

Date: 2026-11-02
Reference: `data-raw/Lookup table for community and source name.xlsx`
(Sheet1, 95 rows: region, district, community, source).
Scope: `region`, `district` in all four exported tables; `community` and
`source_name` in `borehole_visits` and `household_visits` (`samples` and
`labblanks` have no community or source columns).
Method: exact comparison, then a punctuation- and case-insensitive key, then
edit distance within district; for each lookup source, the community values
recorded in the data were tabulated.

This is a report only. Nothing has been changed.

## 1. Region and district: spelled correctly

| Lookup | Data | Status |
|---|---|---|
| Karamoja / Kaabong | Karamoja Region / Kaabong | ✓ |
| Busoga / Luuka | Busoga Region / Luuka | ✓ |
| Teso / Kumi | Teso Region / Kumi | ✓ |
| Central / Nakaseke | Central Region / Nakaseke | ✓ |

All four districts match exactly across all four tables, and each district sits
in the same region in both. The lookup confirms the earlier choices of Kaabong
over the lab file's "Kaboong" and Luuka over "Kamuli". The only difference is
the " Region" suffix, which the data has and the lookup does not. Dropping it is
optional.

## 2. Problems inside the lookup table itself

These need fixing or confirming before the lookup can serve as the reference:

- **Row 95:** `Butemula A` points to source `Lukumbi Mosque`, which repeats
  row 94. Probably a copy error. The data has `Butemula` and `Butemula A` as
  sources.
- **Row 73:** community is `Mugenyi LC1` but source is `Mugenyi LC2`. The data
  only has `Mugenyi`.
- **Row 1:** `St Marys borehole`. The data always uses `St Marys Chapel`
  (33 visits).
- **Rows 50 and 52:** `kakuress` is lowercase and spelled with "ss", while the
  source in row 50 is `Kakures P/S`. The data always uses `Kakures`.
- **Row 43:** `Nawankompe  A` has a double space.
- **Mixed abbreviations:** `P/S` and `PS` (row 46); `TC` and `T/C`; also `S/C`,
  `C/O`, `LC1`. The data currently uses `Ps` and `Tc`, so one convention needs
  choosing.
- **Row 60:** `Moruikara community borehole`. The data has `Moruikara`.
- **Row 62:** `Omatakiria Orapada`. The data has the words reversed:
  `Orapada Omatakiria`.
- **Rows 57 and 59:** community `Olimai` appears twice (sources `Olimai P/S`
  and `Odotuno`). Possibly correct, but worth confirming.

## 3. Source names (boreholes)

The data has 212 distinct district/source pairs. Every one of the 95 lookup
sources has a counterpart in the data.

- **62 match exactly.**
- **20 differ only in punctuation or case** and can be standardised
  mechanically: `Moruese`/`Moru-ese`, `Apapai Apapai`/`Apapai-Apapai`,
  `Acilun Agurut`/`Acilun-Agurut`, `Kibinga Tc`/`Kibinga T/ C`,
  `Kakoola C/ O`, and the `Ps`/`Tc` group.
- **Spelled differently in data and lookup; needs a decision on which is
  correct:**

  | Data | Lookup |
  |---|---|
  | `Nsima` (16) | `Nsiima` |
  | `Busige Bumanha` | `Busige Bumanya` |
  | `Nawanyago Bagole` | `Nawanyago Bugole` |
  | `Kakures B Rarak` | `Kakuress B Rarak` |
  | `Kongoto Oturukulu` | `Kongoto Oturukuku` |

- **Map to a lookup source once a name is chosen** (data name first):
  - `Ikonia Bufumba A` → `Ikonia Bufumba`
  - `Budhuba A Mosque` → `Budhuba A`
  - `Nabikuyi Dodovico` → `Nabikuyi`
  - `Irongo Subcounty` / `Irongo Sub/ C` → `Irongo S/C`
  - `St Marys Chapel` → `St Marys borehole`
  - `Semagulu` (7) → `Kasangombe Semagulu`
  - `Mizimbo` (11, households only) → `Mizimbo 1`
- **Unclear whether same borehole or a different one:**
  - `Kasiga` (7 visits, 2024-12 to 2025-09) against `Kasiga 2`, which is in the
    lookup but has only 1 visit in the data (2024-11-28).
  - `Nakasowan` (2025-08) against `Nakosowan 1` (2024-11).
  - `Namasinda` and `Namasinda A` against `Namasinda 1` and `Namasinda 2`.
  - `Kakures` (5) against `Kakures P/S`.
  - `Kibaale A` and `Kifunfugu A`, beside the lookup's `Kibaale TC` and
    `Kifunfugu B`.
  - `Butemula` and `Butemula A`, which also depend on the row 95 error.
- **Monitored sources missing from the lookup:** `Lukenku` (4 visits),
  `Kivumu` (3), `Bukuku` (2), `Loit`. Kaabong also has the household entry
  `Lokuriana Martha` and the slash entries such as `Peikale/ Tulyenyang`
  (see the 2026-10-23 normalisation report).
- **Not in the lookup at all:** about 88 Nakaseke and 5 Kaabong boreholes
  visited only once. They look like one-off survey visits rather than
  monitored sources, so the lookup cannot standardise them. They would stay as
  they are; a flag such as `in_monitoring_list` could mark the difference.

## 4. Community names: two different things

Community could be standardised by deriving it from the source through the
lookup. But the data and the lookup often record different things under
"community":

- **Kumi:** the data uses a broader area name for every source (`Atutur`,
  `Kamacha`, `Kanyum`, `Nyero`, `Ongino`, `Kakures`). The lookup uses the
  village (`Kalungar`, `Akalabai`, `Apapai`, `Adodoi`, `Munyal`, `Atirir`…).
  For example, `Kalungar PS` is community `Kalungar` in the lookup and
  `Atutur` in all 32 data rows.
- **Nakaseke:** the same pattern for some sources:
  - `Kasangombe` for `Kasangombe Police`
  - `Kiwoko` for `Martyrs Church`
  - `Namasinda` for `Namasinda 1`, `Namasinda 2` and `Namasinda Nakitto`
  - `Lukumbi` for `Lukumbi Mosque`
- **Kaabong:** some rows record a different village for the source
  (`Kamacharkol`, `Kathile`, `Kakamar`, `Kotirae`, `Morunyang`,
  `Nagumalokoringole`). Others record what look like people's names
  (`Jane Abonyo`, `Lokut Lucia`, `Naloto Maria`). Nakaseke also has
  `Nanzige Penina` and `Salongo Kasule`.
- **Luuka:** `Good` appears as a community for `Luzinga Park`, which looks like
  a data-entry error.
- **Plain spelling variants** that the lookup would resolve: `Moru-Ese`,
  `Yaruun`, `Lopelipel`, `Tulenyang`, `Narumugarae`, `Bilamazzi`, `Makitembe`,
  `Nakazi Lugo`, `Kakoola Kivmu`, `Lizlnga Park`, `Modern Time Ps`, and the
  `Ikonia`, `Budhuba` and `Irongo` groups.

## Suggested approach

1. Treat the source as the key.
2. Fix the lookup first (rows 1, 43, 50/52, 73 and 95) and choose one
   abbreviation convention.
3. Decide the spelling conflicts (section 3 table) and the same-or-different
   cases.
4. Normalise `source_name` to the lookup name in both visit tables.
5. Take `community` from the lookup. Because the data's community values are
   partly broader area names, keep the original in a separate column (e.g.
   `community_raw`) rather than overwrite it.
