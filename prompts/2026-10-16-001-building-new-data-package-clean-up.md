---
id: 2026-10-16-001-building-new-data-package-clean-up
timestamp: 2026-10-16T11:05:48+02:00
model: claude-fable-5-1
files_touched:
  - DESCRIPTION
  - data-raw/data_processing.R
  - data/borehole_visits.rda
  - data/household_visits.rda
  - data/labblanks.rda
  - data/samples.rda
  - inst/extdata/borehole_visits.csv
  - inst/extdata/borehole_visits.xlsx
  - inst/extdata/household_visits.csv
  - inst/extdata/household_visits.xlsx
  - inst/extdata/labblanks.csv
  - inst/extdata/labblanks.xlsx
  - inst/extdata/samples.csv
  - inst/extdata/samples.xlsx
---

I am building a new data package and received a dataset in data-raw to process for clean up. Use the washr package and its guide (https://global-health-engineering.github.io/ghedatapublishing/) as support for development of this package and building the website. Stricly start with cleaning the data, writing a dictionary. for context read this: https://ds4owd-002.github.io/project-cecilia2020-ux/ which is the project that the data belongs to and the readme in data-raw, which is not the readme of this project. However, don't trust the code as it may not be correct. Make a plan first adn use tidyverse packages.
