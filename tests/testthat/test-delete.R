context("salt_delete")

test_that("salt_delete returns vector of same size", {
  salt_delete_res <- map(battery, salt_delete)
  walk2(salt_delete_res, battery_lengths, expect_length)
  pmap(list(res = salt_delete_res, b = battery, bname = names(battery)), function(res, b, bname) {
    expect_true(any(nchar(res) < nchar(b)), info = str_glue("battery test: {bname}"))
  })
})

test_that("salt_na returns vector of same size", {
  salt_na_res <- map(battery, salt_na)
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
