library(lidR)
library(future)

# read csv

# Set working directory
outputdirectory="O:/Nat_Ecoinformatics/B_Read/LegacyData/Denmark/Elevation/GST_2014/Punktsky/laz/"
setwd(outputdirectory)

# LiDAR catalog
ctg <- readLAScatalog(outputdirectory)

metadata=ctg@data




