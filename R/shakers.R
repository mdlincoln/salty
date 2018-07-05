# replacement constants ----
# replacement dictionaries used by salt_replace, and must be in the form of a named character vector

load("R/sysdata.rda")

# replacement_ocr_errors is saved as a named vector object in data/dict_ocr_errors.rda

# dict constants ---
# dicts are unnamed character vectors used by salt_insert or salt_replace

dict_punctuation <- c(",", ".", "/", "!", "@", "#", "$" , "%", "^" , "&", "*",
                      "(" , ")", "'", "\"", ";")

dict_blank <- ""

dict_whitespace <- " "

# Shaker function factory ----

# Factory that takes either a replacement or a dict vector and produces a
# function that randomly samples a percentage of it (the default), or samples a
# specified number of values from it.
fill_shakers <- function(v) {
  stopifnot(is.character(v))
  stopifnot(length(v) > 0)

  f <- function(l = NULL, p = 0.5) {
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
#' [shaker] contains various character sets to be added to your data using [salt_insert] and [salt_substitute].
#' [replacement_shaker] is for [salt_replace], and contains pairlists that replace matched patterns in your data.
#'
#' @return A sampling function that will be called by [salt_insert], [salt_substitute], or [salt_replace].
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
  blanks = dict_blank,
  whitespace = dict_whitespace,
  digits = as.character(0:9)
), fill_shakers)


#' @rdname shaker
#' @export
replacement_shaker <- lapply(list(
  ocr_errors = replacement_ocr_errors
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
