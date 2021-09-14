library(lidR)
library(mapview)

# Set working directory
inputdirectory="O:/Nat_Ecoinformatics/B_Read/Denmark/Elevation/LiDAR/2019/laz/ZIPdownload/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/unzipped_dir2019/"
setwd(outputdirectory)

filelist=list.files(path=inputdirectory,pattern = "*.zip")

for (i in filelist[1:4]) {
  print(i)
  
  unzip(paste(inputdirectory,i,sep=""))
  
}

# LiDAR catalog
ctg <- readLAScatalog(outputdirectory)
plot(ctg, map=TRUE)

metadata=ctg@data

#Readlas
las=readLAS("PUNKTSKY_1km_6049_687.laz")