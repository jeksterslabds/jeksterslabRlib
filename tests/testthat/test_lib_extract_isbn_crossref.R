#' ---
#' title: "Test lib_extract_isbn_crossref"
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

#+ parameter_doi_single
doi_single <- "http://doi.org/10.1007/978-0-387-09616-2"
isbn_single_ebook <- "9780387096162"
isbn_single_print <- "9780387096155"

#' ### Single DOI

#' | Variable            | Description | Value                 |
#' |:--------------------|:------------|:----------------------|
#' | `doi_single`        | DOI         | `r doi_single`        |
#' | `isbn_single_ebook` | ISBN ebook  | `r isbn_single_ebook` |
#' | `isbn_single_print` | ISBN print  | `r isbn_single_print` |

#' ## Run test

#+ test
isbn_single_output <- lib_extract_isbn_crossref(doi = doi_single, par = FALSE)
isbn_single_output_ebook <- NA
isbn_single_output_print <- NA
for (i in 1:nrow(isbn_single_output)) {
  if (isbn_single_output[i, "isbn"] == isbn_single_ebook) {
    isbn_single_output_ebook <- isbn_single_output[i, "isbn"]
  }
  if (isbn_single_output[i, "isbn"] == isbn_single_print) {
    isbn_single_output_print <- isbn_single_output[i, "isbn"]
  }
}

#' ## Results

#' ### Single DOI

#' | Item       | Parameter             | Result                       |
#' |:-----------|:----------------------|:-----------------------------|
#' | ISBN ebook | `r isbn_single_ebook` | `r isbn_single_output_ebook` |
#' | ISBN print | `r isbn_single_print` | `r isbn_single_output_print` |

#+ testthat, echo=FALSE
test_that("the output of lib_extract_isbn_crossref is accurate", {
  expect_equivalent(
    isbn_single_ebook,
    isbn_single_output_ebook
  )
  expect_equivalent(
    isbn_single_print,
    isbn_single_output_print
  )
})
