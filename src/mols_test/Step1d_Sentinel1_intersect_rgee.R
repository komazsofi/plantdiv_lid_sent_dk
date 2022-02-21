library(tidyverse)
library(rgee)
library(sf)
library(reshape2)
library(lubridate)

ee_Initialize()

Mols_nov_points <- ee$FeatureCollection("users/komazsofi/Mols_intersect_NOVANA_sites_wgs84")
Mols_nov_points_sf <- ee_as_sf(x = Mols_nov_points, maxFeatures = 10000)
Mols_nov_points_sf_geom = Mols_nov_points$geometry()

s2_mols_VV <- ee$ImageCollection('COPERNICUS/S1_GRD')$
  filterDate('2017-01-01', '2017-12-31')$
  filter(ee$Filter$listContains('transmitterReceiverPolarisation', 'VV'))$
  filter(ee$Filter$eq('orbitProperties_pass', 'DESCENDING'))$
  filter(ee$Filter$eq('instrumentMode', 'IW'))$
  filter(ee$Filter$eq('resolution_meters', 10))$
  filterBounds(Mols_nov_points_sf_geom)$
  map(function(x){
    date <- ee$Date(x$get("system:time_start"))$format('YYYY_MM_dd')
    x$select("VH")
  })

nimages <- s2_mols_VV$size()$getInfo()
ic_date <- ee_get_date_ic(s2_mols_VV)

s2_2020 <- ee_extract(
  x = s2_mols_VV,
  y = Mols_nov_points_sf,
  scale = 25,
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
  ylab("VH")+
  scale_x_continuous(label = scales::label_number(accuracy = 1))