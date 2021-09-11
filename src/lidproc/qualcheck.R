library(lidR)
library(mapview)

library(future)

# Set working directory
workingdirectory="G:/My Drive/_Aarhus/Paper1/2_Dataprocessing/qualityCheck/"
setwd(workingdirectory)

#unzip(paste("PUNKTSKY_623_59_TIF_UTM32-ETRS89.zip",sep=""))

# LiDAR catalog
ctg <- readLAScatalog(workingdirectory)
plot(ctg, map=TRUE)

metadata=ctg@data

las_check(ctg)

plan(multisession)

opt_filter(ctg) <- "-drop_class 7 18"
opt_chunk_size(ctg) <- 0
opt_chunk_buffer(ctg) <- 5

opt_output_files(ctg) <-  paste("G:/My Drive/_Aarhus/Paper1/2_Dataprocessing/qualityCheck/{*}_norm") #modify path (no overlapping reading)
ctg_norm <- normalize_height(ctg, tin())

opt_output_files(ctg) <-  paste("G:/My Drive/_Aarhus/Paper1/2_Dataprocessing/qualityCheck/{*}_dtm")
dtm <- grid_terrain(ctg, 10, tin())

dtm_files <- dir(workingdirectory,pattern="*_dtm.tif")

for (i in 1:length(dtm_files)) {
  
  print(dtm_files[i])
  dtm=raster(dtm_files[i])
  
  slope <- terrain(dtm, opt='slope')
  aspect <- terrain(dtm, opt='aspect')
  
  dtm_hillshade <- hillShade(slope,aspect,40, 270)
  writeRaster(dtm_hillshade,paste(workingdirectory,substr(dtm_files[i],1,25),"_hsd.tif",sep=""),overwrite=TRUE)
  
}

opt_filter(ctg_norm) <- "-keep_class 3 4 5"

opt_output_files(ctg_norm) <-  paste("G:/My Drive/_Aarhus/Paper1/2_Dataprocessing/qualityCheck/{*}_hmean")
hmean <- grid_metrics(ctg_norm, ~mean(Z), 10)

