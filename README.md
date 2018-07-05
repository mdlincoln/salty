<!-- README.md is generated from README.Rmd. Please edit that file -->

# salty

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

When teaching students how toc elan data, it helps to have data that
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

## Example

``` r
library(salty)
set.seed(10)

sample_names <- charlatan::ch_name(10)
sample_names
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"

# Use p to specify the percent of values that you would like to salt
salt_insert(sample_names, p = 0.5, insertions = shaker$punctuation)
#>  [1] "Edwin Kassulke"        "Barron Fadel"         
#>  [3] "Dorla Morissette"      "Manuela !Mante MD"    
#>  [5] "Ferris Kautzer"        "Dju/ana Hyatt"        
#>  [7] "%Dr. Leighton Ryan"    "Ms. ,Migdalia Smitham"
#>  [9] "Ottilia He(rmann"      "Benjiman Dach"

# Use n to specify how many character changes you would like to make in salted values
salt_delete(sample_names, p = 0.5, n = 3)
#>  [1] "Edwin Kassulke"     "BaronFadel"         "rla Moissette"     
#>  [4] "Manuela Mante MD"   "Ferris Kautzer"     "Djuana Hyatt"      
#>  [7] "Dr. Legton yan"     "Ms. Migaia Smitham" "Ottilia Hermann"   
#> [10] "Benjia Dch"
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
