library(raster)
library(rgdal)
library(ggplot2)

library(tidyverse)
library(reshape2)

workingdirectory="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/Mols_test/Sentinel2_Mols/"
setwd(workingdirectory)

# Import

filelist=list.files(pattern = "*_sipi.tif")
all_predictor=stack(filelist)

plants=readOGR(dsn="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2016.shp")
crs(plants)<-"+init=epsg:25832"
plants_wgs84 <- spTransform(plants, proj4string(all_predictor))

# Intersect
metrics <- raster::extract(all_predictor, plants, df = TRUE)

metrics$AKTID <- plants$AKTID
metrics$PROGRAM <- plants$PROGRAM
metrics$NATURTY <- plants$NATURTY
metrics$N_Str_S <- plants$N_Str_S
metrics$N_2_S_S <- plants$N_2_S_S
metrics$N_Specs <- plants$N_Specs

metrics_omit <- na.omit(metrics) 

# visual

namesinfo=colnames(metrics_omit) 
colnames(metrics_omit) <- substring(colnames(metrics_omit), 2, 9)
colnames(metrics_omit)[1]<-"ID"

metrics_forvis=metrics_omit[,c(1:90)]

metrics_forvis_m=metrics_forvis %>% rownames_to_column 

metrics_forvis_melted = melt(metrics_forvis_m, id.vars = c('ID',"rowname"))
metrics_forvis_melted$variable2=as.Date(metrics_forvis_melted$variable,"%Y%m%d")
metrics_forvis_melted$Year <- format(metrics_forvis_melted$variable2, format="%Y")
metrics_forvis_melted$doy=as.numeric(format(metrics_forvis_melted$variable2, format="%j"))

ggplot(metrics_forvis_melted, aes(x = doy, y = value))+
  facet_wrap(~Year)+
  geom_point(aes(color = as.character(ID)))+
  geom_line(aes(color = as.character(ID)),size=1)+
  theme_bw(base_size = 20)+
  xlab("Day of the year")+
  ylab("NDVI variation")+
  ylim(c(0,2))

