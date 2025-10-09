# AEM 2850 - Example 7-2
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

# today we'll explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, an activist project: http://insideairbnb.com


# 1. Import airbnb listings ----
# import data and assign them to all_listings
all_listings <- read_csv("listings.csv")


# 2 Proportions ----
# how are the listings distributed across boroughs? (neighbourhood_group)
# which borough has the most? which borough has the least?

# 2.1 Side-by-side bars
# visualize the number of all_listings in each neighbourhood_group
# using side-by-side bars (via geom_col)
all_listings |>
  count(neighbourhood_group) |>
  ggplot(aes(x = neighbourhood_group, y = n)) +
  geom_col()

# alternatively, this can be done using geom_bar()
# reminder: geom_bar() counts and plots frequencies automatically
all_listings |>
  ggplot(aes(x = neighbourhood_group)) +
  geom_bar()

# modify your geom_bar() code using fct_infreq() to order the bars by
# the frequency with which each neighbourhood_group appears in the data
all_listings |>
  ggplot(aes(x = fct_infreq(neighbourhood_group))) +
  geom_bar()

# now add descriptive axis labels using labs()
all_listings |>
  ggplot(aes(x = fct_infreq(neighbourhood_group))) +
  geom_bar() +
  labs(
    x = NULL,
    y = "Number of listings",
    title = "Airbnb listings by Borough in New York City"
  )

# nice work!
# but what if we want to label the y-axis with proportions?
# go back to your original code using geom_col()
# modify it to plot shares, not counts
all_listings |>
  count(neighbourhood_group) |>
  mutate(share = n / sum(n)) |>
  ggplot(aes(x = fct_reorder(neighbourhood_group, -share), y = share)) +
  geom_col()


# 2.2 Stacked bars
# visualize the proportion of all_listings in each neighbourhood_group
# using stacked bars (via geom_col)
# map the share to x, a dummy value to y, and neighbourhood_group to fill
all_listings |>
  count(neighbourhood_group) |>
  mutate(share = n / sum(n)) |>
  ggplot(aes(x = share, y = "", fill = neighbourhood_group)) +
  geom_col()

# alternatively, this can be done using geom_bar(position = "fill")
all_listings |>
  ggplot(aes(y = "", fill = neighbourhood_group)) +
  geom_bar(position = "fill")

# modify your geom_bar() code using fct_infreq() to order the bars by
# the frequency with which each neighbourhood_group appears in the data
# add an axis label that is more accurate that the default "count"
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  labs(x = "share")

# here is a more polished version for your reference
# you can play around with commenting out lines to see how layers change
all_listings |>
  ggplot(aes(y = "", fill = fct_rev(fct_infreq(neighbourhood_group)))) +
  geom_bar(position = "fill") +
  guides(fill = guide_legend(reverse = TRUE)) +
  scale_y_discrete(breaks = NULL) +
  scale_x_continuous(breaks = seq(0, 1, .1)) +
  scale_fill_viridis_d(direction = -1) +
  theme(legend.position = "bottom") +
  labs(
    title = "Airbnb listings across the boroughs of NYC: parts of the whole",
    x = "share",
    y = NULL,
    fill = NULL
  )


# 2.3 Pie charts
# visualize the proportion of all_listings in each neighbourhood_group
# using a pie chart (via geom_bar)
# you can do this by adding `coord_polar()` to the earlier stacked bars
all_listings |>
  ggplot(aes(y = "", fill = neighbourhood_group)) +
  geom_bar(position = "fill") +
  coord_polar()

# modify your code to arrange the slices in order of their proportion
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  coord_polar()

# add scale_x_continuous(breaks = NULL) to remove the axis ticks
# add scale_y_discrete(breaks = NULL) to remove the (invisible) axis ticks
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_x_continuous(breaks = NULL) +
  scale_y_discrete(breaks = NULL)

# add scale_fill_viridis_d() to use perceptually uniform fill colors
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_x_continuous(breaks = NULL) +
  scale_y_discrete(breaks = NULL) +
  scale_fill_viridis_d()

# add labs() to improve its appearance
# hint: you can use NULL values for most aesthetics here
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_x_continuous(breaks = NULL) +
  scale_y_discrete(breaks = NULL) +
  scale_fill_viridis_d() +
  labs(
    title = "Airbnb listings across the boroughs of NYC: slices of the pie",
    x = NULL,
    y = NULL,
    fill = NULL
  )

# add theme(panel.grid = element_blank()) to remove the circle around the pie
all_listings |>
  ggplot(aes(y = "", fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  coord_polar() +
  scale_x_continuous(breaks = NULL) +
  scale_y_discrete(breaks = NULL) +
  scale_fill_viridis_d() +
  labs(
    title = "Airbnb listings across the boroughs of NYC: slices of the pie",
    x = NULL,
    y = NULL,
    fill = NULL
  ) +
  theme(panel.grid = element_blank())


# 3. Stacked bars revisited ----
# stacked bars can be very effective when comparing proportions
# along another dimension (e.g., across groups or over time)

# use geom_bar() to make a stacked bar chart of neighbourhood_group
# this time, map room_type to y rather than using a dummy value ""
all_listings |>
  ggplot(aes(y = room_type, fill = fct_infreq(neighbourhood_group))) +
  geom_bar(position = "fill") +
  labs(x = "share")

# this highlights similarities/differences in the composition of groups
# "Hotel room" is a stark example: that group is not like the other groups

# on the other hand, this obscures differences in the size of groups
# to see this, modify your geom_bar() code above to plot counts not shares
all_listings |>
  ggplot(aes(y = room_type, fill = fct_infreq(neighbourhood_group))) +
  geom_bar()

# these two visualizations are based on the same data,
# but they are not equally good at what they do
# which one is better depends on the message you want to communicate


# 4. Colors in ggplot2 ----
# in the slides we saw some examples of using color, fill, etc.
#   as **parameters** rather than **aesthetics**
# how do we know what colors R will understand? (e.g., "skyblue")
# here is a quick primer on the options that are available to you by default
# you can use RBG codes to customize colors with nearly limitless possibilities

# reference: to learn more about color related aesthetic (color, fill, alpha)
?aes_colour_fill_alpha

# run this command to list all the pre-defined colors available in R
grDevices::colors()

# add color = "white" to your stacked bar chart from above
all_listings |>
  ggplot(aes(y = room_type, fill = fct_infreq(neighbourhood_group))) +
  geom_bar(
    position = "fill",
    color = "white"
  ) +
  labs(x = "share")

# recall our side-by-side bars plot from above
# choose a color from grDevices::colors() that sounds nice to you
# and reproduce the plot using fill = that color
all_listings |>
  ggplot(aes(x = fct_infreq(neighbourhood_group))) +
  geom_bar(
    fill = "violet"
  ) +
  labs(
    x = NULL,
    y = "Number of listings",
    title = "Airbnb listings by Borough in New York City"
  )

# now use fill = "#B31B1B",
# the official rgb hex code for cornell ("carnelian")
all_listings |>
  ggplot(aes(x = fct_infreq(neighbourhood_group))) +
  geom_bar(
    fill = "#B31B1B"
  ) +
  labs(
    x = NULL,
    y = "Number of listings",
    title = "Airbnb listings by Borough in New York City"
  )

# you can even modify the theme so that the axis labels are carnelian
# just add the layer below to your code from above
all_listings |>
  ggplot(aes(x = fct_infreq(neighbourhood_group))) +
  geom_bar(
    fill = "#B31B1B"
  ) +
  labs(
    x = NULL,
    y = "Number of listings",
    title = "Airbnb listings by Borough in New York City"
  ) +
  theme(text = element_text(color = "#B31B1B"))
