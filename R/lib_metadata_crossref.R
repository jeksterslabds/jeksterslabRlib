#' Extract Crossref Metadata
#'
#' Extracts Crossref metadata from the Crossref API
#' using the item's Digital Object Identifier (DOI).
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams jeksterslabRutils::util_lapply
#' @param doi Character vector
#'   A vector of Digital Object Identifiers.
#' @importFrom jeksterslabRutils util_url_exists
#' @importFrom jeksterslabRutils util_os
#' @importFrom jeksterslabRutils util_lapply
#' @importFrom jeksterslabRutils util_list2vector
#' @importFrom rjson fromJSON
#' @importFrom parallel detectCores
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @importFrom parallel mclapply
#' @importFrom parallel parLapply
#' @examples
#' # Single DOI
#' doi <- "https://doi.org/10.1016/j.adolescence.2014.04.012"
#' lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' doi <- "10.1016/j.adolescence.2014.04.012"
#' lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' # Vector of DOIs
#' doi <- c(
#'   "https://doi.org/10.1016/j.adolescence.2014.04.012",
#'   "https://doi.org/10.1007/s11469-015-9612-8"
#' )
#' lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' doi <- c(
#'   "10.1016/j.adolescence.2014.04.012",
#'   "10.1007/s11469-015-9612-8"
#' )
#' lib_metadata_crossref(
#'   doi = doi,
#'   par = FALSE
#' )
#' @export
lib_metadata_crossref <- function(doi,
                                  par = TRUE,
                                  ncores = NULL) {
  # remove http
  doi <- lib_remove_doi_http(doi = doi)
  # function
  exe <- function(doi) {
    # error output
    err_output <- c(
      doi = doi,
      author = NA_character_,
      editor = NA_character_,
      type = NA_character_,
      title = NA_character_,
      "original-title" = NA_character_,
      subtitle = NA_character_,
      "short-title" = NA_character_,
      publisher = NA_character_,
      "publisher-location" = NA_character_,
      "container-title" = NA_character_,
      "short-container-title" = NA_character_,
      issue = NA_character_,
      page = NA_character_,
      volume = NA_character_,
      language = NA_character_,
      ISNN = NA_character_,
      subject = NA_character_,
      ISBN = NA_character_
    )
    # url
    input_url <- paste0(
      "https://api.crossref.org/works/",
      doi
    )
    # tests if url exists and returns err_output is it doesn't
    if (!util_url_exists(con = input_url)) {
      warning(
        paste(
          input_url,
          "does not exist.\n"
        )
      )
      return(err_output)
    }
    tryCatch(
      {
        # get JSON from API
        input <- fromJSON(
          file = input_url
        )
        # extract metadata
        index <- input[["message"]]
        # type
        # type <- unlist(index[["type"]])
        # contents
        fields <- c(
          "type",
          "title",
          "original-title",
          "subtitle",
          "short-title",
          "publisher",
          "publisher-location",
          "container-title",
          "short-container-title",
          "issue",
          "page",
          "volume",
          "language",
          "ISNN"
        )
        contents <- util_list2vector(
          fields = fields,
          index = index
        )
        # authors
        extract_authors <- function(author) {
          paste0(
            author[["family"]],
            ", ",
            author[["given"]]
          )
        }
        if (is.null(index[["author"]])) {
          author <- NA_character_
        } else {
          authors <- index[["author"]]
          authors <- lapply(
            X = authors,
            FUN = extract_authors
          )
          author <- paste(authors, collapse = " and ")
          author <- ifelse(
            test = is.null(author),
            yes = NA_character_,
            no = author
          )
          author <- unlist(author)
        }
        # editor
        if (is.null(index[["editor"]])) {
          editor <- NA_character_
        } else {
          editors <- index[["editor"]]
          editors <- lapply(
            X = editors,
            FUN = extract_authors
          )
          editor <- paste(editors, collapse = " and ")
          editor <- ifelse(
            test = is.null(editor),
            yes = NA_character_,
            no = editor
          )
          editor <- unlist(editor)
        }
        # subjects
        if (exists("subject", where = index)) {
          subject <- paste(unlist(index[["subject"]]), collapse = " AND ")
          if (is.null(subject)) {
            subject <- NA_character_
          }
        } else {
          subject <- NA_character_
        }
        # ISBN
        if (exists("ISBN", where = index)) {
          ISBN <- paste(unlist(index[["ISBN"]]), collapse = " ")
          if (is.null(ISBN)) {
            ISBN <- NA_character_
          }
        } else {
          ISBN <- NA_character_
        }
        return(
          c(
            doi = doi,
            author = author,
            editor = editor,
            contents,
            subject = subject,
            ISBN = ISBN
          )
        )
      },
      # returns err_output on error
      error = function(err) {
        return(err_output)
      }
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
