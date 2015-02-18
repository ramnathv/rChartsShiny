## @knitr ui.R
require(rCharts)
options(RCHART_LIB = 'polycharts')
shinyUI(pageWithSidebar(
  headerPanel("Percentage of Employed who are Senior Managers, by Sex"),
  
  sidebarPanel(
    selectInput(inputId = "year",
      label = "Select year to compare countries",
      choices = sort(unique(dat2m$year)),
      selected = 2011),
    selectInput(inputId = "country",
      label = "Select country to compare years",
      choices = sort(unique(as.character(dat2m$country))),
      selected = "Canada")
  ),
  
  mainPanel(
    showOutput("chart1", "polycharts"),
    showOutput("chart2", "polycharts")
  )
))