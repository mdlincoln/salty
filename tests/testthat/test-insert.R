context("salt_insert")

test_that("insert punctuation", {
  punctuation_res <- purrr::map(battery, function(x) {
    salt_insert(x, insertions = shaker$punctuation)
  })
  purrr::walk(punctuation_res, expect_is, class = "character")
  purrr::walk2(punctuation_res, battery_lengths, expect_length)
})
