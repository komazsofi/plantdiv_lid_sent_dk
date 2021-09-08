library(lidR)
library(mapview)

library(future)

# Set working directory
workingdirectory="C:/_Koma/_PostDoc/Paper1/2_Dataprocess/qualityCheck/"
setwd(workingdirectory)

#unzip(paste("PUNKTSKY_623_59_TIF_UTM32-ETRS89.zip",sep=""))

# LiDAR catalog
ctg <- readLAScatalog(workingdirectory)
plot(ctg, map=TRUE)

las_check(ctg)

plan(multisession)

opt_filter(ctg) <- "-drop_class 7 18"
opt_chunk_size(ctg) <- 0
opt_chunk_buffer(ctg) <- 5

opt_output_files(ctg) <-  paste("C:/_Koma/_PostDoc/Paper1/2_Dataprocess/qualityCheck/{*}_norm")
ctg_norm <- normalize_height(ctg, tin())

opt_output_files(ctg) <-  paste("C:/_Koma/_PostDoc/Paper1/2_Dataprocess/qualityCheck/{*}_dtm")
dtm <- grid_terrain(ctg, 10, tin())

opt_filter(ctg_norm) <- "-keep_class 3 4 5"

opt_output_files(ctg_norm) <-  paste("C:/_Koma/_PostDoc/Paper1/2_Dataprocess/qualityCheck/{*}_hmean")
hmean <- grid_metrics(ctg_norm, ~mean(Z), 10)

