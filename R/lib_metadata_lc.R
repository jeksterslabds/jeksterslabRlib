#' Extract Library of Congress Metadata.
#'
#' Extracts Library of Congress metadata from the LC API.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams jeksterslabRutils::util_lapply
#' @param lccn Character vector.
#'   Library of Congress Control Number (LCCN)
#' @examples
#' lccn <- c(
#'   "2007925720",
#'   "2009928510"
#' )
#' lib_metadata_lc(
#'   lccn = lccn,
#'   par = FALSE
#' )
#' @export
lib_metadata_lc <- function(lccn,
                            par = TRUE,
                            ncores = NULL) {
  # remove NA
  lccn <- lccn[!is.na(lccn)]
  # function
  exe <- function(lccn) {
    # error output
    err_output <- c(
      lccn = lccn,
      call_number = NA_character_,
      original_format = NA_character_,
      date = NA_character_,
      created_published = NA_character_,
      subject_headings = NA_character_
    )
    # url
    input_url <- paste0(
      "https://www.loc.gov/item/",
      lccn,
      "/?fo=json"
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
        index <- input[["item"]]
        fields <- c(
          "call_number",
          "original_format",
          "date",
          "created_published"
        )
        contents <- util_list2vector(
          fields = fields,
          index = index
        )
        #        contents <- rep(x = NA, times = length(fields))
        #        for (i in seq_along(fields)) {
        #          if (exists(fields[i], where = index)) {
        #            content <- unlist(index[[fields[i]]])
        #            if (is.null(content)) {
        #              contents[i] <- NA_character_
        #            } else {
        #              contents[i] <- content
        #            }
        #          } else {
        #            contents[i] <- NA_character_
        #          }
        #        }
        #        names(contents) <- fields
        # subject_headings
        if (is.null(index[["subject_headings"]])) {
          subject_headings <- NA_character_
        } else {
          subject_headings <- paste(unlist(index[["subject_headings"]]), collapse = " AND ")
        }
        return(
          c(
            lccn = lccn,
            contents,
            subject_headings = subject_headings
          )
        )
      },
      # returns err_output on error
      error = function(err) {
        return(err_output)
      }
    )
  }
  # iterate through the vector of lccn
  output <- util_lapply(
    FUN = exe,
    args = list(lccn = lccn),
    par = par,
    ncores = ncores
  )
  # rbind results
  do.call(
    what = "rbind",
    args = output
  )
}
