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
beer_states <- read_csv("beer_states.csv")

# map million_barrels to x, state to y, and add bars
beer_states |>
  ggplot(aes(x = million_barrels, y = state)) +
  geom_col()

# arrange states from highest to lowest beer production
beer_states |>
  ggplot(aes(x = million_barrels, y = fct_reorder(state, million_barrels))) +
  geom_col()

# add labels to the x and y axes, and add a title
beer_states |>
  ggplot(aes(x = million_barrels, y = fct_reorder(state, million_barrels))) +
  geom_col() +
  labs(title = "Beer Production by State in 2019",
       x = "Millions of Barrels",
       y = NULL)


# 2. Brewers across the size distribution ----
# the second dataset we'll use summarizes the number of brewers and total beer production by year and brewer size category

# import data
brewer_size <- read_csv("brewer_size.csv")

# for 2019 only: map brewer_size to x, n_of_brewers to y, and add bars
brewer_size |>
  filter(year == 2019) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = n_of_brewers)) +
  geom_col() +
  labs(x = "Size of Brewers",
       y = "Number of Brewers")

# for 2019 only: now map total_barrels to y instead of n_of_brewers
brewer_size |>
  filter(year == 2019) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels)) +
  geom_col() +
  labs(x = "Size of Brewers",
       y = "Total Barrels Produced")

# make a grouped bar chart, mapping: size to x, total_barrels to y, and year to fill
# use the years 2009, 2015, and 2019 for the rest of this example
brewer_size |>
  filter(year %in% c(2009, 2015, 2019)) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels, fill = year)) +
  geom_col(position = "dodge") +
  labs(x = "Size of Brewers",
       y = "Total Barrels Produced",
       fill = NULL)

# what happened? see if you can figure out how to get bars side by side
brewer_size |>
  filter(year %in% c(2009, 2015, 2019)) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels, fill = as_factor(year))) +
  geom_col(position = "dodge") +
  labs(x = "Size of Brewers",
       y = "Total Barrels Produced",
       fill = NULL)

# make the same plot, but reverse the mappings for size and year
brewer_size |>
  filter(year %in% c(2009, 2015, 2019)) |>
  ggplot(aes(x = as_factor(year), y = total_barrels, fill = fct_reorder(brewer_size, numeric_size))) +
  geom_col(position = "dodge") +
  labs(x = "Size of Brewers",
       y = "Total Barrels Produced",
       fill = NULL)

# now see what happens if you use position = "stack" instead of position = "dodge"?
brewer_size |>
  filter(year %in% c(2009, 2015, 2019)) |>
  ggplot(aes(x = as_factor(year), y = total_barrels, fill = fct_reorder(brewer_size, numeric_size))) +
  geom_col(position = "stack") +
  labs(x = "Size of Brewers",
       y = "Total Barrels Produced",
       fill = NULL)

