
<!-- README.md is generated from README.Rmd. Please edit that file -->

# entrymodels: Estimate Entry Models

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/entrymodels?color=orange)](https://cran.r-project.org/package=entrymodels)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/entrymodels?color=blue)](https://cran.r-project.org/package=entrymodels)
[![Travis build
status](https://travis-ci.org/gnjardim/entrymodels.svg?branch=master)](https://travis-ci.org/gnjardim/entrymodels)
<!-- badges: end -->

Tools for measuring empirically the effects of entry in concentrated
markets, based in [Bresnahan and Reiss
(1991)](https://www.jstor.org/stable/2937655).

## Installation

You can install the released version of `entrymodels` from
[CRAN](https://CRAN.R-project.org/package=entrymodels) with:

``` r
install.packages("entrymodels")
```

And the development version from
[GitHub](https://github.com/gnjardim/entrymodels) with:

``` r
# install.packages("devtools")
devtools::install_github("gnjardim/entrymodels")
```

Which should return something similar to:

    * installing *source* package 'entrymodels' ...
    ** using staged installation
    ** R
    ** inst
    ** byte-compile and prepare package for lazy loading
    ** help
    *** installing help indices
      converting help for package 'entrymodels'
        finding HTML links ... done
        aux_matrix                              html  
        br1                                     html  
        br2                                     html  
        em_2var                                 html  
        em_basic                                html  
        load_example_data                       html  
    ** building package indices
    ** testing if installed package can be loaded from temporary location
    *** arch - i386
    *** arch - x64
    ** testing if installed package can be loaded from final location
    *** arch - i386
    *** arch - x64
    ** testing if installed package keeps a record of temporary installation path
    * DONE (entrymodels)

Please note that you should have
[Rtools](https://cran.r-project.org/bin/windows/Rtools/) installed.

## Examples

### Basic Model

This is a basic example which shows you how to estimate a basic entry
model with our sample data.

``` r
library(entrymodels)

tb <- load_example_data()
(em <- em_basic(tb, "Populacao", "n_agencias"))
#> # A tibble: 5 x 4
#>   n_competitors critical_values[,1] alpha[,1] gamma[,1]
#>           <int>               <dbl>     <dbl>     <dbl>
#> 1             1               5238.     0.832      7.12
#> 2             2              18961.     0.832      8.19
#> 3             3              42038.     0.825      8.79
#> 4             4              75638.     0.819      9.20
#> 5             5             162958.     0.809      9.71
```

### Two-Variable Model

This is a basic example which shows you how to estimate a two-variable
entry model with our sample data.

``` r
library(entrymodels)

tb <- load_example_data()
(em <- em_2var(tb, "Populacao", "RendaPerCapita", "n_agencias"))
#> # A tibble: 5 x 4
#>   n_competitors critical_values[,1] alpha[,1] gamma[,1]
#>           <int>               <dbl>     <dbl>     <dbl>
#> 1             1               5127.      1.06      17.8
#> 2             2              19265.      1.06      19.2
#> 3             3              44458.      1.05      20.0
#> 4             4              79959.      1.05      20.6
#> 5             5             169059.      1.03      20.9
```

## Citation

To cite package `entrymodels` in publications use:

> Guilherme N. Jardim (2020). entrymodels: Estimate Entry Models. R
> package version 0.2.0.
> <https://CRAN.R-project.org/package=entrymodels>

A BibTeX entry for LaTeX users is:

``` 
  @Manual{entrymodels,
    title = {entrymodels: Estimate Entry Models},
    author = {Guilherme {N. Jardim}},
    year = {2020},
    note = {R package version 0.2.0},
    url = {https://CRAN.R-project.org/package=entrymodels},
  }
```
