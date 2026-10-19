#' household_visits: Field visits to households using a borehole
#'
#' One row per field visit to a household during the monthly monitoring of
#' drinking water quality in four Ugandan districts (Nakaseke, Kaabong, Kumi
#' and Luuka), November 2024 to September 2025. Three households were visited
#' per borehole. Each visit records the borehole the household collects water
#' from, the containers used to transport and store drinking water, and the
#' household's water handling practices (boiling, container cleaning). The two
#' water samples taken at the visit, one from the transport container and one
#' from the storage container, are in [samples], linked through `visit_id`.
#'
#' @source Maji Health / Whave Solutions Limited monitoring programme, field
#'   survey collected with mWater. Data provided by Cecilia Nansiimbi.
#' @format A tibble with 1118 rows and 14 variables
#' \describe{
#'   \item{visit_id}{Unique identifier of the field visit (one survey submission). Integer, assigned over all field visits sorted by district, date and submission time, so no id occurs in both borehole_visits and household_visits. Key for samples$visit_id.}
#'   \item{date_sampled}{Date of the field visit and of sample collection (YYYY-MM-DD).}
#'   \item{region}{Region of Uganda where the visit took place: Central Region, Karamoja Region, Teso Region or Busoga Region.}
#'   \item{district}{District where the visit took place: Nakaseke (Central), Kaabong (Karamoja), Kumi (Teso) or Luuka (Busoga).}
#'   \item{community}{Name of the community (village, parish or trading centre) where the visit took place, as entered by the enumerator and converted to title case.}
#'   \item{source_name}{Name of the borehole from which the household collects its drinking water. Spelling variants were merged within each district; NA where the entry was not a source name.}
#'   \item{storage_container}{Type of container in which the household stores its drinking water: Pot, Sauce pan, Jerry can, Drum or Bucket. 'Other (please specify)' answers were recoded from the specified text.}
#'   \item{transport_container}{Type of container used by the household to collect water from the borehole: Jerry can, Bucket, Quad, Watering can, Water bottle or Jerrycan and watering can. 'Other' answers were replaced by the specified text.}
#'   \item{days_in_transport_container}{Number of days the household keeps water in the transport container before transferring it to the storage container, as reported by the household.}
#'   \item{boils_water}{Whether the household boils its drinking water (TRUE/FALSE).}
#'   \item{storage_cleaning_days}{Reported interval between cleanings of the drinking water storage container. The form asked 'how often do they clean their storage device' and accepted a number; values are interpreted as days (7 = weekly, 30 = monthly). A negative entry was set to NA.}
#'   \item{transport_cleaning_days}{Reported interval between cleanings of the transport container. The form asked 'how often do they clean their transportation device' and accepted a number; values are interpreted as days (7 = weekly, 30 = monthly).}
#'   \item{storage_cleaning_method}{Free-text description by the household of how the storage container is cleaned (materials used, e.g. soap and water, sand, polythene bag).}
#'   \item{transport_cleaning_method}{Free-text description by the household of how the transport container is cleaned (materials used, e.g. steel wire, soap and water, gravel).}
#' }
"household_visits"
