# R-Data-Analysis-Project

The Dataset was exceeding my GitHub Large File Storage Limit so it is not included in the repo. You can download it from [Kaggle](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data/data).

No google slide deck for this one as project is presented through Shiny Dashboard

The purpose of this project is to analyze Earth's climate change using R and visualize key findings through a Shiny App. The dashboard provides insights into historical temperature trends, future projections based on ETS and ARIMA models, performance evaluations of these models, and outlines the potential impacts of global warming at various temperature thresholds.

## How to Run the Shiny App

1. **Download the Dataset:**
   - Ensure that the `GlobalTemperatures.csv` file is placed in the app's directory.

2. **Install Required Packages:**
   - The app automatically checks and installs necessary packages. However, you can manually install them using the following command:
     ```r
     install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "forecast", "lubridate", "DT", "shinycssloaders"))
     ```

3. **Run the App:**
   - Open R or RStudio, set the working directory to the app's folder, and execute:
     ```r
     shiny::runApp()
     ```

## Future Work

1. **Advanced Time Series Analysis:**
   - Implement more sophisticated models such as Bayesian Structural Time Series (BSTS) for improved forecasting accuracy.

FUTURE WORK:

## Acknowledgments

- **Data Source:** [Berkeley Earth Surface Temperature Data](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data/data)
- **R Shiny:** For enabling interactive web applications in R.
