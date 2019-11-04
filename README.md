
<!-- README.md is generated from README.Rmd. Please edit that file -->

# entrymodels

<!-- badges: start -->

![CRAN version](https://www.r-pkg.org/badges/version/entrymodels)
![License](https://img.shields.io/github/license/gnjardim/entrymodels)
[![Travis build
status](https://travis-ci.org/gnjardim/entrymodels.svg?branch=master)](https://travis-ci.org/gnjardim/entrymodels)
<!-- badges: end -->

Tools for measuring empirically the effects of entry in concentrated
markets, based in Bresnahan and Reiss (1991).

## Installation

You can install the released version of entrymodels from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("entrymodels")
```

And the development version from
[GitHub](https://github.com/gnjardim/entrymodels) with:

``` r
# install.packages("devtools")
devtools::install_github("gnjardim/entrymodels")
```

## Example

This is a basic example which shows you how to estimate a basic entry
model with our sample data.

``` r
library(entrymodels)

tb <- load_example_data()
(em <- em_basic(tb, "Populacao", "n_agencias"))
#> # A tibble: 5 x 2
#>   market_size critical_values[,1]
#>         <int>               <dbl>
#> 1           1               5238.
#> 2           2              18961.
#> 3           3              42038.
#> 4           4              75638.
#> 5           5             162958.
```
