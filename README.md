
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggrama

<!-- badges: start -->
<!-- badges: end -->

The goal of ggrama is to make it easy to plot Ramachandran diagrams from
a pdb file using ggplot2 graphics.

## Installation

You can install the development version of ggrama:

``` r
devtools::install_github("missuse/ggrama")
```

## Example

``` r
library(ggrama)

#download a pdb file
download.file("https://files.rcsb.org/download/2ADQ.pdb1.gz",
              dest = "2ADQ.pdb1.gz")

#plot by type of Ramachandran diagrams
ggrama("2ADQ.pdb1.gz") #general type the default
```

<img src="man/figures/README-example-1.png" width="50%" style="display: block; margin: auto;" />

``` r
ggrama("2ADQ.pdb1.gz", "pre.pro") #pre-proline, additional options are glycine and proline
```

<img src="man/figures/README-example-2.png" width="50%" style="display: block; margin: auto;" />

Or plot all four types in a grid

``` r
ggrama_all("2ADQ.pdb1.gz")
```

<img src="man/figures/README-example2-1.png" width="100%" />

Using contours:

``` r
ggrama_all("2ADQ.pdb1.gz",
           contour = TRUE, #contours
           smooth = TRUE, #interpolate background
           smoothing.param = "4") #coefficient of interpolation per dimension
```

<img src="man/figures/README-example3-1.png" width="100%" />
