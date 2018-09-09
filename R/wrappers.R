# Wrap the core underlying functions within easy-to-use wrappers that expose
# common use cases.

#' Salt vectors with common data problems
#'
#' These are easy-to-use wrapper functions that call either [salt_insert] (for
#' including new characters) or [salt_replace] (for salting that requires
#' replacement of specific characters) with sane defaults.
#'
#' For a more fine-grained control over how characters are added and whether ,
#' see the documentation for [salt_insert], [salt_substitute], [salt_replace],
#' and [salt_delete].
#'
#' @name salt
#'
#' @inheritParams salt_insert
#' @inheritParams salt_replace
NULL

#' @describeIn salt Punctuation characters
#' @export
salt_punctuation <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = shaker$punctuation)
}

#' @describeIn salt Upper- and lower-case letters
#' @export
salt_letters <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = shaker$mixed_letters)
}

#' @describeIn salt Spaces
#' @export
salt_whitespace <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = shaker$whitespace)
}

#' @describeIn salt 0-9
#' @export
salt_digits <- function(x, p = 0.2, n = 1) {
  salt_insert(x, p, n, insertions = shaker$digits)
}

#' @describeIn salt Replace some substrings with common OCR problems
#' @export
salt_ocr <- function(x, p = 0.2, rep_p = 0.1) {
  salt_replace(x, replacement_shaker$ocr_errors, p, rep_p)
}

#' @describeIn salt Flip capitalization of letters
#' @export
salt_capitalization <- function(x, p = 0.1, rep_p = 0.1) {
  salt_replace(x, replacement_shaker$capitalization, p, rep_p)
}

#' @describeIn salt Flip decimals to commas and vice versa
#' @export
salt_decimal_commas <- function(x, p = 0.1, rep_p = 0.1) {
  salt_replace(x, replacement_shaker$decimal_commas, p, rep_p)
}
