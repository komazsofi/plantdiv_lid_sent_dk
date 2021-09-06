library(lidR)
library(sf)

library(mapview)


# Set working directory
workingdirectory="C:/_Koma/Work/"
setwd(workingdirectory)

#Import 
areaofint=read.csv(file="C:/_Koma/Field_data/Biowide/BiowideEnvDB.csv",sep=";")
areaofint_whna=areaofint[!is.na(areaofint$utm_x),]
biowide_plots <- st_as_sf(areaofint_whna, coords = c("utm_x", "utm_y"), crs = 25832)
plot(biowide_plots[1])

# LiDAR catalog
ctg <- readLAScatalog("C:/_Koma/LiDAR/")
plot(ctg, map=TRUE)

for (i in biowide_plots[["site_nr"]]){ 
  print(i) 
  subset = clip_roi(ctg, biowide_plots[biowide_plots$site_nr==i,],radius=20)
  subset_whnoise <- filter_poi(subset, Classification != 18)
  
  if (length(subset_whnoise@data$X)>3) {
      writeLAS(subset_whnoise,paste("SiteNr_",i,".laz",sep=""))
  }
}

