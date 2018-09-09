wrapper_insert_test <- function(wrapper, selected_shaker, shaker_name) {
  context(str_glue("salt_insert: {shaker_name}"))

  test_that(str_glue("insert {shaker_name}"), {
    insert_res <- map(battery, function(x) {
      wrapper(x, p = 0.5)
    })
    imap(insert_res, function(x, n) expect_is(x, class = "character", info = n))
    walk2(insert_res, battery_lengths, expect_length)
    imap(insert_res, function(x, n) {
      expect_true(any(map_lgl(x, function(y) {
        any(str_detect(y, fixed(inspect_shaker(selected_shaker))))
      })), info = str_glue("shaker name: {shaker_name} - battery test: {n}"))
    })
  })

  test_that(str_glue("overload insert {shaker_name}"), {
    walk(battery, function(b) {
      expect_warning(salt_insert(b, insertions = selected_shaker, p = 0.5, n = 30))
    })
  })

  test_that("error on zero-length input", {
    expect_error(salt_insert(zero_length, insertions = selected_shaker))
  })
}

wrapper_insert_test(salt_letters, shaker$mixed_letters, "letters")
wrapper_insert_test(salt_punctuation, shaker$punctuation, "punctuation")
wrapper_insert_test(salt_whitespace, shaker$whitespace, "whitespace")
wrapper_insert_test(salt_digits, shaker$digits, "digits")

wrapper_replace_test <- function(wrapper, selected_shaker, shaker_name) {
  context(str_glue("salt_replace: {shaker_name}"))

  test_that(str_glue("replace {shaker_name}"), {
    replace_res <- map(battery, function(x) {
      wrapper(x, p = 0.5, rep_p = 1)
    })
    imap(replace_res, function(x, n) expect_is(x, class = "character", info = n))
    walk2(replace_res, battery_lengths, expect_length)
  })

  test_that("error on zero-length input", {
    expect_error(salt_replace(zero_length, replacements = selected_shaker))
  })
}

wrapper_replace_test(salt_capitalization, replacement_shaker$capitalization, "capitalization")
wrapper_replace_test(salt_decimal_commas, replacement_shaker$decimal_commas, "decimal_commas")
wrapper_replace_test(salt_ocr, replacement_shaker$ocr_errors, "ocr")
