library(snow)

# Set working directory
inputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/DHM2015_unziperror/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/DHM2015_unziperror/unzip"

ziplist=list.files(path=inputdirectory, pattern=paste("\\.","zip","$",sep=""), full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

Nclust <- parallel::detectCores()-2
cl <-makeCluster(Nclust)

sink(paste(outputdirectory,"/zipping_log.txt",sep=""))

parSapply(cl,ziplist, unzip, exdir=outputdirectory, simplify = FALSE)

sink()

stopCluster(cl)

