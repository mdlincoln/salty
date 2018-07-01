# Read ocr errors into a dataframe
dict_ocr_errors <- tibble::deframe(read.csv("data-raw/ocr_errors.csv", stringsAsFactors = FALSE))
devtools::use_data(dict_ocr_errors, overwrite = TRUE)
