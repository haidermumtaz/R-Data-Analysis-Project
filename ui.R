library(shinydashboard)

dashboardPage(
  # Header
  dashboardHeader(title = "Car Analytics Dashboard"),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter Plot", tabName = "scatter", icon = icon("chart-scatter")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  # Body
  dashboardBody(
    tabItems(
      # Scatter Plot Tab
      tabItem(tabName = "scatter",
        fluidRow(
          box(
            title = "Plot Controls",
            status = "primary",
            solidHeader = TRUE,
            width = 4,
            selectInput("x_var", "Select X-axis Variable:",
                      choices = names(mtcars), selected = "wt"),
            selectInput("y_var", "Select Y-axis Variable:",
                      choices = names(mtcars), selected = "mpg"),
            checkboxInput("show_trend", "Show Trend Line", value = FALSE)
          ),
          box(
            title = "Scatter Plot",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            plotOutput("scatter_plot")
          )
        )
      ),
      
      # About Tab
      tabItem(tabName = "about",
        box(
          title = "About this Dashboard",
          status = "info",
          solidHeader = TRUE,
          width = 12,
          p("This dashboard allows you to explore relationships between different variables in the mtcars dataset."),
          p("Use the scatter plot tab to create interactive visualizations of the data.")
        )
      )
    )
  )
)