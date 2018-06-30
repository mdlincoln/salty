context("salt_insert")

test_that("insert punctuation", {
  punctuation_res <- purrr::map(battery, function(x) {
    salt_insert(x, p = 0.5, insertions = shaker$punctuation)
  })
  purrr::imap(punctuation_res, function(x, n) expect_is(x, class = "character", info = n))
  purrr::walk2(punctuation_res, battery_lengths, expect_length)
  purrr::imap(punctuation_res, function(x, n) {
    expect_true(any(purrr::map_lgl(x, function(y) {
      any(stringr::str_detect(y, stringr::fixed(dict_punctuation)))
    })), info = stringr::str_glue("battery test: {n}"))
  })
})

test_that("error on zero-length input", {
  expect_error(salt_insert(zero_length, insertions = shaker$punctuation))
})
