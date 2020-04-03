#' Extract Open Library Metadata
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams jeksterslabRutils::util_lapply
#' @inheritParams lib_remove_isbn_dashes
#' @examples
#' isbn <- c(
#'   "978-0-387-98141-3",
#'   "978-0-387-71762-3"
#' )
#' lib_metadata_openlib(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' @export
lib_metadata_openlib <- function(isbn,
                                 par = TRUE,
                                 ncores = NULL) {
  isbn <- lib_remove_isbn_dashes(isbn)
  exe <- function(isbn) {
    # error output
    err_output <- c(
      isbn = isbn,
      lccn = NA_character_,
      openlibrary = NA_character_,
      lc_classification = NA_character_,
      title = NA_character_,
      subtitle = NA_character_,
      url = NA_character_,
      number_of_pages = NA_character_,
      pagination = NA_character_,
      number_of_pages = NA_character_,
      publish_date = NA_character_
    )
    # url
    input_url <- paste0(
      "https://openlibrary.org/api/books?bibkeys=ISBN:",
      isbn,
      "&jscmd=data&format=json"
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
        lcc <- input[[paste0("ISBN:", isbn)]][["classifications"]]
        lcc_output <- util_list2vector(
          fields = "lc_classification",
          index = lcc
        )
        identifiers <- input[[paste0("ISBN:", isbn)]][["identifiers"]]
        fields_identifiers <- c(
          "lccn",
          "openlibrary"
        )
        identifiers_output <- util_list2vector(
          fields = fields_identifiers,
          index = identifiers
        )
        main <- input[[paste0("ISBN:", isbn)]]
        fields_main <- c(
          "title",
          "subtitle",
          "url",
          "number_of_pages",
          "pagination",
          "number_of_pages",
          "publish_date"
        )
        main_output <- util_list2vector(
          fields = fields_main,
          index = main
        )
        return(
          c(
            isbn = isbn,
            identifiers_output,
            lcc_output,
            main_output
          )
        )
      },
      # returns err_output on error
      error = function(err) {
        return(err_output)
      }
    )
  }
  # iterate through the vector of isbn
  output <- util_lapply(
    FUN = exe,
    args = list(isbn = isbn),
    par = par,
    ncores = ncores
  )
  # rbind results
  do.call(
    what = "rbind",
    args = output
  )
}
