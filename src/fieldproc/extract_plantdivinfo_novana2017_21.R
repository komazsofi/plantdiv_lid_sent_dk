library(sf)
library(tidyverse)

Denmark <- readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/DK_Shape.rds")
novana_17_21=readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Novana_test_2017-2021.rds")

# Convert attributes
novana_17_21$YEAR <- format(novana_17_21$STARTDATO, format="%Y")

print(unique(novana_17_21$YEAR))
print(unique(novana_17_21$NATURTYPE))

novana17=novana_17_21[novana_17_21$YEAR==2017,]

## Histograms 

# Habitat types per year

ggplot(novana_17_21, aes(x = YEAR, fill = NATURTYPE)) +
  geom_histogram(stat="count",position = "dodge")+theme_bw()

## Maps (where these points located - density within grid?)

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = novana_17_21[novana_17_21$YEAR==2017,], aes(color = NATURTYPE),size=2)+theme_bw()

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = novana_17_21[novana_17_21$YEAR==2018,], aes(color = NATURTYPE),size=2)+theme_bw()

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = novana_17_21[novana_17_21$YEAR==2019,], aes(color = NATURTYPE),size=2)+theme_bw()

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = novana_17_21[novana_17_21$YEAR==2020,], aes(color = NATURTYPE),size=2)+theme_bw()

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = novana_17_21[novana_17_21$YEAR==2021,], aes(color = NATURTYPE),size=2)+theme_bw()


