library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)

if (!file.exists("GlobalTemperatures.csv")) {
  stop("The data file 'GlobalTemperatures.csv' is missing. Please ensure it is in the app directory.")
}

global_temps <- read.csv("GlobalTemperatures.csv")

global_temps$dt <- as.Date(global_temps$dt)

# Filter and clean the dataset
global_temps_clean <- global_temps %>%
  filter(!is.na(LandAverageTemperature)) %>%
  mutate(Decade = floor(as.numeric(format(dt, "%Y")) / 10) * 10) %>%
  group_by(Decade) %>%
  summarise(AvgTemp = mean(LandAverageTemperature, na.rm = TRUE))
