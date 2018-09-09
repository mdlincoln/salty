#' Delete some characters from some values
#'
#' @inheritParams salt_substitute
#'
#' @return A character vector the same length as `x`
#'
#' @export
#' @examples
#' x <- c("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
#'        "Nunc finibus tortor a elit eleifend interdum.",
#'        "Maecenas aliquam augue sit amet ultricies placerat.")
#'
#' salt_delete(x, p = 0.5, n = 5)
#'
#' salt_empty(x, p = 0.5)
#'
#' salt_na(x, p = 0.5)
salt_delete <- function(x, p = 0.2, n = 1) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # Find any empty or NA values.
  m_nulls <- which(is.na(xm) | !nzchar(xm))
  # Skip m_nulls when picking which values of x to modify
  xi <- setdiff(p_indices(xm, p), m_nulls)

  selected_x <- xm[xi]

  # For each selected element of x, in what string positions should characters
  # be deleted?
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

#' Remove entire values from a vector
#' @param x A vector
#' @param p A number between 0 and 1. Proportion of values to edit.
#'
#' @return A vector the same length as `x`
#' @name salt_na
NULL

#' @rdname salt_na
#' @export
salt_na <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- NA
  x
}

#' @rdname salt_na
#' @export
salt_empty <- function(x, p = 0.2) {
  xi <- p_indices(x, p)
  x[xi] <- ""
  x
}
