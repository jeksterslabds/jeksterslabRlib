#' Remove DOI HTTP.
#'
#' Removes DOI HTTP using the following patters:
#'   - `http://dx.doi.org/`
#'   - `http://doi.org/`
#'   - `https://dx.doi.org/`
#'   - `https://doi.org/`
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @param doi Character vector.
#'   A vector of Digital Object Identifiers.
#' @examples
#' # Single DOI
#' doi <- "https://doi.org/10.1016/j.adolescence.2014.04.012"
#' lib_remove_doi_http(doi = doi)
#' # Vector of DOIs
#' doi <- c(
#'   "https://doi.org/10.1016/j.adolescence.2014.04.012",
#'   "https://doi.org/10.1007/s11469-015-9612-8",
#'   "https://doi.org/10.1016/j.addbeh.2014.10.002",
#'   "https://doi.org/10.1007/s10566-014-9275-9",
#'   "https://doi.org/10.1037/a0039101",
#'   "https://doi.org/10.1016/j.paid.2016.10.059",
#'   "https://doi.org/10.1016/j.addbeh.2016.03.026",
#'   "https://doi.org/10.1080/10826084.2019.1658784",
#'   "https://doi.org/10.1016/j.addbeh.2018.11.045"
#' )
#' lib_remove_doi_http(doi = doi)
#' @export
lib_remove_doi_http <- function(doi) {
  doi <- doi[!is.na(doi)]
  gsub(
    pattern = "http://dx.doi.org/|http://doi.org/|https://dx.doi.org/|https://doi.org/",
    replacement = "",
    x = doi
  )
}
