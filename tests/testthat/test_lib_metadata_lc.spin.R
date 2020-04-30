#' ---
#' title: "Test lib_metadata_lc"
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

#+ parameter_isbn_single
lccn_single <- "2008938643"
call_number_single <- "QA278.2 .R577 2008"

#' ### Single ISBN

#' | Variable             | Description | Value                  |
#' |:---------------------|:------------|:-----------------------|
#' | `lccn_single`        | LCCN        | `r lccn_single`        |
#' | `call_number_single` | LCC         | `r call_number_single` |

#' ## Run test

#+ test
lccn_single_output <- lib_metadata_lc(lccn = lccn_single, par = FALSE)
call_number_single_output <- lccn_single_output[1, "call_number"]

#' ## Results

#' ### Single ISBN

#' | Item | Parameter              | Result                        |
#' |:-----|:-----------------------|:------------------------------|
#' | LCC  | `r call_number_single` | `r call_number_single_output` |

#+ testthat, echo=FALSE
test_that("the output of lib_metadata_lc is accurate", {
  expect_equivalent(
    call_number_single,
    call_number_single_output
  )
})
