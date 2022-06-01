library(utils)

library(doSNOW)
library(tcltk)
library(foreach)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/lidar_organized/pointclouds/lidar_download_2022march/test_unzip_result/")

list.zip=list.files(path="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/lidar_organized/pointclouds/lidar_download_2022march/test_unzip/",pattern = "*.zip",full.names = TRUE)

Nclust <- parallel::detectCores()-1

cl <-makeCluster(Nclust)
registerDoSNOW(cl)

ntasks <- length(list.zip)
pb <- tkProgressBar(max=ntasks)
progress <- function(n) setTkProgressBar(pb, n)
opts <- list(progress=progress)

foreach(i=1:length(list.zip), .packages=c("utils"),.errorhandling='pass',.options.snow=opts) %dopar% {
  
  unzip(list.zip[i])
  
}

stopCluster(cl)