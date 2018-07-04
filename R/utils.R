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

pic_char_indices <- function(x, n) {
  purrr::map(x, function(y) {
    nchar_y <- nchar(y)

    if (n > nchar_y) {
      warning(stringr::str_glue("There are only {nchar_y} characters in x while n is sest to {n}. Returning only {nchar_y} positions"))
      n <- nchar_y
    }

    sample.int(nchar_y, size = n, replace = FALSE)
  })
}

# Given strings x and y and a pair of insertion positions, add y into x. Y will
# be inserted in between pos1 and pos2
single_incorporate <- function(x, y, pos1, pos2) {
  assertthat::assert_that(assertthat::is.string(x))
  assertthat::assert_that(assertthat::is.string(y))
  assertthat::assert_that(assertthat::is.count(pos1))
  assertthat::assert_that(assertthat::is.count(pos2))
  assertthat::assert_that(pos2 > pos1)

  head_segment <- stringr::str_sub(x, start = 1L, end = pos1)
  tail_segment <- stringr::str_sub(x, start = pos2, end = -1L)
  stringr::str_c(head_segment, y, tail_segment)
}

multi_incorporate <- function(x, insertions, positions) {
  pos <- sort(positions)
  assertthat::assert_that(all(positions %in% seq_len(nchar(x))))

  # After each loop, increase the adjustment size by the number of characters
  # inserted. For each subsequent index from the character indices of the
  # original string, increment position by one to account for those added
  # characters.
  adjustment_size <- 0
  for (i in seq_along(pos)) {
    # Select new characters to insert
    new_chars <- insertions(1)

    # Adjust insertion index based on prior adjustment size
    adjusted_si <- pos[i] + adjustment_size

    # Add new substring
    x <- single_incorporate(x, new_chars, adjusted_si, adjusted_si + 1)

    # Increase adjustment size for next round
    adjustment_size <- nchar(new_chars)
  }
  x
}
