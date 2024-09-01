library(shiny)
library(shinyWidgets)

# Define UI
ui <- fluidPage(
  titlePanel("NIH Grants Explorer"),

  sidebarLayout(
    sidebarPanel(
      pickerInput(
        inputId = "activity_code",
        label = "Select Activity Codes:",
        choices = NULL, # Choices will be updated dynamically
        multiple = TRUE,
        options = list(`actions-box` = TRUE, `live-search` = TRUE)
      ),
      pickerInput(
        inputId = "institute_center",
        label = "Select Institutes/Centers:",
        choices = NULL, # Choices will be updated dynamically
        multiple = TRUE,
        options = list(`actions-box` = TRUE, `live-search` = TRUE)
      )
    ),

    mainPanel(
      plotOutput("MainPlot", width = "100%", height = "1600px") # Adjust width and height as needed
    )
  )
)
