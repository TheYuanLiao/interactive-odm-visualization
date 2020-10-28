#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    l <- reactive({
        # Subsetting data based on input$mode and input$hour from ui.R
        md <- input$mode
        hr <- ifelse(input$time == 0, 24, input$hour)
        df_a <- df %>%
            select(c('ozone', 'dzone', !!md, 'Total', 'Hour')) %>%
            filter(ozone != dzone,
                   Hour == hr) %>%
            mutate(trip = get(md) / sum(get(md)) * 100) %>%
            filter(trip > 0) %>%
            mutate(share = get(md) / Total * 100)
        l <- od2line(flow = df_a, zones = zones)
        
        arrange(l, trip)
    })

    output$netPlot <- renderPlot({
        # draw the ODMs
        tm_shape(zones) +
            tm_fill(col="grey35") +
            tm_borders("white", alpha=.2) + 
            tm_shape(l()) +
            tm_lines(
                palette = "plasma", 
                trans = "log10", style="cont",
                lwd = "trip",
                scale = 9,
                title.lwd = 0.5,
                alpha = 0.5,
                col = "share",
                title = "Mode share (%)",
                legend.lwd.show = FALSE
            ) +
            tm_scale_bar() +
            tm_layout(
                title = input$mode,
                frame = FALSE,
                legend.bg.alpha = 0.5,
                legend.bg.color = "white"
            )
    })

})
