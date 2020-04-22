#' ---
#' title: "Metadata springer_books"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output:
#'   rmarkdown::html_vignette:
#'     toc: true
#' ---
#'
#' ## Library
#'
#+ library
# CRAN
pkg <- "rprojroot"
lib.loc <- .libPaths()[1]
repos <- "https://cran.rstudio.org"
dependencies <- TRUE
type <- "source"
suppressMessages(
  invisible(
    lapply(
      X = pkg[!pkg %in% rownames(installed.packages())],
      FUN = install.packages,
      lib = lib.loc,
      ask = FALSE,
      repos = repos,
      dependencies = dependencies,
      type = type
    )
  )
)
# User Defined
usrpkg <- c(
  "jeksterslabRutils",
  "jeksterslabRlib"
)
suppressMessages(
  invisible(
    lapply(
      X = usrpkg[!usrpkg %in% rownames(installed.packages())],
      FUN = function(x) paste("Build and install", x)
    )
  )
)
suppressMessages(
  invisible(
    lapply(
      X = c(pkg, usrpkg),
      FUN = require,
      character.only = TRUE
    )
  )
)
#'
#' ## Set parameters
#'
#+ parameters
root <- find_root(
  criterion = "DESCRIPTION",
  path = "."
)
dir <- "/media/jeksterslib/books/springer"
all <- TRUE
metadata_crossref <- FALSE
metadata_openlibrary <- FALSE
metadata_calibre <- FALSE
metadata_lc <- FALSE
if (all) {
  metadata_crossref <- metadata_openlibrary <- metadata_calibre <- metadata_lc <- TRUE
}
par <- TRUE
ncores <- parallel::detectCores() - 1
#'
#' ## Check available files
#'
#+ available
springer_books_available <- lib_springer_files(
  dir = dir
)
doi <- unique(
  c(
    springer_books_available[["available_pdf"]][["DOI URL"]],
    springer_books_available[["available_epub"]][["DOI URL"]]
  )
)
isbn <- unique(
  c(
    springer_books_available[["available_pdf"]][["Electronic ISBN"]],
    springer_books_available[["available_epub"]][["Electronic ISBN"]]
  )
)
#'
#' ## Crossref Metadata
#'
#+ crossref
if (metadata_crossref) {
  cat(
    "Downloading Crossref metadata...\n"
  )
  cf <- lib_metadata_crossref(
    doi = doi,
    par = par,
    ncores = ncores
  )
  head(cf)
  cat(
    "Saving Crossref metadata...\n"
  )
  saveRDS(
    object = cf,
    file = file.path(
      root,
      "inst",
      "extdata",
      "metadata_springer_books_crossref.Rds"
    ),
    compress = "xz"
  )
}
#'
#' ## OpenLibrary Metadata
#'
#+ openlibrary
if (metadata_openlibrary) {
  cat(
    "Downloading Open Library metadata...\n"
  )
  openlib <- lib_metadata_openlib(
    isbn = isbn,
    par = par,
    ncores = ncores
  )
  head(openlib)
  cat(
    "Saving Open Library metadata...\n"
  )
  saveRDS(
    object = openlib,
    file = file.path(
      root,
      "inst",
      "extdata",
      "metadata_springer_books_openlib.Rds"
    ),
    compress = "xz"
  )
}
#'
#' ## Calibre Metadata
#'
#+ calibre
if (metadata_calibre) {
  cat(
    "Downloading Calibre metadata...\n"
  )
  cal <- lib_metadata_calibre(
    isbn = isbn,
    par = par,
    ncores = ncores
  )
  head(cal)
  cat(
    "Saving Calibre metadata...\n"
  )
  saveRDS(
    object = cal,
    file = file.path(
      root,
      "inst",
      "extdata",
      "metadata_springer_books_calibre.Rds"
    ),
    compress = "xz"
  )
}
#'
#' ## Library of Congres Metadata
#'
#+ libraryofcongress
if (metadata_lc) {
  cat(
    "Downloading Library of Congress metadata...\n"
  )
  openlib <- file.path(
    root,
    "inst",
    "extdata",
    "metadata_springer_books_openlib.Rds"
  )
  openlib <- readRDS(openlib)
  lccn <- openlib[, "lccn"]
  lc <- lib_metadata_lc(
    lccn = lccn,
    par = par,
    ncores = ncores
  )
  head(lc)
  cat(
    "Saving Library of Congress metadata...\n"
  )
  saveRDS(
    object = lc,
    file = file.path(
      root,
      "inst",
      "extdata",
      "metadata_springer_books_lc.Rds"
    ),
    compress = "xz"
  )
}
