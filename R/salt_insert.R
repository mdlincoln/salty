#' Insert new characters into some values in a vector
#'
#' Inserts a selectino of characters into a percentage of
#'
#' @param x A vector. This will always be coerced to character during salting.
#' @param p A number between 0 and 1. Percent of values in `x` that should be salted.
#' @param insertions A [shaker] function, or a character vector if you want to
#'   manually supply your own list of characters.
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_insert <- function(x, p = 0.2, insertions) {
  xm <- as.character(x)

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(x, p), m_nulls)

  # For each selected element of x, in what string position should the new character be inserted?
  x_si <- purrr::map_int(nchar(x[xi]), sample.int, size = 1)

  # Generate new values with inserted characters
  replacements <- purrr::map2_chr(x[xi], x_si, function(xc, si) {
    x_head <- stringr::str_sub(xc, end = si)
    x_tail <- stringr::str_sub(xc, start = si + 1)
    stringr::str_c(x_head, insertions(l = 1), x_tail)
  })

  x[xi] <- replacements
  x
}

salt_numeric_commas <- function(x, p = 0.1) {
  stopifnot(is.numeric(x))

  xc <- as.character(x)
  xi <- p_indices(xc, p)

  xc[xi] <- stringr::str_replace(xc[xi], "\\.", ",")
  xc
}