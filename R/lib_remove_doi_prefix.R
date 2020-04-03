#' Remove DOI Prefix.
#'
#' Removes DOI HTTP
#' (see [jeksterslabRlib::lib_remove_doi_http()])
#' and
#' prefix,
#' that is, the first 6 digits of a DOI.
#' For example, in the case of
#' `"https://doi.org/10.1016/j.adolescence.2014.04.012"`
#' both
#' `"https://doi.org/"`
#' and `"10.1016/"`
#' are removed resulting in
#' `"j.adolescence.2014.04.012"`.
#'
#' For more information on DOIs and matching regular expressions see
#' [DOI regex](https://www.crossref.org/blog/dois-and-matching-regular-expressions/).
#'
#' Regular expressions
#'   - `/^10.\d{4,9}/[-._;()/:A-Z0-9]+$/i`
#'   - `/^10.1002/[^\s]+$/i`
#'   - `/^10.\d{4}/\d+-\d+X?(\d+)\d+<[\d\w]+:[\d\w]*>\d+.\d+.\w+;\d$/i`
#'   - `/^10.1021/\w\w\d++$/i`
#'   - `/^10.1207/[\w\d]+\&\d+_\d+$/i`
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_remove_doi_http
#' @examples
#' # Single DOI
#' doi <- "https://doi.org/10.1016/j.adolescence.2014.04.012"
#' lib_remove_doi_prefix(doi = doi)
#' doi <- "10.1016/j.adolescence.2014.04.012"
#' lib_remove_doi_prefix(doi = doi)
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
#' lib_remove_doi_prefix(doi = doi)
#' doi <- c(
#'   "10.1016/j.adolescence.2014.04.012",
#'   "10.1007/s11469-015-9612-8",
#'   "10.1016/j.addbeh.2014.10.002",
#'   "10.1007/s10566-014-9275-9",
#'   "10.1037/a0039101",
#'   "10.1016/j.paid.2016.10.059",
#'   "10.1016/j.addbeh.2016.03.026",
#'   "10.1080/10826084.2019.1658784",
#'   "10.1016/j.addbeh.2018.11.045"
#' )
#' lib_remove_doi_prefix(doi = doi)
#' @export
lib_remove_doi_prefix <- function(doi) {
  doi <- lib_remove_doi_http(doi = doi)
  gsub(
    pattern = "^10.\\d{4,9}/",
    replacement = "",
    x = doi
  )
}
