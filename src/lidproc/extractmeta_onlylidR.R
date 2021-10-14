library(lidR)
library(future)

# read csv

# Set working directory
outputdirectory="O:/Nat_Ecoinformatics/B_Read/LegacyData/Denmark/Elevation/GST_2014/Punktsky/"
setwd(outputdirectory)

# LiDAR catalog
ctg <- readLAScatalog(outputdirectory)

metadata=ctg@data

# just header

lidrmeta=readLASheader(metadata$filename[1])

epsg(lidrmeta)
wkt(lidrmeta)




