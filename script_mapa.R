

rm(list=ls())
setwd("/home/marcio/Documentos/ccrs-ufsc")

library(rgdal)
library(sp)
library(raster)
library(tidyverse)
library(leaflet)

# Lê as coordenadas que o Mateus me passou.
coord <- readOGR(dsn = "/home/marcio/Documentos/ccrs-ufsc", layer = "ccrs_coordenadas", verbose = F)

# Transforma as coordenadas em spatialPoints
xy <- cbind(x = coord$x, y = coord$y) %>%
  data.frame %>% 
  SpatialPoints(proj4string = CRS("+proj=utm +zone=22 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))

# Transforma as coordenadas de UTM para LatLong
coord_t <- spTransform(xy, CRSobj = CRS("+proj=longlat +datum=WGS84"))

# Cria um data.frame com as coordenadas
x <- coord_t$x
y <- coord_t$y

lat <- y
lon <- x

#coord$Name
Nome <- coord$Name %>% factor
Endereço <- coord$Endereço %>% factor
dat <- data.frame(lat, lon, Nome, Endereço)

leaflet(options = leafletOptions(minZoom = 0, maxZoom = 20))



greenLeafIcon <- makeIcon(
  iconUrl = "https://celulasconsumo.ufsc.br/static/img/menu-logo.png",
  iconWidth = 38, iconHeight = 59,
  iconAnchorX = 22, iconAnchorY = 54)

ccr_mapa <- dat %>%
  leaflet() %>%
  addTiles() %>% 
  addCircles(lng=lon, lat=lat) %>% 
  addMarkers(~lon, ~lat, popup = ~as.character(Endereço), label = ~as.character(Nome), icon = greenLeafIcon)

