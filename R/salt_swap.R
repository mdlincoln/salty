#' Randomly swap out entire values in a vector
#'
#' @inheritParams salt_insert
#' @param swaps Values to be swapped out
#'
#' @return A character vector the same length as `x`
#'
#' @export
#' @examples
#' x <- c("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
#'        "Nunc finibus tortor a elit eleifend interdum.",
#'        "Maecenas aliquam augue sit amet ultricies placerat.")
#'
#' new_values <- c("foo", "bar", "baz")
#'
#' salt_swap(x, swaps = new_values, p = 0.5)
salt_swap <- function(x, insertions, p) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker function
  if (is.character(insertions))
    insertions <- fill_shakers(insertions)

  xi <- p_indices(xm, p)

  xm[xi] <- insertions(xi)
}
