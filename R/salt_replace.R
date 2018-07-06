#' Insert new characters into some values in a vector
#'
#' Inserts a selectino of characters into a percentage of
#'
#' @param x A vector. This will always be coerced to character during salting.
#' @param insertions A [replacement_shaker] function, or a named character vector of patterns and replacements.
#' @param p A number between 0 and 1. Percent of values in `x` that should be salted.
#' @param rep_p A number between 0 and 1. Probability that a given match should be replaced.
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_replace <- function(x, replacements, p = 0.1, rep_p = 0.5) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker function
  if (is.character(replacements)) {
    assertthat::assert_that(!is.null(names(replacements)))
    replacements <- fill_shakers(replacements)
  }

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(xm, p), m_nulls)

  selected_x <- xm[xi]

  # For each selected element of x, get potential replacement patterns
  pattern_match_indices <- purrr::map(selected_x, function(x) {
    shaker_patterns <- names(inspect_shaker(replacements))
    which(stringr::str_detect(x, fixed(shaker_patterns)))
  })

  # Generate new values with inserted characters
  replacements <- purrr::map2_chr(selected_x, pattern_match_indices, function(xc, si) {
    # If the string contains no pattern matches at all, then return the original value early
    if (length(si) == 0) return(xc)
    selective_replacement(xc, replacements(i = si), rep_p)
  })

  xm[xi] <- replacements
  xm
}

# Run str_replace_all given a string, a list of replacements, and a chance of replacement per match
selective_replacement <- function(x, replacements, rep_p) {
  assertthat::assert_that(is.proportion(rep_p))
  patterns <- stringr::str_c(names(replacements), collapse = "|")

  repfun <- function(m) {
    ifelse(runif(1) <= rep_p, replacements[m], m)
  }
  stringr::str_replace_all(x, pattern = patterns, replacement = repfun)
}

#' Salt a character vector with common OCR problems
salt_character_ocr <- function(x, p = 0.2, n = 1) {
  salt_replace(x, replacement_shaker$ocr_errors, p, n)
}

salt_capitalization <- function(x, p = 0.1, n) {
  salt_replace(x, replacement_shaker$capitalization, p, n)
}
