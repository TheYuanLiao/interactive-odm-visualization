library(plotly)
library(sf)
library(jsonlite)

zones <- st_transform(st_read('InteractiveODM/data/zones_subset.shp'), crs = 4326)
p <- plot_ly(zones,
        text = ~paste("Zone ", zone),
        hoverinfo = "text")
j <- plotly_json(p = p, jsonedit = interactive(), pretty = TRUE)

exportJSON <- toJSON(j$x$data)
write(exportJSON, "zones.json")
