---
title: rCharts
subtitle: Shiny Applications
author: Ramnath Vaidyanathan
github:
  user: ramnathv
  repo: rChartsShiny
  branch: "gh-pages"
framework: minimal
mode: selfcontained
widgets: polycharts
hitheme: solarized_dark
---

## Interactive Visualizations with rCharts and Shiny

<style>
p {
  text-align: justify;
}
body {
 background-image: url(libraries/frameworks/minimal/images/light_wool.png)
}
</style>

In this blog post, I will take you through the details of creating an interactive visualization using [rCharts](http://ramnathv.github.io/rCharts) and [Shiny](http://rstudio.github.io/shiny). I will be attempting to replicate [this visualization](http://www.oecd.org/gender/data/proportionofemployedwhoareseniormanagersbysex.htm) of senior manager percentages by gender across countries, put together by OECD using [Tableau](http://www.tableausoftware.com). Here is the [final shiny app](http://glimmer.rstudio.com/ramnathv/rChartOECD/) that we will be building.

## Data

The data was collected by the International Labor Organization. I used a version of the dataset put together by the excellent data visualization blog: [thewhyaxis](http://thewhyaxis.info/gap-remake/). I cleaned up the dataset, partially in excel and then in R to get the following (more details on the clean up excercise in R can be found in the github repo)


```
         country countrycode year id gender value
1           OECD        OECD 1995  1    Men   9.4
3        Austria         AUT 1995  3    Men   9.5
4        Belgium         BEL 1995  4    Men  12.2
5         Canada         CAN 1995  5    Men  13.2
7 Czech Republic         CZE 1995  7    Men   8.0
8        Denmark         DNK 1995  8    Men   9.6
```


We now proceed to creating an interactive visualization. If you want to follow along, you would need to install `rCharts`, an R package that provides a  [lattice](http://cran.r-project.org/web/packages/lattice/index.html) package style plotting interface to create interactive visualizations using the javascript library [polychart.js](https://github.com/Polychart/polychart2).



```r
require(devtools)
install_github("rCharts", "ramnathv")
```


## First Steps

Our first objective is to recreate the charts here without any menu controls. Once we are able to achieve that, we can add the menu controls easily using Shiny and convert it into an interactive app. This blog post will attemp to show you both how to use rCharts to create such visualizations, as well as how to convert them into an interactive app using Shiny.
 



### Bar Plot

We will now recreate the bar plot shown in the Tableau visualization.


<div id='chart1'></div>


```r
require(rCharts)
YEAR = 2011
# Step 1. create subsets of data by gender
men   <- subset(dat2m, gender == "Men" & year == YEAR)
women <- subset(dat2m, gender == "Women" & year == YEAR)

# Step 2. initialize bar plot for value by countrycode for women
p1 <- rPlot(x = list(var = "countrycode", sort = "value"), y = "value", 
  color = 'gender', data = women, type = 'bar')

# Step 3. add a second layer for men, displayed as points
p1$layer(x = "countrycode", y = "value", color = 'gender', 
  data = men, type = 'point', size = list(const = 3))

# Step 4. format the x and y axis labels
p1$guides(x = list(title = "", ticks = unique(men$countrycode)))
p1$guides(y = list(title = "", max = 18))

# Step 5. set the width and height of the plot and attach it to the dom
p1$addParams(width = 600, height = 300, dom = 'chart1',
  title = "Percentage of Employed who are Senior Managers")

# Step 6. print the chart (just type p1 if you are using it in your R console)
p1$printChart()
```

<script type='text/javascript'>
    var chartParams = {"dom":"chart1","width":600,"height":300,"layers":[{"x":{"var":"countrycode","sort":"value"},"y":"value","data":{"country":["OECD","Austria","Belgium","Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary","Iceland","Ireland","Italy","Luxembourg","Netherlands","Norway","Poland","Portugal","Slovak Republic","Slovenia","Spain","Sweden","Switzerland","United Kingdom"],"countrycode":["OECD","AUT","BEL","CZE","DNK","EST","FIN","FRA","DEU","GRC","HUN","ISL","IRL","ITA","LUX","NLD","NOR","POL","PRT","SVK","SVN","ESP","SWE","CHE","GBR"],"year":[2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011],"id":[1,3,4,7,8,9,10,11,12,13,14,15,16,18,21,23,25,26,27,28,29,30,31,32,34],"gender":["Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women"],"value":[4.4,3,4.7,2.8,1.6,6.5,3.4,6.2,3.2,2.4,5,7.5,5.3,2.4,2.4,4.7,4.3,5.2,4.3,3.7,6.9,3.3,4,5.7,7.5]},"color":"gender","type":"bar"},{"x":"countrycode","y":"value","data":{"country":["OECD","Austria","Belgium","Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary","Iceland","Ireland","Italy","Luxembourg","Netherlands","Norway","Poland","Portugal","Slovak Republic","Slovenia","Spain","Sweden","Switzerland","United Kingdom"],"countrycode":["OECD","AUT","BEL","CZE","DNK","EST","FIN","FRA","DEU","GRC","HUN","ISL","IRL","ITA","LUX","NLD","NOR","POL","PRT","SVK","SVN","ESP","SWE","CHE","GBR"],"year":[2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011],"id":[1,3,4,7,8,9,10,11,12,13,14,15,16,18,21,23,25,26,27,28,29,30,31,32,34],"gender":["Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men"],"value":[7.7,6.8,9.2,6.2,3.8,11.6,6.8,8.6,6.4,5.4,6.3,10.4,9.3,5,5.7,9.6,8.5,6.8,7.8,6.5,9.4,6.3,6.8,9.6,12.5]},"color":"gender","type":"point","size":{"const":3}}],"facet":[],"guides":{"x":{"title":"","ticks":["OECD","AUT","BEL","CZE","DNK","EST","FIN","FRA","DEU","GRC","HUN","ISL","IRL","ITA","LUX","NLD","NOR","POL","PRT","SVK","SVN","ESP","SWE","CHE","GBR"]},"y":{"title":"","max":18}},"coord":[],"title":"Percentage of Employed who are Senior Managers"}
    _.each(chartParams.layers, function(el){el.data = polyjs.data(el.data)})
    polyjs.chart(chartParams);
</script>


The first step is to create subsets of the data by gender for a specific year. We then proceed to initialize a bar plot for `women`. The function `rPlot` uses an interface very similar to the `lattice` package. The first argument specifies that the x variable is going to be `countrycode` and we want it sorted by `value`. The remaining arguments specify different aesthetics of the bar plot.

The next step adds a second layer to this plot using the data for `men`, specifying that the values be displayed as `points`. The code in **Step 3** might seem a little strange to some of you, since there is no explicit assignment involved. The reason for this is that `rCharts` uses [Reference Classes](), which allow object oriented programming in R, leading to more concise code. In essence, `layer2` is a method of the object `p1` that adds a layer to the plot object. 

The last few steps tweak the axis labels, width and height of the plot, before attaching it to a specific DOM element. At this point, you can run Steps 1 through 5 and type `p1` in your R console, and if everything goes right, you will be staring at the same plot created here.


### Line Chart

We can now add a line chart for comparing the values for a specific country across years. We follow the same approach outlined above, except that we only need a single layer in this case.

<div id='chart2'></div>



```r
COUNTRY = "Canada"
country = subset(dat2m, country == COUNTRY)
p2 <- rPlot(value ~ year, color = 'gender', type = 'line', data = country)
p2$addParams(width = 600, height = 300, dom = 'chart2')
p2$guides(y = list(min = 0, title = ""))
p2$printChart()
```

<script type='text/javascript'>
    var chartParams = {"dom":"chart2","width":600,"height":300,"layers":[{"x":"year","y":"value","data":{"country":["Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada","Canada"],"countrycode":["CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN","CAN"],"year":[1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008],"id":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"gender":["Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Men","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women","Women"],"value":[13.2,12.8,11.7,11.2,11.6,11.7,11,11.1,10.7,11,11.1,11.2,10.9,11.3,8.4,8.8,8.1,8.2,7.4,7.5,6.9,6.6,6.8,7.2,7,7.2,7.1,7.1]},"color":"gender","type":"line"}],"facet":[],"guides":{"y":{"min":0,"title":""}},"coord":[]}
    _.each(chartParams.layers, function(el){el.data = polyjs.data(el.data)})
    polyjs.chart(chartParams);
</script>



### Shiny App

Now that we have created the charts for a given `COUNTRY` and `YEAR`, we can go ahead and wrap the code in a Shiny app to allow users to interactively choose the inputs. To create a Shiny app, we need two files: `ui.R` that specifies the user interface and `server.R` that specifies how to generate outputs.

#### User Interface (ui.R)

Let us design the user interface first. Note that we need four components, two select boxes to allow the user to select the year and country, and two `div` tags to place the dynamically generated chart output.


```r
require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel("Percentage of Employed who are Senior Managers, by Sex"),
  
  sidebarPanel(
    selectInput(inputId = "year",
      label = "Select year to compare countries",
      choices = sort(unique(dat2m$year)),
      selected = 2011),
    selectInput(inputId = "country",
      label = "Select country to compare years",
      choices = sort(unique(dat2m$country)),
      selected = "Canada")
  ),
  
  mainPanel(
    showOutput("chart1"),
    showOutput("chart2")
  )
))
```


Although the above code is self explanatory, I want to draw your attention to a couple of things. First, we choose a layout where the controls are placed in a sidebar and the charts in the main panel. Second, we generate the choices for the two selection boxes using the unique values for `year` and `country` in the dataset. Third, `showOutput` is a function in `rCharts` that creates placeholders for the generated charts, with a given id.

#### Chart Output (server.R)

Now that we nailed the UI, we need to tweak the plotting code to interface with the UI. To achieve this, we need to do three things. First, we need to replace COUNTRY and YEAR by `input$country` and `input$year` so that their values are dynamically obtained from user input. Second, we need to wrap the plotting calls inside `renderChart`, which is a function in `rCharts` that adds allows the plots to react to user inputs. Third, we need to assign the output of these calls to their respective elements in the UI (chart1 and chart2).


```r
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
```


Finally, we place the code required to read and process the data in `global.R` so that the data is accessible to both `ui.R` and `server.R`. You can see the resulting [Shiny app here](http://glimmer.rstudio.com/ramnathv/rChartOECD) and the [source code](https://github.com/ramnathv/rChartsShiny/tree/gh-pages/rChartOECD) 


### Notes

This blog post is a github repo and is reproducible using the [slidify](http://slidify.org) package. You can download/clone this repo and run `slidify("index.Rmd")` to reproduce the entire post along with the embedded charts. If you have any questions or comments, please use the [issues page](https://github.com/ramnathv/rChartsShiny/issues/new), tagging it appropriately.

### License

`rCharts` is licensed under the MIT License. However, the Polycharts JavaScript library used to create these charts is not free for commercial use. You can read more about its license at http://polychart.com/js/license.



