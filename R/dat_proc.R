library(mapview)
library(sf)

load(file = 'data/tb_equity.RData')
load(file = 'data/buffer_under.RData')

buffer_under_map <- mapview(buffer_under, col.regions = "#F2AD00", layer.name = "1 mile buffer", alpha.regions = 0.5) + mapview(tb_equity, col.regions = "#00806E", layer.name = "Underserved Communities", alpha.regions = 0.5)

save(buffer_under_map, compress = "xz", file = "data/buffer_under_map.RData")

load(file = 'data/tb_flowlines.RData')


newflow <- st_read("data/tb_flowlines_dissolved.shp")


tb_flowlines_fixed <- st_make_valid(newflow)

flowlines_map <- mapview(tb_flowlines_fixed, color = "#004F7E", layer.name = "Flowlines", label = "GNIS_NAME") + mapview(tb_equity, col.regions = "#00806E", layer.name = "Underserved Communities")

save(flowlines_map, compress = "xz", file = "data/flowlines_map.RData")
