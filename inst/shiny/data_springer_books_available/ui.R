library(shiny)
library(DT)

shinyUI(
  fluidPage(
    title = "JekstersLab Library - Springer Books",
    headerPanel("JekstersLab Library - Springer Books"),
    sidebarPanel(
      h3("Author"),
      DT::dataTableOutput(
        "tbl_author"
      ),
      h3("Type"),
      DT::dataTableOutput(
        "tbl_type"
      ),
      position = "left",
      width = 2
    ),
    mainPanel(
      h3("Books"),
      DT::dataTableOutput(
        "tbl_main"
      )
    ),
    sidebarPanel(
      h3("Subject"),
      DT::dataTableOutput(
        "tbl_subject"
      ),
      h3("Series"),
      DT::dataTableOutput(
        "tbl_series"
      ),
      position = "right",
      width = 2
    )
  )
)
