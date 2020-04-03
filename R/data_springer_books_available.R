#' Extract Data from Springer Database for Available Ebooks.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @param type Character string.
#'   Type of available ebooks.
#' @export
data_springer_books_available <- function(type = c(
                                            "pdf",
                                            "epub",
                                            "both"
                                          )) {
  data <- system.file(
    "extdata",
    "springer_books_available.Rds",
    package = "jeksterslabRlib",
    mustWork = TRUE
  )
  data <- readRDS(data)
  if (type == "pdf") {
    data <- data$available_pdf
  } else if (type == "epub") {
    data <- data$available_epub
  } else if (type == "both") {
    pdf <- data$available_pdf
    epub <- data$available_epub
    data <- unique(
      rbind(
        pdf,
        epub
      )
    )
  } else {
    stop("Invalid `type`\n")
  }
  data <- data[
    c(
      "Book Title",
      "Author",
      "Product Type",
      "Copyright Year",
      "Electronic ISBN",
      "Series Title",
      "DOI URL",
      "Subject Classification",
      "Publisher"
    )
  ]
  data <- as.data.frame(
    data,
    stringsAsFactors = FALSE
  )
  colnames(data) <- c(
    "Title",
    "Author",
    "Type",
    "Year",
    "ISBN",
    "Series",
    "DOI",
    "Subject",
    "Publisher"
  )
  data <- cbind(
    ID = 1:nrow(data),
    data
  )
  Author <- unlist(
    data["Author"]
  )
  Author <- trimws(
    sort(
      unique(
        as.vector(
          unlist(
            sapply(
              Author,
              FUN = strsplit,
              split = ", "
            )
          )
        )
      )
    )
  )
  Author <- Author[!Author == ""]
  Author <- data.frame(
    ID = 1:length(Author),
    Author = Author
  )
  Type <- unlist(
    data["Type"]
  )
  Type <- trimws(
    sort(
      unique(
        as.vector(
          Type
        )
      )
    )
  )
  Type <- data.frame(
    ID = 1:length(Type),
    Type = Type
  )
  Subject <- unlist(
    data["Subject"]
  )
  Subject <- trimws(
    sort(
      unique(
        as.vector(
          unlist(
            sapply(
              Subject,
              FUN = strsplit,
              split = "; "
            )
          )
        )
      )
    )
  )
  Subject <- data.frame(
    ID = 1:length(Subject),
    Subject = Subject
  )
  Series <- unlist(
    data["Series"]
  )
  Series <- trimws(
    sort(
      unique(
        as.vector(
          Series
        )
      )
    )
  )
  Series <- data.frame(
    ID = 1:length(Series),
    Series = Series
  )
  list(
    data = data,
    Author = Author,
    Type = Type,
    Subject = Subject,
    Series = Series
  )
}
