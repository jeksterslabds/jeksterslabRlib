#' ---
#' title: "Test lib_remove_doi_prefix"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output:
#'   rmarkdown::github_document:
#'     toc: true
#' ---

#+ setup
library(testthat)
library(jeksterslabRlib)

#' ## Set test parameters

#+ parameters
doi_01 <- "http://doi.org/10.1016/j.adolescence.2014.04.012"
doi_02 <- "http://dx.doi.org/10.1016/j.adolescence.2014.04.012"
doi_03 <- "https://doi.org/10.1016/j.adolescence.2014.04.012"
doi_04 <- "https://dx.doi.org/10.1016/j.adolescence.2014.04.012"
doi_05 <- "10.1016/j.adolescence.2014.04.012"
doi_without_prefix <- "j.adolescence.2014.04.012"

#' | Variable             | Description          | Value                  |
#' |:---------------------|:---------------------|:-----------------------|
#' | `doi_01`             | DOI 1                | `r doi_01`             |
#' | `doi_02`             | DOI 2                | `r doi_02`             |
#' | `doi_03`             | DOI 3                | `r doi_03`             |
#' | `doi_04`             | DOI 4                | `r doi_04`             |
#' | `doi_05`             | DOI 5                | `r doi_05`             |
#' | `doi_without_prefix` | DOI (without prefix) | `r doi_without_prefix` |

#' ## Run test

#+ test
doi_result_01 <- lib_remove_doi_prefix(doi = doi_01)
doi_result_02 <- lib_remove_doi_prefix(doi = doi_02)
doi_result_03 <- lib_remove_doi_prefix(doi = doi_03)
doi_result_04 <- lib_remove_doi_prefix(doi = doi_04)
doi_result_05 <- lib_remove_doi_prefix(doi = doi_05)

#' ## Results

#' | Item  | Parameter  | Result            |
#' |:------|:-----------|:------------------|
#' | DOI 1 | `r doi_01` | `r doi_result_01` |
#' | DOI 2 | `r doi_02` | `r doi_result_02` |
#' | DOI 3 | `r doi_03` | `r doi_result_03` |
#' | DOI 4 | `r doi_04` | `r doi_result_04` |
#' | DOI 5 | `r doi_05` | `r doi_result_05` |

#+ testthat_01, echo=FALSE
test_that("the output of lib_remove_doi_prefix is accurate", {
  expect_equivalent(
    doi_without_prefix,
    doi_result_01,
    doi_result_02,
    doi_result_03,
    doi_result_04,
    doi_result_05
  )
})
