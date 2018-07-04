#' Insert new characters into some values in a vector
#'
#' Inserts a selectino of characters into a percentage of
#'
#' @param x A vector. This will always be coerced to character during salting.
#' @param p A number between 0 and 1. Percent of values in `x` that should be salted.
#' @param n A postiive integer. Number of times to add new values from `insertions` into selected values in `x`
#' @param insertions A [shaker] function, or a character vector if you want to
#'   manually supply your own list of characters.
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_insert <- function(x, p = 0.2, n = 1, insertions) {
  stopifnot(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker function
  if (is.character(insertions))
    insertions <- fill_shakers(insertions)

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(x, p), m_nulls)

  # For each selected element of x, in what string position should the new character be inserted?
  x_si <- purrr::map(nchar(xm[xi]), sample.int, size = n)

  # Generate new values with inserted characters
  replacements <- purrr::map2_chr(xm[xi], x_si, function(xc, si) {
    multi_incorporate(xc, insertions, si)
  })

  xm[xi] <- replacements
  xm
}

salt_insert_puncutation <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = shaker$punctuation)
}

salt_insert_letters <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = letters)
}
