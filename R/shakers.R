# replacement constants ----
# replacement dictionaries used by salt_replace, and must be in the form of a named character vector

load("R/sysdata.rda")

# replacement_ocr_errors is saved as a named vector object in data/dict_ocr_errors.rda

# dict constants ---
# dicts are unnamed character vectors used by salt_insert or salt_replace

dict_punctuation <- c(",", ".", "/", "!", "@", "#", "$" , "%", "^" , "&", "*",
                      "(" , ")", "'", "\"", ";")

# Shaker function factory ----

# Factory that takes either a replacement or a dict vector and produces a
# function that randomly samples a percentage of it (the default), or samples a
# specified number of values from it.
fill_shakers <- function(v) {
  stopifnot(is.character(v))
  stopifnot(length(v) > 0)

  f <- function(p = 0.5, l = NULL) {
    if (is.null(l)) {
      vi <- p_indices(v, p)
      return(v[vi])
    }
    sample(v, size = l, replace = TRUE)
  }

  structure(f, source = v)
}

#' Access the original source vector for a given shaker function
#'
#' @export
#' @examples
#' inspect_shaker(shaker$punctuation)
inspect_shaker <- function(f) {
  attr(f, which = "source", exact = TRUE)
}

#' Get a set of values to use in `salt_` functions
#'
#' [shaker] is used with [salt_insert] and [salt_substitute]
#'
#' - punctuation
#'
#' [replacement_shaker] is for [salt_replace], and contains conditional dictionaries
#'
#' Call a shaker using the `$` operator.
#'
#' @export
#' @examples
#' shaker$puncutation(l = 5)
shaker <- lapply(list(
  punctuation = dict_punctuation,
  lowercase_letters = letters,
  uppercase_letters = LETTERS,
  mixed_letters = c(letters, LETTERS),
  digits = as.character(0:9)
), fill_shakers)

#' @rdname shaker
#' @export
replacement_shaker <- lapply(list(
  ocr_errors = replacement_ocr_errors
), fill_shakers)

#' @describeIn shaker Get the names of available shakers
#' @export
available_shakers <- function() {
  list(
    shaker = names(salty::shaker),
    replacement_shaker = names(salty::replacement_shaker)
  )
}
