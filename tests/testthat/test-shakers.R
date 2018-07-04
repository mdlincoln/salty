context("shakers")

test_that("fill_shakers rejects poor input", {
  expect_error(fill_shakers(1:5))
  expect_error(fill_shakers(character(0)))
})

test_that("fill_shakers returns a function", {
  expect_is(fill_shakers(letters), "function")
})

test_that("avilable shakers returns shaker names", {
  expect_equivalent(available_shakers(), list(names(shaker), names(replacement_shaker)))
})
