#' salty: Turn Clean Data Into Messy Data
#'
#' Insert, delete, replace, and substitute bits of your data with messy values.
#'
#' - [str_insert] will insert new characters into some of the values of `x`. All
#' the original characters of the original values will be maintained.
#'
#' - [str_substitute] will substitute some characters in some of the values of
#' `x` in place of some of the original characters.
#'
#' - [str_replace] will replace some characters in some of the values of `x`.
#' Unlike [str_substitute], [str_replace] does conditional replacement dependent
#' on the original values of `x`, such as changing capitalization or simulating
#' OCR errors based on certain character combinations.
#'
#' - [str_delete] will remove some characters in the values of `x`
#'
#' - [str_na] and [str_empty] will replace some values of `x` with `NA` or with
#' empty strings.
#'
#' @docType package
#' @name salty
NULL
