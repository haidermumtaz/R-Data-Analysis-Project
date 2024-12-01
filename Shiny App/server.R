library(shiny)
library(ggplot2)
library(shinydashboard)
library(dplyr)


function(input, output, session) {
  
  temp_data <- reactive({
    global_temps <- read.csv("GlobalTemperatures.csv")
    
    global_temps_clean <- global_temps %>%
      filter(!is.na(LandAverageTemperature)) %>%
      mutate(Decade = floor(as.numeric(format(as.Date(dt), "%Y")) / 10) * 10) %>%
      group_by(Decade) %>%
      summarise(AvgTemp = mean(LandAverageTemperature, na.rm = TRUE))
    
    return(global_temps_clean)
  })
  
  # Main plot output
  output$decadePlot <- renderPlot({
    data <- temp_data()
    
    ggplot(data, aes(x = Decade, y = AvgTemp)) +
      geom_line(color = '#FF6B6B', linewidth = 1) +
      geom_point(color = '#4ECDC4', size = 3) +
      geom_smooth(method = 'loess', color = '#45B7D1', fill = '#45B7D180') +
      theme_minimal() +
      labs(
        title = 'Global Land Temperature Change by Decade',
        subtitle = paste('Total change:', 
                        round(tail(data$AvgTemp, 1) - data$AvgTemp[1], 2), 
                        '°C'),
        x = 'Decade',
        y = 'Average Temperature (°C)'
      ) +
      theme(
        plot.title = element_text(size = 14, face = 'bold'),
        plot.subtitle = element_text(size = 12),
        axis.title = element_text(size = 10)
      )
  })
  
  # Value Boxes
  output$totalChangeBox <- renderValueBox({
    data <- temp_data()
    total_change <- round(tail(data$AvgTemp, 1) - data$AvgTemp[1], 2)
    
    valueBox(
      paste0(total_change, "°C"),
      "Total Temperature Change",
      icon = icon("chart-line"),
      color = if(total_change > 0) "red" else "blue"
    )
  })
  
  output$currentTempBox <- renderValueBox({
    data <- temp_data()
    current_temp <- round(tail(data$AvgTemp, 1), 2)
    
    valueBox(
      paste0(current_temp, "°C"),
      "Current Decade Average",
      icon = icon("thermometer-half"),
      color = "purple"
    )
  })
  
  output$earliestTempBox <- renderValueBox({
    data <- temp_data()
    earliest_temp <- round(data$AvgTemp[1], 2)
    
    valueBox(
      paste0(earliest_temp, "°C"),
      "Earliest Decade Average",
      icon = icon("history"),
      color = "blue"
    )
  })
  
  # Future temperature projection
  output$futureTempPlot <- renderPlot({
    data <- temp_data()
    
    # Ensure the Decade column exists
    if (!"Decade" %in% colnames(data)) {
      stop("Decade column not found in data")
    }
    
    # Fit a linear model using historical data
    model <- lm(AvgTemp ~ Decade, data = data)
    
    # Get the current decade
    current_decade <- floor(as.numeric(format(Sys.Date(), "%Y")) / 10) * 10
    
    # Predict future temperatures starting from the current decade
    future_decades <- data.frame(Decade = seq(current_decade, current_decade + 100, by = 10))
    future_temps <- predict(model, newdata = future_decades)
    
    # Create a data frame for future data
    future_data <- data.frame(Decade = future_decades$Decade, AvgTemp = future_temps)
    
    # Calculate the years when the temperature increases by 1 degree (future work didnt complete)
    #initial_temp <- tail(data$AvgTemp, 1)
    #temp_increase_years <- future_data %>%
    #  filter(AvgTemp >= initial_temp + 1) %>%
     # slice(1) %>%
      #pull(Decade)
    
    # Plot
    ggplot(future_data, aes(x = Decade, y = AvgTemp)) +
      geom_line(color = '#FF6B6B', linewidth = 1) +
      geom_point(color = '#45B7D1', size = 3, shape = 4) +
      theme_minimal() +
      labs(
        title = 'Future Global Land Temperature Projection by Decade',
        x = 'Decade',
        y = 'Average Temperature (°C)'
      ) +
      theme(
        plot.title = element_text(size = 14, face = 'bold'),
        axis.title = element_text(size = 10)
      )
  })
}

