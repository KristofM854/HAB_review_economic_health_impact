# ==============================================================================
# validation.R — Data validation functions for the HAB event catalog
# ==============================================================================

#' Validate a single event_id format
#' @param id Character string to validate
#' @return Logical
is_valid_event_id <- function(id) {
  grepl("^[A-Z]{3}_[0-9]{4}_[0-9]{3}$", id)
}

#' Generate the next event_id for a given country and year
#' @param catalog Data frame of existing events
#' @param country_iso3 Three-letter country code
#' @param year Event year
#' @return Character string with next available event_id
next_event_id <- function(catalog, country_iso3, year) {
  prefix <- paste0(country_iso3, "_", year, "_")
  existing <- catalog$event_id[grepl(paste0("^", prefix), catalog$event_id)]
  if (length(existing) == 0) {
    return(paste0(prefix, "001"))
  }
  nums <- as.integer(sub(paste0("^", prefix), "", existing))
  next_num <- max(nums) + 1
  paste0(prefix, sprintf("%03d", next_num))
}

#' Check for duplicate events
#' @param catalog Data frame of events
#' @return Data frame of potential duplicates
find_duplicates <- function(catalog) {
  catalog %>%
    group_by(country_iso3, year, species_primary) %>%
    filter(n() > 1) %>%
    select(event_id, country_iso3, year, species_primary, water_body) %>%
    arrange(country_iso3, year)
}
