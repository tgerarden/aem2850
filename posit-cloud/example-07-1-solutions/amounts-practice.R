# AEM 2850 - Example 7-1
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
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
  labs(
    title = "______",
    x = "______",
    y = "______"
  )


# 2. Brewers across the size distribution ----
# the second dataset we'll use summarizes the number of brewers and total beer production by year and brewer size category

# import data
brewer_size <- read_csv("brewer_size.csv")

# for 2019 only: map brewer_size to x, n_of_brewers to y, and add bars
brewer_size |>
  filter(year == ______) |>
  ggplot(______(x = fct_reorder(______, numeric_size), y = ______)) +
  ______() +
  labs(
    x = "______",
    y = "______"
  )

# for 2019 only: now map total_barrels to y instead of n_of_brewers
brewer_size |>
  filter(year == ______) |>
  ______(aes(x = ______(______, numeric_size), y = ______)) +
  ______() +
  labs(
    x = "______",
    y = "______"
  )


# 3. Brewer size in higher dimensions ----
# let's extend our visualizations to capture changes in brewer sizes over time
# two good ways to do this are using grouped bar charts and facets

# start by filtering the data in brewer_size to the years 2009, 2014, and 2019
brewer_size_over_time <- brewer_size |>
  filter(______ %in% c(______, ______, ______))

# make a grouped bar chart, mapping: size to x, total_barrels to y, and year to fill
brewer_size_over_time |>
  ggplot(aes(x = fct_reorder(______, numeric_size), y = ______, ______ = ______)) +
  geom_col(position = "dodge") +
  ______(
    x = "______",
    y = "______",
    fill = "______"
  )

# what happened? see if you can figure out how to get bars side by side
brewer_size_over_time |>
  ______(______(x = fct_reorder(______, numeric_size), y = ______, ______ = ______(______))) +
  ______(position = "dodge") +
  ______(
    x = "______",
    y = "______",
    fill = "______"
  )

# make the same plot, but reverse the mappings for size and year
brewer_size_over_time |>
  ggplot(______(x = ______, y = ______, fill = ______)) +
  ______(______ = "dodge") +
  labs(
    x = "______",
    y = "______",
    fill = "______"
  )

# now see what happens if you use position = "stack" instead of position = "dodge"?
brewer_size_over_time |>
  ggplot(______(x = ______, y = ______, fill = ______)) +
  geom_col(position = "stack") +
  ______(
    x = "______",
    y = "______",
    fill = "______"
  )

# another option for higher dimensional data is to use facets
# make a plot of total_barrels vs year, and facet by brewer_size
# omit the fill mapping this time
# see if you can order the facets by brewer size
______


# 4. Revisiting brewer sizes in 2019 ----
# let's work directly with average brewer sizes instead of using categories
# using categories are often better for bar plots like these
# but using numeric values will give a sense of the categories' true sizes

# filter brewer_size for the year 2019 and add a variable avg_size
# assign the result to brewer_size_2019
______

# use brewer_size_2019 to plot total barrels vs avg_size using geom_col()
# you might want to use a different, more descriptive label for x than above
______

# what do you notice about this plot? i notice:
# 1. there is a big difference between small, medium, and large brewers!
# 2. the relationship between numeric_size and total_barrels seems non-linear

# apply a log transform of the x axis of your plot using `+ scale_x_log10()`
______

# now make a plot that applies the log transform to both x and y
______

# finally, modify the plot so the axis labels are in millions
# an easy way to do this is by dividing the variables directly inside aes()
______
