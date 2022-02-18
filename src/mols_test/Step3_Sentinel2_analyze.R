library(tidyverse)
library(reshape2)
library(lubridate)

mols_field_2020=read.csv("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/MolsRewildingArea_polygon/s2_mols_2020_monthlymed_allbands_L2A.csv")

mols_field_NDVI=mols_field_2020[,c(111:116)]

mols_field_NDVI$"20200115" <- (mols_field_2020[,84]-mols_field_2020[,48])/(mols_field_2020[,84]+mols_field_2020[,48])
mols_field_NDVI$"20200215" <- (mols_field_2020[,84+1]-mols_field_2020[,48+1])/(mols_field_2020[,84+1]+mols_field_2020[,48+1])
mols_field_NDVI$"20200315" <- (mols_field_2020[,84+2]-mols_field_2020[,48+2])/(mols_field_2020[,84+2]+mols_field_2020[,48+2])
mols_field_NDVI$"20200415" <- (mols_field_2020[,84+3]-mols_field_2020[,48+3])/(mols_field_2020[,84+3]+mols_field_2020[,48+3])
mols_field_NDVI$"20200515" <- (mols_field_2020[,84+4]-mols_field_2020[,48+4])/(mols_field_2020[,84+4]+mols_field_2020[,48+4])
mols_field_NDVI$"20200615" <- (mols_field_2020[,84+5]-mols_field_2020[,48+5])/(mols_field_2020[,84+5]+mols_field_2020[,48+5])
mols_field_NDVI$"20200715" <- (mols_field_2020[,84+6]-mols_field_2020[,48+6])/(mols_field_2020[,84+6]+mols_field_2020[,48+6])
mols_field_NDVI$"20200815" <- (mols_field_2020[,84+7]-mols_field_2020[,48+7])/(mols_field_2020[,84+7]+mols_field_2020[,48+7])
mols_field_NDVI$"20200915" <- (mols_field_2020[,84+8]-mols_field_2020[,48+8])/(mols_field_2020[,84+8]+mols_field_2020[,48+8])
mols_field_NDVI$"20201015" <- (mols_field_2020[,84+9]-mols_field_2020[,48+9])/(mols_field_2020[,84+9]+mols_field_2020[,48+9])
mols_field_NDVI$"20201115" <- (mols_field_2020[,84+10]-mols_field_2020[,48+10])/(mols_field_2020[,84+10]+mols_field_2020[,48+10])
mols_field_NDVI$"20201215" <- (mols_field_2020[,84+11]-mols_field_2020[,48+11])/(mols_field_2020[,84+11]+mols_field_2020[,48+11])

mols_field_NDVI_sel=mols_field_NDVI[,c(1,7:18)]
mols_field_NDVI_selinfo=colnames(mols_field_NDVI_sel) 

mols_field_NDVI_m=mols_field_NDVI_sel %>% rownames_to_column 
mols_field_NDVI_melted = melt(mols_field_NDVI_m, id.vars = c('AKTID',"rowname"))

mols_field_NDVI_melted$variable=gsub("\\..*","",mols_field_NDVI_melted$variable)
mols_field_NDVI_melted$variable2=as.Date(mols_field_NDVI_melted$variable,"%Y%m%d")
mols_field_NDVI_melted$doy=as.numeric(format(mols_field_NDVI_melted$variable2, format="%j"))

ggplot(mols_field_NDVI_melted, aes(x = doy, y = value))+
  geom_point(aes(color = as.character(AKTID)))+
  geom_line(aes(color = as.character(AKTID)),size=1)+
  theme_bw(base_size = 20)+
  xlab("Day of the year")+
  ylab("NDVI")

mols_field_SWIR=mols_field_2020[,c(111:116)]

mols_field_SWIR$"20200115" <- mols_field_2020[,12]
mols_field_SWIR$"20200215" <- mols_field_2020[,12+1]
mols_field_SWIR$"20200315" <- mols_field_2020[,12+2]
mols_field_SWIR$"20200415" <- mols_field_2020[,12+3]
mols_field_SWIR$"20200515" <- mols_field_2020[,12+4]
mols_field_SWIR$"20200615" <- mols_field_2020[,12+5]
mols_field_SWIR$"20200715" <- mols_field_2020[,12+6]
mols_field_SWIR$"20200815" <- mols_field_2020[,12+7]
mols_field_SWIR$"20200915" <- mols_field_2020[,12+8]
mols_field_SWIR$"20201015" <- mols_field_2020[,12+9]
mols_field_SWIR$"20201115" <- mols_field_2020[,12+10]
mols_field_SWIR$"20201215" <- mols_field_2020[,12+11]

mols_field_SWIR_sel=mols_field_SWIR[,c(1,7:18)]
mols_field_SWIR_selinfo=colnames(mols_field_SWIR_sel) 

mols_field_SWIR_m=mols_field_SWIR_sel %>% rownames_to_column 
mols_field_SWIR_melted = melt(mols_field_SWIR_m, id.vars = c('AKTID',"rowname"))

mols_field_SWIR_melted$variable=gsub("\\..*","",mols_field_SWIR_melted$variable)
mols_field_SWIR_melted$variable2=as.Date(mols_field_SWIR_melted$variable,"%Y%m%d")
mols_field_SWIR_melted$doy=as.numeric(format(mols_field_SWIR_melted$variable2, format="%j"))

ggplot(mols_field_SWIR_melted, aes(x = doy, y = value))+
  geom_point(aes(color = as.character(AKTID)))+
  geom_line(aes(color = as.character(AKTID)),size=1)+
  theme_bw(base_size = 20)+
  xlab("Day of the year")+
  ylab("SWIR")

mols_field_MOI=mols_field_2020[,c(111:116)]

mols_field_MOI$"20200115" <- (mols_field_2020[,93]-mols_field_2020[,12])/(mols_field_2020[,93]+mols_field_2020[,12])
mols_field_MOI$"20200215" <- (mols_field_2020[,93+1]-mols_field_2020[,12+1])/(mols_field_2020[,93+1]+mols_field_2020[,12+1])
mols_field_MOI$"20200315" <- (mols_field_2020[,93+2]-mols_field_2020[,12+2])/(mols_field_2020[,93+2]+mols_field_2020[,12+2])
mols_field_MOI$"20200415" <- (mols_field_2020[,93+3]-mols_field_2020[,12+3])/(mols_field_2020[,93+3]+mols_field_2020[,12+3])
mols_field_MOI$"20200515" <- (mols_field_2020[,93+4]-mols_field_2020[,12+4])/(mols_field_2020[,93+4]+mols_field_2020[,12+4])
mols_field_MOI$"20200615" <- (mols_field_2020[,93+5]-mols_field_2020[,12+5])/(mols_field_2020[,93+5]+mols_field_2020[,12+5])
mols_field_MOI$"20200715" <- (mols_field_2020[,93+6]-mols_field_2020[,12+6])/(mols_field_2020[,93+6]+mols_field_2020[,12+6])
mols_field_MOI$"20200815" <- (mols_field_2020[,93+7]-mols_field_2020[,12+7])/(mols_field_2020[,93+7]+mols_field_2020[,12+7])
mols_field_MOI$"20200915" <- (mols_field_2020[,93+8]-mols_field_2020[,12+8])/(mols_field_2020[,93+8]+mols_field_2020[,12+8])
mols_field_MOI$"20201015" <- (mols_field_2020[,93+9]-mols_field_2020[,12+9])/(mols_field_2020[,93+9]+mols_field_2020[,12+9])
mols_field_MOI$"20201115" <- (mols_field_2020[,93+10]-mols_field_2020[,12+10])/(mols_field_2020[,93+10]+mols_field_2020[,12+10])
mols_field_MOI$"20201215" <- (mols_field_2020[,93+11]-mols_field_2020[,12+11])/(mols_field_2020[,93+11]+mols_field_2020[,12+11])

mols_field_MOI_sel=mols_field_MOI[,c(1,7:18)]
mols_field_MOI_selinfo=colnames(mols_field_MOI_sel) 

mols_field_MOI_m=mols_field_MOI_sel %>% rownames_to_column 
mols_field_MOI_melted = melt(mols_field_MOI_m, id.vars = c('AKTID',"rowname"))

mols_field_MOI_melted$variable=gsub("\\..*","",mols_field_MOI_melted$variable)
mols_field_MOI_melted$variable2=as.Date(mols_field_MOI_melted$variable,"%Y%m%d")
mols_field_MOI_melted$doy=as.numeric(format(mols_field_MOI_melted$variable2, format="%j"))

ggplot(mols_field_MOI_melted, aes(x = doy, y = value))+
  geom_point(aes(color = as.character(AKTID)))+
  geom_line(aes(color = as.character(AKTID)),size=1)+
  theme_bw(base_size = 20)+
  xlab("Day of the year")+
  ylab("Moisture index")