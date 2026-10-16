# Description ------------------------------------------------------------------
# R script to process uploaded raw data into tidy, analysis-ready data frames.
#
# Raw data: two mWater survey exports from the Maji Health / Whave Solutions
# monitoring of drinking water quality from borehole sources to household
# storage in four Ugandan districts (Nov 2024 to Sep 2025).
#
#   data-raw/Sample_collection.xlsx    field survey, one row per visit
#   data-raw/Sample_E.coliresults.xlsx lab survey, one row per analysed bottle
#
# Output: four tidy tables, one per observational unit.
#
#   borehole_visits  one row per field visit to a borehole source
#   household_visits one row per field visit to a household
#   samples          one row per water sample (bottle), with E. coli result
#   labblanks        one row per laboratory blank (sterile-water control)
#
# Load packages ----------------------------------------------------------------
## Run the following code in console if you don't have the packages
## install.packages(c("usethis", "fs", "here", "readr", "readxl", "openxlsx",
##                    "tidyverse", "janitor"))
library(usethis)
library(fs)
library(here)
library(readr)
library(readxl)
library(openxlsx)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(tibble)
library(janitor)

# Read data --------------------------------------------------------------------
field_raw <- readxl::read_excel(here::here("data-raw", "Sample_collection.xlsx")) |>
  janitor::clean_names()

lab_raw <- readxl::read_excel(here::here("data-raw", "Sample_E.coliresults.xlsx")) |>
  janitor::clean_names()

# Constants --------------------------------------------------------------------
# Monitoring started in November 2024. Rows before that are pilot / training
# submissions (no region, no survey type) and are dropped.
study_start <- as.Date("2024-11-01")

# Region <-> district is one-to-one in this study. The lab form spells two
# districts differently from the field form (Kaboong vs Kaabong) or names the
# neighbouring district (Kamuli vs Luuka). The field spelling is used.
district_region <- tibble::tribble(
  ~district,   ~region,
  "Nakaseke",  "Central Region",
  "Kaabong",   "Karamoja Region",
  "Kumi",      "Teso Region",
  "Luuka",     "Busoga Region"
)

# Five contamination levels used in the project (colonies per 100 mL).
contamination_levels <- c(
  "Safe",
  "Slightly contaminated",
  "Moderately contaminated",
  "Highly contaminated",
  "Unsafe"
)

# Spelling variants of borehole / source names, after str_to_title(). Only
# clear variants of the same name within a district are merged.
source_recode <- tibble::tribble(
  ~district,  ~from,                       ~to,
  "Kaabong",  "Lopelipel",                 "Lopelpel",
  "Kaabong",  "Moru-Ese",                  "Moruese",
  "Kaabong",  "Nakoreto .",                "Nakoreto",
  "Kaabong",  "Tulenyang",                 "Tulyenyang",
  "Kaabong",  "St Mary's Borehole",        "St Marys Chapel",
  "Kaabong",  "St Marys Borehole",         "St Marys Chapel",
  "Kaabong",  "Yaruun",                    "Yerun",
  "Kumi",     "Kakure Ps",                 "Kakures Ps",
  "Kumi",     "Kalumgar Os",               "Kalungar Ps",
  "Kumi",     "Kalungar",                  "Kalungar Ps",
  "Kumi",     "Kongoto Oturukuku",         "Kongoto Oturukulu",
  "Luuka",    "Budhuaba A Mosque",         "Budhuba A Mosque",
  "Luuka",    "Budhuuba A Mosque",         "Budhuba A Mosque",
  "Luuka",    "Budhuba A",                 "Budhuba A Mosque",
  "Luuka",    "Bukyama",                   "Bukyamata",
  "Luuka",    "Bumanha Busige",            "Busige Bumanha",
  "Luuka",    "Ikonia Bafumba",            "Ikonia Bufumba A",
  "Luuka",    "Ikonia Bafumba A",          "Ikonia Bufumba A",
  "Luuka",    "Ikonia Bufumbaa",           "Ikonia Bufumba A",
  "Luuka",    "Irongo Sc",                 "Irongo Subcounty",
  "Luuka",    "Irongo Sub / C",            "Irongo Subcounty",
  "Luuka",    "Irongo Sub C",              "Irongo Subcounty",
  "Luuka",    "Irongo Subc",               "Irongo Subcounty",
  "Luuka",    "Kibinga T/C",               "Kibinga Tc",
  "Luuka",    "Kiklbinga T/C",             "Kibinga Tc",
  "Luuka",    "Kibingaa",                  "Kibinga A",
  "Luuka",    "Lizinga Park",              "Luzinga Park",
  "Luuka",    "Modern Time Ps",            "Modern Times Ps",
  "Luuka",    "Modern Times",              "Modern Times Ps",
  "Luuka",    "Naika Kagoma",              "Nairika Kagoma",
  "Luuka",    "Nawanyago Bugole",          "Nawanyago Bagole",
  "Luuka",    "Nsiima",                    "Nsima",
  "Nakaseke", "Busumba Borehole",          "Busumba",
  "Nakaseke", "Kakonde Borehole",          "Kakonde",
  "Nakaseke", "Kakoola Kvumu",             "Kakoola Kivumu",
  "Nakaseke", "Kivumu Kakoola",            "Kakoola Kivumu",
  "Nakaseke", "Kasiga.",                   "Kasiga",
  "Nakaseke", "Kuffu Borehole",            "Kuffu",
  "Nakaseke", "Lukenku Borehole",          "Lukenku",
  "Nakaseke", "Lukumbi Borehole",          "Lukumbi",
  "Nakaseke", "Mugenyi Borehole",          "Mugenyi",
  "Nakaseke", "Mugenyi Lc",                "Mugenyi",
  "Nakaseke", "Mugenyi Lc1",               "Mugenyi",
  "Nakaseke", "Nakazi Lugo",               "Nakazzi Lugo",
  "Nakaseke", "Nakitembe Borehole",        "Nakitembe",
  "Nakaseke", "Nalivule Tc",               "Naluvule Tc",
  "Nakaseke", "Naluvule",                  "Naluvule Tc",
  "Nakaseke", "Naluvule T.c",              "Naluvule Tc",
  "Nakaseke", "Namasinda Nakito",          "Namasinda Nakitto",
  "Nakaseke", "Namasinda2",                "Namasinda 2",
  "Nakaseke", "Namsinda 1",                "Namasinda 1",
  "Nakaseke", "Namsinda 2",                "Namasinda 2",
  "Nakaseke", "Namyesi",                   "Namyeso",
  "Nakaseke", "Namyeso Borehole",          "Namyeso",
  "Nakaseke", "Semagullu",                 "Semagulu",
  "Nakaseke", "Ssanze Mifunya",            "Ssanze",
  "Nakaseke", "Wabikyakya Borehole",       "Wabikyakya",
  "Nakaseke", "Wabikykya",                 "Wabikyakya"
)

# Values entered in the source-name field that are not source names
# (an enumerator name, keyboard noise, numbers).
source_junk <- c("Jane Abonyo", "Dff", "Ka", "Good", "02", "20")

# Keyboard noise in the free-text sensory fields.
text_junk <- c("Ddf", "Dd", "Morunyang Nanyangadoket")

# Obvious typos in the free-text sensory fields (after str_to_sentence()).
text_typos <- c(
  "Notbad"      = "Not bad",
  "No bad"      = "Not bad",
  "Mot bad"     = "Not bad",
  "Noy bad"     = "Not bad",
  "Tastless"    = "Tasteless",
  "Tasteleless" = "Tasteless",
  "Tastelless"  = "Tasteless",
  "Good tast"   = "Good taste",
  "Odourkess"   = "Odourless",
  "Odurless"    = "Odourless",
  "Cclear"      = "Clear",
  "Colourles"   = "Colourless",
  "Colour less" = "Colourless",
  "Colorless"   = "Colourless"
)

# Helper: normalise free text (trim, collapse spaces, sentence case), fix
# obvious typos and turn keyboard noise into NA.
clean_text <- function(x) {
  x <- stringr::str_squish(x)
  x <- dplyr::if_else(x %in% text_junk, NA_character_, x)
  x <- stringr::str_to_sentence(x)
  dplyr::if_else(x %in% names(text_typos), unname(text_typos[x]), x)
}

# Tidy data: field survey -> visits + field samples ----------------------------
field <- field_raw |>
  dplyr::select(
    submitted_on,
    datetime_sampled    = enter_date_and_time_of_sampling,
    district            = select_the_district,
    community           = enter_the_name_of_the_community,
    survey_type         = select_the_type_of_survey_being_taken,
    source_name         = enter_the_source_name,
    water_taste         = ask_a_community_member_to_make_notes_on_the_taste_of_the_water,
    water_smell         = ask_a_community_member_to_make_notes_about_the_smell_of_the_water,
    water_colour        = what_is_the_colour_of_the_sampled_water,
    storage_container   = select_the_current_type_of_storage_technology_container_for_drinking_water_being_used,
    storage_other       = please_specify_the_type_of_storage_container_for_drinking_water,
    transport_container = what_medium_type_of_container_do_they_use_to_collect_water_from_the_borehole,
    transport_other     = if_other_please_specify_the_medium_type_of_container_used_for_transporting_water_from_borehole,
    days_in_transport_container = ask_the_household_members_for_how_long_water_is_temporarily_kept_in_the_transportation_container_before_it_is_transferred_into_the_storage_container_record_the_number_in_days,
    boils_water         = does_the_household_boil_their_drinking_water,
    bottle_transport    = take_a_sample_from_the_transportation_medium_container_used_by_the_household_and_enter_sample_bottle_number,
    bottle_storage      = take_another_sample_from_the_household_storage_container_and_enter_the_sample_bottle_number,
    bottle_borehole     = enter_the_sample_bottle_number,
    bottle_duplicate    = enter_the_bottle_number_of_the_duplicate_sample,
    storage_cleaning_days     = how_often_do_they_clean_their_storage_device,
    transport_cleaning_days   = how_often_do_they_clean_their_transportation_device,
    transport_cleaning_method = let_them_briefly_describe_how_they_clean_their_transportation_device,
    storage_cleaning_method   = let_them_briefly_describe_how_they_clean_their_storage_device
  ) |>
  dplyr::mutate(date_sampled = as.Date(datetime_sampled)) |>
  dplyr::filter(date_sampled >= study_start) |>
  dplyr::mutate(
    # Location
    district = dplyr::case_when(
      district == "Kaboong" ~ "Kaabong",
      district == "Kamuli"  ~ "Luuka",
      TRUE ~ district
    ),
    community   = stringr::str_to_title(stringr::str_squish(community)),
    survey_type = stringr::str_to_lower(survey_type),
    # Source / borehole names
    source_name = stringr::str_to_title(stringr::str_squish(source_name)),
    source_name = stringr::str_replace_all(source_name, "\\s*/\\s*", "/ "),
    source_name = dplyr::if_else(source_name %in% source_junk,
                                 NA_character_, source_name),
    # Sensory notes
    dplyr::across(c(water_taste, water_smell, water_colour), clean_text),
    # Storage container: resolve "Other (please specify)"; NA stays NA
    storage_other = stringr::str_to_lower(stringr::str_squish(storage_other)),
    storage_container = dplyr::case_when(
      is.na(storage_container) ~ NA_character_,
      storage_container != "Other (please specify)" ~ storage_container,
      stringr::str_detect(storage_other, "drum|dram") ~ "Drum",
      stringr::str_detect(storage_other, "bucket|backet|cylinder") ~ "Bucket",
      stringr::str_detect(storage_other, "pot") ~ "Pot",
      TRUE ~ "Other"
    ),
    # Transport container: resolve "Other"; NA stays NA
    transport_other = stringr::str_to_sentence(stringr::str_squish(transport_other)),
    transport_container = dplyr::case_when(
      is.na(transport_container) ~ NA_character_,
      transport_container != "Other" ~ transport_container,
      transport_other == "Backet" ~ "Bucket",
      !is.na(transport_other) ~ transport_other,
      TRUE ~ "Other"
    ),
    # Household practices
    boils_water = dplyr::case_when(
      boils_water == "Yes" ~ TRUE,
      boils_water == "No"  ~ FALSE,
      TRUE ~ NA
    ),
    dplyr::across(c(storage_cleaning_days, transport_cleaning_days),
                  \(x) dplyr::if_else(x < 0, NA_real_, x)),
    dplyr::across(c(storage_cleaning_method, transport_cleaning_method),
                  clean_text)
  ) |>
  # Apply the explicit source-name recodes
  dplyr::left_join(source_recode, by = c("district", "source_name" = "from")) |>
  dplyr::mutate(source_name = dplyr::coalesce(to, source_name)) |>
  dplyr::select(-to, -storage_other, -transport_other) |>
  # Region from district
  dplyr::left_join(district_region, by = "district") |>
  # One id space for both visit tables
  dplyr::arrange(district, date_sampled, submitted_on) |>
  dplyr::mutate(visit_id = dplyr::row_number())

borehole_visits <- field |>
  dplyr::filter(survey_type == "borehole") |>
  dplyr::select(
    visit_id, date_sampled, region, district, community, source_name,
    water_taste, water_smell, water_colour
  )

household_visits <- field |>
  dplyr::filter(survey_type == "household") |>
  dplyr::select(
    visit_id, date_sampled, region, district, community, source_name,
    storage_container, transport_container, days_in_transport_container,
    boils_water, storage_cleaning_days, transport_cleaning_days,
    storage_cleaning_method, transport_cleaning_method
  )

# One row per bottle collected in the field
field_samples <- field |>
  dplyr::select(visit_id, region, district, date_sampled,
                bottle_borehole, bottle_duplicate,
                bottle_transport, bottle_storage) |>
  tidyr::pivot_longer(
    cols = tidyr::starts_with("bottle_"),
    names_to = "sample_type",
    names_prefix = "bottle_",
    values_to = "bottle_number",
    values_drop_na = TRUE
  ) |>
  dplyr::mutate(
    sample_type = dplyr::recode(
      sample_type,
      borehole  = "borehole",
      duplicate = "borehole_duplicate",
      transport = "transport_container",
      storage   = "storage_container"
    ),
    bottle_number = as.integer(bottle_number)
  )

# Tidy data: lab survey -> lab results + labblanks -----------------------------
lab <- lab_raw |>
  dplyr::select(
    datetime_result     = enter_the_date_and_time_now,
    region_raw          = select_region,
    district_raw        = select_district,
    is_blank            = is_this_a_laboratory_blank,
    blank_dish          = enter_petri_dish_number_for_laboratory_blank_e_g_b1_or_b13,
    blank_cfu           = enter_number_of_e_coli_colonies_in_the_laboratory_blank_sample,
    bottle_number       = enter_sample_bottle_number,
    petri_dish_number   = enter_sample_petri_dish_number,
    datetime_incubation = enter_sample_incubation_start_time,
    ecoli_cfu           = count_the_number_of_colonies_and_enter_the_number_here_if_there_are_100_colonies_meaning_too_numerous_to_count_enter_101,
    volume_raw          = what_was_the_volume_of_water_that_was_filtered_when_this_sample_was_analysed,
    volume_other        = please_specify_the_volume_of_water_sampled_m_l,
    lab_notes           = record_any_notes_about_the_sample_here
  ) |>
  dplyr::mutate(
    # One incubation start was entered with year 2034 instead of 2024
    datetime_incubation = dplyr::if_else(
      lubridate::year(datetime_incubation) > 2030,
      datetime_incubation - lubridate::years(10),
      datetime_incubation
    ),
    date_incubation = as.Date(datetime_incubation),
    date_result     = as.Date(datetime_result),
    # District: use the lab's district when it is a single valid value,
    # otherwise derive it from the (single-valued) region.
    district = dplyr::case_when(
      district_raw == "Nakaseke" ~ "Nakaseke",
      district_raw == "Kaboong"  ~ "Kaabong",
      district_raw == "Kumi"     ~ "Kumi",
      district_raw == "Kamuli"   ~ "Luuka",
      region_raw == "Central Region"  ~ "Nakaseke",
      region_raw == "Karamoja Region" ~ "Kaabong",
      region_raw == "Teso Region"     ~ "Kumi",
      region_raw == "Busoga Region"   ~ "Luuka",
      TRUE ~ NA_character_
    ),
    bottle_number     = as.integer(bottle_number),
    petri_dish_number = as.character(petri_dish_number),
    tntc              = ecoli_cfu > 100,
    volume_ml = dplyr::case_when(
      volume_raw == "100 mL" ~ 100,
      !is.na(volume_other) ~ as.numeric(volume_other),
      TRUE ~ NA_real_
    ),
    lab_notes = stringr::str_squish(lab_notes)
  ) |>
  dplyr::left_join(district_region, by = "district") |>
  dplyr::filter(date_incubation >= study_start) |>
  # Four results were submitted twice within minutes (identical district,
  # dates, bottle, dish and count), three times to add a laboratory blank.
  # Keep one submission, preferring the one that carries the blank.
  dplyr::arrange(dplyr::desc(is_blank == "Yes"), datetime_result) |>
  dplyr::distinct(district, date_incubation, date_result, bottle_number,
                  petri_dish_number, ecoli_cfu, .keep_all = TRUE)

labblanks <- lab |>
  dplyr::filter(is_blank == "Yes") |>
  dplyr::arrange(district, date_incubation, datetime_result) |>
  dplyr::transmute(
    blank_id = dplyr::row_number(),
    date_incubation,
    date_result,
    region,
    district,
    petri_dish_number = stringr::str_squish(blank_dish),
    ecoli_cfu = as.numeric(blank_cfu)
  )

lab_results <- lab |>
  dplyr::arrange(district, date_incubation, datetime_result) |>
  dplyr::mutate(lab_id = dplyr::row_number()) |>
  dplyr::select(lab_id, region, district, date_incubation, date_result,
                bottle_number, petri_dish_number, ecoli_cfu, tntc,
                volume_ml, lab_notes)

# Match field samples to lab results -------------------------------------------
# Key: district + date + bottle number (bottle numbers restart every day).
# A field bottle and a lab result are linked only when the key is unique on
# both sides. Keys that occur more than once on either side stay unlinked
# ("ambiguous key") so that no result is guessed or double counted.
field_keyed <- field_samples |>
  dplyr::add_count(district, date_sampled, bottle_number, name = "n_field") |>
  dplyr::left_join(
    lab_results |>
      dplyr::count(district, date_incubation, bottle_number, name = "n_lab"),
    by = c("district", "date_sampled" = "date_incubation", "bottle_number")
  ) |>
  dplyr::mutate(match_status = dplyr::case_when(
    is.na(n_lab) ~ "no lab result",
    n_field == 1 & n_lab == 1 ~ "matched",
    TRUE ~ "ambiguous key"
  ))

lab_keyed <- lab_results |>
  dplyr::add_count(district, date_incubation, bottle_number, name = "n_lab") |>
  dplyr::left_join(
    field_samples |>
      dplyr::count(district, date_sampled, bottle_number, name = "n_field"),
    by = c("district", "date_incubation" = "date_sampled", "bottle_number")
  ) |>
  dplyr::mutate(match_status = dplyr::case_when(
    is.na(n_field) ~ "no field record",
    n_field == 1 & n_lab == 1 ~ "matched",
    TRUE ~ "ambiguous key"
  ))

matched <- field_keyed |>
  dplyr::filter(match_status == "matched") |>
  dplyr::select(-n_field, -n_lab) |>
  dplyr::inner_join(
    lab_keyed |>
      dplyr::filter(match_status == "matched") |>
      dplyr::select(-region, -n_field, -n_lab, -match_status),
    by = c("district", "date_sampled" = "date_incubation", "bottle_number"),
    relationship = "one-to-one"
  ) |>
  dplyr::mutate(date_incubation = date_sampled)

field_only <- field_keyed |>
  dplyr::filter(match_status != "matched") |>
  dplyr::select(-n_field, -n_lab)

lab_only <- lab_keyed |>
  dplyr::filter(match_status != "matched") |>
  dplyr::select(-n_field, -n_lab) |>
  dplyr::mutate(date_sampled = date_incubation)

samples <- dplyr::bind_rows(matched, field_only, lab_only) |>
  dplyr::mutate(
    contamination_category = dplyr::case_when(
      ecoli_cfu == 0 ~ "Safe",
      ecoli_cfu <= 10 ~ "Slightly contaminated",
      ecoli_cfu <= 50 ~ "Moderately contaminated",
      ecoli_cfu <= 100 ~ "Highly contaminated",
      ecoli_cfu > 100 ~ "Unsafe",
      TRUE ~ NA_character_
    ),
    contamination_category = factor(contamination_category,
                                    levels = contamination_levels,
                                    ordered = TRUE)
  ) |>
  dplyr::arrange(district, date_sampled, visit_id, sample_type, bottle_number,
                 lab_id) |>
  dplyr::mutate(sample_id = dplyr::row_number()) |>
  dplyr::select(
    sample_id, visit_id, region, district, date_sampled, sample_type,
    bottle_number, date_incubation, date_result, petri_dish_number,
    ecoli_cfu, tntc, volume_ml, contamination_category, lab_notes,
    match_status
  )

# Sanity checks ----------------------------------------------------------------
all_visit_ids <- c(borehole_visits$visit_id, household_visits$visit_id)
borehole_types <- c("borehole", "borehole_duplicate")
household_types <- c("transport_container", "storage_container")

stopifnot(
  # visit ids: unique across both visit tables, all field visits kept
  !anyDuplicated(all_visit_ids),
  length(all_visit_ids) == nrow(field),
  all(c(borehole_visits$district, household_visits$district) %in%
        district_region$district),
  # no column empty by design in either visit table
  !any(colSums(!is.na(borehole_visits)) == 0),
  !any(colSums(!is.na(household_visits)) == 0),
  # samples: keys and foreign keys
  all(samples$visit_id[!is.na(samples$visit_id)] %in% all_visit_ids),
  all(samples$visit_id[samples$sample_type %in% borehole_types] %in%
        borehole_visits$visit_id),
  all(samples$visit_id[samples$sample_type %in% household_types] %in%
        household_visits$visit_id),
  !anyNA(samples$district),
  !anyNA(samples$date_sampled),
  !anyNA(samples$bottle_number),
  all(samples$sample_type %in% c(borehole_types, household_types) |
        is.na(samples$visit_id)),
  all(!is.na(samples$sample_type) | is.na(samples$visit_id)),
  # lab values
  all(samples$ecoli_cfu >= 0, na.rm = TRUE),
  all(!is.na(samples$contamination_category) | is.na(samples$ecoli_cfu)),
  # every lab result and every field bottle appears exactly once
  nrow(lab_results) == sum(!is.na(samples$ecoli_cfu)),
  nrow(field_samples) == sum(!is.na(samples$visit_id)),
  !anyNA(labblanks$ecoli_cfu)
)

message("borehole_visits: ", nrow(borehole_visits), " rows")
message("household_visits: ", nrow(household_visits), " rows")
message("samples: ", nrow(samples), " rows")
print(dplyr::count(samples, match_status))
print(dplyr::count(samples, sample_type))
message("labblanks: ", nrow(labblanks), " rows")

# Export Data ------------------------------------------------------------------
usethis::use_data(borehole_visits, household_visits, samples, labblanks,
                  overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
for (name in c("borehole_visits", "household_visits", "samples", "labblanks")) {
  dataset <- get(name)
  readr::write_csv(dataset,
                   here::here("inst", "extdata", paste0(name, ".csv")))
  openxlsx::write.xlsx(dataset,
                       here::here("inst", "extdata", paste0(name, ".xlsx")))
}
