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
library(broom)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll continue to explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, a mission driven activist project with the objective to:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 1. Import airbnb listings ----
# import data
listings <- read_csv("listings.csv")

# what variables do we have?
names(listings)

# first, let's look at the distribution of price


# what is the minimum price?


# now, let's look at the distribution of accommodates


# what is the minimum accommodates?


# make a new data frame "dat" for analysis that:
# removes listings with zero prices and accommodates,
# removes listings with zero prices and accommodates,
# removes listings with prices above $1,000/night, and accommodates above 10
# for simplicity, only include listings of two room types: "Entire room/apt" and "Private room"
# finally, generate a variable log_price = log(price)


# for the following analysis, we want to explore the association of prices and some room characteristics
# it seems intuitive that prices would be higher if a property can hold more people (higher accommodation)
# how can we visualize this relationship?


# 2. Scatter plots ----
# use a scatter plot to visualize the association between price and accommodates


# label the x-axis by 1, 2, ..., 10 using the breaks argument to scale_x_continuous


# a lot of points lay on top of each other at the lower end of prices
# we can use the geom_point argument position = "jitter" to help visualize them
# we can also adjust the size and transparency of the points by setting size = , and alpha =


# do price and accommodates show any correlation?


# what if we use log(price) on the y-axis?


# the correlation between log(price) and accommodates looks stronger
# now check the correlation coefficient between log(price) and accommodation


# add a layer with a flexible fit to the data using geom_smooth()


# does a linear model seem like a reasonable approximation to this line?


# 3. Building a univariate model ----
# 3.1: let's build a linear model of the relationship between price and accommodates

# use lm() to estimate a linear model of price as a function of accommodates
price_linear <- lm()

# use tidy() to tidy the model output as a data frame
tidy(price_linear, conf.int = TRUE)

# how do we interpret the coefficient on `accommodates`?

# can you visualize this linear relationship using geom_smooth?


# bonus: can you visualize this relationship using your regression estimates?
# i recommend that you skip this during class and come back to it as time allows



# 3.2: now let's estimate a model where the dependent variable is log(price)
# continue to use the independent variable accommodates
price_loglinear <- lm()

# tidy the model output


# how do we interpret the coefficient of `accommodates`?

# can you visualize this linear relationship using geom_smooth?


# bonus: can you visualize this relationship using your regression estimates?
# i recommend that you skip this during class and come back to it as time allows



# 4. Multivariate models ----
# listing prices might be correlated with lots of variables, not just accommodates
# what variables do you think might be associated with listing price?
# what happens if we add them into the regression model?

# 4.1 multivariate regression
# estimate a "big" linear model that includes:
# price, accommodates, bedrooms, room_type, and neighbourhood_group
price_model_big <- lm()


# tidy the results

# what is the coefficient of `accommodates` now?
# is it the same as the one we obtained from the univariate model?
# how do we interpret this coefficient?
# how do we interpret the other coefficients?

# how do we visualize all the coefficients at one plot?

# 4.2 coefficient plots
# use geom_pointrange() to plot the point estimates and confidence intervals





# 4.3 marginal effects
# let's plot the marginal effect of accommodations holding other attributes fixed
# hold bedrooms at its mean, fix room_type at private room, and neighbourhood_group at Manhattan

# create a dataset with accommodates change from 1 to 10, and other variables hold constant at the chosen level


# use augment() to make predictions for these new data


# use geom_line to visualize marginal effects
# use geom_ribbon to visualize confidence intervals


# bonus: visualize marginal effects for different room types
# still hold bedrooms at its mean level, and fix neighbourhood group at Manhattan


# use augment() to make predictions for these new data


# use geom_line to visualize marginal effects, coloring by room_type
# use geom_ribbon to visualize confidence intervals, filling by room_type


# or facet the plot by room type


# how would you allow for different slopes for each room_type?
