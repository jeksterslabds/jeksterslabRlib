#' ISBN to Library of Congress Control Number (LCCN).
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_remove_isbn_dashes
#' @inheritParams jeksterslabRutils::util_lapply
#' @importFrom jeksterslabRutils util_get_numbers
#' @importFrom curl curl
#' @examples
#' # Single ISBN
#' isbn <- "978-0-387-98141-3"
#' lib_isbn2lccn(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' # Vector of ISBNs
#' isbn <- c(
#'   "978-0-387-98141-3",
#'   "978-0-387-71762-3"
#' )
#' lib_isbn2lccn(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' @export
lib_isbn2lccn <- function(isbn,
                          par = TRUE,
                          ncores = NULL) {
  isbn <- lib_remove_isbn_dashes(isbn = isbn)
  # function
  exe <- function(isbn) {
    err_output <- c(
      isbn = isbn,
      lccn = NA_character_
    )
    # url
    input_url <- paste0(
      "http://lx2.loc.gov:210/lcdb?version=1.1&operation=searchRetrieve&query=bath.isbn=",
      isbn,
      "&maximumRecords=1&recordSchema=mods"
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
        on.exit(
          close(con)
        )
        # get XML from API
        con <- curl(input_url)
        on.exit(
          close(con)
        )
        mods <- readLines(con)
        lccn_line <- grep(
          pattern = "lccn",
          x = mods,
          value = TRUE
        )
        if (length(lccn_line) == 0) {
          lccn <- NA
        } else {
          lccn <- util_get_numbers(x = lccn_line)
        }
        return(
          c(
            isbn = isbn,
            lccn = lccn
          )
        )
      },
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
