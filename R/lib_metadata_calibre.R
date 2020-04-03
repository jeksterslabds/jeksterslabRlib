#' Extract Calibre Metadata
#'
#' Extracts metadata using Calibre's \code{fetch-ebook-metadata} command
#' with the argument \code{--identifier isbn:ITEM_ISBN}.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_remove_isbn_dashes
#' @inheritParams jeksterslabRutils::util_lapply
#' @importFrom jeksterslabRutils util_xml2list
#' @examples
#' isbn <- c(
#'   "978-0-387-98141-3",
#'   "978-0-387-71762-3"
#' )
#' lib_metadata_calibre(
#'   isbn = isbn,
#'   par = FALSE
#' )
#' @export
lib_metadata_calibre <- function(isbn,
                                 par = TRUE,
                                 ncores = NULL) {
  isbn <- lib_remove_isbn_dashes(isbn)
  # function
  exe <- function(isbn) {
    err_output <- c(
      isbn = isbn,
      title = NA_character_,
      description = NA_character_,
      subject = NA_character_,
      amazon = NA_character_,
      google = NA_character_,
      uuid = NA_character_,
      calibre = NA_character_
    )
    tryCatch(
      {
        con <- tempfile()
        system(
          paste0(
            "fetch-ebook-metadata --identifier isbn:",
            isbn,
            " --opf > ",
            con
          ),
          ignore.stdout = FALSE,
          ignore.stderr = FALSE
        )
        output <- util_xml2list(
          tags = c(
            "dc:title",
            "dc:description",
            "dc:subject"
          ),
          con = con
        )
        title <- unlist(output[[1]])
        description <- unlist(output[[2]])
        subject <- paste(unlist(output[[3]]), collapse = " AND ")
        text <- readLines(con)
        identifiers <- grep(pattern = "<dc:identifier[[:print:]]+>", x = text, value = TRUE)
        identifiers <- gsub(
          pattern = "<dc:identifier opf:scheme=|</dc:identifier>|id=\"calibre_id\"|id=\"uuid_id\"|\"",
          replacement = "",
          x = identifiers
        )
        identifiers <- trimws(
          gsub(
            pattern = "[[:space:]]+>|>",
            replacement = ":",
            x = identifiers
          )
        )
        # identifiers <- paste(identifiers, collapse = " ")
        id <- c(
          "AMAZON:",
          "GOOGLE:",
          "uuid:",
          "calibre:"
        )
        identifier <- rep(x = NA, times = length(id))
        names(identifier) <- c(
          "amazon",
          "google",
          "uuid",
          "calibre"
        )
        for (i in seq_along(identifier)) {
          x <- grep(
            pattern = id[i],
            x = identifiers,
            value = TRUE
          )
          if (length(x) == 0) {
            identifier[i] <- NA_character_
          } else {
            identifier[i] <- gsub(
              pattern = id[i],
              replacement = "",
              x = x
            )
          }
        }
        return(
          c(
            isbn = isbn,
            title = title,
            description = description,
            subject = subject,
            identifier
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
