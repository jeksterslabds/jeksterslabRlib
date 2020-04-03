library(shiny)
library(DT)
library(jeksterslabRlib)

shinyServer(
  function(
           input,
           output,
           session) {
    #########################################################################
    # get selectInput to work on type
    #########################################################################
    out <- data_springer_books_available(type = "both")
    data <- out[["data"]]
    Author <- out[["Author"]]
    Type <- out[["Type"]]
    Subject <- out[["Subject"]]
    Series <- out[["Series"]]
    output$tbl_author <- DT::renderDataTable(
      Author,
      rownames = FALSE,
      server = TRUE,
      options = list(
        searchHighlight = TRUE,
        search = list(
          regex = TRUE,
          caseInsensitive = TRUE
        )
      )
    )
    output$tbl_type <- DT::renderDataTable(
      Type,
      rownames = FALSE,
      server = TRUE,
      options = list(
        searchHighlight = TRUE,
        search = list(
          regex = TRUE,
          caseInsensitive = TRUE
        )
      )
    )
    output$tbl_subject <- DT::renderDataTable(
      Subject,
      rownames = FALSE,
      server = TRUE,
      options = list(
        searchHighlight = TRUE,
        search = list(
          regex = TRUE,
          caseInsensitive = TRUE
        )
      )
    )
    output$tbl_series <- DT::renderDataTable(
      Series,
      rownames = FALSE,
      server = TRUE,
      options = list(
        searchHighlight = TRUE,
        search = list(
          regex = TRUE,
          caseInsensitive = TRUE
        )
      )
    )
    output$tbl_main <- DT::renderDataTable(
      data,
      rownames = FALSE,
      filter = "top",
      server = TRUE,
      extensions = "Buttons",
      options = list(
        dom = "Bfrtip",
        buttons = c(
          "copy",
          "csv",
          "excel",
          "pdf",
          "print"
        ),
        searchHighlight = TRUE,
        search = list(
          regex = TRUE,
          caseInsensitive = TRUE
        )
      )
    )
  }
)
