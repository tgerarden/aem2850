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
  labs(
    title = "Beer Production by State in 2019",
    x = "Millions of Barrels",
    y = NULL
  )


# 2. Brewers across the size distribution ----
# the second dataset we'll use summarizes the number of brewers and total beer production by year and brewer size category

# import data
brewer_size <- read_csv("brewer_size.csv")

# for 2019 only: map brewer_size to x, n_of_brewers to y, and add bars
brewer_size |>
  filter(year == 2019) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = n_of_brewers)) +
  geom_col() +
  labs(
    x = "Size of Brewers",
    y = "Number of Brewers"
  )

# for 2019 only: now map total_barrels to y instead of n_of_brewers
brewer_size |>
  filter(year == 2019) |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels)) +
  geom_col() +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced"
  )


# 3. Brewer size in higher dimensions ----
# let's extend our visualizations to capture changes in brewer sizes over time
# two good ways to do this are using grouped bar charts and facets

# start by filtering the data in brewer_size to the years 2009, 2014, and 2019
brewer_size_over_time <- brewer_size |>
  filter(year %in% c(2009, 2014, 2019))

# make a grouped bar chart, mapping: size to x, total_barrels to y, and year to fill
brewer_size_over_time |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels, fill = year)) +
  geom_col(position = "dodge") +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced",
    fill = "Year"
  )

# what happened? see if you can figure out how to get bars side by side
brewer_size_over_time |>
  ggplot(aes(x = fct_reorder(brewer_size, numeric_size), y = total_barrels, fill = as_factor(year))) +
  geom_col(position = "dodge") +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced",
    fill = NULL
  )

# make the same plot, but reverse the mappings for size and year
brewer_size_over_time |>
  ggplot(aes(x = as_factor(year), y = total_barrels, fill = fct_reorder(brewer_size, numeric_size))) +
  geom_col(position = "dodge") +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced",
    fill = NULL
  )

# now see what happens if you use position = "stack" instead of position = "dodge"?
brewer_size_over_time |>
  ggplot(aes(x = as_factor(year), y = total_barrels, fill = fct_reorder(brewer_size, numeric_size))) +
  geom_col(position = "stack") +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced",
    fill = NULL
  )

# another option for higher dimensional data is to use facets
# make a plot of total_barrels vs year, and facet by brewer_size
# omit the fill mapping this time
# see if you can order the facets by brewer size
brewer_size_over_time |>
  mutate(size = fct_reorder(brewer_size, numeric_size)) |>
  ggplot(aes(x = as_factor(year), y = total_barrels)) +
  geom_col() +
  facet_wrap(vars(size))+
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced",
    fill = NULL
  )


# 4. Revisiting brewer sizes in 2019 ----
# let's work directly with average brewer sizes instead of using categories
# using categories are often better for bar plots like these
# but using numeric values will give a sense of the categories' true sizes

# filter brewer_size for the year 2019 and add a variable avg_size
# assign the result to brewer_size_2019
brewer_size_2019 <- brewer_size |>
  filter(year == 2019) |>
  mutate(avg_size = total_barrels / n_of_brewers)

# use brewer_size_2019 to plot total barrels vs avg_size using geom_col()
# you might want to use a different, more descriptive label for x than above
brewer_size_2019 |>
  ggplot(aes(x = avg_size, y = total_barrels)) +
  geom_col() +
  labs(
    x = "Average Brewer Production",
    y = "Total Barrels Produced"
  )

# what do you notice about this plot? i notice:
# 1. there is a big difference between small, medium, and large brewers!
# 2. the relationship between numeric_size and total_barrels seems non-linear

# apply a log transform of the x axis of your plot using `+ scale_x_log10()`
brewer_size_2019 |>
  ggplot(aes(x = avg_size, y = total_barrels)) +
  geom_col() +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced"
  ) +
  scale_x_log10()

# now make a plot that applies the log transform to both x and y
brewer_size_2019 |>
  ggplot(aes(x = avg_size, y = total_barrels)) +
  geom_col() +
  labs(
    x = "Size of Brewers",
    y = "Total Barrels Produced"
  ) +
  scale_x_log10() +
  scale_y_log10()

# finally, modify the plot so the axis labels are in millions
# an easy way to do this is by dividing the variables directly inside aes()
brewer_size_2019 |>
  ggplot(aes(x = avg_size / 1e3, y = total_barrels / 1e6)) +
  geom_col() +
  labs(
    x = "Size of Brewers (thousands)",
    y = "Total Barrels Produced (millions)"
  ) +
  scale_x_log10() +
  scale_y_log10()
