#' Remove ISBN Dashes.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @param isbn Character vector.
#'   International Standard Book Number.
#' @examples
#' # Single ISBN
#' isbn <- "978-3-030-29184-6"
#' lib_remove_isbn_dashes(isbn = isbn)
#' # Vector of ISBNs
#' isbn <- c(
#'   "978-0-387-98141-3",
#'   "978-0-387-71762-3"
#' )
#' lib_remove_isbn_dashes(isbn = isbn)
#' @export
lib_remove_isbn_dashes <- function(isbn) {
  isbn <- isbn[!is.na(isbn)]
  gsub(
    pattern = "-| ",
    replacement = "",
    x = isbn
  )
}
