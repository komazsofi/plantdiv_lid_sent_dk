library(raster)
library(rgdal)
library(ggplot2)

workingdirectory="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/satelliteprocess/Mols_test/Sentinel2_febr17/processed/2020/"
setwd(workingdirectory)

# Import

filelist=list.files(pattern = "*.tif")
all_predictor=stack(filelist)

plants=readOGR(dsn="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2016.shp")

# Intersect
metrics <- raster::extract(all_predictor, plants, df = TRUE)

metrics$AKTID <- plants$AKTID
metrics$PROGRAM <- plants$PROGRAM
metrics$NATURTY <- plants$NATURTY
metrics$N_Str_S <- plants$N_Str_S
metrics$N_2_S_S <- plants$N_2_S_S
metrics$N_Specs <- plants$N_Specs

metrics_omit <- na.omit(metrics) 

metrics_omit_sel=metrics_omit[(metrics_omit$AKTID==779885 | metrics_omit$AKTID==779891 | metrics_omit$AKTID==779894 | metrics_omit$AKTID==779898 
                               | metrics_omit$AKTID==779900 | metrics_omit$AKTID==779911 | metrics_omit$AKTID==779916 | metrics_omit$AKTID==780629 
                               | metrics_omit$AKTID==780655 | metrics_omit$AKTID==780762),]

write.csv(metrics_omit_sel,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/MolsRewildingArea_polygon/s2_mols_2020_monthlymed_allbands_L2A.csv")