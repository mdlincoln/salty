# Constants used to fill up a shaker ----

# kv constants are replacement dictionaries used by salt_replace, and must be in the form of a named character vector
dict_ocr_errors <- c(
  "13" = "B",
  "B" = "13",
  "a" = "o",
  "O" = "0",
  "l" = "1",
  "l" = "I",
  "I" = "1",
  "$" = "S"
)

# dicts are unnamed character vectors
dict_punctuation <- c(",", ".", "/", "!", "@", "#", "$" , "%", "^" , "&", "*",
                      "(" , ")", "'", "\"", ";")

# Shaker function factory ----

# Factory that takes either a kv or a dict vector and produces a function that
# randomly samples a percentage of it (the default), or samples a specified
# number of values from it.
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
inspect_shaker <- function(f) {
  attr(f, which = "source", exact = TRUE)
}

#' Get a set of values to use in `salt_` functions
#'
#' Available shakers:
#'
#' - punctuation
#' - ocr_errors
#'
#' Call a shaker using the `$` operator.
#'
#' @examples
#' shaker$puncutation(l = 5)
shaker <- lapply(list(
  punctuation = dict_punctuation,
  ocr_erorrs = dict_ocr_errors,
  lowercase_letters = letters,
  uppercase_letters = LETTERS,
  mixed_letters = c(letters, LETTERS),
  digits = as.character(0:9)
), fill_shakers)
