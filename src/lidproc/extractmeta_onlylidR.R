library(lidR)
library(future)

library(mapview)

# Set working directory
outputdirectory="C:/_Koma/GitHub/komazsofi/ecodes-dk-lidar/data/laz/"
setwd(outputdirectory)

# LiDAR catalog
ctg <- readLAScatalog(outputdirectory)
plot(ctg, map=TRUE)

metadata=ctg@data

# Add real flight time

plan(multisession)

stat_pcloud <- cloud_metrics(ctg, func = ~max(Z))




