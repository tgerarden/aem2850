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


# 2. Histograms ----
# use a histogram to visualize the distribution of price for all_listings


# make a data frame `listings` with the listings priced below $1000/night


# use a histogram to visualize the distribution of price for listings


# increase the number of bins to 50 (default is 30)


# instead of specifying the number of bins, specify a binwidth of 25 ($/night)


# specify a binwidth of 25, but now make the bins start at 0 instead of being centered around 0


# modify the previous plot by making the border of the bars white



# 3. Density plots ----
# use the listings below $1000 to make a density plot of all listing prices


# fill by room_type to make a separate density plot for each room_type
# experiment with transparency (alpha) as a parameter of geom_density()
# choose a value for alpha that facilitates understanding


# use facets to put them on separate plots for readability


# put all the facets in a single column to facilitate comparisons


# ridgeline plots offer an intermediate option between overlays and facets
# these can be useful for comparisons of distributions across many categories
# quintessential example: changes in distributions over time
# use geom_density_ridges() from the package ggridges to implement this


# the default densities produced by geom_density_ridges() extend below $0
# does that make sense?
# add scale_x_continuous(limits = c(0, NA)) to prevent it



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


# modify our_histogram by setting the x axis breaks: 0, 100, 760.2, and 1000
# note how it adjusts the gridlines


# keep the x axis labels at: 0, 100, 760.2, and 1000
# now label them with text: c("free", "cheap", "oh you fancy, huh?", "")
# you can use the labels argument of scale_x_continuous


# add scale_y_continuous(breaks = NULL) to remove horizontal lines


# we can use scale_... to do other things, like impose limits
# use scale_y_continuous to limit to between 0 and 2500
# what happens to the bars that previously exceeded 2500?


# what happens if you limit the y axis to above -2500 and put NA for the upper value?



# 6. Open-ended exploratory analysis of entire apartments ----
# make a new data frame `apts` that contains only entire apartments
# hint: look at the variable room_type


# now explore other variables in the dataset using what we have learned

# suggestions:
# visualize the distribution of prices in each neighbourhood_group


# visualize the distribution of reviews using the default scale


# visualize the distribution of reviews using a log scale



# 7. Feedback ----
# how did this format go vs the format we used in examples earlier in the course?
# please shoot me an email (gerarden@cornell.edu) if you have any strong opinions!
