library(plotly)
library(sf)

zones <- st_transform(st_read('InteractiveODM/data/zones_subset.shp'), crs = 4326)
p <- plot_ly(zones,
        text = ~paste("Zone ", zone),
        hoverinfo = "text")
plotly_build(p)
