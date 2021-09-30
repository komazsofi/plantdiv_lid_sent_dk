library(sf)
library(doParallel)
library(foreach)
# Set working directory
#inputdirectory="O:/Nat_Ecoinformatics/B_Read/Denmark/Elevation/LiDAR/2019/laz/ZIPdownload/"
inputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/test/input/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/test/output/"
setwd(outputdirectory)

#ziplist=list.files(path=inputdirectory,pattern = "*.zip",full.names = TRUE)
#sapply(ziplist, unzip)

# Writing out metainfo into a shp file

setwd("C:/_Koma/LAStools/LAStools/bin/")

filelist=list.files(path=outputdirectory, pattern="\\.laz$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

lasinfo <- data.frame(matrix(ncol = 9, nrow = 0))
x <- c("BlockID","FileName", "wkt_astext","NumPoints","MinGpstime", "MaxGpstime","Year","Month","Day")
colnames(lasinfo) <- x

## number of clusters to use

# I usually use

Nclust <- parallel::detectCores()/2

# And then use that for the makeCluster function
cl <- makeCluster(2)

registerDoParallel(cl)

lasinfo <- foreach(i=1:length(filelist), .combine = rbind, .packages = c("sf")) %dopar% {
  #print(i)
  
  tmp <- system(paste("lasinfo.exe ",filelist[i],sep=""), intern=TRUE, wait=FALSE)
  
  FileName <- paste(filelist[i])
  
  BlockID <- substring(FileName,66,73)
  
  NumPoints_str <- tmp[(grep(pattern = "  number of point records", tmp))]
  NumPoints<-as.numeric(unlist(strsplit(NumPoints_str, split=" "))[10])
  
  mins=tmp[(grep(pattern='min x y z', tmp))]
  maxs=tmp[(grep(pattern='max x y z', tmp))]
  
  xmin <- as.numeric(unlist(strsplit(mins, " * "))[6])
  xmax <- as.numeric(unlist(strsplit(maxs, " * "))[6])
  ymin <- as.numeric(unlist(strsplit(mins, " * "))[7])
  ymax <- as.numeric(unlist(strsplit(maxs, " * "))[7])
  
  wkt_astext=paste("POLYGON((",xmin," ",ymin,",",xmin," ",ymax,",", xmax," ",ymax,",",
                   xmax," ", ymin,",",xmin," ",ymin,"))",sep="")
  
  gpsrange <- tmp[(grep(pattern = "  gps_time", tmp))]
  gpsrange2=unlist(strsplit(gpsrange, split=" "))
  MinGpstime=as.character(as.POSIXct(as.numeric(gpsrange2[4])+1000000000,origin="1980-01-06"))
  MaxGpstime=as.character(as.POSIXct(as.numeric(gpsrange2[5])+1000000000,origin="1980-01-06"))
  
  Year=substring(MinGpstime,1,4)
  Month=substring(MinGpstime,6,7)
  Day=substring(MinGpstime,9,10)
  
  newline <- cbind(BlockID,FileName, wkt_astext,NumPoints, MinGpstime, MaxGpstime,Year,Month,Day)
  
  newline
}


stopCluster(cl)
df = st_as_sf(lasinfo, wkt = "wkt_astext")
st_write(df, paste(outputdirectory,"lasinfo.shp",sep=""))







  