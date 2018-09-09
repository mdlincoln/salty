# replacement constants ----
# replacement dictionaries used by salt_replace, and must be in the form of a
# named character vector

load("R/sysdata.rda")

replacement_capitalization <- purrr::set_names(c(letters, LETTERS), c(LETTERS, letters))

replacement_decimal_commas <- c("\\." = ",")

# replacement_ocr_errors is saved as a named vector object in
# data/dict_ocr_errors.rda

# dict constants ---
# dicts are unnamed character vectors used by salt_insert or salt_replace

dict_punctuation <- c(",", ".", "/", "!", "@", "#", "$" , "%", "^" , "&", "*",
                      "(" , ")", "'", "\"", ";")

dict_whitespace <- " "

# Shaker function factory ----

# Factory that takes either a replacement or a dict vector and produces a
# function that randomly samples a percentage of it (the default), or samples a
# specified number of values from it.
fill_shakers <- function(v) {
  assertthat::assert_that(is.character(v))
  assertthat::assert_that(length(v) > 0)

  f <- function(n = NULL, i = NULL, p = 0.5) {

    # If a length is supplied, sample vector l times with replacement
    if (!is.null(n)) {
      assertthat::assert_that(assertthat::is.count(n))
      return(sample(v, size = n, replace = TRUE))
    }

    # If exact indices are supplied, return i positions of the vector
    if (!is.null(i)) {
      assertthat::assert_that(is.integer(i))
      assertthat::assert_that(all(i) %in% seq_along(v))
      return(v[i])
    }

    # If a proportion is supplied, sample that proportion of the vector
    assertthat::assert_that(is.proportion(p))
    vi <- p_indices(v, p)
    return(v[vi])
  }

  structure(f, source = v)
}

#' Access the original source vector for a given [shaker] function
#'
#' @param f A [shaker] function
#'
#' @return A character vector
#'
#' @export
#' @examples
#' inspect_shaker(shaker$punctuation)
inspect_shaker <- function(f) {
  attr(f, which = "source", exact = TRUE)
}

#' Get a set of values to use in `salt_` functions
#'
#' [shaker] contains various character sets to be added to your data using
#' [salt_insert] and [salt_substitute]. [replacement_shaker] is for
#' [salt_replace], and contains pairlists that replace matched patterns in your
#' data.
#'
#' @return A sampling function that will be called by [salt_insert],
#'   [salt_substitute], or [salt_replace].
#'
#' @name shaker
NULL

#' @rdname shaker
#' @export
#' @examples
#' salt_insert(letters, shaker$punctuation)
shaker <- lapply(list(
  punctuation = dict_punctuation,
  lowercase_letters = letters,
  uppercase_letters = LETTERS,
  mixed_letters = c(letters, LETTERS),
  whitespace = dict_whitespace,
  digits = as.character(0:9)
), fill_shakers)


#' @rdname shaker
#' @export
replacement_shaker <- lapply(list(
  ocr_errors = replacement_ocr_errors,
  capitalization = replacement_capitalization,
  decimal_commas = replacement_decimal_commas
), fill_shakers)

#' @rdname shaker
#' @export
#' @examples
#' available_shakers()
available_shakers <- function() {
  list(
    shaker = names(shaker),
    replacement_shaker = names(replacement_shaker)
  )
}

is.proportion <- function(x) {
  assertthat::assert_that(assertthat::is.number(x))
  x >= 0 & x <= 1
}
