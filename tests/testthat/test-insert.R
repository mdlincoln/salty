insert_test <- function(selected_shaker, shaker_name) {
  context(stringr::str_glue("Salt_insert: {shaker_name}"))

  test_that("insert punctuation", {
    punctuation_res <- purrr::map(battery, function(x) {
      salt_insert(x, p = 0.5, insertions = selected_shaker)
    })
    purrr::imap(punctuation_res, function(x, n) expect_is(x, class = "character", info = n))
    purrr::walk2(punctuation_res, battery_lengths, expect_length)
    purrr::imap(punctuation_res, function(x, n) {
      expect_true(any(purrr::map_lgl(x, function(y) {
        any(stringr::str_detect(y, stringr::fixed(inspect_shaker(selected_shaker))))
      })), info = stringr::str_glue("shaker name: {shaker_name} - battery test: {n}"))
    })
  })

  test_that("error on zero-length input", {
    expect_error(salt_insert(zero_length, insertions = selected_shaker))
  })
}

imap(shaker, insert_test)
