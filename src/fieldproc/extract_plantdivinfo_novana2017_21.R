library(sf)
library(tidyverse)

Denmark <- readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/DK_Shape.rds")

## NOVANA extraction 1 (novana_2017_2021)
novana_17_21=readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Novana_test_2017-2021.rds")

# Convert attributes
novana_17_21$YEAR <- format(novana_17_21$STARTDATO, format="%Y")

print(unique(novana_17_21$YEAR))
print(unique(novana_17_21$NATURTYPE))

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

## NOVANA extraction 2 (Dataset2005_2021)

nov_extr2=read_sf("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Dataset2005_2021.shp")

nov_extr2$Year2 <- format(nov_extr2$STARTDA, format="%Y")

# Visualization

ggplot(nov_extr2, aes(x = Year2, fill = PROGRAM)) +
  geom_histogram(stat="count",position = "dodge")+theme_bw()

ggplot(data = nov_extr2)+
  geom_sf()+
  facet_wrap(facets = vars(Year2))+
  theme_bw()
