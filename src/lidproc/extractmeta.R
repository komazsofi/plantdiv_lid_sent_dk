library(sf)

setwd("C:/_Koma/LAStools/LAStools/bin/")

filelist=list.files(path="O:/Nat_Ecoinformatics-tmp/au700510/unzipped_dir2019/", pattern="\\.laz$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

lasinfo <- data.frame(matrix(ncol = 9, nrow = 0))
x <- c("FileName", "wkt_astext","NumPoints", "xmin", "xmax", "ymin", "ymax", "mingpstime", "maxgpstime")
colnames(lasinfo) <- x

for (i in 1:length(filelist)) {
  print(i)
  
  tmp <- system(paste("lasinfo.exe ",filelist[i],sep=""), intern=TRUE, wait=FALSE)
  
  FileName <- paste(filelist[i])
  
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
  mingpstime=as.character(as.POSIXct(as.numeric(gpsrange2[4])+1000000000,origin="1980-01-06"))
  maxgpstime=as.character(as.POSIXct(as.numeric(gpsrange2[5])+1000000000,origin="1980-01-06"))
  
  newline <- cbind(FileName, wkt_astext,NumPoints, xmin, xmax, ymin, ymax, mingpstime, maxgpstime)
  
  lasinfo <- rbind(lasinfo, newline)
}

df = st_as_sf(lasinfo, wkt = "wkt_astext")
st_write(df, "O:/Nat_Ecoinformatics-tmp/au700510/unzipped_dir2019/lasinfo.shp")







  