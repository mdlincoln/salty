<!-- README.md is generated from README.Rmd. Please edit that file -->

# salty

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

When teaching students how to clean data, it helps to have data that
isn’t *too* clean already. **salty** offers functions for “salting”
clean data with problems often found in datasets in the wild, such as:

  - pseudo-OCR errors
  - inconsistent capitalization and spelling
  - invalid dates
  - unpredictable punctuation in numeric fields
  - missing values or empty strings

## Installation

You can install salty from github with:

``` r
# install.packages("devtools")
devtools::install_github("mdlincoln/salty")
```

## Usage

``` r
library(salty)
set.seed(10)

# We'll use charaltan to create some sample data

sample_names <- charlatan::ch_name(10)
sample_names
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"

sample_numbers <- charlatan::ch_double(10)
sample_numbers
#>  [1]  1.280597456  0.667415054  1.691754965  0.001261409 -0.742461312
#>  [6]  0.609684421 -0.989606379 -0.034848335  0.847159906  1.525498006
```

salty offers a few different ways of adding salt to your data:
inserting, substituting, replacing, and deleting.

`salt_insert` keeps all the characters in the original while adding new
ones, while `salt_substitute` overwrites those characters.

``` r
# Use p to specify the percent of values that you would like to salt
salt_insert(sample_names, shaker$punctuation, p = 0.5)
#>  [1] "Edwin Kassulke"       "Barron' Fadel"        "Dorla M%orissette"   
#>  [4] "M&anuela Mante MD"    "Ferri$s Kautzer"      "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] ")Benjiman Dach"

# Use n to specify how many new insertions/substitutions you want to make to selected values
salt_substitute(sample_names, shaker$punctuation, p = 0.5, n = 3)
#>  [1] "/dwin Ka/sulke%"      "Ba(ro& Fadel^"        "Dorla Morissette"    
#>  [4] "Man^ela Ma(te MD,"    "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] "#r. L,ighton R#an"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Be$jim'n Dac!"
```

Different flavors of salt are available using `shaker`, however you can
also supply your own character vector of possible replacements if you
like.

``` r
salt_insert(sample_names, shaker$mixed_letters, p = 0.5)
#>  [1] "Edwin Kassulke"        "Barron Fadel"         
#>  [3] "DorPla Morissette"     "Manuela Mante MD"     
#>  [5] "Ferris KauBtzer"       "Djuana Hyatt"         
#>  [7] "Dr. Leighton Rynan"    "Ms. Migdalia SmiVtham"
#>  [9] "OttiliKa Hermann"      "Benjiman Dach"

salt_insert(sample_numbers, shaker$digits, p = 0.5)
#>  [1] "1.288059745613008"   "0.6674715054241444"  "1.691754960457426"  
#>  [4] "0.00126140879361831" "-0.742461311814763"  "0.609684420504159"  
#>  [7] "-0.9896063879077806" "-0.0348483349098612" "0.847159905848433"  
#> [10] "1.592549800647527"

salt_insert(sample_names, c("foo", "bar", "baz"), p = 0.5)
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dbazorla Morissette" 
#>  [4] "Manuela Mante MD"     "Ferbarris Kautzer"    "barDjuana Hyatt"     
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hebazrmann"  
#> [10] "Benjimafoon Dach"
```

`salt_replace` is a bit more targeted: it works with pairs of patterns
and replacements, either contained in `replacement_shaker` or
user-specified. Use `rep_p` to set a probability of how many possible
replacements should actually get swapped out for any given
value.

``` r
salt_replace(sample_names, replacement_shaker$ocr_errors, p = 1, rep_p = 1)
#>  [1] "Edwvi'n Kassulke"      "BarroIn Fadel"        
#>  [3] "Dorla Morisfette"      "Mlanuela Mlante MD"   
#>  [5] "Ferris Kautzer"        "Djuana Hyatt"         
#>  [7] "Dr. LeiglhltoIn Ryan"  "Ms. Migdalia Smitlham"
#>  [9] "Ottilia Hermann"       "Benjiman Daclh"

salt_replace(sample_names, replacement_shaker$capitalization, p = 0.5, rep_p = 0.2)
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris kautzer"       "DjuanA hYAtt"        
#>  [7] "Dr. LeiGhton Ryan"    "Ms. Migdalia Smitham" "OttiLIa HerMann"     
#> [10] "Benjiman Dach"

salt_replace(sample_numbers, replacement_shaker$decimal_commas, p = 0.5, rep_p = 1)
#>  [1] "1,28059745613008"    "0.667415054241444"   "1.69175496457426"   
#>  [4] "0,00126140879361831" "-0,742461311814763"  "0,609684420504159"  
#>  [7] "-0.989606379077806"  "-0.0348483349098612" "0,847159905848433"  
#> [10] "1.52549800647527"
```

`salt_delete` will simply drop characters, while `salt_empty` and
`salt_na` will replace entire values.

``` r
salt_delete(sample_names, p = 0.5, n = 6)
#>  [1] "Edwin Kassulke"       "ar Fal"               "rla Moriste"         
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "Dan Hyt"             
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Otilia erm"          
#> [10] "enjimanc"

salt_empty(sample_names, p = 0.5)
#>  [1] "Edwin Kassulke"   "Barron Fadel"     "Dorla Morissette"
#>  [4] "Manuela Mante MD" "Ferris Kautzer"   ""                
#>  [7] ""                 ""                 ""                
#> [10] ""

salt_na(sample_names, p = 0.5)
#>  [1] "Edwin Kassulke"    "Barron Fadel"      "Dorla Morissette" 
#>  [4] NA                  NA                  NA                 
#>  [7] "Dr. Leighton Ryan" NA                  NA                 
#> [10] "Benjiman Dach"
```

## Related work

<https://github.com/paulhendricks/anonymizer>

<https://github.com/ropensci/charlatan>

## Acknowledgements

The common OCR replacement errors are partially derived from the sed
replacements specified in the [Royal Society Corpus
project](http://fedora.clarin-d.uni-saarland.de/rsc/access.html):
Knappen, Jörg, Fischer, Stefan, Kermes, Hannah, Teich, Elke, and
Fankhauser, Peter. 2017. “The Making of the Royal Society Corpus.” In
*Proceedings of the NoDaLiDa 2017 Workshop on Processing Historical
Language*. Göteborg, Sweden. Linköping University Electronic Press.
<http://www.ep.liu.se/ecp/article.asp?issue=133&article=003&volume=>.
