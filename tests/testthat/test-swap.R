swap_test <- function(selected_shaker, shaker_name) {
  context(str_glue("salt_swap: {shaker_name}"))

  if (is.character(selected_shaker)) {
    shaker_contents <- selected_shaker
  } else {
    shaker_contents <- inspect_shaker(selected_shaker)
  }

  test_that(str_glue("swap {shaker_name}"), {
    swap_res <- map(battery, function(x) {
      salt_swap(x, swaps = selected_shaker, p = 0.5)
    })
    imap(swap_res, function(x, n) expect_is(x, class = "character", info = n))
    walk2(swap_res, battery_lengths, expect_length)
    imap(swap_res, function(x, n) {
      expect_true(any(map_lgl(x, function(y) {
        any(shaker_contents %in% y)
      })), info = str_glue("shaker name: {shaker_name} - battery test: {n}"))
    })
  })

  test_that("error on zero-length input", {
    expect_error(salt_swap(zero_length, swaps = selected_shaker))
  })
}

imap(c(shaker, list("literal" = literal_salts)), swap_test)
