#' ---
#' title: "Data Springer Books"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output:
#'   rmarkdown::html_vignette:
#'     toc: true
#' ---
#'
#' ## Data Source
#'
#+ data_source, echo=FALSE
data_source <- "https://adminportal.springernature.com/metadata/books"
#'
#' Data is sourced from
#' `r paste0("[Springer Nature Metadata]", "(", data_source, ")")`.
#'
#' ### Languages and eBook Collections
#'
#'   - English/International
#'     - Computer Science without Lecture Notes (starting 1960)
#'     - Lecture Notes in Computer Science
#'     - Mathematics and Statistics without Lecture Notes (starting 1929)
#'     - Lecture Notes in Mathematics
#'
#' ### Subject Classification
#'
#' #### all
#'
#'   - Computer Science
#'   - Education
#'   - Mathematics
#'   - Philosophy
#'   - Popular Science
#'   - Psychology
#'   - Social Sciences
#'   - Statistics
#'
#' #### parts
#'
#'   - Architecture / Design
#'     - Design, general
#'       - Graphic Design
#'   - Business and Management
#'     - Management
#'       - Project Management
#'       - Knowledge Management
#'     - Operations Research/Decision Theory
#'     - IT in Business
#'     - Business Mathematics
#'   - Criminology and Criminal Justice
#'     - Research Methods in Criminology
#'   - Cultural and Media Studies
#'     - Photography
#'     - Printing and Publishing
#'     - Library Science
#'   - Economics
#'     - History of Economic Thought/Methodology
#'     - Economic Theory/Quantitative Economics/Mathematical Methods
#'     - Behavioral/Experimental Economics
#'   - Life Sciences
#'     - Bioinformatics
#'     - Behavioral Sciences
#'     - Computer Appl. in Life Science
#'   - Linguistics
#'     - Research Methods in Language and Linguistics
#'   - Medicine & Public Health
#'     - Health Informatics
#'     - Epidemiology
#'
#' ## Set parameters
#'
#' - If `production = TRUE`, use production data (`SpringerNature_Books*`).
#' - If `production = FALSE`, use test data (`Tests_Springer*`).
#'
#' ## Library
#'
#+ library
library(jeksterslabRutils)
library(jeksterslabRlib)
#'
#' ## Set parameters
#'
#+ parameters
tmp_dir <- tempdir()
root <- pkg_find_root(pkg_name = "jeksterslabRlib")
dir <- "/media/jeksterslib/books/springer"
production <- TRUE
chkfiles <- TRUE
par <- TRUE
ncores <- parallel::detectCores() - 1
if (production) {
  pattern <- "^SpringerNature_Books.*"
} else {
  pattern <- "^Test_Springer.*"
}
cat(
  paste0(
    "Parameters:\n",
    "\t", "dir = ", "\"", dir, "\"", "\n",
    "\t", "production = ", production, "\n",
    "\t", "chkfiles = ", chkfiles, "\n",
    "\t", "par = ", par, "\n",
    "\t", "ncores = ", ncores, "\n"
  )
)
#'
#' ## Build Springer Books data
#'
#+ data_springer_books
cat(
  "Binding Springer Books data from SpringerNature...\n"
)
files <- list.files(
  pattern = paste0(
    pattern,
    "\\.zip"
  )
)
for (i in seq_along(files)) {
  unzip(
    zipfile = files[i],
    exdir = tmp_dir
  )
}
springer_books <- util_bind(
  dir = tmp_dir,
  format = "xlsx",
  pattern = pattern,
  fn_column = FALSE,
  save = FALSE
)
springer_books_doi <- unique(
  springer_books[["DOI URL"]]
)
springer_books <- springer_books[!duplicated(springer_books[["DOI URL"]]), ]
#'
#' ## Get available files
#'
#+ data_springer_books_available
cat(
  paste0(
    "Checking downloaded files in ",
    dir,
    "...",
    "\n"
  )
)
springer_books_available <- lib_springer_files(dir = dir)
doi_pdf <- lib_remove_doi_http(
  springer_books_available[["available_pdf"]][["DOI URL"]]
)
doi_epub <- lib_remove_doi_http(
  springer_books_available[["available_epub"]][["DOI URL"]]
)
doi_root_pdf <- lib_remove_doi_prefix(doi = doi_pdf)
doi_root_epub <- lib_remove_doi_prefix(doi = doi_epub)
#'
#' ## Check PDF files and delete invalid files
#'
#+ check_and_delete_pdf
if (chkfiles) {
  cat(
    "Checking and deleting invalid PDF documents...\n"
  )
  util_check_file_type(
    dir = dir,
    fn = paste0(
      doi_root_pdf,
      ".pdf"
    ),
    file_type = "PDF document",
    remove_files = TRUE,
    par = par,
    ncores = ncores
  )
}
#'
#' ## Check EPUB files and delete invalid files
#'
#+ check_and_delete_epub
if (chkfiles) {
  cat(
    "Checking and deleting invalid EPUB documents...\n"
  )
  util_check_file_type(
    dir = dir,
    fn = paste0(
      doi_root_epub,
      ".epub"
    ),
    file_type = "EPUB document",
    remove_files = TRUE,
    par = par,
    ncores = ncores
  )
}
#'
#' ## Rerun `lib_springer_files` to get available files after deleting invalid files
#'
#+ rerun_lib_springer_files
if (chkfiles) {
  springer_books_available <- lib_springer_files(
    dir = dir
  )
  doi_pdf <- lib_remove_doi_http(
    springer_books_available[["available_pdf"]][["DOI URL"]]
  )
  doi_epub <- lib_remove_doi_http(
    springer_books_available[["available_epub"]][["DOI URL"]]
  )
}
cat(
  paste0(
    length(doi_pdf),
    " ",
    "available PDF files.\n",
    length(doi_epub),
    " ",
    "available EPUB files.\n"
  )
)
#'
#' ## Save data
#'
#' ### `extdata`
#'
#+ extdata_01
springer_books_fn <- file.path(
  root,
  "inst",
  "extdata",
  "springer_books.Rds"
)
cat(
  paste0(
    "Saving ",
    springer_books_fn,
    "...\n"
  )
)
saveRDS(
  object = springer_books,
  file = springer_books_fn,
  compress = "xz"
)
#'
#+ extdata_02
springer_books_available_fn <- file.path(
  root,
  "inst",
  "extdata",
  "springer_books_available.Rds"
)
cat(
  paste0(
    "Saving ",
    springer_books_available_fn,
    "...\n"
  )
)
saveRDS(
  object = springer_books_available,
  file = springer_books_available_fn,
  compress = "xz"
)
#'
#' ### `data`
#'
#+ data
springer_books_doi_fn <- file.path(
  root,
  "data",
  "springer_books_doi.rda"
)
cat(
  paste0(
    "Saving ",
    springer_books_doi_fn,
    "...\n"
  )
)
save(
  springer_books_doi,
  file = springer_books_doi_fn,
  compress = "xz"
)
#'
#' ## Clean `tempdir`
#'
#+ clean tempdir
util_clean_tempdir()
