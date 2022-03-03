library(sf)
library(gdalUtils)
library(raster)

# Functions

mosaicList <- function(rasList){
  
  #Internal function to make a list of raster objects from list of files.
  ListRasters <- function(list_names) {
    raster_list <- list() # initialise the list of rasters
    for (i in 1:(length(list_names))){ 
      grd_name <- list_names[i] # list_names contains all the names of the images in .grd format
      raster_file <- raster::raster(grd_name)
    }
    raster_list <- append(raster_list, raster_file) # update raster_list at each iteration
  }
  
  #convert every raster path to a raster object and create list of the results
  raster.list <-sapply(rasList, FUN = ListRasters)
  
  # edit settings of the raster list for use in do.call and mosaic
  names(raster.list) <- NULL
  #####This function deals with overlapping areas
  raster.list$fun <- mean
  
  #run do call to implement mosaic over the list of raster objects.
  mos <- do.call(raster::mosaic, raster.list)
  
  #set crs of output
  crs(mos) <- crs(x = raster(rasList[1]))
  return(mos)
}

workingdirectory="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS_v2/2018/lidar/lidar_metrics_dhm2018/tar/"
setwd(workingdirectory)

lidar_measure = st_read("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS_v2/2018/lidar2018.shp")

metricname=list.files(pattern = "*.tar")
metricnames=substr(metricname,1,nchar(metricname)-4)

metricnames2=metricnames[metricnames != "point_count"]

for (j in metricnames2) {
  print(j)
  
  filelist=paste0(workingdirectory,j,"/",j,"_",lidar_measure$BlockID,".tif")
  
  metric=mosaicList(filelist)
  writeRaster(metric,paste("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS_v2/2018/lidar/lidar_2018_only/",j,".tif",sep=""),overwrite=TRUE)
  
}


