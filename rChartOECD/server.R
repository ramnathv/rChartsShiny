require(rCharts)
shinyServer(function(input, output) {
  output$chart1 <- renderChart({
    YEAR = input$year
    men <- subset(dat2m, gender == "Men" & year == YEAR)
    women <- subset(dat2m, gender == "Women" & year == YEAR)
    p1 <- rPlot(x = list(var = "countrycode", sort = "value"), y = "value", 
                color = 'gender', data = women, type = 'bar')
    p1$layer2(x = "countrycode", y = "value", color = 'gender', 
              data = men, type = 'point', size = list(const = 3))
    p1$addParams(height = 300, dom = 'chart1', 
                 title = "Percentage of Employed who are Senior Managers")
    p1$guides(x = list(title = "", ticks = unique(men$countrycode)))
    p1$guides(y = list(title = "", max = 18))
    return(p1)
  })
  output$chart2 <- renderChart({
    COUNTRY = input$country
    country = subset(dat2m, country == COUNTRY)
    p2 <- rPlot(value ~ year, color = 'gender', type = 'line', data = country)
    p2$guides(y = list(min = 0, title = ""))
    p2$guides(y = list(title = ""))
    p2$addParams(height = 300, dom = 'chart2')
    return(p2)
  })
})