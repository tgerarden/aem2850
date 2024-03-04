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

# import data
beer_states <- ______("beer_states.csv")

# map million_barrels to x, state to y, and add bars
beer_states |>
  ggplot(aes(x = ______, y = ______)) +
  geom_col()

# arrange states from highest to lowest beer production
beer_states |>
  ______(______(x = ______, y = fct_reorder(______, million_barrels))) +
  geom_col()

# add labels to the x and y axes, and add a title
beer_states |>
  ______(______(x = ______, y = fct_reorder(______, ______))) +
  ______() +
  labs(title = "______",
       x = "______",
       y = "______")


# 2. Brewers across the size distribution ----
# the second dataset we'll use summarizes the number of brewers and total beer production by year and brewer size category

# import data
brewer_size <- read_csv("brewer_size.csv")

# for 2019 only: map brewer_size to x, n_of_brewers to y, and add bars
brewer_size |>
  filter(year == ______) |>
  ggplot(______(x = fct_reorder(______, numeric_size), y = ______)) +
  ______() +
  labs(x = "______",
       y = "______")

# for 2019 only: now map total_barrels to y instead of n_of_brewers
brewer_size |>
  filter(year == ______) |>
  ______(aes(x = ______(______, numeric_size), y = ______)) +
  ______() +
  labs(x = "______",
       y = "______")


# make a grouped bar chart, mapping: size to x, total_barrels to y, and year to fill
# use the years 2009, 2015, and 2019 for the rest of this example
brewer_size |>
  filter(year %in% c(______, ______, ______)) |>
  ggplot(aes(x = fct_reorder(______, numeric_size), y = ______, ______ = ______)) +
  geom_col(position = "dodge") +
  ______(x = "______",
       y = "______",
       fill = "______")

# what happened? see if you can figure out how to get bars side by side
brewer_size |>
  filter(year ______ c(______, ______, ______)) |>
  ______(______(x = fct_reorder(______, numeric_size), y = ______, ______ = ______(______))) +
  ______(position = "dodge") +
  ______(x = "______",
       y = "______",
       fill = "______")

# make the same plot, but reverse the mappings for size and year
brewer_size |>
  filter(______) |>
  ggplot(______(x = ______, y = ______, fill = ______)) +
  ______(______ = "dodge") +
  labs(x = "______",
       y = "______",
       fill = "______")

# now see what happens if you use position = "stack" instead of position = "dodge"?
brewer_size |>
  filter(______) |>
  ggplot(______(x = ______, y = ______, fill = ______)) +
  geom_col(position = "stack") +
  ______(x = "______",
       y = "______",
       fill = "______")
