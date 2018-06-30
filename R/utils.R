#' Sample a proportion of indices of a vector
#'
#' @param x A vector
#' @param p A numeric probability between 0 and 1
#'
#' @return An integer vector of indices.
p_indices <- function(x, p) {
  stopifnot(is.vector(x))
  stopifnot(assertthat::is.number(p) & p <= 1 & p >= 0)

  l <- length(x)
  sample.int(l, size = ceiling(l * p))
}

# Take a named character vector and expand it to include all combos of names and values
mirror <- function(v) {
  stopifnot(!is.null(names(v)))
  stopifnot(is.character(v))

  all_names <- names(v)
  all_values <- unname(v)

  res <- c(all_names, all_values)
  names(res) <- c(all_values, all_names)
  unique(res)
}
