#' Replace certain patterns into some values in a vector
#'
#' Inserts a selection of characters into some values of x. Pair [salt_replace]
#' with the named vectors in [replacement_shaker], or supply your own named
#' vector of replacements. The convenience functions [salt_ocr] and
#' [salt_capitalization] are light wrappers around [salt_replace].
#'
#' @inheritParams salt_insert
#' @param replacements A [replacement_shaker] function, or a named character
#'   vector of patterns and replacements.
#' @param rep_p A number between 0 and 1. Probability that a given match should
#'   be replaced in one of the selected values.
#'
#' @return A character vector the same length as `x`
#'
#' @export
#' @examples
#'
#' x <- c("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
#'        "Nunc finibus tortor a elit eleifend interdum.",
#'        "Maecenas aliquam augue sit amet ultricies placerat.")
#'
#' salt_replace(x, replacement_shaker$capitalization, p = 0.5, rep_p = 0.2)
#'
#' salt_ocr(x, p = 1, rep_p = 0.5)
salt_replace <- function(x, replacements, p = 0.1, rep_p = 0.5) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker
  # function
  if (is.character(replacements)) {
    assertthat::assert_that(!is.null(names(replacements)),
                            msg = "salt_repalce requires a named character vector. Consult ?replacement_shaker")
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
    which(stringr::str_detect(x, shaker_patterns))
  })

  # Generate new values with inserted characters
  replacements <- purrr::map2_chr(selected_x, pattern_match_indices, function(xc, si) {
    # If the string contains no pattern matches at all, then return the original
    # value early
    if (length(si) == 0) return(xc)
    selective_replacement(xc, replacements(i = si), rep_p)
  })

  xm[xi] <- replacements
  xm
}

# Run str_replace_all given a string, a list of replacements, and a chance of
# replacement per match
selective_replacement <- function(x, replacements, rep_p) {
  assertthat::assert_that(is.proportion(rep_p))
  patterns <- stringr::str_c(names(replacements), collapse = "|")

  # For any given match, only replace conditional to a probability
  repfun <- function(m) {
    ifelse(stats::runif(1) <= rep_p, stringr::str_replace_all(m, replacements), m)
  }

  stringr::str_replace_all(x, pattern = patterns, replacement = repfun)
}
