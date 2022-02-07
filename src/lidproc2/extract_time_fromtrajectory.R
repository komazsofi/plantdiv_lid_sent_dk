library(sf)
library(plyr)
library(dplyr)

# Set global variables
wd="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/unziped_KMS2007_traj/"
setwd(wd)

filelist=list.files(pattern = "*.shp")

# Import 

DHM2017 = read_sf("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/DHM2007_20211102_2342.shp")

# Intersect the scan lines with the polygons

for (i in filelist) {
  print(i)
  
  scanline = read_sf(i)
  st_crs(scanline) = st_crs(DHM2017)
  
  scanline$length = st_length(scanline$geometry)
  linepol = st_intersection(scanline, DHM2017)
  
  linepol$lpercent = 100 * (st_length(linepol)/linepol$length)
  
  # intersection
  int = st_intersection(DHM2017, linepol)
  int_sel=int[,c(1,66,30)]
  int_sel_df <- int_sel %>% st_set_geometry(NULL)
  
  write.csv(int_sel_df,paste("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/",gsub('.{4}$', '', i),".csv"))
}

# Import back csv files into one

filenames <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/", pattern = "*.csv", full.names=TRUE)
csvs <- ldply(filenames, read.csv)

# select the ones which are the longest line within the intersected polygon

csvs_grouped=csvs %>% group_by(BlockID) %>% top_n(1, lpercent)

# format date into year, month, day

csvs_grouped <- transform(csvs_grouped, date = as.Date(as.character(SCANDATE), "%Y%m%d"))
csvs_grouped$year <- format(csvs_grouped$date, format="%Y")
csvs_grouped$month <- format(csvs_grouped$date, format="%m")
csvs_grouped$day <- format(csvs_grouped$date, format="%d")

# add this info to polygon

joined_DHM2017 = DHM2017 %>% left_join(csvs_grouped, by = "BlockID")
st_write(joined_DHM2017, "O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/DHM2017_joined_maxlengthtrajdate_v2.shp")

# visualize

library(ggplot2)
library(cowplot)
library(sf)
library(tidyverse)

outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/"

file="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/DHM2017_joined_maxlengthtrajdate_v2.shp"
dirname="DHM2017"

df = st_read(file)

df$year_rec <- as.factor(df$year_1)

recentyear_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = year_rec),
          colour = NA) +
  labs(fill = "Year", title = "Most recent tile acquisition years") +
  scale_fill_manual(values = c("2005" = "darkviolet", "2006" = "brown","2007" = "gold"))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_trajtime",".png",sep=""), recentyear_plot,
          base_height = 6)

