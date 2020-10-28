#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(sf)
library(stplanr)
library(tmap)

# Define UI for application that draws a histogram
shinyUI(fixedPage(

    # Application title
    titlePanel("Origin-destination matrices (ODMs) explorer"),
    
    sidebarLayout(
        sidebarPanel(
            radioButtons("mode", h4("Please select the transport mode:"),
                         choices = list("Non-bike" = 'Non-bike',
                                        'E-bike' = 'E-bike',
                                        'Bike' = 'Bike'), selected = "Non-bike"),
            
            radioButtons("time", h4("Explore by time? If you want to see the ODM by hour of day, click Yes:"),
                         choices = list("Yes" = 1, 
                                        "No" = 0), selected = 0),
            h5("No will show the results of all trips over 24 hours."),
            hr(),
            conditionalPanel("input.time == 1",
                             sliderInput('hour', h3('Hour of day (departure)'), 
                                         min=0, max=23, value=8, step=1, round=0)),
            
            submitButton("Plot"),
            
            hr(),
            
            p("Inspired by Robin Lovelace and Edward Leigh's work: ",
              a("Origin-destination data with stplanr.", 
                href = "https://cran.r-project.org/web/packages/stplanr/vignettes/stplanr-od.html")),
            
            p("Author of this APP: ",
              a("Yuan Liao", 
                href = "https://yuanliao.netlify.app")),
        ),
        
        mainPanel(
            h4("North Holland, The Netherlands"),
            
            p("The recorded visits to various locations by individual persons are 
            aggregated to study the flows of people between different zones/regions. 
            An origin-destination (OD) matrix can be constructed with the origins and destinations of all trips.
              These OD matrices are particularly important for studying travel demand of different modes"),
            
            plotOutput("netPlot", height = "800px", width="100%"),
            
            p("Data source: Centraal Bureau voor de Statistiek (CBS); Rijkswaterstaat (RWS) (2017): 
              Onderzoek Verplaatsingen in Nederland 2017 - OViN 2017. DANS.",
              a("DOI: 10.17026/dans-xxt-9d28", 
                href = "https://doi.org/10.17026/dans-xxt-9d28")),
        )
    )
))
