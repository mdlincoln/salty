
<!-- README.md is generated from README.Rmd. Please edit that file -->

# salty

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis-CI Build
Status](https://travis-ci.org/mdlincoln/salty.svg?branch=master)](https://travis-ci.org/mdlincoln/salty)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/mdlincoln/salty?branch=master&svg=true)](https://ci.appveyor.com/project/mdlincoln/salty)
[![Coverage
Status](https://img.shields.io/codecov/c/github/mdlincoln/salty/master.svg)](https://codecov.io/github/mdlincoln/salty?branch=master)

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

## Basic usage

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

salty offers several easy-to-use functions for adding common problems to
your data.

``` r
# Add in erroeous letters or puncutation
salt_letters(sample_names)
#>  [1] "Edwin Kassulke"       "Barroun Fadel"        "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kyautzer"      "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"
salt_punctuation(sample_names)
#>  [1] "Edwin K'assulke"      "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "D$juana Hyatt"       
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"

# Flip capitals
salt_capitalization(sample_names)
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. MigdalIa SmItHam" "Ottilia Hermann"     
#> [10] "Benjiman Dach"

# Introduce OCR errors. You can specify the proportion of values in the vector
# that should be salted, and the proportion of possible matches within a single
# value that should be changed.
salt_ocr(sample_names, p = 1, rep_p = 1)
#>  [1] "Edwvi'n Kassulke"      "BarroIn Fadel"        
#>  [3] "Dorla Morisfette"      "Mlanuela Mlante MD"   
#>  [5] "Ferris Kautzer"        "Djuana Hyatt"         
#>  [7] "Dr. LeiglhltoIn Ryan"  "Ms. Migdalia Smitlham"
#>  [9] "Ottilia Hermann"       "Benjiman Daclh"
```

`salt_delete` will simply drop characters from randomly selected values
in a vector, while `salt_empty` and `salt_na` will replace entire
values.

``` r
salt_delete(sample_names, p = 0.5, n = 6)
#>  [1] "Edwin Kassulke"   "Barron Fadel"     "Dor Morset"      
#>  [4] "Manuela Mante MD" "Feri Kauz"        "Djuana Hyatt"    
#>  [7] "r. Lightoan"      "MsMidala Smiha"   "OttliaHean"      
#> [10] "Benjiman Dach"

salt_empty(sample_names, p = 0.5)
#>  [1] ""                     ""                     "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     ""                     ""                    
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] ""

salt_na(sample_names, p = 0.5)
#>  [1] "Edwin Kassulke"       NA                     NA                    
#>  [4] NA                     "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] NA                     "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] NA
```

## Advanced usage

For more fine-grained control over the salting process, and for access
to a wider range of salting types, you can use the underlying functions
provided for: inserting, substituting, replacing.

The set of insertions and replacements are specified via `shakers`,
pre-filled character sets and pattern/replacement pairs that the `salt`
verbs then call.

``` r
available_shakers()
#> $shaker
#> [1] "punctuation"       "lowercase_letters" "uppercase_letters"
#> [4] "mixed_letters"     "whitespace"        "digits"           
#> 
#> $replacement_shaker
#> [1] "ocr_errors"     "capitalization" "decimal_commas"
```

`salt_insert` keeps all the characters in the original while adding new
ones, while `salt_substitute` overwrites those characters.

``` r
# Use p to specify the percent of values that you would like to salt
salt_insert(sample_names, shaker$punctuation, p = 0.5)
#>  [1] "Ed\"win Kassulke"      "B^arron Fadel"        
#>  [3] "Dorla Morissette"      "Manuela Mante MD"     
#>  [5] "Ferris Kautzer"        "Djuana Hyatt"         
#>  [7] "Dr. Leighton Ryan"     "Ms.( Migdalia Smitham"
#>  [9] "Ottil.ia Hermann"      "Benj$iman Dach"

# Use n to specify how many new insertions/substitutions you want to make to selected values
salt_substitute(sample_names, shaker$punctuation, p = 0.5, n = 3)
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "D/rla Mo.issette."   
#>  [4] "Manuela Mante MD"     "Ferris %a^t*er"       "Dju,na^Hyatt'"       
#>  [7] "Dr. Leighto\" *(an"   "Ms. Migdalia Smitham" "O%tili^ Hermann@"    
#> [10] "Benjiman Dach"
```

Different flavors of salt are available using `shaker`, however you can
also supply your own character vector of possible replacements if you
like.

``` r
salt_insert(sample_names, shaker$mixed_letters, p = 0.5)
#>  [1] "Edwin Kassulke"       "Barron FLadel"        "Dorla Morissette"    
#>  [4] "Manuela MantIe MD"    "Ferris Kautzer"       "Djuana Hyatt"        
#>  [7] "DrU. Leighton Ryan"   "Ms. Migdalia Smitham" "Ottilia Hermannn"    
#> [10] "Benjiman DachM"

salt_insert(sample_numbers, shaker$digits, p = 0.5)
#>  [1] "1.328059745613008"    "0.667415054241444"    "1.69175496457426"    
#>  [4] "0.001261408793618831" "-0.7424613118147763"  "0.6096844205304159"  
#>  [7] "-20.989606379077806"  "-0.0348483349098612"  "0.847159905848433"   
#> [10] "1.52549800647527"

salt_insert(sample_names, c("foo", "bar", "baz"), p = 0.5)
#>  [1] "Edwin Kassulke"       "Barron Fadel"         "Dorla Morissette"    
#>  [4] "Manuela Mantebaz MD"  "Ferrfoois Kautzer"    "Djuanabar Hyatt"     
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottbazilia Hermann"  
#> [10] "Benjiman Dacbarh"
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
#>  [1] "Edwin KassUlKe"       "bARRon FaDeL"         "Dorla Morissette"    
#>  [4] "MAnuelA MAnTe MD"     "fErris KautZer"       "Djuana Hyatt"        
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"

salt_replace(sample_numbers, replacement_shaker$decimal_commas, p = 0.5, rep_p = 1)
#>  [1] "1,28059745613008"    "0.667415054241444"   "1.69175496457426"   
#>  [4] "0.00126140879361831" "-0,742461311814763"  "0,609684420504159"  
#>  [7] "-0,989606379077806"  "-0.0348483349098612" "0.847159905848433"  
#> [10] "1,52549800647527"
```

You may also specify your own arbitrary character vector of possible
insertions.

``` r
salt_insert(sample_names, insertions = c("X", "Z"))
#>  [1] "Edwin Kassulke"       "Barron FadZel"        "Dorla Morissette"    
#>  [4] "Manuela Mante MD"     "Ferris Kautzer"       "Djuana HyatXt"       
#>  [7] "Dr. Leighton Ryan"    "Ms. Migdalia Smitham" "Ottilia Hermann"     
#> [10] "Benjiman Dach"
```

## Possible future work

  - Modifying date strings to introduce subtle errors like invalid dates
    (e.g. February 30th)
  - Simulting character encoding problems

## Related work

**salty** should *not* be used for anonymizing data; that’s not its
purpose. However, it does draw some inspiration from
[anonymizer](https://github.com/paulhendricks/anonymizer).

To *create* sample data for salting, take a look at
[charlatan](https://github.com/ropensci/charlatan).

## Acknowledgements

The common OCR replacement errors are partially derived from the `sed`
replacements specified in the [Royal Society Corpus
project](http://fedora.clarin-d.uni-saarland.de/rsc/access.html):
Knappen, Jörg, Fischer, Stefan, Kermes, Hannah, Teich, Elke, and
Fankhauser, Peter. 2017. “The Making of the Royal Society Corpus.” In
*Proceedings of the NoDaLiDa 2017 Workshop on Processing Historical
Language*. Göteborg, Sweden. Linköping University Electronic Press.
<http://www.ep.liu.se/ecp/article.asp?issue=133&article=003&volume=>.
