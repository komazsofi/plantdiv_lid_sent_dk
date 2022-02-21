library(rgee)
library(sf)

setwd("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/Mols_test/Sentinel2_Mols/")

ee_Initialize(drive=TRUE)

Mols_nov_points <- ee$FeatureCollection("users/komazsofi/MolsRewilding_union_wgs84")
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

  img_band_selected <- img$select('B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B9', 'B11', 'B12')
  
  # quality band
  ndvi_qa <- img$select("QA60")
  
  # Select pixels to mask
  quality_mask <- getQABits(ndvi_qa, "110000000000")
  
  # Mask pixels with value zero.
  img_band_selected$updateMask(quality_mask)
}


s2_mols <- s2$
  filterBounds(Mols_nov_points_sf_geom)$
  filter(ee$Filter$lte("CLOUDY_PIXEL_PERCENTAGE", 15))$
  filter(ee$Filter$date('2017-01-01', '2021-12-31'))$map(s2_clean)

infoimages <- s2_mols$getInfo()
nimages <- s2_mols$size()$getInfo()
ic_date <- ee_get_date_ic(s2_mols)

write.csv(ic_date,"Mols_Sentinel2_metainfo.csv")

s2_ic_local <- ee_imagecollection_to_local(
  ic = s2_mols,
  scale = 10,
  region = Mols_nov_points_sf_geom,
  via = 'drive'
)