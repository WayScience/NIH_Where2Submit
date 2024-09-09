# server layout for the landing page
library(shiny)
library(shinyWidgets)
library(rsconnect)

# Define UI
ui <- fluidPage(
  titlePanel("NIH Grants Explorer, 2023 Data."),

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
