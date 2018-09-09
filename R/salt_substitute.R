#' Substitute certain characters in a vector
#'
#' @inheritParams salt_insert
#'
#' @param substitutions Values to be substituted in
#'
#' @return A character vector the same length as `x`
#'
#' @export
#' @examples
#' x <- c("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
#'        "Nunc finibus tortor a elit eleifend interdum.",
#'        "Maecenas aliquam augue sit amet ultricies placerat.")
#'
#' salt_substitute(x, shaker$digits, p = 0.5, n = 5)
salt_substitute <- function(x, substitutions, p = 0.2, n = 1) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker
  # function
  if (is.character(substitutions))
    substitutions <- fill_shakers(substitutions)

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
    multi_incorporate(xc, substitutions, si, overwrite = TRUE)
  })

  xm[xi] <- replacements
  xm
}
