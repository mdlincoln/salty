context("utils")

test_that("p_indices rejects invalid inputs", {
  expect_error(p_indices(iris, 0.2))
  expect_error(p_indices(letters, 2))
  expect_error(p_indices(letters, -1))
})


test_that("p_indices always returns indices within x", {
  p_index_res <- p_indices(letters, 0.3)
  expect_is(p_index_res, "integer")
  expect_true(all(p_index_res) %in% seq_along(letters))
})
