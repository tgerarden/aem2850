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


# 2. Histograms ----
# use a histogram to visualize the distribution of price for all listings

# let's focus on listings below $1000/night

# use a histogram to visualize the distribution for properties below $1000/night

# increase the number of bins to 10 (default is 30)

# decrease the number of bins to 50 (default is 30)

# instead of specifying the number of bins, specify a binwidth of $25

# specify a binwidth of $25, but now make the bins start at 0 instead of being centered around 0

# modify the previous plot by making the border of the bars white


# 3. Colors in ggplot2 ----
# tuesday we saw some examples of using color, fill, etc. as parameters rather than aesthetics
# a question came up: how do we know what colors R will understand? (e.g., "skyblue")
# here is a quick primer on the options that are available to you by default
# you can use RBG codes (either on your own or through other packages) to customize colors with virtually limitless possibilities

# first: use the help to learn more about color related aesthetic (color, fill, alpha)
?aes_colour_fill_alpha

# read the help to find a command that will list all the pre-defined colors available in R, and enter it

# reproduce your histogram from before, filling with the 42nd element in the list of colors
# see if you can do this WITHOUT manually looking through the list and typing out its name

# now look through the list and find a color that sounds nice to you, and reproduce the histogram using this fill

# google the official rgb hex code for cornell ("carnelian"), and use that code to fill your histogram

# now modify the theme so that the axis labels (numbers and/or words) are printed in carnelian

# one really nice thing about ggplot's layered grammar of graphics is that we can just keep adding things
# in fact, we can even assign plots to names and then continue adding to them without duplicating code
# to see this in action, give your current histogram a name so that you can reference it below

# use the name to reproduce the plot


# 4. Customizing axis labels ----
# another thing that came up tuesday was whether we can customize the numeric labeling of axes
# to modify the x axis, we can use scale_x_continuous(), scale_x_discrete(), etc. depending on the data type
# we can do the same thing for the y axis: scale_y_continuous(), etc.

# modify the previous plot by labeling the x axis at 0, 100, 200, etc.

# modify the previous plot by labeling the x axis at: 0, 100, 760.2, and 1000
# note how it adjusts the gridlines

# keep the x axis labels at: 0, 100, 760.2, and 1000
# but now label them with text: c("free", "cheap", "oh you fancy, huh?", "")
# note how it adjusts the gridlines

# use scale_y_continuous to remove the horizontal lines and axis

# we can use scale_... to do other things, like limit  to also limit
# use scale_y_continuous to limit to between 0 and 2500
# what happens to the bars that previously exceeded 2500?

# what happens if you limit the y axis to above -2500 and put NA for the upper value?


# 5. Density plots ----
# use the listings below $1000 to make a density plot of all listing prices

# make a separate density plot for each room_type and overlay them
# to make them more readable, experiment with transparency (alpha) as a parameter of geom_density()

# use facets to put them on separate plots for readability

# put all the facets in a single column to facilitate comparisons

# ridgeline plots offer an intermediate option between overlays and facets
# these can be useful for comparisons of distributions across many categories (e.g., over time)
# use geom_density_ridges() from the package ggridges to implement this

# the default densities produced by geom_density_ridges() extend below $0
# does that make sense?
# find a way to prevent that from happening


# 6. Open-ended exploratory analysis of private rooms ----
# make a new data frame that contains only private rooms
# explore other variables in the dataset using data wrangling and visualization tools we have learned so far

# suggestions:
# visualize the number of listings in each neighbourhood_group. which has the most? which has the least?
# visualize the proportion of listings in each neighbourhood_group
# visualize the distribution of prices in each neighbourhood_group
# visualize the distribution of reviews (you might want to use a log scale for this)
# visualize the distribution of last_review (over time)


# 7. Feedback ----
# how did this format go vs the format we used in previous examples? please shoot me an email (gerarden@cornell.edu) if you have a strong opinion!
