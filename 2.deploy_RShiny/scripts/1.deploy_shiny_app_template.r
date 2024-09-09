library(dplyr)
library(ggplot2)
library(rsconnect)

rsconnect::setAccountInfo(
  name = Sys.getenv("RSCONNECT_NAME"),
  token = Sys.getenv("RSCONNECT_TOKEN"),
  secret = Sys.getenv("RSCONNECT_SECRET")
)

rsconnect::deployApp(appDir = "../temporal_shiny_app", appName = "temporal_shiny_app")

