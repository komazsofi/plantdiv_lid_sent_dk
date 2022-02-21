library(rgdal)
library(raster)

library(snow)

setwd("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/Mols_test/Sentinel2_Mols/")
filelist=list.files(pattern = "*H.tif")

for (i in filelist){
  
  print(i)
  
  raster=stack(i)
  #NDVI=(raster$B8-raster$B4)/(raster$B8+raster$B4)
  BSI=((raster$B11+raster$B4)-(raster$B8+raster$B2))/((raster$B11+raster$B4)+(raster$B8+raster$B2))
  
  beginCluster(2)
  
  #sd_ndvi=clusterR(NDVI, focal, args=list(w=matrix(1,3,3), fun=sd, pad=TRUE,na.rm = TRUE))
  sd_bsi=clusterR(BSI, focal, args=list(w=matrix(1,3,3), fun=sd, pad=TRUE,na.rm = TRUE))
  
  endCluster()
  
  #writeRaster(NDVI,paste0(substr(i,1,38),"_ndvi.tif"),overwrite=TRUE)
  #writeRaster(sd_ndvi,paste0(substr(i,1,38),"_ndvi_sd.tif"),overwrite=TRUE)
  writeRaster(BSI,paste0(substr(i,1,38),"_bsi.tif"),overwrite=TRUE)
  writeRaster(sd_bsi,paste0(substr(i,1,38),"_bsi_sd.tif"),overwrite=TRUE)
  
}


#NDVI=(raster$B8-raster$B4)/(raster$B8+raster$B4)
#BSI=((raster$B11+raster$B4)-(raster$B8+raster$B2))/((raster$B11+raster$B4)+(raster$B8+raster$B2))
#SIPI=(raster$B8-raster$B1)/(raster$B8-raster$B4)
#EVI= 2.5 * (raster$B8 - raster$B4) / ((raster$B8 + 6.0 * raster$B4 - 7.5 * raster$B2) + 1.0)
#GNDVI=(raster$B8-raster$B3)/(raster$B8+raster$B3)
