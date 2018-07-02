# Read ocr errors into a dataframe
replacement_ocr_errors <- tibble::deframe(read.csv("data-raw/ocr_errors.csv", stringsAsFactors = FALSE))
devtools::use_data(replacement_ocr_errors, overwrite = TRUE, internal = TRUE)
