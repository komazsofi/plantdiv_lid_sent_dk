## Quality check of Danish country-wide ALS datasets

This report aims to check the quality of the different Danish country-wide ALS datasets on the AU server. The following directories were revised:

| directory name | expected flight campaign | adjusted GPS time |
| --- |:---:| ---:|  
| KMS2007 | 2006/2007 | not available (trajectory files) | 
| DHM2007 | 2006/2007 | not available (trajectory files) | 
| GST_2014 | 2014/2015 | available |
| DHM2015 | 2014/2015 | available |
| 2015_2018 | 2018+ | available |
| 2019 | 2018+ | available |

## KMS2007

The metadata extraction was successful, no corrupt files occurred in the dataset. The issue with the directory is that the downloaded files did not cover the whole of Denmark (big blocks are missing). Furthermore one tile (6123_485) has an outlier. The header file of the las files contain limited information: no adjusted GPStime, no georeferencing information possible to retrieve. However, linking the tiles to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. The data acquisition times are possible to retrieve from the trajectory data (TODO). The las files were extracted either using TerraScan or CPS/RTW LAS Lib v1.08.

Based on visual exploration of random tiles the data is a first-last return LiDAR data and the point density is around 0.5 points/m^2. 

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/KMS2007_pdens.png)  |  ![](figures/KMS2007_histo_pdens_plot.png)

## DHM2007

The metadata extraction was successful, no corrupt files occurred in the dataset. The directory contains all the tiles across Denmark. One tile (6123_485) has an outlier. The header file of the las files contain limited information: no adjusted GPStime, no georeferencing information possible to retrieve. However, linking the tiles to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. The data acquisition times are possible to retrieve from the trajectory data (TODO). The las files were extracted either using TerraScan or CPS/RTW LAS Lib v1.08. 

Based on visual exploration of random tiles the data is a first-last return LiDAR data and the point density is around 0.5 points/m^2. 

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/DHM2007_pdens.png)  |  ![](figures/DHM2007_histo_pdens_plot.png) 

## GST_2014

The metadata extraction found 99 incorrect files with incorrect header information with the error message as follows:

"ERROR: header size is 0 but should be at least 227
ERROR: cannot open lasreaderlas with file name 'xxx\PUNKTSKY_1km_6116_483.laz'
Error: LASlib internal error. See message above."

The geographic information is stored as epgs code within the laz files (which is expected since las v.1.3 is used) however 6 tiles do not contain geographic information, but linking them to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. The datasets were largely extracted with PDAL 1.3.0. Main issue with the dataset is that the minimum GPS time (converted into day-month-year) shows that it contains LiDAR data from the (previous) 2006/2007 ALS campaign (in the case of 11720 tiles). These mixed points from different flight campaigns are related to remaining water points or ground points used for georeferencing purposes (based on random visual check). 


Oldest            |  Most recent
:-------------------------:|:-------------------------:
![](figures/GST_2014_oldest_gpstime.png)  |  ![](figures/GST_2014_recent_gpstime.png)
![](figures/GST_2014_histo_oldest_plot.png)  |  ![](figures/GST_2014_histo_recent_plot.png)

The dataset is a discrete-return LiDAR data with 4-5 recorded returns. The estimated mean point density calculated for all returns is 8 pt/m^2. 

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/GST_2014_pdens.png)  |  ![](figures/GST_2014_histo_pdens_plot.png)

The dataset was measured both in leaf-off (november-march) and leaf-on (april-october) seasons.

Seasonality map          |  Seasonality histogram
:-------------------------:|:-------------------------:
![](figures/GST_2014_months_inseason.png)  |  ![](figures/GST_2014_histo_season_plot.png)

## DHM2015

There have already been errors occurred during unzipping the files. My unzipping script skipped the following directories: 10km_614_57, 10km_615_53, 10km_622_52, 10km_622_53, 10km_633_54. It was possible to unzip them manually and add to the dataset later. One problematic file were identified and two additional files got the following error message during processing:

"WARNING: 'chunk table and 44909292 bytes are missing. LAZ file truncated during
copy or transfer?' 
ERROR: 'end-of-file during chunk with index 51' after 2591397 of 10321753 points
"

The geographic information is largely not stored within the laz files, but linking them to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. 200 tiles contain epgs code within the laz files. The laz files were extracted using CPS/RTW LAS Lib v1.08, PDAl 1.3.0, sspplash:DVR90 and TerraScan. The minimum GPS time shows mixing the different flight campaigns. Furthermore in some regions we lost the date of flightinformation.

Oldest            |  Most recent
:-------------------------:|:-------------------------:
![](figures/DHM2015_oldest_gpstime.png)  |  ![](figures/DHM2015_recent_gpstime.png)
![](figures/DHM2015_histo_oldest_plot.png)  |  ![](figures/DHM2015_histo_recent_plot.png)

The dataset is a discrete-return LiDAR data with 4-5 recorded returns. The estimated mean point density calculated for all returns is 8 pt/m^2. 

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/DHM2015_pdens.png)  |  ![](figures/DHM2015_histo_pdens_plot.png)

The dataset was measured both in leaf-off (november-march) and leaf-on (april-october) seasons.

Seasonality map          |  Seasonality histogram
:-------------------------:|:-------------------------:
![](figures/DHM2015_months_inseason.png)  |  ![](figures/DHM2015_histo_season_plot.png)

## 2015_2018

The metadata extraction found 8 incorrect files however no error message was retrieved regarding these files (TODO: needs to be checked manually). 

The geographic information is mainly stored as epgs code within the laz files however 276 tiles do not contain geographic information, but linking them to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. The datasets were largely extracted with PDAL 1.3.0 and 1.5.0. Some files were extracted using TerraScan and one with CPS/RTW LAS Lib v1.08. The dataset contains LiDAR data from all three flight campaigns. The 2014/2015 LiDAR dataset was updated with the more recently measured dataset(s). Based on the minimum GPS time 9348 tiles contain data from the 2006/2007 flight campaign as well as the 2018 measured region contains some tiles which were measured in 2015. 

Oldest            |  Most recent
:-------------------------:|:-------------------------:
![](figures/dir2015_2018_oldest_gpstime.png)  |  ![](figures/dir2015_2018_recent_gpstime.png)
![](figures/dir2015_2018_histo_oldest_plot.png)  |  ![](figures/dir2015_2018_histo_recent_plot.png)

The most recently measured LiDAR dataset is a full waveform ALS data. The estimated mean point density calculated for all returns is 10 pt/m^2.

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/dir2015_2018_pdens.png)  |  ![](figures/dir2015_2018_histo_pdens_plot.png)

The dataset was measured both in leaf-off (november-march) and leaf-on (april-october) seasons.

Seasonality map          |  Seasonality histogram
:-------------------------:|:-------------------------:
![](figures/dir2015_2018_months_inseason.png)  |  ![](figures/dir2015_2018_histo_season_plot.png)

## 2019

The metadata extraction found 92 incorrect files however no error messages were retrieved regarding these files (TODO: needs to be checked manually). 

The geographic information is mainly stored as wkt within the laz files however 11 tiles do not contain geographic information, but linking them to epgs:25832 (ETR89 UTM 32 N based on the GRS80 spheroid) gives the correct geographic location. The files were extracted using various software solutions: CPD/RTW LAS Lib v1.08, las2las (different versions), PDAL 1.3.0, 1.8.0 and TerraScan. Based on the minimum GPS time 7646 tiles contain data from the 2006/2007 flight campaign as well as the regions measured in 2018, 2019 it still contains some files from the 2014/2015 flight campaign. 

Oldest            |  Most recent
:-------------------------:|:-------------------------:
![](figures/dir2019_oldest_gpstime.png)  |  ![](figures/dir2019_recent_gpstime.png)
![](figures/dir2019_histo_oldest_plot.png)  |  ![](figures/dir2019_histo_recent_plot.png)

The most recently measured LiDAR dataset is a full waveform ALS data. The estimated mean point density calculated for all returns is 12 pt/m^2.

Point density map           |  Point density histogram
:-------------------------:|:-------------------------:
![](figures/dir2019_pdens.png)  |  ![](figures/dir2019_histo_pdens_plot.png)

The dataset was measured both in leaf-off (november-march) and leaf-on (april-october) seasons.

Seasonality map          |  Seasonality histogram
:-------------------------:|:-------------------------:
![](figures/dir2019_months_inseason.png)  |  ![](figures/dir2019_histo_season_plot.png)

## Conclusion

Minimum requirement for data usability: 
- Avoid mixing the tiles from different flight campaigns. Storing the different flight campaigns separately. (TODO: separate the point clouds and re-organize them according to flight campaigns) 

Maximum requirements/wishes:
- Standardized way of saving geographical information
- Report about the overall vertical and horizontal accuracy
- Report about how the classification have been carried out
- Used scanners for the flight campaigns
- Access to the trajectory files