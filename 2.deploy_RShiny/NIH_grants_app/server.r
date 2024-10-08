# this is the R shiny app logic that will be deployed to shinyapps.io
library(shiny)
library(ggplot2)
library(dplyr)
library(arrow)
library(shinyWidgets)

# Install required packages if not already installed
if (!require(ggExtra)) {
  install.packages("ggExtra")
}
if (!require(patchwork)) {
  install.packages("patchwork")
}
if (!require(ggplotify)) {
  install.packages("ggplotify")
}
if (!require(rsconnect)) {
  install.packages("rsconnect")
}


library(patchwork)
library(ggExtra)
library(ggplotify)
library(rsconnect)

# Define server logic
server <- function(input, output, session) {
  df <- arrow::read_parquet("All_academic_projects_funded_by_NIH_cleaned.parquet")
  df$combined_institute_and_activity <- paste(df$`Institute/Center`, df$`Activity Code`, sep = " - ")
  df$`Total Funding` <- df$`Total Funding` / 1000000 # Convert to millions

  all_activity_code_choices <- unique(df$`Activity Code`)
    all_institute_center_choices <- unique(df$`Institute/Center`)

  # Set default selections
  default_activity_code <- unique("F31")
  default_institute_center <- unique(df$`Institute/Center`)



  # Update activity code choices
  observe({
    updatePickerInput(session, "activity_code", choices = all_activity_code_choices, selected = default_activity_code)
  })

  # Update institute/center choices
  observe({
    updatePickerInput(session, "institute_center", choices = all_institute_center_choices, selected = default_institute_center)
  })

  output$MainPlot <- renderPlot({
    # Filter data based on selected activity codes and institutes/centers
    data <- dplyr::filter(df, `Activity Code` %in% input$activity_code & `Institute/Center` %in% input$institute_center)

    # Create plots
    success_plot <- (
      ggplot(data = data, aes(x = `Institute/Center`, y = `Success Rate`, fill = `Activity Code`))
      + geom_bar(stat = "identity", position = "dodge")
      + theme_bw()
      + labs(title = "Success Rate by Institute/Center", x = "Institute/Center", y = "Success Rate")
      + theme(axis.text.x = element_text(angle = 90, hjust = 1),
              text = element_text(size = 16), # Increase text size
              plot.title = element_text(size = 20, hjust = 0.5)) # Increase title size
    )

    # Check if the data frame is empty
    if (nrow(data) == 0) {
      # Display a default plot
      ggplot() +
        theme_void() +
        theme(
          text = element_text(size = 26, hjust = 0.5, vjust = 0.5)
        ) +
        # set the text to be in the top plot
        ggtitle("Loading data, please wait...") +
        theme(plot.title = element_text(size = 20, hjust = 0.5))


    } else {

    dollar_plot <- (
        ggplot(data = data, aes(x = `Institute/Center`, y = `Total Funding`, fill = `Activity Code`))
        + geom_bar(stat = "identity", position = "dodge")
        + labs(title = "Total Funding by Institute/Center", x = "Institute/Center", y = "Total Funding (Millions)")
        + scale_y_continuous(labels = scales::dollar)
        + theme_bw()
        + theme(axis.text.x = element_text(angle = 90, hjust = 1),
                text = element_text(size = 16), # Increase text size
                plot.title = element_text(size = 20, hjust = 0.5)) # Increase title size
        )

        funding_vs_success_plot <- (
        ggplot(data = data, aes(x = `Total Funding`, y = `Success Rate`, color = combined_institute_and_activity))
        + geom_point(size = 2)
        + labs(title = "Total Funding vs. Success Rate", x = "Total Funding (Millions)", y = "Success Rate", color = "Institute/Center - Activity Code")
        + scale_x_continuous(labels = scales::dollar)
        + theme(text = element_text(size = 16), # Increase text size
                plot.title = element_text(size = 20, hjust = 0.5)) # Increase title size
        + ylim(0, 1)
        + theme_bw()
        + theme(legend.position = "bottom", # Move legend to the bottom
                legend.title = element_text(hjust = 0.5)) # Center the legend title
        + guides(color = guide_legend(title.position = "top")) # Move legend title to the top
        )
        funding_vs_success_plot <- as.ggplot(ggMarginal(funding_vs_success_plot, type="density"))

        # Combine plots
        width <- 20
        height <- 40
        options(repr.plot.width = width, repr.plot.height = height)
        combined_plot <- (success_plot / dollar_plot) / funding_vs_success_plot
        combined_plot
    }
  })
}
