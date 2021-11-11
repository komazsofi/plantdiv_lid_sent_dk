# The script aims to visualize the results of extractmeta script.
# It re-used some elements from https://github.com/jakobjassmann/ecodes-dk-lidar/blob/1e3c0634fa48dff334c2bbfbc086d86b5282b34a/documentation/generate_date_stamp_figure.R
#
# The following parameters needs to be defined in line 10-12: outputdirectory, file, dirname (where the file is coming from)

library(ggplot2)
library(cowplot)
library(sf)
library(tidyverse)

# Set parameters
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/"

#file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/dir2015_2018_20211104_0935.shp"
#dirname="dir2015_2018"

#file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/GST_2014_20211102_0549.shp"
#dirname="GST_2014"

#file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/DHM2007_20211102_2342.shp"
#dirname="DHM2007"

#file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/KMS2007_20211101_1227.shp"
#dirname="KMS2007"

file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/dir2019_20211108_0706.shp"
dirname="dir2019"

#file="O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/DHM2015_20211111_1414.shp"
#dirname="DHM2015"

df = st_read(file)

# Maps

df$year_rec <- paste(substring(df$MxGpstm,1,4),sep="")
df$year_rec [df$year_rec  == "2011" | df$year_rec  == "2010"] <- NA
df$year_rec <- as.factor(df$year_rec)

recentyear_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = year_rec),
          colour = NA) +
  labs(fill = "Year", title = "Most recent tile acquisition years") +
  scale_fill_manual(values = c("2007" = "darkviolet", "2013" = "brown","2014" = "gold",
                               "2015" = "darkolivegreen4","2018" = "chocolate4","2019" = "hotpink","NA"="darkgray"))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_recent_gpstime",".png",sep=""), recentyear_plot,
          base_height = 6)

df$year_old <- paste(substring(df$MnGpstm,1,4),sep="")
df$year_old [df$year_old  == "2011" | df$year_old  == "2010" ] <- NA
df$year_old <- as.factor(df$year_old)

oldestyear_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = year_old),
          colour = NA) +
  labs(fill = "Year", title = "Oldest tile acquisition years") +
  scale_fill_manual(values = c("2007" = "darkviolet", "2013" = "brown","2014" = "gold",
                               "2015" = "darkolivegreen4","2018" = "chocolate4","2019" = "hotpink","NA"="darkgray"))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_oldest_gpstime",".png",sep=""), oldestyear_plot,
          base_height = 6)

pdens_plot <-ggplot() +
  geom_sf(data = df, aes(fill = allPntD),colour = NA)+
  scale_fill_gradient2(low = "blue", mid = "yellow", high = "red",limits=c(0, 25))+
  labs(fill = "Point density (all)", title = "Point density per tiles")+theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_pdens",".png",sep=""), pdens_plot,
          base_height = 6)

df$months_rec <- paste(substring(df$MxGpstm,6,7),sep="")
df$months_rec [df$year_rec  == "2011" | df$year_rec  == "2010"] <- NA
df$months_rec <- as.factor(df$months_rec)

recentmonths_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = months_rec),
          colour = NA) +
  labs(fill = "Months", title = "Most recent tile acquisition months") +
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_recentmonths_gpstime",".png",sep=""), recentmonths_plot,
          base_height = 6)

df$months_inseason <- NA
df$months_inseason [df$months_rec  == "01" | df$months_rec  == "02" | df$months_rec  == "03" | df$months_rec  == "11" | df$months_rec  == "12"] <- "leaf-off"
df$months_inseason [df$months_rec  == "04" | df$months_rec  == "05" | df$months_rec  == "06" | df$months_rec  == "07" | df$months_rec  == "08" 
                    | df$months_rec  == "09" | df$months_rec  == "10"] <- "leaf-on"
df$months_inseason <- as.factor(df$months_inseason)

months_inseason_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = months_inseason),
          colour = NA) +
  labs(fill = "Seasonality", title = "Seasonality of the most recent tile acquisition") +
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_months_inseason",".png",sep=""), months_inseason_plot,
          base_height = 6)

# Histograms

df_sumyearec=df %>% group_by(year_rec) %>% summarise(n = n())

histo_recent <- ggplot(data=df_sumyearec,aes(x=year_rec,y=n,fill=as.factor(year_rec)))+geom_col()+
  labs(fill = "Year", title = "Most recent tile acquisition years") +
  geom_text(data=df_sumyearec,aes(x=year_rec,y=n+1000,label=n),inherit.aes = F)+
  scale_y_continuous(limits = c(0,30000)) +
  xlab("Year") + ylab("Number of tiles") +
  scale_fill_manual(values = c("2007" = "darkviolet", "2013" = "brown","2014" = "gold",
                               "2015" = "darkolivegreen4","2018" = "chocolate4","2019" = "hotpink","NA"="darkgray"))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_histo_recent_plot",".png",sep=""), histo_recent,
          base_height = 6)

df_sumyearold=df %>% group_by(year_old) %>% summarise(n = n())

histo_old <- ggplot(data=df_sumyearold,aes(x=year_old,y=n,fill=as.factor(year_old)))+geom_col()+
  labs(fill = "Year", title = "Oldest tile acquisition years") +
  geom_text(data=df_sumyearold,aes(x=year_old,y=n+1000,label=n),inherit.aes = F)+
  scale_y_continuous(limits = c(0,30000)) +
  xlab("Year") + ylab("Number of tiles") +
  scale_fill_manual(values = c("2007" = "darkviolet", "2013" = "brown","2014" = "gold",
                               "2015" = "darkolivegreen4","2018" = "chocolate4","2019" = "hotpink","NA"="darkgray"))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_histo_oldest_plot",".png",sep=""), histo_old,
          base_height = 6)

histo_pdens <- ggplot(data = df, aes(x = allPntD)) + geom_histogram(binwidth=5)+
  labs(title = "Point density histogram (all returns)",
       x = "All point density",
       y = "Number of tiles",
       subtitle = paste0("Mean: ",round(mean(df$allPntD),2), ", Median: ",round(median(df$allPntD),2),
                         ", Min: ",round(min(df$allPntD),2),", Max: ",round(max(df$allPntD),2)))+
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_histo_pdens_plot",".png",sep=""), histo_pdens,
          base_height = 6)