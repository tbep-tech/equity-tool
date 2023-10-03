library(sf)
library(dplyr)

# simplify flow lines

newflow <- st_read("data/tb_flowlines_dissolved.shp")

tb_flowlines_simp <- st_make_valid(newflow) %>%
    st_simplify(dTolerance = 20)

save(tb_flowlines_simp, file = 'data/tb_flowlines_simp.RData')

