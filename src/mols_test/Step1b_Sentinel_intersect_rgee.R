library(tidyverse)
library(rgee)
library(sf)
library(reshape2)
library(lubridate)

ee_Initialize()

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

s2_mols_points <- s2$
  filterBounds(Mols_nov_points_sf_geom)$
  filter(ee$Filter$lte("CLOUDY_PIXEL_PERCENTAGE", 15))$
  filter(ee$Filter$date('2017-01-01', '2021-12-31'))$map(getNDVI)

nimages <- s2_mols_points$size()$getInfo()
ic_date <- ee_get_date_ic(s2_mols_points)

s2_2020 <- ee_extract(
  x = s2_mols_points$select('NDVI'),
  y = Mols_nov_points_sf,
  scale = 10,
  fun = ee$Reducer$median(),
  sf = FALSE
)

s2_2020_sel=s2_2020[,c(1,15:ncol(s2_2020))]
novana=s2_2020[,c(1:14)]

s2_2020info=colnames(s2_2020_sel) 
colnames(s2_2020_sel) <- substring(colnames(s2_2020_sel), 18, 25)
colnames(s2_2020_sel)[1]<-"ID"

s2_2020_sel_m=s2_2020_sel %>% rownames_to_column 

s2_2020_sel_melted = melt(s2_2020_sel_m, id.vars = c('ID',"rowname"))
s2_2020_sel_melted$variable=gsub("\\..*","",s2_2020_sel_melted$variable)
s2_2020_sel_melted$variable2=as.Date(s2_2020_sel_melted$variable,"%Y%m%d")
s2_2020_sel_melted$Year <- format(s2_2020_sel_melted$variable2, format="%Y")
s2_2020_sel_melted$doy=as.numeric(format(s2_2020_sel_melted$variable2, format="%j"))

ggplot(s2_2020_sel_melted, aes(x = doy, y = value))+
  facet_wrap(~Year)+
  geom_point(aes(color = as.character(ID)))+
  geom_line(aes(color = as.character(ID)),size=1)+
  theme_bw(base_size = 20)+
  xlab("Day of the year")+
  ylab("NDVI")+
  scale_x_continuous(label = scales::label_number(accuracy = 1))


