library(dplyr)
library(sf)
library(stplanr)
library(tmap)

df <- read.csv('InteractiveODM/data/odms_by_mode.csv')
colnames(df) <- c("ozone", "dzone", "Non-bike", "E-bike", "Bike", "Total", 'Hour')
zones <- st_transform(st_read('InteractiveODM/data/zones_subset.shp'), crs = 4326)
df <- df %>% filter(ozone %in% zones$zone, dzone %in% zones$zone)

input <- list()
input$mode <- "Non-bike"
input$hour <- 24

df_a <- df %>%
  select(c('ozone', 'dzone', !!input$mode, 'Total', 'Hour')) %>%
  filter(ozone != dzone,
         Hour == input$hour) %>%
  mutate(trip = get(input$mode) / sum(get(input$mode)) * 100) %>%
  filter(trip > 0) %>%
  mutate(share = get(input$mode) / Total * 100)

l <- od2line(flow = df_a, zones = zones)

l <- l %>%
  arrange(trip)

tm_shape(zones) +
  tm_fill(col="grey35") +
  tm_borders("white", alpha=.2) + 
tm_shape(l) +
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
    frame = FALSE,
    legend.bg.alpha = 0.5,
    legend.bg.color = "white"
  )
