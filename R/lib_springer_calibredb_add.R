#' Add Springer Books to Calibre
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @inheritParams lib_remove_doi_http
#' @param dir Character string.
#'   Directory where Springer Books are located.
#' @param calibre_dir Character string.
#'   Directory where Calibre's Library Database is located.
#' @importFrom jeksterslabRutils util_clean_tempdir
#' @export
lib_springer_calibredb_add <- function(doi,
                                       dir,
                                       calibre_dir) {
  springer_books_available <- system.file(
    "extdata",
    "springer_books_available.Rds",
    package = "jeksterslabRlib",
    mustWork = TRUE
  )
  springer_books_available <- readRDS(springer_books_available)
  extract <- function(doi,
                      springer_books_available,
                      dir,
                      type = c("pdf", "epub")) {
    doi <- lib_remove_doi_prefix(doi)
    if (type == "pdf") {
      available <- springer_books_available[["available_pdf"]]
    }
    if (type == "epub") {
      available <- springer_books_available[["available_epub"]]
    }
    # remove dois not in available files
    doi_trimmed <- rep(x = NA, times = length(doi))
    for (i in seq_along(doi)) {
      if (doi[i] %in% available[["doi_root"]]) {
        doi_trimmed[i] <- doi[i]
      } else {
        doi_trimmed[i] <- NA
      }
    }
    if (all(is.na(doi_trimmed))) {
      stop("None of the DOIs provided are available.")
    }
    doi <- doi_trimmed[!is.na(doi_trimmed)]
    doi <- as.data.frame(doi)
    names(doi) <- "doi_root"
    metadata <- merge(
      x = doi,
      y = available,
      by = "doi_root"
    )
    list(
      author = metadata[["Author"]],
      title = metadata[["Book Title"]],
      isbn = lib_remove_isbn_dashes(metadata[["Electronic ISBN"]]),
      doi = metadata[["DOI URL"]],
      doi_root = as.character(metadata[["doi_root"]]),
      uri = metadata[["OpenURL"]],
      series = metadata[["Series Title"]],
      publisher = metadata[["Publisher"]]
    )
  }
  pdf <- extract(
    doi = doi,
    springer_books_available = springer_books_available,
    dir = dir,
    type = "pdf"
  )
  epub <- extract(
    doi = doi,
    springer_books_available = springer_books_available,
    dir = dir,
    type = "epub"
  )
  exe <- function(author,
                  title,
                  isbn,
                  doi,
                  doi_root,
                  uri,
                  series,
                  publisher,
                  dir,
                  calibre_dir,
                  type) {
    tmp_dir <- tempdir()
    fn <- paste0(
      doi_root,
      ".",
      type
    )
    tmp_file <- paste0(
      file.path(
        tmp_dir,
        fn
      )
    )
    tmp_opf <- paste0(
      tempfile(),
      ".opf"
    )
    file.copy(
      file.path(
        dir,
        fn
      ),
      tmp_dir
    )
    fetch <- "fetch-ebook-metadata"
    meta <- "ebook-meta"
    add <- "calibredb add"
    to_opf <- paste(
      "--opf >",
      shQuote(tmp_opf)
    )
    from_opf <- paste(
      "--from-opf",
      shQuote(tmp_opf)
    )
    common_options <- paste(
      "--authors",
      shQuote(author),
      "--title",
      shQuote(title),
      paste0(
        "--identifier isbn:",
        shQuote(isbn)
      ),
      paste0(
        "--identifier doi:",
        shQuote(doi)
      ),
      paste0(
        "--identifier uri:",
        shQuote(uri)
      ),
      "--isbn",
      shQuote(isbn)
    )
    if (is.na(series)) {
      series <- " "
    } else {
      series <- paste(
        "--series",
        shQuote(series)
      )
    }
    publisher <- paste0(
      "--publisher",
      shQuote(publisher)
    )
    library_path <- paste(
      "--library-path",
      shQuote(calibre_dir)
    )
    system(
      paste(
        fetch,
        common_options,
        to_opf
      ),
      ignore.stdout = FALSE,
      ignore.stderr = FALSE
    )
    system(
      paste(
        meta,
        tmp_file,
        common_options,
        from_opf
      ),
      ignore.stdout = FALSE,
      ignore.stderr = FALSE
    )
    system(
      paste(
        add,
        library_path,
        common_options,
        series,
        tmp_file
      ),
      ignore.stdout = FALSE,
      ignore.stderr = FALSE
    )
  }
  # add epub first
  invisible(
    mapply(
      FUN = exe,
      author = epub[["author"]],
      title = epub[["title"]],
      isbn = epub[["isbn"]],
      doi = epub[["doi"]],
      doi_root = epub[["doi_root"]],
      uri = epub[["uri"]],
      series = epub[["series"]],
      publisher = epub[["publisher"]],
      dir = dir,
      calibre_dir = calibre_dir,
      type = "epub"
    )
  )
  # if epub does not exist this adds pdf
  invisible(
    mapply(
      FUN = exe,
      author = pdf[["author"]],
      title = pdf[["title"]],
      isbn = pdf[["isbn"]],
      doi = pdf[["doi"]],
      doi_root = pdf[["doi_root"]],
      uri = pdf[["uri"]],
      series = pdf[["series"]],
      publisher = pdf[["publisher"]],
      dir = dir,
      calibre_dir = calibre_dir,
      type = "pdf"
    )
  )
  util_clean_tempdir()
}
