#' Put salt in a data.frame
#'
#' @param tbl The table to ensalt
#' @param ... The column to ensalt. Can be combined with tidyselect helpers.
#' @param salt The salt function
#'
#' @return A dataframe with some salt in it
#' @export
#' @rdname ensalt
#' @importFrom dplyr mutate_at vars
#'
#' @examples
#' ensalt(iris, Sepal.Length, Sepal.Width, salt = salt_na)
#' ensalt(iris, contains("Sepal"), salt = salt_na)


ensalt <- function(x, ..., salt = salt_na) {
  UseMethod("ensalt")
}

#' @export
#' @rdname ensalt
ensalt.data.frame <- function(x, ..., salt = salt_na) {
  mutate_at(x, .vars =  vars(...), .funs = salt)
}
