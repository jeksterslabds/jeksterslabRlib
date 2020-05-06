#' ---
#' title: "Test lib_isbn2googlebookid"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output: rmarkdown::html_vignette
#' vignette: >
#'   %\VignetteIndexEntry{Test: lib_isbn2googlebookid}
#'   %\VignetteEngine{knitr::rmarkdown}
#'   %\VignetteEncoding{UTF-8}
#' ---
#'
#+ setup
library(testthat)
library(jeksterslabRlib)
context("Test lib_isbn2googlebookid")
#'
#' ## Set test parameters
#'
#+ parameter_isbn_single
isbn_single <- "978-0-387-09616-2"
googlebooksid_single <- "9Aq5k0hZLykC"
#'
#' ### Single ISBN
#'
#' | Variable               | Description     | Value                    |
#' |:-----------------------|:----------------|:-------------------------|
#' | `isbn_single`          | ISBN            | `r isbn_single`          |
#' | `googlebooksid_single` | Google Books ID | `r googlebooksid_single` |
#'
#' ## Run test
#'
#+ test
isbn_single_output <- lib_isbn2googlebooksid(isbn = isbn_single, par = FALSE)
googlebooksid_single_output <- isbn_single_output[1, "google"]
#'
#' ## Results
#'
#' ### Single ISBN
#'
#' | Item            | Parameter                | Result                          |
#' |:----------------|:-------------------------|:--------------------------------|
#' | Google Books ID | `r googlebooksid_single` | `r googlebooksid_single_output` |
#'
#+ testthat, echo=FALSE
test_that("the output of lib_isbn2googlebooksid is accurate", {
  expect_equivalent(
    googlebooksid_single,
    googlebooksid_single_output
  )
})
