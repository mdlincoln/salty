#' Delete some characters from some values
#'
#' @inheritParams salt_substitute
#' @param pp Number between 0 and 1. Percent of characters to remove from selected values
#'
#' @return A character vector the same length as `x`
#'
#' @export
salt_delete <- function(x, p = 0.2, n = 1) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(xm, p), m_nulls)

  selected_x <- xm[xi]

  # For each selected element of x, in what string positions should characters be deleted?
  x_si <- pic_char_indices(selected_x, n)

  replacements <- purrr::map2_chr(selected_x, x_si, function(s, si) {
    split_x <- stringr::str_split(s, pattern = "")[[1]]
    pruned_x <- split_x[-si]
    res <- stringr::str_c(pruned_x, collapse = "")
    if (length(res) < 1)
      return("")
    res
  })

  xm[xi] <- replacements
  xm
}

salt_na <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- NA
  x
}

salt_empty <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- ""
  x
}