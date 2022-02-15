library(raster)
library(rasterdiv)
library(rasterVis)

raster=raster("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/sentinel2/Jan20_sent2_ndvi/processed/merged/S2_ndvi_med.tif")

e <- as(extent(c(xmin= 556000, xmax= 557000, ymin= 6212000, ymax= 6213000)), 'SpatialPolygons')
crs(e) <- crs(raster)
r2 <- crop(raster, extent(e))

r2_aggr <- raster::aggregate(r2, fact=2.5)

rao <- Rao(r2_aggr,window=3,na.tolerance=0.1,dist_m="euclidean",shannon=FALSE,np=3)

writeRaster(r2,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/sentinel2/Jan21_sent2_ndvi_tryoutRao/r2.tif")
writeRaster(rao[["window.3"]][["alpha.1"]],"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/sentinel2/Jan21_sent2_ndvi_tryoutRao/rao_20m.tif")

