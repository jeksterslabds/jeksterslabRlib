#' DOI to ISBN for Wiley Books
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams jeksterslabRutils::util_lapply
#' @inheritParams lib_remove_doi_http
#' @importFrom curl curl
#' @examples
#' doi <- c(
#'   "10.1002/9780470515075",
#'   "10.1002/9780470721896"
#' )
#' lib_wiley_doi2isbn(
#'   doi = doi,
#'   par = FALSE
#' )
#' @export
lib_wiley_doi2isbn <- function(doi,
                               par = TRUE,
                               ncores = NULL) {
  doi <- lib_remove_doi_http(doi = doi)
  exe <- function(doi) {
    url <- paste0(
      "https://www.onlinelibrary.wiley.com/doi/book/",
      doi
    )
    con <- curl(url)
    on.exit(
      close(con)
    )
    text <- readLines(con)
    isbn <- sub(
      pattern = "[[:print:]]*Print ISBN:</span><span class=\"info_value\">([[:digit:]]*)[[:print:]]*",
      replacement = "\\1",
      x = grep(
        pattern = "Online ISBN",
        x = text,
        value = TRUE
      )
    )
    eisbn <- sub(
      pattern = "[[:print:]]*Online ISBN:</span><span class=\"info_value\">([[:digit:]]*)[[:print:]]*",
      replacement = "\\1",
      x = grep(
        pattern = "Online ISBN",
        x = text,
        value = TRUE
      )
    )
    c(
      doi = doi,
      isbn = isbn,
      eisbn = eisbn
    )
  }
  # iterate through the vector of doi
  output <- util_lapply(
    FUN = exe,
    args = list(doi = doi),
    par = par,
    ncores = ncores
  )
  # rbind results
  do.call(
    what = "rbind",
    args = output
  )
}
