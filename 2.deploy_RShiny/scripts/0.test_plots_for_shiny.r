library(ggplot2)
library(dplyr)
library(arrow)
library(devtools)
devtools::install_github("thomasp85/patchwork")
library(patchwork)
library(ggExtra)
library(ggplotify)

# set path to the loadable data
data_path <- "../../data/All_academic_projects_funded_by_NIH_cleaned.parquet"
academic_df <- arrow::read_parquet(data_path)
academic_df$combined_institute_and_activity <- paste(academic_df$`Institute/Center`, academic_df$`Activity Code`, sep = " - ")
academic_df$`Total Funding` <- academic_df$`Total Funding` / 1000000
dim(academic_df)
head(academic_df)

# select RO1 from NCI
nci_ro1_df <- academic_df %>% filter(`Activity Code` == "R01")
dim(nci_ro1_df)
nci_ro1_df

# get a scaled metric for the total funding amount, total awards, total reviews, and success rate for each institution and activity code
funding_vs_success_plot <- (
    ggplot(data = nci_ro1_df, aes(x = `Total Funding`, y = `Success Rate`, color = combined_institute_and_activity))
    + geom_point(size = 2)
    # Move legedn to the bottom
    + theme(legend.position = "bottom")
    + labs(title = "Total Funding vs Success Rate for NCI RO1 Grants",
           x = "Total Funding (Millions)",
           y = "Success Rate",
              color = "Institute/Center - Activity Code")
    # make the legend title to be on the top of the legend
    + theme(legend.title = element_text(hjust = 0.5))
      + guides(color = guide_legend(title.position = "top")
      )
)
funding_vs_success_plot <- ggMarginal(funding_vs_success_plot, type="density")
funding_vs_success_plot




# plot the success rate of the projects by Activity Code and Institute
height <- 10
width <- 20
options(repr.plot.width = width, repr.plot.height = height)
success_plot <- (
    ggplot(data = academic_df, aes(x = `Institute/Center`, y = `Success Rate`, fill = `Activity Code`))
    + geom_bar(stat = "identity", position = "dodge")
    )
success_plot

# plot the total amount of funding by Activity Code and Institute
dollar_plot <- (
    ggplot(data = academic_df, aes(x = `Institute/Center`, y = `Total Funding`, fill = `Activity Code`))
    + geom_bar(stat = "identity", position = "dodge")
    # remove legend
    + theme(legend.position = "none")
    )
dollar_plot

# Final plot combining all plots in patchwork
success_plot + dollar_plot / as.grob(funding_vs_success_plot)

