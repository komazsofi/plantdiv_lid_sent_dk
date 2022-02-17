library(tidyverse)
library(rgee)
library(sf)
library(reshape2)
library(lubridate)

library(stars)
library(tmap)

ee_Initialize(drive=TRUE)

Mols_nov_points <- ee$FeatureCollection("users/komazsofi/Mols_intersect_NOVANA_sites_wgs84")
Mols_nov_points_sf <- ee_as_sf(x = Mols_nov_points, maxFeatures = 10000)
Mols_nov_points_sf_geom = Mols_nov_points$geometry()

s2 <- ee$ImageCollection("COPERNICUS/S2_SR")

getQABits <- function(image, qa) {
  # Convert decimal (character) to decimal (little endian)
  qa <- sum(2^(which(rev(unlist(strsplit(as.character(qa), "")) == 1))-1))
  # Return a single band image of the extracted QA bits, giving the qa value.
  image$bitwiseAnd(qa)$lt(1)
}

s2_clean <- function(img) {
  # Select only band of interest, for instance, B2,B3,B4,B8
  img_band_selected <- img$select("B[2-4|8]")
  
  # quality band
  ndvi_qa <- img$select("QA60")
  
  # Select pixels to mask
  quality_mask <- getQABits(ndvi_qa, "110000000000")
  
  # Mask pixels with value zero.
  img_band_selected$updateMask(quality_mask)
}

getNDVI <- function(image) {
  ndvi <- image$normalizedDifference(c("B8", "B4"))$rename('NDVI')
  return(image$addBands(ndvi))
}

s2_mols <- s2$
  filterBounds(Mols_nov_points_sf_geom)$
  filter(ee$Filter$lte("CLOUDY_PIXEL_PERCENTAGE", 15))$
  filter(ee$Filter$date('2018-01-01', '2018-12-31'))$map(getNDVI)

s2_ic_local <- ee_imagecollection_to_local(
  ic = s2_mols$select('NDVI'),
  scale = 10,
  region = Mols_nov_points_sf_geom,
  via = 'drive'
)

###############################################

setwd("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/Mols_test/Sentinel2_rgee/")
filelist=list.files(pattern = "*.tif")

images=read_stars(filelist)
images_merged=merge(images)

images_merged %>% 
  st_get_dimension_values(3) %>% 
  substr(
    start = 1,
    stop = 8
  ) %>% 
  as.Date(format="%Y%m%d") %>% 
  as.character() %>% 
  sprintf("Mols area: %s", .) ->  
  s2_new_names

m1 <- tm_shape(images_merged) +
  tm_raster(
    n = 20, 
    title = "NDVI",
    style = "fisher") +
  tmap_style(style = "natural") +
  tm_facets(nrow = 1, ncol = 1) +
  tm_layout(
    frame.lwd = 2,
    panel.label.bg.color = NA,
    attr.outside = TRUE,
    panel.show = FALSE,
    legend.title.size = 1,
    legend.title.fontface = 2,
    legend.text.size = 0.7,
    legend.frame = FALSE,
    legend.outside = TRUE,
    legend.position = c(0.20, 0.15),
    legend.bg.color = "white",
    legend.bg.alpha = 1,
    main.title = sprintf("Mols region: %s", s2_new_names),
    main.title.size = 1.2,
    main.title.fontface = 2
  )+
  tm_credits(
    text = "Source: Sentinel-2 MSI: MultiSpectral Instrument, Level-2A",
    size = 1,
    just = "right"
  ) 

tmap_animation(tm = m1, width = 699*3,height = 555*3,delay = 100)


