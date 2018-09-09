# Use charlatan to set up some character and numeric values to salt
library(purrr)
library(charlatan)
library(stringr)
library(tibble)

set.seed(1)

fake_names <- ch_name(25)
null_names <- c(fake_names, "")
na_names <- c(fake_names, NA_character_)

fake_numbers <- ch_currency(25)
na_numbers <- c(fake_numbers, NA_real_)

fake_integers <- ch_integer(25)
na_integers <- c(fake_integers, NA_real_)

zero_length <- character(0)

battery <- tibble::lst(
  fake_names,
  null_names,
  na_names,
  fake_numbers,
  na_numbers,
  fake_integers,
  na_integers
)

battery_lengths <- purrr::map_int(battery, length)

literal_salts <- c("foo", "bar", "bat")

literal_replacement_salts <- c("a" = "b", "i" = "e")

