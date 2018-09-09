replace_test <- function(selected_shaker, shaker_name) {
  context(str_glue("salt_replace: {shaker_name}"))

  test_that(str_glue("replace {shaker_name}"), {
    replace_res <- map(battery, function(x) {
      salt_replace(x, replacements = selected_shaker, p = 0.5, rep_p = 1)
    })
    imap(replace_res, function(x, n) expect_is(x, class = "character", info = n))
    walk2(replace_res, battery_lengths, expect_length)
  })

  test_that("error on zero-length input", {
    expect_error(salt_replace(zero_length, replacements = selected_shaker))
  })
}

imap(replacement_shaker, replace_test)

expect_error(salt_replace(letters, replacements = LETTERS))
