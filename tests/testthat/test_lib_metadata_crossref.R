#' ---
#' title: "Test: lib_metadata_crossref"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output: rmarkdown::html_vignette
#' vignette: >
#'   %\VignetteIndexEntry{Test: lib_metadata_crossref}
#'   %\VignetteEngine{knitr::rmarkdown}
#'   %\VignetteEncoding{UTF-8}
#' ---
#'
#+ setup
library(testthat)
library(jeksterslabRlib)
context("Test lib_metadata_crossref")
#'
#' ## Set test parameters
#'
#+ parameters_journal_doi_single
journal_doi_single <- "10.1016/j.adolescence.2014.04.012"
journal_doi_single_author <- "Pesigan, Ivan Jacob Agaloos and Luyckx, Koen and Alampay, Liane Peña"
journal_doi_single_title <- "Brief report: Identity processes in Filipino late adolescents and young adults: Parental influences and mental health outcomes"
journal_doi_single_journal <- "Journal of Adolescence"
book_doi_single <- "10.1007/978-0-387-98141-3"
book_doi_single_author <- "Wickham, Hadley"
book_doi_single_title <- "ggplot2"
book_doi_single_publisher <- "Springer New York"
book_doi_single_location <- "New York, NY"
#'
#' ### Journal Single DOI
#'
#' | Variable                     | Description | Value                          |
#' |:-----------------------------|:------------|:-------------------------------|
#' | `journal_doi_single_author`  | Author      | `r journal_doi_single_author`  |
#' | `journal_doi_single_title`   | Title       | `r journal_doi_single_title`   |
#' | `journal_doi_single_journal` | Journal     | `r journal_doi_single_journal` |
#'
#' ### Book Single DOI
#'
#' | Variable                    | Description | Value                         |
#' |:----------------------------|:------------|:------------------------------|
#' | `book_doi_single_author`    | Author      | `r book_doi_single_author`    |
#' | `book_doi_single_title`     | Title       | `r book_doi_single_title`     |
#' | `book_doi_single_publisher` | Publisher   | `r book_doi_single_publisher` |
#' | `book_doi_single_location`  | Location    | `r book_doi_single_location`  |
#'
#' ## Run test
#'
#+ test_01
journal_doi_single_output <- lib_metadata_crossref(doi = journal_doi_single, par = FALSE)
journal_doi_single_output_author <- journal_doi_single_output[1, "author"]
journal_doi_single_output_title <- journal_doi_single_output[1, "title"]
journal_doi_single_output_journal <- journal_doi_single_output[1, "container-title"]
#'
#+ test_02
book_doi_single_output <- lib_metadata_crossref(doi = book_doi_single, par = FALSE)
book_doi_single_output_author <- book_doi_single_output[1, "author"]
book_doi_single_output_title <- book_doi_single_output[1, "title"]
book_doi_single_output_publisher <- book_doi_single_output[1, "publisher"]
book_doi_single_output_location <- book_doi_single_output[1, "publisher-location"]
#'
#' ## Results
#'
#' ### Journal Single DOI
#'
#' | Item      | Parameter                      | Result                                |
#' |:----------|:-------------------------------|:--------------------------------------|
#' | Author    | `r journal_doi_single_author`  | `r journal_doi_single_output_author`  |
#' | Title     | `r journal_doi_single_title`   | `r journal_doi_single_output_title`   |
#' | Journal   | `r journal_doi_single_journal` | `r journal_doi_single_output_journal` |
#'
#' ### Book Single DOI
#'
#' | Item      | Parameter                     | Result                               |
#' |:----------|:------------------------------|:-------------------------------------|
#' | Author    | `r book_doi_single_author`    | `r book_doi_single_output_author`    |
#' | Title     | `r book_doi_single_title`     | `r book_doi_single_output_title`     |
#' | Publisher | `r book_doi_single_publisher` | `r book_doi_single_output_publisher` |
#' | Location  | `r book_doi_single_location`  | `r book_doi_single_output_location`  |
#'
#+ testthat_01, echo=FALSE
test_that("the output of lib_metadata_crossref for journal single DOI is accurate", {
  expect_equivalent(
    journal_doi_single_author,
    journal_doi_single_output_author
  )
  expect_equivalent(
    journal_doi_single_title,
    journal_doi_single_output_title
  )
  expect_equivalent(
    journal_doi_single_journal,
    journal_doi_single_output_journal
  )
})
#'
#+ testthat_02, echo=FALSE
test_that("the output of lib_metadata_crossref for book single DOI is accurate", {
  expect_equivalent(
    book_doi_single_author,
    book_doi_single_output_author
  )
  expect_equivalent(
    book_doi_single_title,
    book_doi_single_output_title
  )
  expect_equivalent(
    book_doi_single_publisher,
    book_doi_single_output_publisher
  )
  expect_equivalent(
    book_doi_single_location,
    book_doi_single_output_location
  )
})
