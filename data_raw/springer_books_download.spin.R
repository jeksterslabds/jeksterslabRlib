#' ---
#' title: "Download Springer_Books"
#' author: "Ivan Jacob Agaloos Pesigan"
#' date: "`r Sys.Date()`"
#' output:
#'   rmarkdown::html_vignette:
#'     toc: true
#' ---
#'
#' ## Springer Books Directory
#'
#+ directory
dir <- "/media/jeksterslib/books/springer"
print(dir)
#'
#' ## Available Books
#'
#' ### PDF
#'
#+ pdf
pdf <- length(
  list.files(
    path = dir,
    pattern = "[[:print:]].pdf"
  )
)
print(pdf)
#'
#' ### EPUB
#'
#+ epub
epub <- length(
  list.files(
    path = dir,
    pattern = "[[:print:]].epub"
  )
)
print(epub)
#'
#' ## Download Books
#'
#+ download
jeksterslabRlib::lib_springer_download(
  dir = dir,
  type = "both",
  par = TRUE,
  ncores = 2
)
