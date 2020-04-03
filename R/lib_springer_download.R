#' Download Resources from link.springer.com.
#'
#' Downloads \code{pdf} and \code{epub} files
#' from \code{link.springer.com}
#' using \code{wget}.
#' It is assumed that you have access
#' to the resources via your library.
#' It also assumes that \code{wget}
#' is installed in your system.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams jeksterslabRutils::util_bind
#' @inheritParams jeksterslabRutils::util_check_file_type
#' @inheritParams jeksterslabRutils::util_wget
#' @inheritParams lib_remove_doi_http
#' @param type Character string.
#'   Type of ebooks to download.
#' @param chkfiles Logical.
#'   Check available files in \code{dir}.
#'   If \code{TRUE},
#'   the download queue will EXCLUDE dois
#'   from available files.
#' @importFrom jeksterslabRutils util_bind
#' @importFrom jeksterslabRutils util_check_file_type
#' @importFrom jeksterslabRutils util_wget
#' @importFrom utils glob2rx
#' @examples
#' # Single DOI
#' doi <- "10.1007/978-0-387-98141-3"
#' lib_springer_download(
#'   dir = getwd(),
#'   doi = doi,
#'   chkfiles = TRUE,
#'   type = "both",
#'   par = FALSE
#' )
#' # Vector of DOIs
#' doi <- c(
#'   "https://doi.org/10.1007/978-0-387-71762-3",
#'   "10.1007/978-0-387-98141-3"
#' )
#' lib_springer_download(
#'   dir = getwd(),
#'   doi = doi,
#'   chkfiles = TRUE,
#'   type = "both",
#'   par = FALSE
#' )
#' @export
lib_springer_download <- function(dir,
                                  doi = NULL,
                                  chkfiles = TRUE,
                                  args = "-nc",
                                  remove_files = TRUE,
                                  type = c("pdf", "epub", "both"),
                                  par = TRUE,
                                  ncores = NULL) {
  exe <- function(doi,
                  PDF,
                  dir,
                  args,
                  remove_files,
                  par,
                  ncores) {
    # create links
    link <- lib_springer_link(
      doi = doi,
      PDF = PDF
    )
    # download using wget
    if (PDF) {
      doc <- "PDF"
      ext <- ".pdf"
      file_type <- "PDF document"
    } else {
      doc <- "EPUB"
      ext <- ".epub"
      file_type <- "EPUB document"
    }
    cat(
      paste(
        "Downloading",
        length(doi),
        doc,
        "document/s...\n"
      )
    )
    util_wget(
      dir = dir,
      link = link,
      args = args,
      par = par,
      ncores = ncores
    )
    # check files and delete non PDF documents
    cat(
      paste(
        "Checking files and deleting non",
        doc,
        "documents...\n"
      )
    )
    util_check_file_type(
      dir = dir,
      fn = paste0(
        doi_root_pdf,
        ext
      ),
      file_type = file_type,
      remove_files = remove_files,
      par = par,
      ncores = ncores
    )
  }
  # generate doi if doi = NULL
  if (is.null(doi)) {
    doi <- jeksterslabRlib::springer_books_doi
  }
  # generate doi_pdf, doi_epub, doi_root_pdf, doi_root_epub
  # it is easier to extract unique DOIs without the html component
  doi_unique <- doi_pdf <- doi_epub <- unique(
    lib_remove_doi_http(doi = doi)
  )
  doi_root_pdf <- doi_root_epub <- lib_remove_doi_prefix(doi = doi)
  cat(
    paste(
      "Total number of unique DOIs provided:",
      length(doi_unique),
      "\n"
    )
  )
  # check type
  if (type == "both") {
    download_pdf <- TRUE
    download_epub <- TRUE
  }
  if (type == "pdf") {
    download_pdf <- TRUE
    download_epub <- FALSE
  }
  if (type == "epub") {
    download_pdf <- FALSE
    download_epub <- TRUE
  }
  # check files
  if (chkfiles) {
    cat(
      paste0(
        "Checking downloaded files in ",
        dir,
        ".",
        "\n"
      )
    )
    files <- lib_springer_files(dir = dir)
    doi_available_pdf <- lib_remove_doi_http(
      files[["available_pdf"]][["DOI URL"]]
    )
    doi_available_epub <- lib_remove_doi_http(
      files[["available_epub"]][["DOI URL"]]
    )
    if (download_pdf) {
      doi_pdf <- doi_pdf[!doi_pdf %in% doi_available_pdf]
      doi_root_pdf <- lib_remove_doi_prefix(doi = doi_pdf)
    }
    if (download_epub) {
      doi_epub <- doi_epub[!doi_epub %in% doi_available_epub]
      doi_root_epub <- lib_remove_doi_prefix(doi = doi_epub)
    }
  }
  # download
  if (download_pdf) {
    if (length(doi_pdf) > 0) {
      exe(
        doi = doi_pdf,
        PDF = TRUE,
        dir = dir,
        args = args,
        remove_files = remove_files,
        par = par,
        ncores = ncores
      )
    } else {
      cat("No PDF document to download.\n")
    }
  }
  if (download_epub) {
    if (length(doi_epub) > 0) {
      exe(
        doi = doi_epub,
        PDF = FALSE,
        dir = dir,
        args = args,
        remove_files = remove_files,
        par = par,
        ncores = ncores
      )
    } else {
      cat("No EPUB document to download.\n")
    }
  }
  # create a list of available springer books in dir
  output <- lib_springer_files(dir = dir)
  cat(
    paste(
      nrow(output$available_pdf),
      "available PDF documents.\n"
    )
  )
  cat(
    paste(
      nrow(output$available_epub),
      "available EPUB documents.\n"
    )
  )
  output_file <- file.path(
    getwd(),
    "springer_books_available.Rds"
  )
  saveRDS(
    object = output,
    file = output_file,
    compress = "xz"
  )
  cat(
    paste(
      "See",
      output_file,
      "for available Springer books.\n"
    )
  )
}
