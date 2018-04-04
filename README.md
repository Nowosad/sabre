
<!-- README.md is generated from README.Rmd. Please edit that file -->
sabre
=====

[![Travis build status](https://travis-ci.org/Nowosad/sabre.svg?branch=master)](https://travis-ci.org/Nowosad/sabre) [![Coverage status](https://codecov.io/gh/Nowosad/sabre/branch/master/graph/badge.svg)](https://codecov.io/github/Nowosad/sabre?branch=master)

The **sabre** (**S**patial **A**ssociation **B**etween **RE**gionalizations) is an R package for calculating a degree of spatial association between regionalizations or categorical maps. This package offers support for `sf` spatial objects, and the following methods:

-   the V-measure method
-   the MapCurve method (Hargrove et al., 2006)

Installation
------------

<!-- You can install the released version of sabre from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("sabre") -->
<!-- ``` -->
You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Nowosad/sabre")
```

Examples
--------

``` r
library(sabre)
library(sf)
data("regions1")
data("regions2")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
regions_vm = sabre_calc(regions1, z, regions2, z)
regions_vm
#> The SABRE results:
#> 
#>  V-measure: 0.36 
#>  Homogeneity: 0.32 
#>  Completeness: 0.42 
#> 
#>  The spatial objects could be retrived with:
#>  $map1  - the first map
#>  $map2 - the second map
```

``` r
data("eco_us")
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
eco_us_vm = sabre_calc(eco_us, PROVINCE, eco_us, SECTION)
eco_us_vm
#> The SABRE results:
#> 
#>  V-measure: 0.8 
#>  Homogeneity: 1 
#>  Completeness: 0.66 
#> 
#>  The spatial objects could be retrived with:
#>  $map1  - the first map
#>  $map2 - the second map
```

References
----------

-   Rosenberg, Andrew, and Julia Hirschberg. "V-measure: A conditional entropy-based external cluster evaluation measure." Proceedings of the 2007 joint conference on empirical methods in natural language processing and computational natural language learning (EMNLP-CoNLL). 2007.
-   Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg. "Mapcurves: a quantitative method for comparing categorical maps." Journal of Geographical Systems 8.2 (2006): 187.
