library(leaflet)
library(sf)

load(file = 'data/tb_equity.RData')
load(file = 'data/buffer_under.RData')
newflow <- st_read("data/tb_flowlines_dissolved.shp")

buffer_under <- st_transform(buffer_under, crs = 4326)
tb_equity <- st_transform(tb_equity, crs = 4326)
newflow <- st_transform(newflow, crs = 4326)

# bounding box
bnds <- sf::st_bbox(newflow)

# esri tiles
esri <- rev(grep("^Esri", leaflet::providers, value = TRUE))

# empty map
m <- leaflet::leaflet() %>%
  leaflet::fitBounds(bnds[['xmin']], bnds[['ymin']], bnds[['xmax']], bnds[['ymax']]) %>%
  leaflet::addScaleBar(position = "bottomleft")

# add provider tiles
for (provider in esri) {
  m <- m %>% leaflet::addProviderTiles(provider, group = provider)
}

# buffer under map ----------------------------------------------------------------------------

buffer_under_map <- m %>%
  addPolygons(
    data = buffer_under,
    group = "1 mile buffer",
    fillColor = "#F2AD00",
    color = 'black',
    fillOpacity = 0.5,
    weight = 1,
    opacity = 1
    ) %>%
  addPolygons(
    data = tb_equity,
    group = "Underserved Communities",
    fillColor = "#00806E",
    color = 'black',
    fillOpacity = 0.5,
    weight = 1,
    opacity = 1
  ) %>%
  addLegend(labels = "1 mile buffer", colors = "#F2AD00", opacity = 1) %>%
  addLegend(labels = "Underserved Communities", colors = "#00806E", opacity = 1) %>%
  addLayersControl(
    baseGroups = names(esri),
    overlayGroups = c("1 mile buffer", "Underserved Communities"),
    position = 'topleft'
    )

save(buffer_under_map, compress = "xz", file = "data/buffer_under_map.RData")

# flowlines map -------------------------------------------------------------------------------



tb_flowlines_fixed <- st_make_valid(newflow)

flowlines_map <- mapview(tb_flowlines_fixed, color = "#004F7E", layer.name = "Flowlines", label = "GNIS_NAME") + mapview(tb_equity, col.regions = "#00806E", layer.name = "Underserved Communities")

flowlines_map <- flowlines_map@map

save(flowlines_map, compress = "xz", file = "data/flowlines_map.RData")
