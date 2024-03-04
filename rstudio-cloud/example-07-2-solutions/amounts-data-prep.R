# AEM 2850 - Example 7 part 2
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore beer statistics from the Alcohol and Tobacco Tax and Trade Bureau (TTB)
# intermediate source: https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-03-31/readme.md
# i have done a little pre-processing for your convenience


# 1. Brewers across the United States ----
# the first dataset we'll use summarizes total beer production by state in 2019

# prep data
beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv') %>%
  filter(year == 2019 & state!="total" & !is.na(barrels)) %>%
  group_by(state, year) %>%
  summarize(million_barrels = sum(barrels)/1e6) %>%
  ungroup()
write_csv(beer_states, "beer_states.csv")



# 2. Brewers across the size distribution ----
# the second dataset we'll use summarizes the number of brewers and total beer production by year and brewer size category

# prep data
brewer_size <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewer_size.csv') %>%
  filter(brewer_size != "Zero Barrels") %>%
  filter(brewer_size != "Total" & brewer_size != "Under 1 Barrel") %>%
  mutate(min_size = brewer_size) %>%
  separate(min_size, into = c("min_size", "max_size"), sep = " ", extra = "merge") %>%
  mutate(min_size = parse_number(min_size),
         numeric_size = ifelse(min_size < 100000, 1,
                              ifelse(min_size < 1000000, 100000,
                                     1000000)),
         brewer_size = ifelse(numeric_size == 1, "1 to 100,000 Barrels",
                              ifelse(numeric_size == 100000, "100,001 to 1,000,000 Barrels",
                                     "1,000,001 Barrels and Over"))) %>%
  select(-min_size, -max_size) %>%
  group_by(brewer_size, numeric_size, year) %>%
  summarize_all(sum)
write_csv(brewer_size, "brewer_size.csv")

