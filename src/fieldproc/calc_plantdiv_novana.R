library(sf)
library(tidyverse)
library(vegan)
library(data.table)
library(broom)

# Get species richness of star species

ForRichness <- fread(file="O:/Nat_Ecoinformatics-tmp/au700510/fielddata_process/Novana/alledata-abiotiske.csv", na.strings = "mv") %>% as.data.frame()  %>%
  dplyr::select(site, plot, antalstjernearter, year, UTMx,UTMy,sekhabtype,terhabtype) %>% 
  rename(StarRichness = antalstjernearter)  %>% 
  dplyr::filter(!is.na(StarRichness))

# Filter minimum sampled 4 years and 2006|2007|2014|2015

plots_incertainyears1=ForRichness[(ForRichness$year==2006 | ForRichness$year==2007),]
plotids_cyears=unique(plots_incertainyears1$plot)
ForRichness_filt1=ForRichness %>% filter(
  plot %in% plotids_cyears
)

plots_incertainyears2=ForRichness_filt1[(ForRichness_filt1$year==2014 | ForRichness_filt1$year==2015),]
plotids_cyears2=unique(plots_incertainyears2$plot)

ForRichness_filt1x=ForRichness_filt1 %>% filter(
  plot %in% plotids_cyears2
)

Ns <- ForRichness_filt1x %>% 
  group_by(plot) %>% 
  summarise(n = n()) %>% 
  arrange(n) 
TestIDs <- Ns %>% dplyr::filter(n >= 4) %>% pull(plot)

ForRichness_filt2 <- ForRichness_filt1x %>% 
  dplyr::filter(plot %in% TestIDs) %>% 
  group_split(plot)

# linear fit

Analysis_Name <- ForRichness_filt2 %>% 
  purrr::map(~pull(.x, plot)) %>% 
  reduce(c) %>% 
  unique()

Analysis <-ForRichness_filt2 %>% 
  purrr::map(~lm(StarRichness ~ year, data = .x)) %>% 
  purrr::map(broom::tidy) %>% 
  purrr::map(~dplyr::filter(.x, term == "year")) %>% 
  purrr::map2(Analysis_Name, ~mutate(.x, plot = .y)) %>% 
  reduce(bind_rows)

# Trends

Stable <- Analysis %>% 
  dplyr::filter(p.value >= 0.05) %>% 
  dplyr::mutate(estimate)

Stable$trend <- "Stable"

Upwards <- Analysis %>% 
  dplyr::filter(p.value < 0.05, estimate > 0)

Upwards$trend <- "Upwards"

Downwards <- Analysis %>% 
  dplyr::filter(p.value < 0.05, estimate < 0)

Downwards$trend <- "Downwards"

DiversTrend <- list(Stable, Downwards, Upwards) %>% 
  reduce(bind_rows)

# Put together into vegetation database

DiversTrend_sel=DiversTrend[,c("plot", "trend")]

veg_db <- left_join(ForRichness, DiversTrend_sel, by="plot")
veg_db_c=veg_db[!is.na(veg_db$trend),]

plot_info <-
  ForRichness %>% 
  group_by(plot) %>% 
  filter(row_number()==1)

veg_db_plot <- left_join(plot_info, DiversTrend_sel, by="plot")
veg_db_plot_c=veg_db_plot[!is.na(veg_db_plot$trend),]

# convert 

veg_db_c_coord=veg_db_c[!is.na(veg_db_c$UTMx),]
veg_db_c_sf=st_as_sf(veg_db_c_coord,coords = c("UTMx","UTMy"))
st_crs(veg_db_c_sf) <- 25832
#st_write(veg_db_c_sf, paste("O:/Nat_Ecoinformatics-tmp/au700510/fielddata_process/Novana/output/veg_db_c_sf.shp",sep=""))

veg_db_plot_c_coord=veg_db_plot_c[!is.na(veg_db_plot_c$UTMx),]
veg_db_plot_c_sf=st_as_sf(veg_db_plot_c_coord,coords = c("UTMx","UTMy"))
st_crs(veg_db_plot_c_sf) <- 25832
#st_write(veg_db_plot_c_sf, paste("O:/Nat_Ecoinformatics-tmp/au700510/fielddata_process/Novana/output/veg_db_plot_c_sf.shp",sep=""))

# Visualization

ggplot(veg_db_c, aes(x = year, y = StarRichness)) + geom_path(aes(group= as.factor(plot), color = as.factor(plot))) + geom_point(aes(group= as.factor(plot), color = as.factor(plot))) + 
  theme_bw() + theme(legend.position = "none") + facet_wrap(~trend)

# Make map

Denmark <- readRDS("O:/Nat_Ecoinformatics-tmp/au700510/fielddata_process/DK_Shape.rds")

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = veg_db_plot_c_sf[veg_db_plot_c_sf$trend=="Upwards",], color = "green4")

ggplot()+geom_sf(data = Denmark)+
  geom_sf(data = veg_db_plot_c_sf[veg_db_plot_c_sf$trend=="Downwards",], color = "slateblue4")




