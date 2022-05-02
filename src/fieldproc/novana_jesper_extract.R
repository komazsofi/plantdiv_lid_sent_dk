library(data.table)
library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)
library(kableExtra)
library(xlsx)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/DiffRS/Field_data/ForZsofia/NOVANAAndP3_tozsofia/")
#setwd("G:/My Drive/_Aarhus/_PostDoc/_Paper1_diffRS_plantdiv/1_Datasets/Field_data/ForZsofia/NOVANAAndP3_tozsofia/")
data<-as.data.frame(fread("NOVANAAndP3_tozsofia.tsv",encoding="UTF-8"))
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
raster::shapefile(data_plot_forshp_biow,"data_plot_forshp_biow_utm",overwrite=TRUE)

# for single year: how many plots per habitat per region

nofplots_perhabreg_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID,Habitat,Region, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

nofplots_perhab_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID,Habitat, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

write.xlsx(nofplots_perhabreg_yearly, file = "nofplots.xlsx",
           sheetName = "perhabperreg", append = FALSE,showNA=FALSE)

write.xlsx(nofplots_perhab_yearly, file = "nofplots.xlsx",
           sheetName = "perhab", append = TRUE,showNA=FALSE)

# spatial distribution

biowide_dk_sf=st_as_sf(biowide_dk)
data_plot_forshp_biow_sf=st_read("data_plot_forshp_biow_utm.shp")

ggplot()+geom_sf(data = biowide_dk_sf)+
  geom_sf(data = data_plot_forshp_biow_sf, aes(color = Habitat),size=2)+
  facet_wrap(facets = vars(Year))+
  theme_bw()

habitats=unique(data_plot_forshp_biow_sf$HabitatID)

for (i in habitats){
  
  print(i)
  
  #print(ggplot()+geom_sf(data = biowide_dk_sf)+
    #geom_sf(data = data_plot_forshp_biow_sf[data_plot_forshp_biow_sf$Habitat==i,], aes(color = Habitat),size=2)+
    #facet_wrap(facets = vars(Year))+
    #theme_bw())
  
  myplot=ggplot()+geom_sf(data = biowide_dk_sf)+
    geom_sf(data = data_plot_forshp_biow_sf[data_plot_forshp_biow_sf$HabitatID==i,], aes(color = Habitat),size=2)+
    facet_wrap(facets = vars(Year))+
    theme_bw()
  
  ggsave(paste(i,".png",sep=""),plot=myplot)
  
}

ggplot()+geom_sf(data = biowide_dk_sf)+
  geom_sf(data = data_plot_forshp_biow_sf[data_plot_forshp_biow_sf$Habitat=="Hede",], aes(color = Habitat),size=2)+
  facet_wrap(facets = vars(Year))+
  theme_bw()




