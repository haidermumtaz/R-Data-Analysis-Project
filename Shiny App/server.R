source("global.R")

function(input, output, session) {

 
  temp_data <- reactive({
    global_temps_clean
  })

  # Main plot output
  output$decadePlot <- renderPlotly({
    data <- temp_data()
    
    total_change <- round(tail(data$avg_temp, 1) - data$avg_temp[1], 2)
    
    p <- ggplot(data, aes(x = decade, y = avg_temp)) +
      geom_line(color = '#FF6B6B', linewidth = 1) +
      geom_point(
        color = '#4ECDC4', 
        size = 3,
        aes(text = paste0(
          "Decade: ", decade,
          "\nTemperature: ", round(avg_temp, 2), "°C"
        ))
      ) +
      geom_smooth(method = 'loess', color = '#45B7D1', fill = '#45B7D180') +
      theme_minimal() +
      labs(
        title = 'Global Land Temperature Change by Decade',
        subtitle = paste('Total change:', total_change, '°C'),
        x = 'Decade',
        y = 'Average Temperature (°C)'
      ) +
      theme(
        plot.title = element_text(size = 14, face = 'bold'),
        plot.subtitle = element_text(size = 12),
        axis.title = element_text(size = 10)
      )
    
    ggplotly(p, tooltip = "text") %>%
      config(displayModeBar = FALSE) %>%
      layout(
        hoverlabel = list(
          bgcolor = "white",
          font = list(size = 12)
        ),
        title = list(
          text = paste0(
            'Global Land Temperature Change by Decade',
            '<br>',
            '<sup>',
            'Total change: ', total_change, '°C',
            '</sup>'
          ),
          font = list(size = 14, weight = 'bold')
        )
      )
  })
  
  # Value Boxes
  output$totalChangeBox <- renderValueBox({
    data <- temp_data()
    total_change <- round(tail(data$avg_temp, 1) - data$avg_temp[1], 2)
    
    valueBox(
      paste0(total_change, "°C"),
      "Total Temperature Change",
      icon = icon("chart-line"),
      color = if(total_change > 0) "red" else "blue"
    )
  })

  output$currentTempBox <- renderValueBox({
    data <- temp_data()
    current_temp <- round(tail(data$avg_temp, 1), 2)
    
    valueBox(
      paste0(current_temp, "°C"),
      "Current Decade Average",
      icon = icon("thermometer-half"),
      color = "purple"
    )
  })
  
  output$earliestTempBox <- renderValueBox({
    data <- temp_data()
    earliest_temp <- round(data$avg_temp[1], 2)
    
    valueBox(
      paste0(earliest_temp, "°C"),
      "Earliest Decade Average",
      icon = icon("history"),
      color = "blue"
    )
  })
  
  # Reactive expression for model fitting and predictions
  predictions_data <- reactive({
    time_index <- 1:nrow(global_temps_clean)
    poly_model <- lm(temp_change ~ poly(time_index, 2), 
                     data=global_temps_clean, 
                     weights=weight)
    
    future_time <- (max(time_index) + 1):(max(time_index) + 30)
    future_decades <- seq(max(global_temps_clean$decade) + 10, by=10, length.out=30)
    
    predictions <- predict(poly_model, 
                          newdata=data.frame(time_index=future_time),
                          interval="prediction",
                          level=0.95)
    
    predictions_df <- data.frame(
      decade = future_decades,
      temp_change = predictions[,"fit"]
    )
    
    last_decade_index <- which(predictions_df$temp_change >= 4)[1]
    if(!is.na(last_decade_index)) {
      predictions_df <- predictions_df[1:last_decade_index,]
    }
    
    return(predictions_df)
  })
  
  # Generate the plot
  output$temp_plot <- renderPlotly({
    predictions_df <- predictions_data()
    
    p <- ggplot() +
      geom_line(data=predictions_df, aes(x=decade, y=temp_change), 
                color="red", size=1) +
      
      geom_hline(yintercept=seq(1.5, 4.0, by=0.5), 
                 linetype="dashed", color="darkgreen", alpha=0.7) +
      
      annotate("text", x=max(predictions_df$decade), 
               y=seq(1.5, 4.0, by=0.5), 
               label=paste0(seq(1.5, 4.0, by=0.5), "°C"), 
               hjust=-0.1, color="darkgreen") +
      
      theme_minimal() +
      labs(title="Projected Temperature Change (Present day onwards)",
           x="Decade",
           y="Temperature Change (°C)") +
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5)) +
      scale_x_continuous(breaks = seq(2020, max(predictions_df$decade), by=20)) +
      scale_y_continuous(limits = c(1.5, 4.2))
    
    ggplotly(p) %>% 
      config(displayModeBar = FALSE) %>%
      layout(
        hovermode = "x unified",
        hoverlabel = list(
          bgcolor = "#F0F8FF",
          bordercolor = "#4682B4",
          font = list(size = 12, color = "#2F4F4F")
        )
      ) %>%
      style(
        hovertemplate = paste(
          "Decade: %{x}<br>",
          "Temperature Change: %{y:.2f}°C",
          "<extra></extra>"
        )
      )
  })
  
  # Generate the threshold crossings table
  output$threshold_table <- renderTable({
    predictions_df <- predictions_data()
    thresholds <- seq(1.5, 4.0, by=0.5)
    threshold_crossings <- data.frame()
    
    for(threshold in thresholds) {
      crossing <- predictions_df[which(predictions_df$temp_change >= threshold)[1],]
      if(nrow(crossing) > 0) {
        threshold_crossings <- rbind(threshold_crossings,
                                   data.frame(threshold=threshold,
                                            decade=crossing$decade,
                                            temp_change=round(crossing$temp_change, 2)))
      }
    }
    
    names(threshold_crossings) <- c("Temperature Threshold (°C)", "Decade", "Projected Temperature (°C)")
    threshold_crossings
  })

  # Impact data for different temperature thresholds
  impact_data <- data.frame(
    threshold = c(1.5, 2.0, 3.0, 4.0),
    description = c(
      paste(
        "<ul>",
        "<li>Greater sea-level rise threatening coastal communities.</li>",
        "<li>Loss of up to 90% of coral reefs.</li>",
        "<li>Increased water scarcity affecting millions of people.</li>",
        "<li>Decline in agricultural productivity in many regions.</li>",
        "</ul>"
      ),
      paste(
        "<ul>",
        "<li>All coral reefs lost.</li>",
        "<li>20-30 cm sea-level rise by 2100, displacing tens of millions.</li>",
        "<li>Arctic ice-free in summer at least once per decade.</li>",
        "<li>Doubling of extreme heat days in many regions.</li>",
        "<li>Mass extinctions as ecosystems fail to adapt.</li>",
        "</ul>"
      ),
      paste(
        "<ul>",
        "<li>Massive displacement of hundreds of millions.</li>",
        "<li>Agriculture severely reduced, risking food shortages.</li>",
        "<li>Widespread water scarcity, impacting billions.</li>",
        "<li>Catastrophic biodiversity loss across ecosystems.</li>",
        "<li>Increased risk of feedback loops (e.g., methane release).</li>",
        "</ul>"
      ),
      paste(
        "<ul>",
        "<li>Global ecosystems unable to sustain current lifeforms.</li>",
        "<li>Collapse of major agricultural systems.</li>",
        "<li>Permanent inundation of major coastal cities.</li>",
        "<li>Heatwaves exceeding survivability threshold in some areas.</li>",
        "<li>Mass migration and geopolitical instability.</li>",
        "</ul>"
      )
    ),
    stringsAsFactors = FALSE
  )

  # Dynamic impact details based on selected threshold
  output$impactDetails <- renderUI({
    req(input$thresholdSelect)
    
    chosen_threshold <- as.numeric(input$thresholdSelect)
    
    predictions_df <- predictions_data()
    
    crossing_index <- which(predictions_df$temp_change >= chosen_threshold)[1]
    
    if (is.na(crossing_index)) {
      decade_text <- paste("This model does NOT project crossing", 
                           chosen_threshold, "°C within the next",
                           max(predictions_df$decade) - 2020, "years.")
    } else {
      crossed_decade <- predictions_df$decade[crossing_index]
      crossed_temp   <- round(predictions_df$temp_change[crossing_index], 2)
      
      line1 <- paste0("The model projects crossing ", 
                      chosen_threshold, "°C in the decade of ", 
                      crossed_decade, 
                      " (projected temperature: ", 
                      crossed_temp, "°C)")
      line2 <- paste0("The Impact of ", chosen_threshold, "°C of warming is:")
      
      tagList(
        strong(line1),
        br(), br(),
        strong(line2),
        HTML(impact_data[impact_data$threshold == chosen_threshold, ]$description)
      )
    }
  })

}



