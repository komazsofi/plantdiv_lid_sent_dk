library(dplyr)
library(tidyverse)

# Set working directory
dir_laz="O:/Nat_Ecoinformatics-tmp/au659486_LiDAR/DHM2015/DHM2015_punksky_20211013135310/DHM2015_punktsky_unzip/"
dir_zip="O:/Nat_Ecoinformatics-tmp/au659486_LiDAR/DHM2015/DHM2015_punksky_20211013135310/DHM2015_punktsky/"

filelist=list.files(path=dir_laz, pattern=paste("\\.","laz","$",sep=""), full.name=TRUE, include.dirs=TRUE, recursive=TRUE)
ziplist=list.files(path=dir_zip, pattern=paste("\\.","zip","$",sep=""), full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

#ziplist_full=lapply(ziplist,unzip,list = TRUE) %>% bind_rows()

testFunction <- function (ziplist) {
  return(tryCatch(unzip(ziplist,list = TRUE), error=function(e) NULL))
}

ziplist_full=lapply(ziplist,testFunction) %>% bind_rows()

# Make lists zipping error

BlockID_laz <- substring(filelist,nchar(filelist)-11,nchar(filelist)-4) 
BlockID_zip <- substring(ziplist,nchar(ziplist)-9,nchar(ziplist)-4)

BlockID_laz_zip=unique(paste(str_sub(BlockID_laz,1,3),"_",str_sub(BlockID_laz,6,7),sep=""))
filecheck1=setdiff(BlockID_zip,BlockID_laz_zip)

# Make lists not processed files

laz <- substring(filelist,nchar(filelist)-24,nchar(filelist)-4)
zipfull <- substring(ziplist_full$Name,nchar(ziplist_full$Name)-24,nchar(ziplist_full$Name)-4)

filecheck2=setdiff(zipfull,laz)

# track back non extracted zipped files

BlockID_zip_formiss=unique(paste(str_sub(filecheck2,14,16),"_",str_sub(filecheck2,19,20),sep=""))
filecheck1=setdiff(BlockID_zip,BlockID_laz_zip)

# move zip files into new directory for process

file.copy(from = paste0(dir_zip,"10km_",BlockID_zip_formiss,".zip"),to = paste0("O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/DHM2015_unziperror/", "10km_",BlockID_zip_formiss,".zip"))

# move files into new directory for process

file.copy(from = paste0(dir_laz, filecheck2,".laz"),to = paste0("O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/DHM2015_unziperror/notprocessedfiles/", filecheck2,".laz"))
