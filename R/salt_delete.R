#' Delete some characters from some values
#'
#' @inheritParams salt_substitute
#' @param pp Number between 0 and 1. Percent of characters to remove from selected values
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_delete <- function(x, p = 0.2, pp = 0.1) {

}

salt_na <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- NA
  x
}

salt_empty <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- ""
  x
}