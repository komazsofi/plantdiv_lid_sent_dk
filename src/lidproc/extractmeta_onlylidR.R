library(lidR)
library(mapview)

# Set working directory
inputdirectory="O:/Nat_Ecoinformatics/B_Read/Denmark/Elevation/LiDAR/2019/laz/ZIPdownload/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/unzipped_dir2019/"
setwd(outputdirectory)

filelist=list.files(path=inputdirectory,pattern = "*.zip")

for (i in filelist[1:3]) {
  print(i)
  
  unzip(paste(inputdirectory,i,sep=""))
  
}

# LiDAR catalog
ctg <- readLAScatalog(outputdirectory)
plot(ctg, map=TRUE)

metadata=ctg@data

# Add additional attributes with info

setwd("C:/_Koma/LAStools/LAStools/bin/")

for (j in 1:nrow(metadata)) {
  print(j)
  
  tmp <- system(paste("lasinfo.exe ",metadata$filename[j],sep=""), intern=TRUE, wait=FALSE)
  
  gpsrange <- tmp[(grep(pattern = "  gps_time", tmp))]
  gpsrange2=unlist(strsplit(gpsrange, split=" "))
  mingpstime=as.POSIXct(as.numeric(gpsrange2[4])+1000000000,origin="1980-01-06")
  maxgpstime=as.POSIXct(as.numeric(gpsrange2[5])+1000000000,origin="1980-01-06")
  
  metadata$minGPS[j] <- as.character(mingpstime)
  metadata$maxGPS[j] <- as.character(maxgpstime)
}

