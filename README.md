
<!-- README.md is generated from README.Rmd. Please edit that file -->

# salty

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/salty)](https://cran.r-project.org/package=salty)
[![Downloads, grand
total](http://cranlogs.r-pkg.org/badges/grand-total/salty)](https://cranlogs.r-pkg.org/)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/mdlincoln/salty/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mdlincoln/salty/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/mdlincoln/salty/branch/master/graph/badge.svg)](https://app.codecov.io/gh/mdlincoln/salty?branch=master)
<!-- badges: end -->

When teaching students how to clean data, it helps to have data that
isn’t *too* clean already. **salty** offers functions for “salting”
clean data with problems often found in datasets in the wild, such as:

- pseudo-OCR errors
- inconsistent capitalization and spelling
- invalid dates
- unpredictable punctuation in numeric fields
- missing values or empty strings

## Installation

Install salty from CRAN with:

``` r
install.packages("salty")
```

You may install the development version of salty from github with:

``` r
# install.packages("devtools")
devtools::install_github("mdlincoln/salty")
```

## Basic usage

``` r
library(salty)
set.seed(10)

# We'll use charlatan to create some sample data

sample_names <- charlatan::ch_name(10)
sample_names
#>  [1] "Bradyn Witting"           "Glenn Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"     "Donte Beatty"            
#>  [5] "Jax Lueilwitz"            "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "Jacquline Hand"           "Dr. Newman Dietrich Sr."

sample_numbers <- charlatan::ch_double(10)
sample_numbers
#>  [1] -1.26519802 -0.37366156 -0.68755543 -0.87215883 -0.10176101 -0.25378053
#>  [7] -1.85374045 -0.07794607  0.96856634  0.18492596
```

salty offers several easy-to-use functions for adding common problems to
your data.

``` r
# Add in erroneous letters or punctuation
salt_letters(sample_names)
#>  [1] "Bradyn Witting"           "Glenn Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"     "Donte Beatty"            
#>  [5] "oJax Lueilwitz"           "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "JacqulTine Hand"          "Dr. Newman Dietrich Sr."
salt_punctuation(sample_names)
#>  [1] "Bradyn Witting"           "Gl,enn Trantow PhD"      
#>  [3] "Mariano Tromp-Willms"     "Donte Beatty"            
#>  [5] "Jax Lueilwitz"            "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr.' Cordero Effertz PhD"
#>  [9] "Jacquline Hand"           "Dr. Newman Dietrich Sr."

# Flip capitals
salt_capitalization(sample_names)
#>  [1] "Bradyn Witting"           "Glenn Trantow PhD"       
#>  [3] "MArIano Tromp-WillmS"     "Donte Beatty"            
#>  [5] "Jax Lueilwitz"            "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "Jacquline Hand"           "Dr. Newman Dietrich Sr."

# Introduce OCR errors. You can specify the proportion of values in the vector
# that should be salted, and the proportion of possible matches within a single
# value that should be changed.
salt_ocr(sample_names, p = 1, rep_p = 1)
#>  [1] "Bradyn Witti'ng"            "Glenn Tratltovvv PhD"      
#>  [3] "Mariallo Tromp-Willms"      "DoInte Beatty"             
#>  [5] "Jax Lueilwvitz"             "Esperanza Hane-Reiclhert"  
#>  [7] "MIr. Muhammad ZboIncak DDS" "MIr. Cordero Effertz PhD"  
#>  [9] "Jacqll1i'ne Ha nd"          "Dr. Newvman Dietriclh Sr."
```

`salt_delete` will simply drop characters from randomly selected values
in a vector, while `salt_empty` and `salt_na` will replace entire
values.

``` r
salt_delete(sample_names, p = 0.5, n = 6)
#>  [1] "rdy Witg"                "Glenn Trantow PhD"      
#>  [3] "Maiano romp-Wl"          "Donte Beatty"           
#>  [5] "Jax Lueilwitz"           "Esprna Hne-Rechrt"      
#>  [7] "Mr. Muhad Zocak DS"      "Mr. Cordero Effertz PhD"
#>  [9] "Jaulin n"                "Dr. Newman Dietrich Sr."

salt_empty(sample_names, p = 0.5)
#>  [1] ""                        "Glenn Trantow PhD"      
#>  [3] ""                        "Donte Beatty"           
#>  [5] "Jax Lueilwitz"           "Esperanza Hane-Reichert"
#>  [7] ""                        "Mr. Cordero Effertz PhD"
#>  [9] ""                        ""

salt_na(sample_names, p = 0.5)
#>  [1] "Bradyn Witting"           "Glenn Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"     NA                        
#>  [5] NA                         NA                        
#>  [7] "Mr. Muhammad Zboncak DDS" NA                        
#>  [9] NA                         "Dr. Newman Dietrich Sr."
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
#>  [1] "Bradyn Witting"            "Glenn #Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"      "(Donte Beatty"            
#>  [5] "Jax Lue*ilwitz"            "Esperanza H'ane-Reichert" 
#>  [7] "Mr. Muhammad Zbo'ncak DDS" "Mr. Cordero Effertz PhD"  
#>  [9] "Jacquline Hand"            "Dr. Newman Dietrich Sr."

# Use n to specify how many new insertions/substitutions you want to make to selected values
salt_substitute(sample_names, shaker$punctuation, p = 0.5, n = 3)
#>  [1] "Bradyn Witting"           "Glenn Trantow PhD"       
#>  [3] "Maria#o /r(mp-Willms"     "%onte B\"atty%"          
#>  [5] "Jax Lueil)i\"@"           "Espe#a)za Hane(Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "J'cqu/ine(Hand"           "Dr. Newman Dietrich Sr."
```

Different flavors of salt are available using `shaker`, however you can
also supply your own character vector of possible replacements if you
like.

``` r
salt_insert(sample_names, shaker$mixed_letters, p = 0.5)
#>  [1] "ABradyn Witting"          "Glenn Tqrantow PhD"      
#>  [3] "Mariano Tromp-Willms"     "Donte Beatty"            
#>  [5] "Jaxx Lueilwitz"           "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero TEffertz PhD"
#>  [9] "Jacquline Handg"          "Dr. Newman Dietrich Sr."

salt_insert(sample_numbers, shaker$digits, p = 0.5)
#>  [1] "-1.26519850215309"   "-0.373661555154702"  "-0.687555430387918" 
#>  [4] "-30.87215882671769"  "-0.101761006224816"  "-0.2537680530102462"
#>  [7] "-1.853740454457914"  "-0.0779460660753655" "0.96856634052454"   
#> [10] "0.1849259599590315"

salt_insert(sample_names, c("foo", "bar", "baz"), p = 0.5)
#>  [1] "Bradyn Witting"             "Glenn Trantow PhD"         
#>  [3] "barMariano Tromp-Willms"    "Donte bazBeatty"           
#>  [5] "Jax Lueilwitz"              "Efoosperanza Hane-Reichert"
#>  [7] "Mr. Muhammad Zboncak DDS"   "Mr. Corfoodero Effertz PhD"
#>  [9] "Jacquline Handbaz"          "Dr. Newman Dietrich Sr."
```

`salt_replace` is a bit more targeted: it works with pairs of patterns
and replacements, either contained in `replacement_shaker` or
user-specified. Use `rep_p` to set a probability of how many possible
replacements should actually get swapped out for any given value.

``` r
salt_replace(sample_names, replacement_shaker$ocr_errors, p = 1, rep_p = 1)
#>  [1] "Bradyn Witti'ng"            "Glenn Tratltovvv PhD"      
#>  [3] "Mariallo Tromp-Willms"      "DoInte Beatty"             
#>  [5] "Jax Lueilwvitz"             "Esperanza Hane-Reiclhert"  
#>  [7] "MIr. Muhammad ZboIncak DDS" "MIr. Cordero Effertz PhD"  
#>  [9] "Jacqll1i'ne Ha nd"          "Dr. Newvman Dietriclh Sr."

salt_replace(sample_names, replacement_shaker$capitalization, p = 0.5, rep_p = 0.2)
#>  [1] "BRadyn WiTting"           "Glenn Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"     "DoNte Beatty"            
#>  [5] "JAx LuEiLwitZ"            "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "JAcquline HAnd"           "Dr. Newman DiETrICh Sr."

salt_replace(sample_numbers, replacement_shaker$decimal_commas, p = 0.5, rep_p = 1)
#>  [1] "-1.2651980215309"    "-0.373661555154702"  "-0.687555430387918" 
#>  [4] "-0,87215882671769"   "-0.101761006224816"  "-0,253780530102462" 
#>  [7] "-1,85374045447914"   "-0.0779460660753655" "0,96856634052454"   
#> [10] "0,184925959990315"
```

You may also specify your own arbitrary character vector of possible
insertions.

``` r
salt_insert(sample_names, insertions = c("X", "Z"))
#>  [1] "XBradyn Witting"          "Glenn Trantow PhD"       
#>  [3] "Mariano Tromp-Willms"     "DoXnte Beatty"           
#>  [5] "Jax Lueilwitz"            "Esperanza Hane-Reichert" 
#>  [7] "Mr. Muhammad Zboncak DDS" "Mr. Cordero Effertz PhD" 
#>  [9] "Jacquline Hand"           "Dr. Newman Dietrich Sr."
```

## Possible future work

- Modifying date strings to introduce subtle errors like invalid dates
  (e.g. February 30th)
- Simulating character encoding problems

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
<https://aclanthology.org/W17-0503.pdf>.
