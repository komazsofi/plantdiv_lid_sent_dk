library(raster)
library(SpaDES)

setwd("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/retileDTM/test2/")

asc_list=list.files(pattern = "*.asc")

for (k in asc_list) {
  
  dtm_bro=raster(k)
  sections=splitRaster(dtm_bro, nx=10, ny=10, path="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/retileDTM/test2/retile/")
  
}

#dtm_bro=raster("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/retileDTM/DTM_bro_622_59.asc")
#sections=splitRaster(dtm_bro, nx=10, ny=10, path="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/retileDTM/retile/")

setwd("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/retileDTM/test2/retile/")

tiled_grds=list.files(pattern = "*.grd")

for (i in tiled_grds) {
  print(i)
  
  tile=raster(i)
    
  rrrr=substr(as.character(tile@extent@ymin),1,4)
  ccc=substr(as.character(tile@extent@xmin),1,3)
  
  crs(tile) <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs" 
  
  if (all(is.na(tile[1]))==FALSE) {
    writeRaster(tile,paste("DTM_1km_",rrrr,"_",ccc,".tif",sep=""),overwrite=TRUE)
  }
   
}
