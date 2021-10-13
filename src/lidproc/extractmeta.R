# The script aims to derive basic information regarding the las/laz files with lasinfo from LAStools. 
#
# To use the script the inputdirectory, outputdirectory and lasinfoloc needs to be rightly set (see # Set working directories section). 
# Also in line 56 BlockID the substring() function needs to be adjusted according to the filepath
#
# To run the script from command line (Command Prompt) on a windows machine the following command can be used (after navigating the location of the Rscript file ((for me C:\Program Files\R\R-4.1.1\bin)): 
# C:\Program Files\R\R-4.1.1\bin>Rscript O:\Nat_Ecoinformatics-tmp\extractmeta_server.R
# O:\Nat_Ecoinformatics-tmp\ - needs to be set to the path of where the R file located

library(sf)
#library(doParallel)
library(foreach)
library(doSNOW)
library(tcltk)

# Set working directories
inputdirectory="C:/_Koma/GitHub/komazsofi/ecodes-dk-lidar/data/laz/" #set this to the path where the laz (unzipped) files are located 
outputdirectory="C:/_Koma/GitHub/komazsofi/ecodes-dk-lidar/data/laz/" #set this to the path where the resulted files wished to be extracted
lasinfoloc="C:/_Koma/LAStools/LAStools/bin/" #set this to the path where the lasinfo.exe file is located 

start_time <- Sys.time()

# Writing out metainfo into a shp file

setwd(lasinfoloc)

filelist=list.files(path=inputdirectory, pattern="\\.laz$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

lasinfo <- data.frame(matrix(ncol = 24, nrow = 0))
x <- c("BlockID","FileName", "wkt_astext","NumPoints","MinGpstime", "MaxGpstime","Year","Month","Day","zmin","zmax","maxRetNum","maxNumofRet","minClass","maxClass",
       "minScanAngle","maxScanAngle","FirstRet","InterRet","LastRet","SingleRet","allPointDens","lastonlyPointDens","NofFile")
colnames(lasinfo) <- x

## set up parameters for the parallel process

Nclust <- parallel::detectCores()-2
#cl <- makeCluster(Nclust)
#registerDoParallel(cl)

cl <-makeCluster(Nclust,outfile="")
registerDoSNOW(cl)

ntasks <- length(filelist)
pb <- tkProgressBar(max=ntasks)
progress <- function(n) setTkProgressBar(pb, n)
opts <- list(progress=progress)

lasinfo <- foreach(i=1:length(filelist), .combine = rbind, .packages = c("sf"), .options.snow=opts, .errorhandling = "remove") %dopar% {
  
  print(filelist[i])
  
  tmp <- system(paste("lasinfo.exe ",filelist[i]," -stdout -compute_density",sep=""), intern=TRUE, wait=FALSE)
    
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
  
  if (NumPoints>0) {
    
    newline <- cbind(BlockID,FileName,wkt_astext,NumPoints,MinGpstime,MaxGpstime,Year,Month,Day,zmin,zmax,maxRetNum,maxNumofRet,minClass,maxClass,
                     minScanAngle,maxScanAngle,FirstRet,InterRet,LastRet,SingleRet,allPointDens,lastonlyPointDens,NofFile)
    
  } else {
    
    newline <- cbind(BlockID,FileName,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                     NA,NA,NA,NA,NA,NA,NA,NA,NA)
    
  }
  
  newline

}

stopCluster(cl)

# export

st=format(Sys.time(), "%Y%m%d_%H%M")

lasinfo_df=as.data.frame(lasinfo)
lasinfo_df[, c(4,10:13,16:24)] <- sapply(lasinfo_df[, c(4,10:13,16:24)], as.numeric)
colnames(lasinfo_df) <- x
write.csv(lasinfo_df,paste(outputdirectory,"lasinfo_",st,".csv",sep=""))

lasinfo_df_c=lasinfo_df[!is.na(lasinfo_df$wkt_astext),]
df = st_as_sf(lasinfo_df_c, wkt = "wkt_astext")
st_crs(df) <- 25832
st_write(df, paste(outputdirectory,"lasinfo_",st,".shp",sep=""))

end_time <- Sys.time()
print(end_time - start_time)






  