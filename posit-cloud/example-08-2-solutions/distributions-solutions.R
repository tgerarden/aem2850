# AEM 2850 - Example 8
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages
# install.packages("ggridges") # in this case, it has already been done for you in this project
library(ggridges) # load the ggridges package so we can use geom_density_ridges()

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, an activist project:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 1. Import airbnb listings ----
# import data and assign them to all_listings
all_listings <- read_csv("listings.csv")


# 2. Histograms ----
# use a histogram to visualize the distribution of price for all_listings
all_listings |>
  ggplot(aes(x = price)) +
  geom_histogram()

# make a data frame `listings` with the listings priced below $1000/night
listings <- all_listings |>
  filter(price < 1000)

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
  geom_histogram(
    binwidth = 25,
    boundary = 0
  )

# modify the previous plot by making the border of the bars white
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(
    binwidth = 25,
    boundary = 0,
    color = "white"
  )


# 3. Density plots ----
# use the listings below $1000 to make a density plot of all listing prices
listings |>
  ggplot(aes(x = price)) +
  geom_density()

# fill by room_type to make a separate density plot for each room_type
# experiment with transparency (alpha) as a parameter of geom_density()
# choose a value for alpha that facilitates understanding
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
# these can be useful for comparisons of distributions across many categories
# quintessential example: changes in distributions over time
# use geom_density_ridges() from the package ggridges to implement this
listings |>
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none")

# the default densities produced by geom_density_ridges() extend below $0
# does that make sense?
# add scale_x_continuous(limits = c(0, NA)) to prevent it
listings |>
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none") +
  scale_x_continuous(limits = c(0, NA))


# 4. Assigning plots ----
# with ggplot, we can just keep adding layers
# we can even assign plots to names, and then add more layers
# let's assign our histogram to `our_histogram`:
our_histogram <- listings |>
  ggplot(aes(x = price)) +
  geom_histogram(
    binwidth = 25, boundary = 0,
    color = "white",
    fill = "#B31B1B"
  ) +
  theme_classic() +
  # set black gridlines to help us see changes across plots
  theme(panel.grid.major = element_line(color = "black"))

# use the name `our_histogram` to reproduce the plot
our_histogram


# 5. Customizing axis labels ----
# how can we customize the numeric labeling of axes?
# for the x axis, we can use scale_x_continuous(), scale_x_discrete(), etc.
# we can do the same thing for the y axis: scale_y_continuous(), etc.
# we just need to choose the right scale based on the data type

# modify our_histogram by labeling the x axis at 0, 100, 200, etc.
# use the breaks argument of scale_x_continuous to do it
our_histogram +
  scale_x_continuous(breaks = c(0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000))
# or:
our_histogram +
  scale_x_continuous(breaks = seq(0, 1000, 100))

# modify our_histogram by setting the x axis breaks: 0, 100, 760.2, and 1000
# note how it adjusts the gridlines
our_histogram +
  scale_x_continuous(breaks = c(0, 100, 760.2, 1000))

# keep the x axis labels at: 0, 100, 760.2, and 1000
# now label them with text: c("free", "cheap", "oh you fancy, huh?", "")
# you can use the labels argument of scale_x_continuous
our_histogram +
  scale_x_continuous(
    breaks = c(0, 100, 760.2, 1000),
    labels = c("free", "cheap", "oh you fancy, huh?", "")
  )

# add scale_y_continuous(breaks = NULL) to remove horizontal lines
our_histogram +
  scale_x_continuous(
    breaks = c(0, 100, 760.2, 1000),
    labels = c("free", "cheap", "oh you fancy, huh?", "")
  ) +
  scale_y_continuous(breaks = NULL)

# we can use scale_... to do other things, like impose limits
# use scale_y_continuous to limit to between 0 and 2500
# what happens to the bars that previously exceeded 2500?
our_histogram +
  scale_y_continuous(limits = c(0, 2500))

# what happens if you limit the y axis to above -2500 and put NA for the upper value?
our_histogram +
  scale_y_continuous(limits = c(-2500, NA))


# 6. Open-ended exploratory analysis of entire apartments ----
# make a new data frame `apts` that contains only entire apartments
# hint: look at the variable room_type
apts <- listings |>
  filter(room_type == "Entire home/apt")

# now explore other variables in the dataset using what we have learned

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
  geom_histogram() +
  scale_x_log10()


# 7. Feedback ----
# how did this format go vs the format we used in examples earlier in the course?
# please shoot me an email (gerarden@cornell.edu) if you have any strong opinions!
