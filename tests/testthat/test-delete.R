context("delete")

test_that("salt_na returns vector of same size", {
  salt_na_res <- map(battery, salt_na)
  imap(salt_na_res, function(x, n) expect_is(x, class = "character", info = n))
  walk2(salt_na_res, battery_lengths, expect_length)
  imap(salt_na_res, function(x, n) {
    expect_true(any(is.na(x)), info = str_glue("battery test: {n}"))
  })
})

test_that("salt_empty returns vector of same size", {
  salt_empty_res <- map(battery, salt_empty)
  imap(salt_empty_res, function(x, n) expect_is(x, class = "character", info = n))
  walk2(salt_empty_res, battery_lengths, expect_length)
  imap(salt_empty_res, function(x, n) {
    expect_true(any(!nzchar(x)), info = str_glue("battery test: {n}"))
  })
})
