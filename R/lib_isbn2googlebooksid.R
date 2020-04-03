#' ISBN to Google Books ID
#'
#' @param isbn Character vector.
#'   International Standard Book Number.
#' @inheritParams lib_remove_isbn_dashes
#' @inheritParams jeksterslabRutils::util_lapply
#' @importFrom jeksterslabRutils util_lapply
#' @examples
#' # Single ISBN
#' isbn <- "978-0-387-98141-3"
#' lib_isbn2googlebooksid(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' # Vector of ISBNs
#' isbn <- c(
#'   "978-0-387-98141-3",
#'   "978-0-387-71762-3"
#' )
#' lib_isbn2googlebooksid(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' @export
lib_isbn2googlebooksid <- function(isbn,
                                   par = TRUE,
                                   ncores = NULL) {
  isbn <- lib_remove_isbn_dashes(isbn = isbn)
  exe <- function(isbn) {
    # error output
    err_output <- c(
      isbn = isbn,
      google = NA_character_
    )
    # url
    input_url <- paste0(
      "https://www.googleapis.com/books/v1/volumes?q=isbn:",
      isbn
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
        google <- fromJSON(
          file = input_url
        )[["items"]][[1]][["id"]]
        return(
          c(
            isbn = isbn,
            google = google
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
