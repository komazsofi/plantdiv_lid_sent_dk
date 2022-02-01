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
  geom_sf(aes(color=PROGRAM))+
  facet_wrap(facets = vars(Year2))+
  theme_bw()

## NOVANA extraction 3 (Dataset2005_2021)

nov_extr3=read_sf("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Dataset2005_2021_v2.shp")
nov_extr3$Year2 <- format(nov_extr3$STARTDA, format="%Y")

ggplot(nov_extr3, aes(x = Year2, fill = NATURTY)) +
  geom_histogram(stat="count",position = "dodge",show.legend = FALSE)+theme_bw()

ggplot(data = nov_extr3)+
  geom_sf(aes(color=PROGRAM))+
  facet_wrap(facets = vars(Year2))+
  theme_bw()

# Filter for year 2016-2020

nov_extr3_sel=nov_extr3[(nov_extr3$Year2>2015 & nov_extr3$Year2<2021),]

nov_extr3_overg=nov_extr3_sel[nov_extr3_sel$PROGRAM=="Overvågning af naturtyper",]
nov_extr3_bes=nov_extr3_sel[nov_extr3_sel$PROGRAM=="Besigtigelser",]
nov_extr3_kort=nov_extr3_sel[nov_extr3_sel$PROGRAM=="Kortlægning af naturtyper",]

nov_extr3_overg$HabitatCode=NA

nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Klithede']="2140"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Revling-indlandsklit']="2320"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Rigkær']="7230"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Havtornklit']="2160"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Græs-indlandsklit']="2330"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Kystklint/klippe']="1230"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Enekrat']="5130"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Højmose']="7110"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Hvid klit']="2120"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Klitlavning']="2190"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Visse-indlandsklit']="2310"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Enårig strandengsvegetation']="1310"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Enebærklit']="2250"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Strandvold med enårige']="1210"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Vadegræssamfund']="1320"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Kildevæld']="7220"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Grå/grøn klit']="2130"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Surt overdrev']="6230"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Tør hede']="4030"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Grårisklit']="2170"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Indlandsklippe']="8220"
nov_extr3_overg$HabitatCode[nov_extr3_overg$NATURTY=='Indlandssalteng']="1340"

nov_extr3_overg$HabitatCodeGroup=NA

nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "1210" | nov_extr3_overg$HabitatCode == "1220" | nov_extr3_overg$HabitatCode == "1230" | nov_extr3_overg$HabitatCode == "1310"
                                 | nov_extr3_overg$HabitatCode == "1320" | nov_extr3_overg$HabitatCode == "1330" | nov_extr3_overg$HabitatCode == "1340" ]="Beaches and salt marshes"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "2110" | nov_extr3_overg$HabitatCode == "2120" | nov_extr3_overg$HabitatCode == "2130" | nov_extr3_overg$HabitatCode == "2140"
                                 | nov_extr3_overg$HabitatCode == "2160" | nov_extr3_overg$HabitatCode == "2170" | nov_extr3_overg$HabitatCode == "2190" | nov_extr3_overg$HabitatCode == "2250" ]="Coastal dunes"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "2310" | nov_extr3_overg$HabitatCode == "2320" | nov_extr3_overg$HabitatCode == "2330" | nov_extr3_overg$HabitatCode == "4010"
                                 | nov_extr3_overg$HabitatCode == "4030" | nov_extr3_overg$HabitatCode == "5130" ]="Inland dunes, heath and scrub"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "6120" | nov_extr3_overg$HabitatCode == "6210" | nov_extr3_overg$HabitatCode == "6230" | nov_extr3_overg$HabitatCode == "6410" ]="Over grazing and meadows"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "7110" | nov_extr3_overg$HabitatCode == "7120" | nov_extr3_overg$HabitatCode == "7140" | nov_extr3_overg$HabitatCode == "7150"
                                 | nov_extr3_overg$HabitatCode == "7210" | nov_extr3_overg$HabitatCode == "7220"  | nov_extr3_overg$HabitatCode == "7230" ]="Bog"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "8220" ]="Mower"
nov_extr3_overg$HabitatCodeGroup[nov_extr3_overg$HabitatCode == "2180" | nov_extr3_overg$HabitatCode == "9110" | nov_extr3_overg$HabitatCode == "9120" | nov_extr3_overg$HabitatCode == "9130"
                                 | nov_extr3_overg$HabitatCode == "9150" | nov_extr3_overg$HabitatCode == "9160" | nov_extr3_overg$HabitatCode == "9170" | nov_extr3_overg$HabitatCode == "9190"]="Forest"


# Analysis

ranked_natty_overg=nov_extr3_overg %>% 
  group_by(nov_extr3_overg$HabitatCode) %>%
  summarize(Count=n()) %>%
  mutate(Percent = round((Count/sum(Count)*100))) %>%
  arrange(desc(Count))

ranked_natty_kort=nov_extr3_kort %>% 
  group_by(nov_extr3_kort$HabitatCodeGroup,nov_extr3_kort$Year2) %>%
  summarize(Count=n()) %>%
  mutate(Percent = round((Count/sum(Count)*100))) %>%
  arrange(desc(Count))

ranked_natty_kort=nov_extr3_kort %>% 
  group_by(nov_extr3_kort$NATURTY) %>%
  summarize(Count=n()) %>%
  mutate(Percent = round((Count/sum(Count)*100))) %>%
  arrange(desc(Count))

# Export

nov_extr2_2018=nov_extr2[(nov_extr2$Year2==2016),]
st_write(nov_extr2_2018,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2016.shp")
nov_extr2_2018=nov_extr2[(nov_extr2$Year2==2017),]
st_write(nov_extr2_2018,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2017.shp")
nov_extr2_2018=nov_extr2[(nov_extr2$Year2==2018),]
st_write(nov_extr2_2018,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2018.shp")
nov_extr2_2018=nov_extr2[(nov_extr2$Year2==2019),]
st_write(nov_extr2_2018,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2019.shp")
nov_extr2_2018=nov_extr2[(nov_extr2$Year2==2020),]
st_write(nov_extr2_2018,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_2020.shp")

