library(ggplot2)

novana_17_21=readRDS("O:/Nat_Ecoinformatics-tmp/au700510_2022_1/fielddata/Novana2/Novana_test_2017-2021.rds")
novana_17_21$YEAR <- format(novana_17_21$STARTDATO, format="%Y")

print(unique(novana_17_21$YEAR))
print(unique(novana_17_21$NATURTYPE))

## histograms 

# habitat types per year

ggplot(novana_17_21, aes(x = YEAR, fill = NATURTYPE)) +
  geom_histogram(stat="count",position = "dodge")

## maps (where these points located - density within grid?)
