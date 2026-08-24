# Description ------------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages ----------------------------------------------------------------
## Run the following code in console if you don't have the packages
## install.packages(c("usethis", "fs", "here", "readr", "readxl", "openxlsx"))
library(usethis)
library(fs)
library(here)
library(readr)
library(readxl)
library(openxlsx)

# Read data --------------------------------------------------------------------
# data_in <- readr::read_csv("data-raw/dataset.csv")
# codebook <- readxl::read_excel("data-raw/codebook.xlsx") |>
#  clean_names()

# Tidy data --------------------------------------------------------------------
## Clean the raw data into a tidy format here

raw_data1 <- readxl::read_excel(here::here("data", "raw", "Sample_collection.xlsx"))

raw_data2 <- readxl::read_excel(here::here("data", "raw", "Sample_E.coliresults.xlsx"))

#Selecting relevant columns

#raw_data1: Sample collection

sample_data <- raw_data1|>
  select(
    `Enter date and time of sampling`,
    `Select the District`,
    `Select the region`,
    `Select the type of survey being taken`,
    `Enter the source name`,
    `Ask a community member to make notes on the taste of the water`,
    `Ask a community member to make notes about the smell of the water`,
    `What is the colour of the sampled water`,
    `Select the current type of storage technology/ container for drinking water being used`,
    `Please specify the type of storage container for drinking water`,
    `What medium/ type of container do they use to collect water from the borehole?`,
    `Take a sample from the transportation medium/ container used by the household and enter sample bottle number`,
    `Take another sample from the household storage container and enter the sample bottle number.`,
    `Enter the sample bottle number`)

#raw_data2: E.coli testing results

sample_result <- raw_data2 |>
  select(`Enter the date and time now`,
         `Select region`,
         `Select district`,
         `Enter sample bottle number`,
         `Enter sample petri dish number`,
         `Enter sample incubation start time`,
         `Count the number of colonies and enter the number here. If there are >100 colonies, meaning "too numerous to count", enter 101.`,
         `What was the volume of water that was filtered when this sample was analysed?`
  )

#Renaming columns

#sample_data
samples_data <- sample_data |> rename(date = `Enter date and time of sampling`,
                                      district = `Select the District`,
                                      region = `Select the region`,
                                      survey = `Select the type of survey being taken`,
                                      source = `Enter the source name`,
                                      taste = `Ask a community member to make notes on the taste of the water`,
                                      smell = `Ask a community member to make notes about the smell of the water`,
                                      color = `What is the colour of the sampled water`,
                                      storage_container = `Select the current type of storage technology/ container for drinking water being used`,
                                      other_container = `Please specify the type of storage container for drinking water`,
                                      tp_container = `What medium/ type of container do they use to collect water from the borehole?`,
                                      storage_num = `Take a sample from the transportation medium/ container used by the household and enter sample bottle number`,
                                      tp_num = `Take another sample from the household storage container and enter the sample bottle number.`,
                                      bh_num = `Enter the sample bottle number`)

#sample_result

samples_result <- sample_result |>
  rename(result_date = `Enter the date and time now`,
         region = `Select region`,
         district = `Select district`,
         sample_num = `Enter sample bottle number`,
         dish_num = `Enter sample petri dish number`,
         test_date = `Enter sample incubation start time`,
         E.coli_CFUs = `Count the number of colonies and enter the number here. If there are >100 colonies, meaning "too numerous to count", enter 101.`,
         volume = `What was the volume of water that was filtered when this sample was analysed?`
  )

samples_data$date_column <- as.Date(samples_data$date, format = "%Y-%m-%d")

#Transferring all sample names and bottle numbers into one column

#samples names
samples_names_2425 <- samples_data |>
  filter(date_column >= as.Date("2024-11-1") & date_column <= as.Date("2025-9-22"))|>
  mutate(bh = case_when(
    survey == "Borehole"  & !is.na(source) ~ source ,
    TRUE~ NA_character_)) |>
  relocate(bh, .before = storage_container) |>
  mutate(storage_container = ifelse(
    storage_container == "Other (please specify)",
    other_container,
    storage_container )) |>
  relocate(other_container, .before = bh) |>
  relocate(date_column, .before = date)

samples_names_2425|>
  count(survey)

#Creating all samples names column

samples_names_final <-samples_names_2425 |>
  pivot_longer(
    cols = c(bh,storage_container, tp_container),
    names_to = "Sample_Type",
    values_to = "Sample_Name")

samples_names_final|>
  count(survey)

samples_names_final |>
  count(Sample_Type)

samples_names_final |>
  count(Sample_Name)

#Creating all sample collection bottle numbers column

samples_data_final <- samples_names_final |>
  mutate(Sample_Num =
           case_when(Sample_Type == "bh" ~ bh_num,
                     Sample_Type == "storage_container" ~ storage_num,
                     Sample_Type == "tp_container" ~ tp_num,
                     .default = NA)) |>
  filter(!is.na(Sample_Num))


glimpse(samples_data_final)

samples_data_final |>
  count(Sample_Type)

#Final cleaned sample collection data
samples_data_cleaned <-samples_data_final |>
  filter(!is.na(Sample_Name)) |>
  select(date_column,
         district,
         region,
         survey,
         source,
         taste,
         smell,
         color,
         Sample_Type,
         Sample_Name,
         Sample_Num) |>
  arrange(desc(region), desc(date_column))|> rename(sample_type = Sample_Type,
                                                    sample_name = Sample_Name,
                                                    sample_num = Sample_Num,
                                                    test_date = date_column)  |> mutate(region = case_when(
                                                      region == "Busoga Region" ~ "Busoga Region",
                                                      region == "Busoga Region, Central Region, Teso Region" ~ "Busoga Region",
                                                      region == "Central Region" ~ "Central Region",
                                                      region == "Karamoja Region" ~ "Karamoja Region",
                                                      region == "Teso Region" ~ "Teso Region",
                                                      region == "Teso Region, Central Region, Busoga Region" ~ "Central Region",
                                                      region == "Teso Region, Karamoja Region" ~ "Teso Region",
                                                      TRUE ~ region
                                                    )) |>
  mutate(district = case_when(
    region == "Teso Region" ~ "Kumi",
    region == "Busoga Region" ~ "Kamuli",
    region == "Central Region" ~ "Nakaseke",
    region == "Karamoja Region" ~ "Kabong",
    TRUE ~ district ))

samples_data_cleaned |> count(survey)

samples_data_cleaned |>
  count(region)

samples_data_cleaned |>
  count(district)
samples_data_cleaned |>
  count(sample_type)

samples_result$result_date<- as.Date(samples_result$result_date, format = "%Y-%m-%d")

samples_result$test_date<- as.Date(samples_result$test_date, format = "%Y-%m-%d")

#Matching dates as in samples data df

samples_result_2425<- samples_result |> filter(result_date >= as.Date("2024-11-1") & result_date <= as.Date("2025-9-22")) |>
  filter(test_date >= as.Date("2024-11-1") & test_date <= as.Date("2025-9-22"))

#Removing redundant columns
samples_result_final <- samples_result_2425|>select(district,region,
                                                    sample_num,
                                                    dish_num,
                                                    E.coli_CFUs,
                                                    volume,
                                                    test_date,
                                                    result_date) |> mutate(region = case_when(
                                                      region == "Busoga Region" ~ "Busoga Region",
                                                      region == "Busoga Region, Central Region, Teso Region" ~ "Busoga Region",
                                                      region == "Central Region" ~ "Central Region",
                                                      region == "Karamoja Region" ~ "Karamoja Region",
                                                      region == "Teso Region" ~ "Teso Region",
                                                      region == "Teso Region, Central Region, Busoga Region" ~ "Central Region",
                                                      region == "Teso Region, Karamoja Region" ~ "Teso Region",
                                                      TRUE ~ region)) |>  mutate(district = case_when(
                                                        region == "Teso Region" ~ "Kumi",
                                                        region == "Busoga Region" ~ "Kamuli",
                                                        region == "Central Region" ~ "Nakaseke",
                                                        region == "Karamoja Region" ~ "Kabong",
                                                        TRUE ~ district )) |> arrange(desc(region), desc(result_date))


samples_result_final |>
  count(region)

samples_result_final |>
  count(district)

samples_result_final |>
  count(test_date)

#Joining the sample data and sample result

samples_joined <- samples_data_cleaned %>%

  right_join(samples_result_final, by = c("test_date" = "test_date",
                                          "sample_num" = "sample_num",
                                          "region" = "region",
                                          "district" = "district")) |>
  relocate(result_date, .after = test_date)
samples_joined |>
  filter(!is.na(survey))

samples_joined |> count(region)

samples_joined |> count(survey)

samples_joined |> count(sample_type)

head(samples_joined)

#Correcting typos in rows of the final dataset containing both sample collection and sample result data

samples_joined_regions <- samples_joined |> mutate(region = case_when(
  region == "Busoga Region" ~ "Busoga Region",
  region == "Busoga Region, Central Region, Teso Region" ~ "Busoga Region",
  region == "Central Region" ~ "Central Region",
  region == "Karamoja Region" ~ "Karamoja Region",
  region == "Teso Region" ~ "Teso Region",
  region == "Teso Region, Central Region, Busoga Region" ~ "Central Region",
  region == "Teso Region, Karamoja Region" ~ "Teso Region",
  TRUE ~ region
))

samples_joined_regions |>count(region)

samples_joined_regions |> count(district)

samples_joined_regions|> count(survey)

samples_joined_district <-samples_joined_regions |>
  mutate(district = case_when(
    region == "Teso Region" ~ "Kumi",
    region == "Busoga Region" ~ "Kamuli",
    region == "Central Region" ~ "Nakaseke",
    region == "Karamoja Region" ~ "Kabong",
    TRUE ~ district ))

samples_joined_district|> count(district)

test_data <- samples_data |>
  filter(date_column == "2025-03-18",
         storage_num == 5 | tp_num == 5 | bh_num == 5)

rm(test_data)

rm(samples_joined_district)

rm(samples_joined_regions)


# Export Data ------------------------------------------------------------------
usethis::use_data(waterqualityuganda, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
readr::write_csv(waterqualityuganda,
                 here::here("inst", "extdata", paste0("waterqualityuganda", ".csv")))
openxlsx::write.xlsx(waterqualityuganda,
                     here::here("inst", "extdata", paste0("waterqualityuganda", ".xlsx")))
