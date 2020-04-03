#' Create a list of available Springer books.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_springer_download
#' @export
lib_springer_files <- function(dir) {
  pdf <- list.files(
    path = dir,
    pattern = glob2rx("*.pdf")
  )
  pdf <- gsub(
    pattern = ".pdf$",
    replacement = "",
    x = pdf
  )
  pdf <- as.data.frame(as.character(pdf))
  names(pdf) <- "doi_root"
  epub <- list.files(
    path = dir,
    pattern = glob2rx("*.epub")
  )
  epub <- gsub(
    pattern = ".epub$",
    replacement = "",
    x = epub
  )
  epub <- as.data.frame(as.character(epub))
  names(epub) <- "doi_root"
  springer_books <- system.file(
    "extdata",
    "springer_books.Rds",
    package = "jeksterslabRlib",
    mustWork = TRUE
  )
  y <- readRDS(springer_books)
  doi <- y[["DOI URL"]]
  doi_root <- lib_remove_doi_prefix(doi)
  y$doi_root <- doi_root
  available_pdf <- merge(
    x = pdf,
    y = y,
    by = "doi_root"
  )
  available_epub <- merge(
    x = epub,
    y = y,
    by = "doi_root"
  )
  list(
    available_pdf = available_pdf,
    available_epub = available_epub
  )
}
