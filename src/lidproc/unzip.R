# Set working directory
inputdirectory="O:/Nat_Ecoinformatics/B_Read/Denmark/Elevation/LiDAR/2019/laz/ZIPdownload/"
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/unzipped_dir2019/"
setwd(outputdirectory)

ziplist=list.files(path=inputdirectory,pattern = "*.zip",full.names = TRUE)
sapply(ziplist, unzip)