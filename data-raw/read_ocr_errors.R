# Read ocr errors into a dataframe
replacement_ocr_errors_raw <- read.csv("data-raw/ocr_errors.csv", stringsAsFactors = FALSE)
named_reps <- tibble::deframe(replacement_ocr_errors_raw)
replacement_ocr_errors <- purrr::set_names(x = names(named_reps), nm = unname(named_reps))
devtools::use_data(replacement_ocr_errors, overwrite = TRUE, internal = TRUE)
