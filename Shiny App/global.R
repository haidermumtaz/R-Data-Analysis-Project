library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(lubridate)

if (!file.exists("GlobalTemperatures.csv")) {
  stop("The data file 'GlobalTemperatures.csv' is missing. Please ensure it is in the app directory.")
}

global_temps <- read.csv("GlobalTemperatures.csv")

global_temps$dt <- as.Date(global_temps$dt)

# Filter and clean the dataset
global_temps_clean <- global_temps %>%
  filter(!is.na(LandAverageTemperature)) %>%
  mutate(
    year = year(dt),
    decade = floor(year / 10) * 10
  ) %>%
  group_by(decade) %>%
  summarize(
    avg_temp = mean(LandAverageTemperature, na.rm = TRUE),
    avg_uncertainty = mean(LandAverageTemperatureUncertainty, na.rm = TRUE)
  ) %>%
  filter(!is.na(avg_temp))

# Calculate weights and temperature change
global_temps_clean$weight <- 1 / global_temps_clean$avg_uncertainty
global_temps_clean$weight <- global_temps_clean$weight / sum(global_temps_clean$weight)
baseline_temp <- global_temps_clean$avg_temp[1]
global_temps_clean$temp_change <- global_temps_clean$avg_temp - baseline_temp