# ==============================================================================
# utils.R — Helper functions for the HAB event catalog
# ==============================================================================

#' Format large numbers with commas for display
#' @param x Numeric vector
#' @return Character vector
format_number <- function(x) {
  scales::comma(x, accuracy = 1)
}

#' Format currency values
#' @param x Numeric value
#' @param prefix Currency symbol (default "$")
#' @return Character string
format_currency <- function(x, prefix = "$") {
  ifelse(is.na(x), NA_character_,
         paste0(prefix, scales::comma(x, accuracy = 1)))
}

#' Convert cell density from cells/mL to cells/L
#' @param x Numeric value in cells/mL
#' @return Numeric value in cells/L
cells_ml_to_l <- function(x) {
  x * 1000
}
