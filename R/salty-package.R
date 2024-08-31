#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' salty: Turn Clean Data Into Messy Data
#'
#' Insert, delete, replace, and substitute bits of your data with messy values.
#'
#' Convenient wrappers such as [salt_punctuation] are provided for quick access
#' to this package's functionality with simple defaults. For more fine-grained
#' control, use one of the underlying `salt_` functions:
#'
#' - [salt_insert] will insert new characters into some of the values of `x`. All
#' the original characters of the original values will be maintained.
#'
#' - [salt_substitute] will substitute some characters in some of the values of
#' `x` in place of some of the original characters.
#'
#' - [salt_replace] will replace some characters in some of the values of `x`.
#' Unlike [salt_substitute], [salt_replace] does conditional replacement dependent
#' on the original values of `x`, such as changing capitalization or simulating
#' OCR errors based on certain character combinations.
#'
#' - [salt_delete] will remove some characters in the values of `x`
#'
#' - [salt_na] and [salt_empty] will replace some values of `x` with `NA` or with
#' empty strings.
#'
#' - [salt_swap] replaces entire values of `x` with new strings
#'
#' @name salty
## usethis namespace: end
NULL
