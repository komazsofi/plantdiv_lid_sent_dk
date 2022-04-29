library(data.table)
library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/DiffRS/Field_data/ForZsofia/NOVANAAndP3_tozsofia/")
data<-as.data.frame(fread("NOVANAAndP3_tozsofia.tsv"))
biowide_dk = readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/DiffRS/Field_data/biowide_zones.shp")

data=data[data$Yeare>2015,]

# prep. plot database

data_plot=data %>% 
  group_by(data$AktID,data$Yeare,data$Habitat,data$HabitatID,data$UTM_X_orig,data$UTM_Y_orig) %>%
  summarize(Count=n())

# make a shapefile

data_plot_forshp=data_plot

names(data_plot_forshp) <- c("AktID","Year","Habitat","HabitatID","UTM_X","UTM_Y","SpRichness")

coordinates(data_plot_forshp)=~UTM_X+UTM_Y
proj4string(data_plot_forshp)<- CRS("+proj=utm +zone=32 +ellps=intl +towgs84=-87,-98,-121,0,0,0,0 +units=m +no_defs ")
raster::shapefile(data_plot_forshp,"Novana_plots_utm",overwrite=TRUE)

# intersect with regions

data_plot_forshp_biow=raster::intersect(data_plot_forshp,biowide_dk)
names(data_plot_forshp_biow) <- c("AktID","Year","Habitat","HabitatID","SpRichness","Region")

# how many plots per year per habitat types

data_plot_forshp_biow_df=data_plot_forshp_biow@data

nofplots_perhabitats=data_plot_forshp_biow_df %>% 
  group_by(data_plot_forshp_biow_df$Habitat,data_plot_forshp_biow_df$HabitatID,data_plot_forshp_biow_df$Region) %>%
  summarize(Count=n())

nofplots_perhabitats_peryear=data_plot_forshp_biow_df %>% 
  group_by(data_plot_forshp_biow_df$Habitat,data_plot_forshp_biow_df$HabitatID,data_plot_forshp_biow_df$Year,data_plot_forshp_biow_df$Region) %>%
  summarize(Count=n())

# how many plots per danish regions and per year and per habitat types

# spatial distribution




