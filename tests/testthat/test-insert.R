insert_test <- function(selected_shaker, shaker_name) {
  context(str_glue("salt_insert: {shaker_name}"))

  if (is.character(selected_shaker)) {
    shaker_contents <- selected_shaker
  } else {
    shaker_contents <- inspect_shaker(selected_shaker)
  }

  test_that(str_glue("insert {shaker_name}"), {
    insert_res <- map(battery, function(x) {
      salt_insert(x, p = 0.5, insertions = selected_shaker)
    })
    imap(insert_res, function(x, n) expect_is(x, class = "character", info = n))
    walk2(insert_res, battery_lengths, expect_length)
    imap(insert_res, function(x, n) {
      expect_true(any(map_lgl(x, function(y) {
        any(str_detect(y, fixed(shaker_contents)))
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

imap(c(shaker, list("literal" = literal_salts)), insert_test)
