library(sf)
library(doParallel)
library(foreach)
# Set working directory
#inputdirectory="O:/Nat_Ecoinformatics/B_Read/Denmark/Elevation/LiDAR/2019/laz/ZIPdownload/"
#inputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/test/input/"
#outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/test/output/"
outputdirectory="C:/_Koma/GitHub/komazsofi/ecodes-dk-lidar/data/laz/"
setwd(outputdirectory)

#ziplist=list.files(path=inputdirectory,pattern = "*.zip",full.names = TRUE)
#sapply(ziplist, unzip)

# Writing out metainfo into a shp file

setwd("C:/_Koma/LAStools/LAStools/bin/")

filelist=list.files(path=outputdirectory, pattern="\\.laz$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

lasinfo <- data.frame(matrix(ncol = 24, nrow = 0))
x <- c("BlockID","FileName", "wkt_astext","NumPoints","MinGpstime", "MaxGpstime","Year","Month","Day","zmin","zmax","maxRetNum","maxNumofRet","minClass","maxClass",
       "minScanAngle","maxScanAngle","FirstRet","InterRet","LastRet","SingleRet","allPointDens","lastonlyPointDens","NofFile")
colnames(lasinfo) <- x

## set up parameters for the parallel process

Nclust <- parallel::detectCores()-2
cl <- makeCluster(Nclust)
registerDoParallel(cl)

lasinfo <- foreach(i=1:length(filelist), .combine = rbind, .packages = c("sf")) %dopar% {
  #print(i)
  
  tmp <- system(paste("lasinfo.exe ",filelist[i]," -stdout -compute_density -cores 4",sep=""), intern=TRUE, wait=FALSE)
  
  FileName <- paste(filelist[i])
  
  BlockID <- substring(FileName,64,72) #needs to be adjust based on the used path!!!!
  
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
  
  Year=substring(MaxGpstime,1,4)
  Month=substring(MaxGpstime,6,7)
  Day=substring(MaxGpstime,9,10)
  
  zmin=as.numeric(unlist(strsplit(mins, " * "))[8])
  zmax=as.numeric(unlist(strsplit(maxs, " * "))[8])
  
  RetNum_str <- tmp[(grep(pattern = "  return_number", tmp))]
  maxRetNum<-as.numeric(unlist(strsplit(RetNum_str, split=" "))[20])
  
  NumofRet_str <- tmp[(grep(pattern = "  number_of_returns", tmp))]
  maxNumofRet<-as.numeric(unlist(strsplit(NumofRet_str, split=" "))[16])
  
  Class_str <- tmp[(grep(pattern = "  classification", tmp))]
  minClass <-as.numeric(unlist(strsplit(Class_str, split=" "))[9])
  maxClass <-as.numeric(unlist(strsplit(Class_str, split=" "))[18])
  
  ScanAngle_str <- tmp[(grep(pattern = "  scan_angle_rank", tmp))]
  minScanAngle <-as.numeric(unlist(strsplit(ScanAngle_str, split=" "))[6])
  maxScanAngle <-as.numeric(unlist(strsplit(ScanAngle_str, split=" "))[15])
  
  FirstRet_str <- tmp[(grep(pattern = "number of first returns:", tmp))]
  FirstRet <-as.numeric(unlist(strsplit(FirstRet_str, split=" "))[12])
  
  InterRet_str <- tmp[(grep(pattern = "number of intermediate returns:", tmp))]
  InterRet <-as.numeric(unlist(strsplit(InterRet_str, split=" "))[5])
  
  LastRet_str <- tmp[(grep(pattern = "number of last returns:", tmp))]
  LastRet <-as.numeric(unlist(strsplit(LastRet_str, split=" "))[13])
  
  SingleRet_str <- tmp[(grep(pattern = "number of single returns:", tmp))]
  SingleRet <-as.numeric(unlist(strsplit(SingleRet_str, split=" "))[11])
  
  PointDens_str <- tmp[(grep(pattern = "point density:", tmp))]
  allPointDens <-as.numeric(unlist(strsplit(PointDens_str, split=" "))[5])
  lastonlyPointDens <-as.numeric(unlist(strsplit(PointDens_str, split=" "))[8])
  
  NofFile_str <- tmp[(grep(pattern = "  point_source_ID", tmp))]
  min_NofFile <-as.numeric(unlist(strsplit(NofFile_str, split=" "))[4])
  max_NofFile <-as.numeric(unlist(strsplit(NofFile_str, split=" "))[10])
  NofFile=max_NofFile-min_NofFile
  
  newline <- cbind(BlockID,FileName,wkt_astext,NumPoints,MinGpstime,MaxGpstime,Year,Month,Day,zmin,zmax,maxRetNum,maxNumofRet,minClass,maxClass,
                   minScanAngle,maxScanAngle,FirstRet,InterRet,LastRet,SingleRet,allPointDens,lastonlyPointDens,NofFile)
  
  newline
}

stopCluster(cl)

# export

lasinfo_df=as.data.frame(lasinfo)
lasinfo_df[, c(4,10:13,16:24)] <- sapply(lasinfo_df[, c(4,10:13,16:24)], as.numeric)

df = st_as_sf(lasinfo_df, wkt = "wkt_astext")
st_crs(df) <- 25832 
st_write(df, paste(outputdirectory,"lasinfo.shp",sep=""))







  