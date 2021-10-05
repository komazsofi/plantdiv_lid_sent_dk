library(tidyverse)
library(sf)
library(ggplot2)

abiotiske=read.csv("G:/My Drive/_Aarhus/Paper1/1_Datasets/Fielddata/Novana/alledata-abiotiske.csv",sep=",")
cover=read.csv("G:/My Drive/_Aarhus/Paper1/1_Datasets/Fielddata/Novana/alledata-cover.csv",sep=",")
frekvens=read.csv("G:/My Drive/_Aarhus/Paper1/1_Datasets/Fielddata/Novana/alledata-frekvens.csv",sep=",")

Denmark <- readRDS("G:/My Drive/_Aarhus/Paper1/1_Datasets/DK_Shape.rds")

# How many plots were measured across years

abiotiske_perplots <- abiotiske %>% group_by(plot) %>% summarise(n = n())
abiotiske_peryears <- abiotiske %>% group_by(year) %>% summarise(n = n())

abiotiske_perplots_df=as.data.frame(abiotiske_perplots)

# New dataframe to collect what we need

veg_db<- abiotiske[c("site", "plot", "year","UTMx","UTMy")]
#veg_db_plantdiv$measurefreq <- merge(veg_db_plantdiv, abiotiske_perplots, by="plot")
veg_db_plantdiv<- left_join(veg_db, abiotiske_perplots_df, by="plot")

# calculate plant diversity indices

veg_db_plantdiv$richness <- rowSums(frekvens[,4:2180])

# interesting data

veg_db_plantdiv_comp=veg_db_plantdiv[!(is.na(veg_db_plantdiv$UTMx) | veg_db_plantdiv$UTMx=="" | veg_db_plantdiv$UTMx=="mv"), ]

veg_db_plantdiv_mintimes=veg_db_plantdiv_comp[(veg_db_plantdiv_comp$n>4),]
#print(unique(veg_db_plantdiv_mintimes$site))

# visualize

ggplot(data=veg_db_plantdiv_mintimes[(veg_db_plantdiv_mintimes$site==45),],aes(x=year,y=richness,group=plot,color=as.factor(plot)))+geom_line()+geom_point()

# Map visualizations

veg_db_plantdiv_mintimes_perplots <- veg_db_plantdiv_mintimes %>% group_by(plot) %>% summarise(UTMx=max(UTMx),UTMy=max(UTMy),site=max(site),n=max(n),meanrich_overtime=mean(richness))
veg_db_plantdiv_mintimes_perplots_sf <- st_as_sf(veg_db_plantdiv_mintimes_perplots, coords = c("UTMx", "UTMy"), crs = 25832)

ggplot()+geom_sf(data = Denmark)+geom_sf(data = veg_db_plantdiv_mintimes_perplots_sf, aes(color = n))

# export to QGIS

veg_db_plantdiv_sf <- st_as_sf(veg_db_plantdiv_mintimes, coords = c("UTMx", "UTMy"), crs = 25832)
st_write(veg_db_plantdiv_sf, "G:/My Drive/_Aarhus/Paper1/1_Datasets/Fielddata/Novana/veg_db_plantdiv_comp.shp")