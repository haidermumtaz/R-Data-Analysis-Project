source("global.R")

ui <- dashboardPage(
  dashboardHeader(
    title = tags$div(
      style = "font-size: 16px;",
      "Global Temperature"
    )
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")),
      menuItem("Temperature Trends", tabName = "temp_trends", icon = icon("temperature-high")),
      menuItem("Future Projection", tabName = "future_projection", icon = icon("chart-line")),
      menuItem("Future Impact of Global Warming", tabName = "future_impact", icon = icon("exclamation-triangle")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Introduction Tab
      tabItem(
        tabName = "introduction",
        fluidRow(
          box(
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            title = "An Analysis of Earth's Global Land Temperature and its Impact on our Climate",
            p("This dashboard provides insights into global land temperature changes over the decades."),
            p("Explore the Temperature Trends tab to see historical data and the Future Projection tab for predictions."),
            p("The About tab contains additional information about the data sources and methodology.")
          )
        )
      ),
      
      # Temperature Trends Tab
      tabItem(
        tabName = "temp_trends",
        fluidRow(
          box(
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            title = "Global Land Temperature Change by Decade",
            plotlyOutput("decadePlot", height = "400px")
          )
        ),
        fluidRow(
          valueBoxOutput("totalChangeBox", width = 4),
          valueBoxOutput("currentTempBox", width = 4),
          valueBoxOutput("earliestTempBox", width = 4)
        ),
        fluidRow(
          box(
            width = 12,
            status = "info",
            solidHeader = TRUE,
            title = "Temperature Trends Information",
            p("As you can see, the earth has already surpassed 1°C of warming since the Industrial Revolution. 
            Present day temperatures are the highest they have been in the last 2,000 years and have reached a peak of 1.47°C of total global warming.
            Our current status of over 1° C of warming has had alarming impacts on our climate and ecosystems, which are not limited to: "),
            p(" -Increased frequency and intensity of heatwaves."),
            p("-Melting glaciers and polar ice, causing sea-level rise."),
            p("-Coral reef bleaching of over 70% of reefs."),
            p("-More extreme weather events like hurricanes, droughts, and floods."),
            p("-Changes in ecosystems, with some species struggling to adapt.")
            
          )
        )
      ),
      
      # Future Projection Tab
      tabItem(
        tabName = "future_projection",
        fluidRow(
          box(
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            title = "Future Global Land Temperature Projection",
            plotlyOutput("temp_plot", height = "400px")
          )
        ),
        fluidRow(
          box(
            width = 12,
            status = "info",
            solidHeader = TRUE,
            title = "Future Projections Information",
            p("This projection uses a linear model to estimate future global land temperatures based on historical data."),
            p("The projection predicts temperature changes for the next 100 years, starting from the current decade."),
            p("As you can see, the temperature is projected to continue to rise, with the rate of warming accelerating.
            As we have learned from the data, the earth has already reached a peak of 1.47°C of warming.")
            
          )
        )
      ),
tabItem(
  tabName = "future_impact",
  fluidRow(
    box(
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      title = "Future Impact of Global Warming",
      p("If the Earth continues to warm at this rate, the effects on our planet will be catastrophic, even at such small scales of 1 degree Celsius.")
    )
  ),
  fluidRow(
    box(
      width = 12,
      status = "info",
      solidHeader = TRUE,
      title = "Explore the Effects by Temperature Threshold",
      selectInput(
        inputId = "thresholdSelect",
        label = "Choose a Temperature Threshold (°C):",
        choices = c(1.5, 2.0, 3.0, 4.0)
      ),
      uiOutput("impactDetails")
    )
  )
),

      
      # About Tab
      tabItem(
        tabName = "about",
        box(
          width = 12,
          title = "About This Dashboard",
          "This dashboard visualizes global land temperature changes across decades using the Berkeley Earth Surface Temperature dataset."
        )
      )
    )
  )
)


