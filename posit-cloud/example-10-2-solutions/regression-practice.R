# AEM 2850 - Example 10-2
# Plan for today:
# - Go through slides
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages
library(broom)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll continue to explore data on Airbnb listings from New York City
# the data come from Inside Airbnb, an activist project: http://insideairbnb.com


# 1. Import airbnb listings ----
# import data
listings <- read_csv("listings.csv")

# reminder: what variables do we have?
names(listings)

# make a new data frame "prices" that:
# removes listings with zero prices and accommodates,
# removes listings with prices above $1,000/night, and accommodates above 10
# removes listings with NA values for bathrooms_text
# for simplicity, only include room types "Entire room/apt" and "Private room"
# finally, generate a variable log_price = log(price)
prices <- listings |>
  filter(price>0 & price<=1000) |>
  filter(accommodates>0 & accommodates<=10) |>
  filter(!is.na(bathrooms_text)) |>
  filter(room_type == "Entire home/apt" | room_type == "Private room") |>
  mutate(log_price = log(price))

# as a reminder, in example-10-1 we looked at the relationships between:
# price and accommodates
# price and bathrooms_text
# now, let's use regressions to explore some more complicated relationships


# 2. Building a univariate model ----
# 2.1: let's build a linear model of the relationship between price and accommodates

# use lm() to estimate a linear model of price as a function of accommodates
price_linear <- lm(
  # <Y> ~ <X>,
  # data = <DATA>
)

# use summary() to see the model results in detail


# use tidy() to tidy the model output as a data frame


# use tidy() again, but now add the argument "conf.int = TRUE"


# how do we interpret the coefficient on `accommodates`?
# do you think it reflects guest demand, host costs, or both?

# can you visualize this linear relationship using geom_smooth?



# 2.2: now let's estimate a model where the dependent variable is log_price
# continue to use the independent variable accommodates
price_loglinear <- lm(
  #
  #
)

# tidy the model output


# how do we interpret the coefficient of `accommodates` now?

# can you visualize this linear relationship using geom_smooth?


# 3. Regressions with categorical variables ----
# categorical, or factor, variables, take on a known and fixed set of values
# could be numbers, but often other categories that do not have numeric values
# how could we include a variable like neighbourhood_group in a regression?
prices |> distinct(neighbourhood_group)

# try estimating a linear regression of price on neighbourhood_group


# use summary() to look at the regression results


# what happened?

# how should we interpret the results?

# how could we visualize this?


# 4. Multivariate models ----
# listing prices might be correlated with lots of variables, not just accommodates
# what variables do you think might be associated with listing price?
# what happens if we add them into the regression model?

# 4.1 multivariate regression
# estimate a "big" linear model that includes:
# price, accommodates, bedrooms, room_type, and neighbourhood_group
price_linear_big <- lm(
  #
  #
)

# tidy the results

# what is the coefficient of `accommodates` now?
# is it the same as the one we obtained from the univariate model?
# how do we interpret this coefficient?
# how do we interpret the other coefficients?

# how do we visualize all the coefficients at one plot?

# 4.2 coefficient plots
# use tidy() to tidy the estimates and confidence intervals as a data frame
# filter out the intercept term


# use geom_pointrange() to plot the point estimates and confidence intervals


# 5. Interactions and varying slopes ----
# how could you allow for different slopes on accommodates for each room_type?

# one way would be to estimate separate regressions for each room_type
# how would you do that?
# try it:

# one way to would be including interaction effects
# try this using the syntax accommodates:room_type + room_type

