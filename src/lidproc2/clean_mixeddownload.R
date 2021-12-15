library(tidyverse)
library(sf)

library(foreach)
library(doSNOW)
library(tcltk)

# set working directories

examined_dir="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/metainfo_extract/unzipped_dir2019/"
metadata="dir2019_20211108_0706.shp"

# get metadata info about the examined directory

dir2019shp=read_sf(paste(examined_dir,metadata,sep="")) %>%
  select(tile_id = BlockID, max_date = MxGpstm, header_year = CreatYr) %>%
  mutate(max_date = as.Date(max_date), 
         max_GPS_year = format(as.Date(max_date), "%Y"),
         data_source = "dir2019")  %>%
  mutate(year = case_when(max_GPS_year == 2011 ~ header_year,
                          T ~ max_GPS_year)) %>%
  group_by(tile_id) %>%
  filter(n()==1) %>%
  ungroup()

dir2019shp$year[dir2019shp$year == 0] <- NA

# make dirs for different years

subfolder_names=unique(dir2019shp$year)

for (j in 1:length(subfolder_names)){
  folder<-dir.create(paste0(examined_dir,subfolder_names[j]))
}

# sort files

parallel::detectCores()
n.cores <- parallel::detectCores() - 1
my.cluster <- parallel::makeCluster(n.cores)
registerDoSNOW(my.cluster)

ntasks <- 10
pb <- tkProgressBar(max=ntasks)
progress <- function(n) setTkProgressBar(pb, n)
opts <- list(progress=progress)

foreach(i = 40:50, .options.snow=opts) %dopar% {
  file.copy(from=paste0(examined_dir,"PUNKTSKY_1km_",dir2019shp$tile_id[i],".laz"), to=paste0(examined_dir,"/", dir2019shp$year[i],"/","PUNKTSKY_1km_",dir2019shp$tile_id[i],".laz"))
}

