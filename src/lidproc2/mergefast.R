file1=read.csv("O:/Nat_Ecoinformatics-tmp/au700510/lidar_process/DHM2015_unziperror/DHM2015_20211110_1637.csv")
file2=read.csv("O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/DHM2015_20211110_0926.csv")

lasinfo_df=rbind(file1,file2)

lasinfo_df=lasinfo_df[-1]

st=format(Sys.time(), "%Y%m%d_%H%M")

lasinfo_df_c=lasinfo_df[!is.na(lasinfo_df$wkt_astext),]
df = st_as_sf(lasinfo_df_c, wkt = "wkt_astext")
st_crs(df) <- 25832
st_write(df, paste("O:/Nat_Ecoinformatics-tmp/au700510/metadata_dklidar/","DHM2015","_",st,".shp",sep=""))