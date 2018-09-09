#' Insert new characters into some values in a vector
#'
#' Inserts a selection of characters into a percentage of values in the supplied
#' vector.
#'
#' @param x A vector. This will always be coerced to character during salting.
#' @param insertions A [shaker] function, or a character vector.
#' @param p A number between 0 and 1. Percent of values in `x` that should be
#'   salted.
#' @param n A positive integer. Number of times to add new values from
#'   `insertions` into selected values in `x` manually supply your own list of
#'   characters.
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_insert <- function(x, insertions, p = 0.2, n = 1) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker
  # function
  if (is.character(insertions))
    insertions <- fill_shakers(insertions)

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(xm, p), m_nulls)

  selected_x <- xm[xi]

  # For each selected element of x, in what string positions should new
  # characters be inserted?
  x_si <- pic_char_indices(selected_x, n)

  # Generate new values with inserted characters
  replacements <- purrr::map2_chr(selected_x, x_si, function(xc, si) {
    multi_incorporate(xc, insertions, si, overwrite = FALSE)
  })

  xm[xi] <- replacements
  xm
}
