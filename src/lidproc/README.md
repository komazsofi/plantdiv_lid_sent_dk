This work aimed to extract metadata information about the las/laz files coming from the danish country-wide ALS datasets from different downloads over the years. The developed scripts (https://github.com/komazsofi/plantdiv_lid_sent_dk/blob/master/src/lidproc/) extracts metadata information about flight acquisition dates, point density etc. (see below) as a shapefile. It only uses the las/laz file header to fetch the basic information about the las/laz files.  

## The metadata extraction scripts are performed in the following order: 

* Step A: unzip.R : unzip zipped las/laz files (generally from webservices  laz/las files are accessible only in zipped formats) 

	* Input: zipped las/laz files in the working directory  

	* Output: unzipped las/laz files in the output directory 

* Step B: extractmeta_v2.R: using the unzipped las/laz files in directories extracts a shapefile and csv files about the metadata of the las/laz files, also catch information about errors  

	* Input: unzipped las/laz files in the working directory  

	* Output: a shapefile and a csv about the las/laz files in directory named as: directory name, date of file extraction, time of file extraction (year,month,day_hour and minutes), a log txt file named as dirname which contains information about printed screen information during the process, a csv file with listing the potentially problematic files which were not processed during the loop due to errors names as *problematic_files*.csv 

* Step C: extractmeta_visual.R: based on the generated shapefiles visualize some of the most important aspects of the data Input: extracted shapefile from extractmeta_v2.r script for fast overbiew purposes 

	* Output: maps and histograms as png files about oldest flight dates, recent flight dates, point density, most recent month of data acquisition 

## Name of the attributes extracted within the shapefile using LAStools lasinfo.exe: 

- BlockID: the identifier of the 1 km x 1 km block 

- FileNam: the name of the file and the full path when the script was applied 

- NumPnts: number of point records within the 1 km x 1km block 

- MnGpstm: minimum GPS time recorded within the 1 km x 1 km block 

- MxGpstm: maximum GPS time recorded within the 1 km x 1 km block 

- Year: year of the flight calculated based on the maximum GPS time measured within the 1 km x 1km block 

- Month: month of the flight calculated based on the maximum GPS time measured within the 1 km x 1km block 

- Day: day of the flight calculated based on the maximum GPS time measured within the 1 km x 1km block 

- zmin: minimum z (height) within the 1 km x 1km block 

- zmax: maximum z (height) within the 1 km x 1km block 

- maxRtNm: maximum return number within the 1 km x 1km block 

- mxNmfRt: maximum number of returns within the 1 km x 1km block 

- minClss: minimum ASPRS class within the 1 km x 1km block 

- maxClss: maximum ASPRS class within the 1 km x 1km block 

- mnScnAn: minimum scan angle within the 1 km x 1km block 

- mxScnAn: maximum scan angle within the 1 km x 1km block 

- FirstRt: number of first returns within the 1 km x 1km block 

- InterRt: number of intermediate returns within the 1 km x 1km block 

- LastRet: number of last returns within the 1 km x 1km block 

- SingLRt: number of single returns within the 1 km x 1km block 

- allPntD: average point density of all returns calculated within the 1 km x 1km block 

- lstnIPD: average point density of last returns only calculated within the 1 km x 1km block 

- minFlID: minimum point source ID within the 1 km x 1km block 

- maxFlID: maximum point source ID within the 1 km x 1km block 

- epgs: check whether the las header contains epgs information (usually the case of las version 1.3) and if yes write it into the attribute 

- crs: gives information whether geographic information is exist within the las/laz file. It can be "No georef info" it has neither epgs or wkt information, "It has epgs info" it has epgs information (expected in the case of las v. 1.3.), "It has wkt info" it has wkt information (expected in the case of las v 1.4) 

- LasVer: version of the las/laz file 

- GenSoft: the last software which touched the file 

- CreateYear: the year of generating the file with the last software used (not necessary the same as data acquisition date) 

Some further comments and limitations about the average point density estimations from LAStools: https://groups.google.com/g/lastools/c/I2OVvgOtW0E Keep it mind that point density estimated based on the number of returns / the total area implemented within the LAStools software.  

## With the script the following directories were examined: 

- KMS2007*.shp was extracted based on O:\...\LegacyData\Denmark\Elevation\KMS2007\PointCloud (GPS time were not adjusted so real date cannot be extracted - scan lines are provided) 

- GST2014*.shp was extracted based on O:\...\LegacyData\Denmark\Elevation\GST_2014\Punktsky\laz  

- dir2015_2018*.shp was extracted based on O:\...\B_Read\Denmark\Elevation\LiDAR\2015_2018\laz 

- dir2019*.shp was extracted based on O:\...\B_Read\Denmark\Elevation\LiDAR\2019\laz\ZIPdownload 

- DHM2007*.shp was extracted based on O:\...\DHM2007 

- DHM2015*.shp was extracted based on O:\...\DHM2015 

 

 