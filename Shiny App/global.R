library(dplyr)

# Check if the file exists
if (!file.exists("GlobalTemperatures.csv")) {
  stop("The data file 'GlobalTemperatures.csv' is missing. Please ensure it is in the app directory.")
}

# Load the data using a relative path
global_temps <- read.csv("GlobalTemperatures.csv")

# Convert the 'dt' column to Date type
global_temps$dt <- as.Date(global_temps$dt)

# Filter and clean the dataset
global_temps_clean <- global_temps %>%
  filter(!is.na(LandAverageTemperature)) %>%
  mutate(Decade = floor(as.numeric(format(dt, "%Y")) / 10) * 10) %>%
  group_by(Decade) %>%
  summarise(AvgTemp = mean(LandAverageTemperature, na.rm = TRUE))
