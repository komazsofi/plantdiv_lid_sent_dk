"
@author: Zsofia Koma, AU
Aim: This script download DK lidar data from the https://dataforsyningen.dk/ website
"

# Set working directory
workingdirectory="O:/Nat_Ecoinformatics-tmp/LiDAR_2022/Dataforsyningen_2018plus_24032022/" ## set this directory where you would like to put your las files
setwd(workingdirectory)

generated_token="?bearertoken=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNTg2YWNjNTA4MzkzNzljZTJjYjI1NjdkYzYwOTI1N2EyNjM1NjEzNmNiYjgyMTJmMGU5NGEzNWExY2JiNGE3NjIxMThhZWEwYzA5OTU3NjgiLCJpYXQiOjE2NDgyMTA5NzUsIm5iZiI6MTY0ODIxMDk3NSwiZXhwIjoxNjQ4Mjk3Mzc1LCJzdWIiOiIxMzcxOTQiLCJzY29wZXMiOltdfQ."

# Set filenames and dwnload and unzip the required dataset
req_tile=as.list(read.csv("10km_blocklist.txt",header = FALSE))

#for (tile in req_tile$V1[1:2]){
#download.file(paste("https://download.dataforsyningen.dk/Statsaftalen/DANMARK/3_HOJDEDATA/PUNKTSKY/PUNKTSKY_",tile,"_TIF_UTM32-ETRS89.zip",generated_token,sep=""),
#paste("PUNKTSKY_",tile,"_TIF_UTM32-ETRS89.zip",sep=""))
#}

req_tile$V2=paste("https://download.dataforsyningen.dk/Statsaftalen/DANMARK/3_HOJDEDATA/PUNKTSKY/PUNKTSKY_",req_tile$V1,"_TIF_UTM32-ETRS89.zip",generated_token,sep="")

write.table(req_tile$V2[15:667], file = "dhm2018_list_v2.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 