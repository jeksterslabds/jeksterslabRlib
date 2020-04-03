#' Extract ISBN from the result of lib_metadata_crossref.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_metadata_crossref
#' @param fromdoi Logical.
#'   If \code{TRUE}, uses the argument \code{doi}
#'   and the function \code{lib_metadata_crossref}
#'   to generate ISBN.
#'   If \code{FALSE}, uses the argument \code{cf}
#'   to generate ISBN.
#' @param cf R Object.
#'   Result of \code{lib_metadata_crossref}.
#' @examples
#' # Single DOI
#' doi <- "10.1007/978-0-387-98141-3"
#' cf <- lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' lib_extract_isbn_crossref(
#'   fromdoi = TRUE,
#'   doi = doi,
#'   par = FALSE
#' )
#' lib_extract_isbn_crossref(
#'   fromdoi = FALSE,
#'   cf = cf,
#'   par = FALSE
#' )
#' # Vector of DOIs
#' doi <- c(
#'   "https://doi.org/10.1007/978-0-387-71762-3",
#'   "10.1007/978-0-387-98141-3"
#' )
#' cf <- lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' lib_extract_isbn_crossref(
#'   fromdoi = TRUE,
#'   doi = doi,
#'   par = FALSE
#' )
#' lib_extract_isbn_crossref(
#'   fromdoi = FALSE,
#'   cf = cf,
#'   par = FALSE
#' )
#' @export
lib_extract_isbn_crossref <- function(fromdoi = TRUE,
                                      doi = NULL,
                                      cf = NULL,
                                      par = TRUE,
                                      ncores = NULL) {
  if (!is.null(doi)) {
    doi <- lib_remove_doi_http(doi = doi)
  }
  if (fromdoi) {
    cf <- lib_metadata_crossref(
      doi = doi,
      par = par,
      ncores = ncores
    )
  }
  cf_isbn <- cf[, "ISBN"]
  isbn <- as.vector(
    unlist(
      strsplit(
        x = cf_isbn,
        split = " "
      )
    )
  )
  isbn <- lib_remove_isbn_dashes(isbn)
  index <- rep(x = NA, length(isbn))
  for (i in seq_along(isbn)) {
    index[i] <- grep(
      pattern = isbn[i],
      x = cf_isbn
    )
  }
  doi <- cf[index, "doi"]
  output <- cbind(
    doi = doi,
    isbn = isbn
  )
  # with NA
  if (anyNA(cf[, "ISBN"])) {
    doi_na <- cf[is.na(cf[, "ISBN"]), "doi"]
    with_na <- cbind(
      doi = doi_na,
      isbn = NA_character_
    )
    # final output
    output <- rbind(
      output,
      with_na
    )
  }
  rownames(output) <- c()
  output
}
