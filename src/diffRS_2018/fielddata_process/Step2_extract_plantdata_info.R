library(sf)
library(tidyverse)

# Import

novana <- readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS/fielddata/Dataset2005_2021.rds")

novana_2018=novana[novana$Year==2018,]
print(unique(novana_2018$NATURTYPE))

lidar_measure = st_read("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS_v2/2018/lidar2018_disolv.shp") # need to wite  ascript which makes the disoslve shp

# intersect

novana_2018_withinlidar <- st_intersection(novana_2018, lidar_measure)
print(unique(novana_2018_withinlidar$NATURTYPE))

novana_2018_withinlidar_cnattype=novana_2018_withinlidar %>% 
  group_by(novana_2018_withinlidar$NATURTYPE) %>%
  summarize(Count=n())

# make new grouped nature type classes

novana_2018_withinlidar$Nature_Group=NA

novana_2018_withinlidar$Nature_Group[novana_2018_withinlidar$NATURTYPE=='Grå/grøn klit' | novana_2018_withinlidar$NATURTYPE=='Hvid klit'
                                     | novana_2018_withinlidar$NATURTYPE=='Forklit' | novana_2018_withinlidar$NATURTYPE=='Kalkoverdrev'
                                     | novana_2018_withinlidar$NATURTYPE=='Surt overdrev' | novana_2018_withinlidar$NATURTYPE=='Kystklint/klippe'
                                     | novana_2018_withinlidar$NATURTYPE=='Tør overdrev på kalkholdigt sand' | novana_2018_withinlidar$NATURTYPE=='Klithede'
                                     | novana_2018_withinlidar$NATURTYPE=='Enekrat' | novana_2018_withinlidar$NATURTYPE=='Tør hede']="Nature dry"

novana_2018_withinlidar$Nature_Group[novana_2018_withinlidar$NATURTYPE=='Strandeng' | novana_2018_withinlidar$NATURTYPE=='Enårig strandengsvegetation'
                                     | novana_2018_withinlidar$NATURTYPE=='Strandvold med flerårige' | novana_2018_withinlidar$NATURTYPE=='Strandvold med enårige'
                                     | novana_2018_withinlidar$NATURTYPE=='Højmose' | novana_2018_withinlidar$NATURTYPE=='Nedbrudt højmose'
                                     | novana_2018_withinlidar$NATURTYPE=='Rigkær' | novana_2018_withinlidar$NATURTYPE=='Klint og stenstrand'
                                     | novana_2018_withinlidar$NATURTYPE=='Hængesæk' | novana_2018_withinlidar$NATURTYPE=='Kildevæld'
                                     | novana_2018_withinlidar$NATURTYPE=='Tidvis våd eng' | novana_2018_withinlidar$NATURTYPE=='Vadegræssamfund'
                                     | novana_2018_withinlidar$NATURTYPE=='Avneknippemose' | novana_2018_withinlidar$NATURTYPE=='Våd hede'
                                     | novana_2018_withinlidar$NATURTYPE=='Tørvelavning']="Nature wet"

novana_2018_withinlidar$Nature_Group[novana_2018_withinlidar$NATURTYPE=='Skovbevokset tørvemose' | novana_2018_withinlidar$NATURTYPE=='Elle- og askeskov'
                                     | novana_2018_withinlidar$NATURTYPE=='Bøg på mor med kristtorn' | novana_2018_withinlidar$NATURTYPE=='Bøg på muld'
                                     | novana_2018_withinlidar$NATURTYPE=='Ege-blandskov' | novana_2018_withinlidar$NATURTYPE=='Skovklit'
                                     | novana_2018_withinlidar$NATURTYPE=='Bøg på mor' | novana_2018_withinlidar$NATURTYPE=='Stilkege-krat']="Forest"

novana_2018_withinlidar_natgroup=novana_2018_withinlidar %>% 
  group_by(novana_2018_withinlidar$Nature_Group) %>%
  summarize(Count=n())

novana_2018_withinlidar_natgroup2=novana_2018_withinlidar %>% 
  group_by(novana_2018_withinlidar$Nature_Group,novana_2018_withinlidar$NATURTYPE) %>%
  summarize(Count=n())

names(novana_2018_withinlidar_natgroup2)<-c("Nature_Group","Natur type","Count","geometry")

ggplot(novana_2018_withinlidar_natgroup2[novana_2018_withinlidar_natgroup2$Nature_Group=="Forest",], aes(x="", y=Count, fill=`Natur type`),size=3) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void(base_size = 25)

# export

st_write(novana_2018_withinlidar,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/_DiffRS_v2/2018/novana_2018_withinlidar.shp")