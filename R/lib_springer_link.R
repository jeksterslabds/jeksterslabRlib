#' Generate Spinger Links from DOI.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_remove_doi_http
#' @param PDF Logical.
#'   If \code{TRUE}, returns links for \code{PDF} files.
#'   If \code{FALSE}, returns links for \code{EPUB} files.
#' @examples
#' # Single DOI
#' doi <- "10.1007/978-0-387-98141-3"
#' lib_springer_link(
#'   doi = doi,
#'   PDF = TRUE
#' )
#' lib_springer_link(
#'   doi = doi,
#'   PDF = FALSE
#' )
#' # Vector of DOIs
#' doi <- c(
#'   "https://doi.org/10.1007/978-0-387-71762-3",
#'   "10.1007/978-0-387-98141-3"
#' )
#' lib_springer_link(
#'   doi = doi,
#'   PDF = TRUE
#' )
#' lib_springer_link(
#'   doi = doi,
#'   PDF = FALSE
#' )
#' @export
lib_springer_link <- function(doi = "10.1007/978-0-387-79054-1",
                              PDF = TRUE) {
  doi <- lib_remove_doi_http(doi = doi)
  if (PDF) {
    prefix <- "https://link.springer.com/content/pdf/"
    suffix <- ".pdf"
  } else {
    prefix <- "https://link.springer.com/download/epub/"
    suffix <- ".epub"
  }
  paste0(
    prefix,
    doi,
    suffix
  )
}
