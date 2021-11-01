library(snow)

# Set working directory
inputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/metainfo_extract/test3_unzip/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/metainfo_extract/test3_unzip"

ziplist=list.files(path=inputdirectory, pattern=paste("\\.","ZIP","$",sep=""), full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

Nclust <- parallel::detectCores()-2
cl <-makeCluster(Nclust)

sink(paste(outputdirectory,"/zipping_log.txt",sep=""))

parSapply(cl,ziplist, unzip, exdir=outputdirectory, simplify = FALSE)

sink()

stopCluster(cl)

