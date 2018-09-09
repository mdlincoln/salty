#' Randomly swap out entire values in a vector
#'
#' Because `swaps` can be provided by either a character vector or a function
#' that returns a character vector, `salt_swap` can be fruitfully used in
#' conjunction with the [charlatan::charlatan] package to intersperse real data with
#' simulated data.
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
salt_swap <- function(x, swaps, p = 0.2) {
  assertthat::assert_that(length(x) > 0)
  xm <- as.character(x)

  # If a character vector is provided for insertions, then turn it into a shaker
  # function
  if (is.character(swaps))
    swaps <- fill_shakers(swaps)

  xi <- p_indices(xm, p)

  xm[xi] <- swaps(length(xi))

  xm
}
