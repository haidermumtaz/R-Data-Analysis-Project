source("global.R")

ui <- dashboardPage(
  dashboardHeader(
    title = tags$div(
      style = "font-size: 16px;",  # Adjust the font size as needed
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
            plotOutput("decadePlot", height = "400px")
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
            p("Climate change is arguably the biggest issue facing humanity today, as the Earth's rising temperatures have profound and escalating consequences as global average temperatures increase."),
            p("This graph shows the change in global land temperature over the decades from 1750 to 2024."),
            p("The trend line indicates the overall warming trend observed in the data."),
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
            plotOutput("futureTempPlot", height = "400px")
          )
        ),
        fluidRow(
          box(
            width = 12,
            status = "info",
            solidHeader = TRUE,
            title = "Future Projections Information",
            p("This projection uses a linear model to estimate future global land temperatures based on historical data."),
            p("The model predicts temperature changes for the next 100 years, starting from the current decade."),
            p("As you can see, the temperature is projected to continue to rise, with the rate of warming accelerating.
            As we have learned from the data, the earth has already reached a peak of 1.47°C of warming.")
            
          )
        )
      ),
# Future Impact of Global Warming Tab
      tabItem(
        tabName = "future_impact",
        fluidRow(
          box(
            width = 12,
            status = "warning",
            solidHeader = TRUE,
            title = "Future Impact of Global Warming",
            p("If the Earth continues to warm at this rate, the effects on our planet will be catastrophic, even at such small scales of 1 degree celcius."),
          )
        ),
        fluidRow(
          box(
            width = 6,
            status = "info",
            solidHeader = TRUE,
            title = "1.5°C of warming",
            p(" -Greater sea-level rise threatening coastal communities."),
          p(" -Loss of up to 90% of coral reefs."),
          p(" -Increased water scarcity affecting millions of people."),
          p(" -Decline in agricultural productivity in many regions, risking food security.")
          ),
          box(
            width = 6,
            status = "info",
            solidHeader = TRUE,
            title = "2°C of warming",
          p("-Virtually all coral reefs lost."),
          p("-Significant rise in sea levels (20-30 cm by 2100), displacing tens of millions of people."),
          p("-Arctic ice-free in summer at least once per decade."),
          p("-Doubling of extreme heat days in many regions."),
          p("Mass extinctions as ecosystems fail to adapt."),
          p("Severe health impacts, including heat-related illnesses and vector-borne diseases.")
          )
        ),
        fluidRow(
          box(
            width = 6,
            status = "info",
            solidHeader = TRUE,
            title = "3° of warming",
            p("-Massive displacement of people (hundreds of millions) due to coastal flooding and desertification."),
            p("-Agricultural productivity severely reduced, risking widespread food shortages."),
            p("-Widespread water scarcity, impacting billions."),
            p("-Catastrophic biodiversity loss across terrestrial and marine ecosystems."),
            p("-Increased risk of feedback loops, such as methane release from permafrost.")
            ),
          box(
            width = 6,
            status = "info",
            solidHeader = TRUE,
            title = "4°C of warming",
            p("-Global ecosystems unable to sustain current lifeforms; extinction of countless species."),
            p("-Collapse of major agricultural systems."),
            p("-Permanent inundation of major cities (e.g., New York, Mumbai, Tokyo)."),
            p("-Heatwaves so severe they exceed the survivability threshold for humans in some areas."),
            p("-Mass migration and geopolitical instability.")
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


