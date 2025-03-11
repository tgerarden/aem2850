# AEM 2850 - Example 8
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
# install.packages("ggridges") # in this case, it has already been done for you in this project
library(ggridges) # load the ggridges package so we can use geom_density_ridges()

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, a mission driven activist project with the objective to:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 1. Import airbnb listings ----
# import data and assign them to all_listings
all_listings <- read_csv("listings.csv")


# 2. Proportions ----
# how are the listings distributed across boroughs? (neighbourhood_group)
# which borough has the most? which borough has the least?

# visualize the number of all_listings in each neighbourhood_group
# using bars (via geom_col)
all_listings |>
  count(neighbourhood_group) |>
  ggplot(aes(x = neighbourhood_group, y = n)) +
  geom_col()

# alternatively, this can be done using geom_bar()
# reminder: geom_bar() counts and plots frequencies automatically
all_listings |>
  ggplot(aes(x = neighbourhood_group)) +
  geom_bar()

# visualize the proportion of all_listings in each neighbourhood_group
# using stacked bars (via geom_col)
all_listings |>
  count(neighbourhood_group) |>
  mutate(share = n / sum(n)) |>
  ggplot(aes(x = "", y = share, fill = neighbourhood_group)) +
  geom_col()

# alternatively, this can be done using geom_bar()
all_listings |>
  ggplot(aes(y = "", fill = neighbourhood_group)) +
  geom_bar(position = "fill")

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
    x = NULL,
    y = "share",
    fill = NULL
  )

# visualize the proportion of all_listings in each neighbourhood_group
# using a pie chart (via geom_bar)
# you can do this by adding the layer `coord_polar()` to the earlier stacked bars
all_listings |>
  ggplot(aes(y = "", fill = neighbourhood_group)) +
  geom_bar(position = "fill") +
  coord_polar()

# here is a more polished version for your reference
# you can play around with commenting out lines to see how layers change
all_listings |>
  count(neighbourhood_group) |>
  ggplot(aes(
    x = n,
    y = "",
    fill = fct_reorder(neighbourhood_group, -n)
    )) +
  geom_col() + coord_polar() +
  scale_x_continuous(breaks = NULL) +
  scale_fill_viridis_d() +
  labs(
    title = "Airbnb listings across the boroughs of NYC: slices of the pie",
    x = NULL,
    y = NULL,
    fill = NULL
  )


# 3. Histograms ----
# use a histogram to visualize the distribution of price for all_listings
all_listings |>
  ggplot(aes(x = price)) +
  geom_histogram()

# make a data frame named listings with the listings priced below $1000/night
listings <- all_listings |>
  filter(price<1000)

# use a histogram to visualize the distribution of price for listings
listings |>
  ggplot(aes(x = price)) +
  geom_histogram()

# increase the number of bins to 50 (default is 30)
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(bins = 50)

# instead of specifying the number of bins, specify a binwidth of 25 ($/night)
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25)

# specify a binwidth of 25, but now make the bins start at 0 instead of being centered around 0
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25,
                 boundary = 0)

# modify the previous plot by making the border of the bars white
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25,
                 boundary = 0,
                 color = "white")


# 4. Density plots ----
# use the listings below $1000 to make a density plot of all listing prices
listings |>
  ggplot(aes(x = price)) +
  geom_density()

# fill by room_type to make a separate density plot for each room_type
# to make them more readable, experiment with transparency (alpha) as a parameter of geom_density()
listings |>
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2)

# use facets to put them on separate plots for readability
listings |>
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2) +
  guides(fill = "none") +
  facet_wrap(vars(room_type))

# put all the facets in a single column to facilitate comparisons
listings |>
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2) +
  guides(fill = "none") +
  facet_wrap(vars(room_type), ncol = 1)

# ridgeline plots offer an intermediate option between overlays and facets
# these can be useful for comparisons of distributions across many categories (e.g., over time)
# use geom_density_ridges() from the package ggridges to implement this
listings |>
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none")

# the default densities produced by geom_density_ridges() extend below $0
# does that make sense?
# you can use scale_x_continuous(limits = c(0, NA)) to prevent it
listings |>
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none") +
  scale_x_continuous(limits = c(0, NA))


# 5. Colors in ggplot2 ----
# in the slides we saw some examples of using color, fill, etc. as parameters rather than aesthetics
# how do we know what colors R will understand? (e.g., "skyblue")
# here is a quick primer on the options that are available to you by default
# you can use RBG codes (either on your own or through other packages) to customize colors with virtually limitless possibilities

# first: use the help to learn more about color related aesthetic (color, fill, alpha)
?aes_colour_fill_alpha

# read the help to find a command that will list all the pre-defined colors available in R, and enter it
grDevices::colors()

# reproduce your histogram from before, filling with the color "tomato"
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "tomato")

# now look through the list and find a color that sounds nice to you, and reproduce the histogram using this fill
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "orchid")

# use #B31B1B, the official rgb hex code for cornell ("carnelian"), to fill your histogram
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B")

# you can even modify the theme so that the axis labels (numbers and/or words) are printed in carnelian, just add the layer below to your code from above
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(text = element_text(color = "#B31B1B"))



# WE NEED TO KEEP THIS PART BELOW FOR THURSDAY

# one really nice thing about ggplot's layered grammar of graphics is that we can just keep adding things
# in fact, we can even assign plots to names and then continue adding to them without duplicating code
# to see this in action, assign your current histogram to "histogram" so that you can reference it below
histogram <- listings |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(text = element_text(color = "#B31B1B"))

# use the name to reproduce the plot
histogram


# 6. Customizing axis labels ----
# how can we customize the numeric labeling of axes?
# to modify the x axis, we can use scale_x_continuous(), scale_x_discrete(), etc. depending on the data type
# we can do the same thing for the y axis: scale_y_continuous(), etc.

# modify the previous plot by labeling the x axis at 0, 100, 200, etc.
histogram +
  scale_x_continuous(breaks = c(0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000))
# or:
histogram +
  scale_x_continuous(breaks = seq(0, 1000, 100))

# modify the previous plot by labeling the x axis at: 0, 100, 760.2, and 1000
# note how it adjusts the gridlines
histogram +
  scale_x_continuous(breaks = c(0, 100, 760.2, 1000))

# keep the x axis labels at: 0, 100, 760.2, and 1000
# but now label them with text: c("free", "cheap", "oh you fancy, huh?", "")
# note how it adjusts the gridlines
histogram +
  scale_x_continuous(
    breaks = c(0, 100, 760.2, 1000),
    labels = c("free", "cheap", "oh you fancy, huh?", "")
  )

# use scale_y_continuous(breaks = NULL) to remove the horizontal lines and axis
histogram +
  scale_x_continuous(
    breaks = c(0, 100, 760.2, 1000),
    labels = c("free", "cheap", "oh you fancy, huh?", "")
  ) +
  scale_y_continuous(breaks = NULL)

# we can use scale_... to do other things, like impose limits
# use scale_y_continuous to limit to between 0 and 2500
# what happens to the bars that previously exceeded 2500?
histogram +
  scale_y_continuous(limits = c(0, 2500))

# what happens if you limit the y axis to above -2500 and put NA for the upper value?
histogram +
  scale_y_continuous(limits = c(-2500, NA))


# 7. Open-ended exploratory analysis of entire apartments ----
# make a new data frame that contains only entire apartments
# explore other variables in the dataset using data wrangling and visualization tools we have learned so far
apts <- listings |>
  filter(room_type == "Entire home/apt")

# suggestions:
# visualize the distribution of prices in each neighbourhood_group
apts |>
  ggplot(
    aes(
    x = price,
    y = neighbourhood_group,
    fill = neighbourhood_group
    )
  ) +
  geom_density_ridges() +
  guides(fill = "none")

# visualize the distribution of reviews using the default scale
apts |>
  ggplot(aes(x = number_of_reviews)) +
  geom_histogram()

# visualize the distribution of reviews using a log scale
apts |>
  ggplot(aes(x = number_of_reviews)) +
  geom_histogram(boundary = 0) + # note boundary is before we transform the scale, so 0 is equivalent to 1 on a log scale bc log10(1) = 0
  scale_x_log10()


# 8. Feedback ----
# how did this format go vs the format we used in examples earlier in the course?
# please shoot me an email (gerarden@cornell.edu) if you have any strong opinions!
