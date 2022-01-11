library(sf)

# Set global variables
wd="O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/"
setwd(wd)

# Import 

DHM2017 = read_sf("DHM2007_20211102_2342.shp")
scanline = read_sf("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/lidarprocess/extract_info_from_flightlines/unziped_KMS2007_traj/scan_604_68.shp")

st_crs(scanline) = st_crs(DHM2017)

# intersection
int = st_intersection(DHM2017, scanline)
plot(int)

int = st_intersection(scanline, DHM2017)
plot(int)