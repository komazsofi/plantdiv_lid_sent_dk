library(data.table)
library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)
library(kableExtra)

#("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/DiffRS/Field_data/ForZsofia/NOVANAAndP3_tozsofia/")
setwd("G:/My Drive/_Aarhus/_PostDoc/_Paper1_diffRS_plantdiv/1_Datasets/Field_data/ForZsofia/NOVANAAndP3_tozsofia/")
data<-as.data.frame(fread("NOVANAAndP3_tozsofia.tsv"))
biowide_dk = readOGR(dsn="biowide_zones.shp")

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

data_plot_forshp_biow_df=data_plot_forshp_biow@data

# for single year: how many plots per habitat per region

nofplots_perhabreg_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID,Region, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

nofplots_perhab_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

# spatial distribution




