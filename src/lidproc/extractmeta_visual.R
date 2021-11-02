# The script aims to visualize the results of extractmeta script.
# It re-used some elements from https://github.com/jakobjassmann/ecodes-dk-lidar/blob/1e3c0634fa48dff334c2bbfbc086d86b5282b34a/documentation/generate_date_stamp_figure.R
#
# The following parameters needs to be defined in line 10-12: outputdirectory, file, dirname (where the file is coming from)

library(ggplot2)
library(cowplot)
library(sf)
library(tidyverse)

# Set parameters
outputdirectory="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/metainfo_extract/test_diff_lasfiles/"
file="O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/metainfo_extract/GST_2014_20211015_0148w_crs.shp"
dirname="GST_2014"

df = st_read(file)
names(df)[4] <- "MinGpstime"
names(df)[5] <- "MaxGpstime"
names(df)[21] <- "allPointDens"

# Maps

df$year_rec <- paste(substring(df$MaxGpstime,1,4),sep="")
df$year_rec [df$year_rec  == "2011"] <- NA
df$year_rec <- as.factor(df$year_rec)

recentyear_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = year_rec),
          colour = NA) +
  labs(fill = "Year", title = "Tile acquisition years") +
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_recent_gpstime",".png",sep=""), recentyear_plot,
          base_height = 6)

df$year_old <- paste(substring(df$MinGpstime,1,4),sep="")
df$year_old [df$year_old  == "2011"] <- NA
df$year_old <- as.factor(df$year_old)

oldestyear_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = year_old),
          colour = NA) +
  labs(fill = "Year, Month", title = "Tile acquisition dates") +
  labs(fill = "Year", title = "Tile acquisition years") +
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_oldest_gpstime",".png",sep=""), oldestyear_plot,
          base_height = 6)

pdens_plot <-ggplot() +
  geom_sf(data = df, aes(fill = allPointDens),colour = NA)+
  scale_fill_gradient2(low = "blue", mid = "yellow", high = "red",limits=c(0, 30))+
  labs(fill = "Point density (all)", title = "Point density per tiles")+theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_pdens",".png",sep=""), pdens_plot,
          base_height = 6)

df$months_rec <- paste(substring(df$MaxGpstime,6,7),sep="")
df$months_rec [df$year_rec  == "2011"] <- NA
df$months_rec <- as.factor(df$months_rec)

recentmonths_plot <-ggplot() +
  geom_sf(data = df,
          aes(fill = months_rec),
          colour = NA) +
  labs(fill = "Months", title = "Most recent tile acquisition months") +
  theme_cowplot()

save_plot(paste(outputdirectory,dirname,"_recentmonths_gpstime",".png",sep=""), recentmonths_plot,
          base_height = 6)

# Histograms

df_sumyearec=df %>% group_by(year_rec) %>% summarise(n = n())

histo_recent <- ggplot(data=df_sumyearec,aes(x=year_rec,y=n,fill=as.factor(year_rec)))+geom_col()+
  labs(fill = "Year", title = "Most recent tile acquisition years") +
  geom_text(data=df_sumyearec,aes(x=year_rec,y=n+1000,label=n),inherit.aes = F)+
  scale_y_continuous(limits = c(0,30000)) +
  xlab("Year") + ylab("Number of tiles") +
  theme_cowplot()

histo_recent_plot <- plot_grid(recentyear_plot, histo_recent, labels = c('A', 'B'),ncol=2)
save_plot(paste(outputdirectory,dirname,"_histo_recent_plot",".png",sep=""), histo_recent_plot,
          base_height = 6)