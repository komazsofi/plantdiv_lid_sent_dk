library(sf)
library(tidyverse)

# Import

nov_extr3=read_sf("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Dataset2005_2021_v2.shp")
nov_extr3$Year2 <- format(nov_extr3$STARTDA, format="%Y")

nov_extr3_sel=nov_extr3[(nov_extr3$Year2>2015 & nov_extr3$Year2<2021),]

# Make groups

##

nov_extr3_sel_naturedry_meadows <- nov_extr3_sel %>% filter(NATURTY %in% c("Tør overdrev på kalkholdigt sand",
                                                                     "Kalkoverdrev",
                                                                     "Surt overdrev",
                                                                     "Overdrev",
                                                                     "Overdrev; - surt overdrev",
                                                                     "Overdrev;Surt overdrev; - surt overdrev",
                                                                     "Surt overdrev; - surt overdrev;Overdrev",
                                                                     "Overdrev; - surt overdrev;Surt overdrev",
                                                                     "Overdrev; - surt overdrev; - kalkoverdrev"))

# Analysis

ggplot(nov_extr3_sel_naturedry_meadows, aes(x = Year2, y = N_Specs)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturedry_meadows, aes(x = Year2, y = N_Str_S)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturedry_meadows, aes(x = Year2, y = N_2_S_S)) +
  geom_boxplot()+theme_bw()

nov_extr3_sel_naturedry_meadows %>% 
  group_by(nov_extr3_sel_naturedry_meadows$Year) %>%
  summarize(Count=n())

##

nov_extr3_sel_naturedry_inlanddune <- nov_extr3_sel %>% filter(NATURTY %in% c("Enekrat",
                                                                              "Tør hede",
                                                                              "Græs-indlandsklit",
                                                                              "Græs-indlandsklit;Hede",
                                                                              "Revling-indlandsklit",
                                                                              "Visse-indlandsklit",
                                                                              "- tør hede;Hede",
                                                                              "Hede",
                                                                              "Hede; - hedekrat",
                                                                              "Hede; - tør hede; - hedekrat"))

# Analysis

ggplot(nov_extr3_sel_naturedry_inlanddune, aes(x = Year2, y = N_Specs)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturedry_inlanddune, aes(x = Year2, y = N_Str_S)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturedry_inlanddune, aes(x = Year2, y = N_2_S_S)) +
  geom_boxplot()+theme_bw()

nov_extr3_sel_naturedry_inlanddune %>% 
  group_by(nov_extr3_sel_naturedry_inlanddune$Year) %>%
  summarize(Count=n())

##

nov_extr3_sel_naturewet_bog <- nov_extr3_sel %>% filter(NATURTY %in% c("Højmose",
                                                                       "Nedbrudt højmose",
                                                                       "Hængesæk",
                                                                       "Hængesæk; - hængesæk;Mose og Kær",
                                                                       "Tørvelavning",
                                                                       "Avneknippemose",
                                                                       "Kildevæld",
                                                                       "Rigkær",
                                                                       "- fugtig krat; - hængesæk;Mose og Kær",
                                                                       "- fugtig krat; - højstaude-/rørsump; - hængesæk;Mose og Kær",
                                                                       "- fugtig krat; - højstaude-/rørsump;Mose og Kær",
                                                                       "- fugtig krat;Mose og Kær",
                                                                       "- hængesæk; - fugtig krat;Mose og Kær",
                                                                       "- hængesæk; - højmose;Mose og Kær",
                                                                       "- hængesæk;Mose og Kær",
                                                                       "- højstaude-/rørsump; - fugtig krat;Mose og Kær",
                                                                       "- højstaude-/rørsump; - hængesæk;Mose og Kær",
                                                                       "- højstaude-/rørsump;Mose og Kær"))

# Analysis

ggplot(nov_extr3_sel_naturewet_bog, aes(x = Year2, y = N_Specs)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturewet_bog, aes(x = Year2, y = N_Str_S)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturewet_bog, aes(x = Year2, y = N_2_S_S)) +
  geom_boxplot()+theme_bw()

nov_extr3_sel_naturewet_bog %>% 
  group_by(nov_extr3_sel_naturewet_bog$Year) %>%
  summarize(Count=n())

##

nov_extr3_sel_naturewet_meadow <- nov_extr3_sel %>% filter(NATURTY %in% c("Tidvis våd eng",
                                                                          "Våd hede"))

# Analysis

ggplot(nov_extr3_sel_naturewet_meadow, aes(x = Year2, y = N_Specs)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturewet_meadow, aes(x = Year2, y = N_Str_S)) +
  geom_boxplot()+theme_bw()

ggplot(nov_extr3_sel_naturewet_meadow, aes(x = Year2, y = N_2_S_S)) +
  geom_boxplot()+theme_bw()

nov_extr3_sel_naturewet_meadow %>% 
  group_by(nov_extr3_sel_naturewet_meadow$Year) %>%
  summarize(Count=n())

# Export

st_write(nov_extr3_sel_naturedry_meadows,"O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/nov_extr3_sel_naturedry_meadows.shp")