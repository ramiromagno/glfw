
<!-- README.md is generated from README.Rmd. Please edit that file -->

# glfw <img src="man/figures/logo.svg" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/glfw)](https://CRAN.R-project.org/package=glfw)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{glfw}` is an R Interface to the GLFW C Library:
<https://www.glfw.org>.

## Installation

`{glfw}` depends on the [GLFW](https://www.glfw.org/) C library. Install
it first before trying to install `{glfw}`.

You can install the development version of `{glfw}` like so:

``` r
# install.packages("remotes")
remotes::install_github("ramiromagno/glfw")
```

## Usage

Currently the package functionality can be tested out by running the
examples contained in the folder inst/tutorials. The examples provided
are taken from two online resources:

-   <https://learnopengl.com/>
-   <https://ogldev.org/>

The original examples are written in C/C++ but are here adapted to R.

## Code organization

1.  Typically, a src/ file has an accompanying R/ file.
2.  Source files starting with `glfw_` provide the GLFW API which this
    package is all about.
3.  Source files starting with `glm_` provide the GLM API in R code.
4.  Source files starting with `gl_` provide the OpenGL API.
5.  Source files starting with `r_` provide novel API but that is not
    GLFW API per se, typically utility functions.
6.  GL and GLFW constants are generated in data-raw/ and exported as
    datasets.

## Admonition

This R package is still very early in its development and is hardly
usable at the moment. Feedback and contributions are very welcome
nevertheless.
