library(shiny)
library(ggplot2)
library(shinydashboard)

function(input, output, session) {
  
  # Reactive expression to create the ggplot based on inputs
  output$scatter_plot <- renderPlot({
    p <- ggplot(mtcars, aes_string(x = input$x_var, y = input$y_var)) +
      geom_point(size = 3, color = "blue") +
      labs(
        x = input$x_var,
        y = input$y_var,
        title = paste("Scatter Plot of", input$y_var, "vs", input$x_var)
      ) +
      theme_minimal()
    
    # Add trend line if checkbox is checked
    if (input$show_trend) {
      p <- p + geom_smooth(method = "lm", se = FALSE, color = "red")
    }
    
    p
  })
}
