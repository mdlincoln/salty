sale_replace <- function(x, replacements, p = 0.1, n = 1) {

}

#' Salt a character vector with common OCR problems
#'
#' @param x A character vector
#' @param p A number
salt_character_ocr <- function(x, p = 0.1, ocr_errors = ocr_errors) {
  stopifnot(is.numeric(x))
  xi <- p_indices(xc, p)

  x[xi] <- stringr::str_replace(x, )
}

salt_capitalization <- function(x, p = 0.1) {
  stopifnot(is.character(x))

  # Collect some indices
  x_nchar <- nchar(x, allowNA = TRUE)
  x_rep_i <- vapply(x_nchar, sample.int, FUN.VALUE = integer(1), size = 1)
}

salt_character_punctuation <- function(x, p = 0.5) {

}
