# AEM 2850 - Example 7
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
library(ggridges) # load the core tidyverse packages

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, a mission driven activist project with the objective to:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 1. Import airbnb listings ----
# import data
listings <- read_csv("listings.csv")


# 2. Histograms ----
# use a histogram to visualize the distribution of price for all listings
listings %>%
  ggplot(aes(x = price)) +
  geom_histogram()

# let's focus on listings below $1000/night
dat <- listings %>%
  filter(price<1000)

# use a histogram to visualize the distribution for properties below $1000/night
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram()

# increase the number of bins to 10 (default is 30)
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(bins = 10)

# decrease the number of bins to 50 (default is 30)
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(bins = 50)

# instead of specifying the number of bins, specify a binwidth of $25
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25)

# specify a binwidth of $25, but now make the bins start at 0 instead of being centered around 0
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0)

# modify the previous plot by making the border of the bars white
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white")


# 3. Colors in ggplot2 ----
# tuesday we saw some examples of using color, fill, etc. as parameters rather than aesthetics
# a question came up: how do we know what colors R will understand? (e.g., "skyblue")
# here is a quick primer on the options that are available to you by default
# you can use RBG codes (either on your own or through other packages) to customize colors with virtually limitless possibilities

# first: use the help to learn more about color related aesthetic (color, fill, alpha)
?aes_colour_fill_alpha

# read the help to find a command that will list all the pre-defined colors available in R, and enter it
grDevices::colors()

# reproduce your histogram from before, filling with the 42nd element in the list of colors
# see if you can do this WITHOUT manually looking through the list and typing out its name
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = grDevices::colors()[42])

# now look through the list and find a color that sounds nice to you, and reproduce the histogram using this fill
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "orchid")

# google the official rgb hex code for cornell ("carnelian"), and use that code to fill your histogram
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B")

# now modify the theme so that the axis labels (numbers and/or words) are printed in carnelian
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(axis.title.x = element_text(color = "#B31B1B"),
        axis.title.y = element_text(color = "#B31B1B"),
        axis.text.x = element_text(color = "#B31B1B"),
        axis.text.y = element_text(color = "#B31B1B"))

# there are multiple ways to implement these depending on what you want and how much you want to type...
dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(axis.title = element_text(color = "#B31B1B"),
        axis.text = element_text(color = "#B31B1B"))

dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(text = element_text(color = "#B31B1B"))

# one really nice thing about ggplot's layered grammar of graphics is that we can just keep adding things
# in fact, we can even assign plots to names and then continue adding to them without duplicating code
# to see this in action, give your current histogram a name so that you can reference it below
histogram <- dat %>%
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 25, boundary = 0,
                 color = "white",
                 fill = "#B31B1B") +
  theme(text = element_text(color = "#B31B1B"))

# use the name to reproduce the plot
histogram


# 4. Customizing axis labels ----
# another thing that came up tuesday was whether we can customize the numeric labeling of axes
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
  scale_x_continuous(breaks = c(0, 100, 760.2, 1000),
                     labels = c("free", "cheap", "oh you fancy, huh?", ""))

# use scale_y_continuous to remove the horizontal lines and axis
histogram +
  scale_x_continuous(breaks = c(0, 100, 760.2, 1000),
                     labels = c("free", "cheap", "oh you fancy, huh?", "")) +
  scale_y_continuous(breaks = NULL)

# we can use scale_... to do other things, like limit  to also limit
# use scale_y_continuous to limit to between 0 and 2500
# what happens to the bars that previously exceeded 2500?
histogram +
  scale_y_continuous(limits = c(0, 2500))

# what happens if you limit the y axis to above -2500 and put NA for the upper value?
histogram +
  scale_y_continuous(limits = c(-2500, NA))


# 5. Density plots ----
# use the listings below $1000 to make a density plot of all listing prices
dat %>%
  ggplot(aes(x = price)) +
  geom_density()

# make a separate density plot for each room_type and overlay them
# to make them more readable, experiment with transparency (alpha) as a parameter of geom_density()
dat %>%
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2)

# use facets to put them on separate plots for readability
dat %>%
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2) +
  guides(fill = "none") +
  facet_wrap(~room_type)

# put all the facets in a single column to facilitate comparisons
dat %>%
  ggplot(aes(x = price, fill = room_type)) +
  geom_density(alpha = 0.2) +
  guides(fill = "none") +
  facet_wrap(~room_type, ncol = 1)

# ridgeline plots offer an intermediate option between overlays and facets
# these can be useful for comparisons of distributions across many categories (e.g., over time)
# use geom_density_ridges() from the package ggridges to implement this
dat %>%
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none")

# the default densities produced by geom_density_ridges() extend below $0
# does that make sense?
# find a way to prevent that from happening
dat %>%
  ggplot(aes(x = price, y = room_type, fill = room_type)) +
  geom_density_ridges() +
  guides(fill = "none") +
  scale_x_continuous(limits = c(0, NA))


# 6. Open-ended exploratory analysis of private rooms ----
# make a new data frame that contains only private rooms
# explore other variables in the dataset using data wrangling and visualization tools we have learned so far

# suggestions:
# visualize the number of listings in each neighbourhood_group. which has the most? which has the least?
# visualize the proportion of listings in each neighbourhood_group
# visualize the distribution of prices in each neighbourhood_group
# visualize the distribution of reviews (you might want to use a log scale for this)
# visualize the distribution of last_review (over time)

rooms <- dat %>%
  filter(room_type == "Private room")

# visualize the number of listings in each neighbourhood_group. which has the most? which has the least?
dat %>%
  group_by(neighbourhood_group) %>%
  count() %>%
  ggplot(aes(x = n, y = fct_reorder(neighbourhood_group, n))) +
  geom_col()

# visualize the proportion of listings in each neighbourhood_group
# pie
dat %>%
  group_by(neighbourhood_group) %>%
  count() %>%
  ggplot(aes(x = n, y = "", fill = fct_reorder(neighbourhood_group, -n))) +
  geom_col() + coord_polar() +
  scale_x_continuous(breaks = NULL) +
  labs(x = NULL,
       y = NULL,
       fill = NULL)

# stacked bars
dat %>%
  ggplot(aes(x = "", fill = fct_rev(fct_infreq(neighbourhood_group)))) +
  geom_bar(position = "fill") +
  coord_flip() +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(reverse = TRUE)) +
  scale_x_discrete(breaks = NULL) +
  scale_y_continuous(breaks = seq(0, 1, .1)) +
  labs(x = NULL,
       y = "share",
       fill = NULL)

# visualize the distribution of prices in each neighbourhood_group
dat %>%
  ggplot(aes(x = price, y = neighbourhood_group, fill = neighbourhood_group)) +
  geom_density_ridges() +
  guides(fill = "none")

# visualize the distribution of reviews (you might want to use a log scale for this)
dat %>%
  ggplot(aes(x = number_of_reviews)) +
  geom_histogram()
dat %>%
  ggplot(aes(x = number_of_reviews)) +
  geom_histogram(boundary = 0) + # note boundary is before we transform the scale, so 0 is equivalent to 1 on a log scale bc log10(1) = 0
  scale_x_log10()

# visualize the distribution of last_review (over time)
rooms %>%
  ggplot(aes(x = last_review)) +
  geom_density()


# 7. Feedback ----
# how did this format go vs the format we used in previous examples? please shoot me an email (gerarden@cornell.edu) if you have a strong opinion!
