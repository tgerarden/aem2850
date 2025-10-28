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

# what variables do we have?
names(listings)

# first, let's look at the distribution of price
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(color = "white", binwidth = 200, boundary = 0)

# what is the minimum price?
listings |>
  summarize(min(price))

# now, let's look at the distribution of accommodates
listings |>
  ggplot(aes(x = accommodates)) +
  geom_histogram(color = "white", binwidth = 1, boundary = 0)

# what is the minimum accommodates?
listings |>
  summarize(min(accommodates))

# make a new data frame "dat" for analysis that:
# removes listings with zero prices and accommodates,
# removes listings with zero prices and accommodates,
# removes listings with prices above $1,000/night, and accommodates above 10
# for simplicity, only include listings of two room types: "Entire room/apt" and "Private room"
# finally, generate a variable log_price = log(price)
dat <- listings |>
  filter(price>0 & price<=1000) |>
  filter(accommodates>0 & accommodates<=10) |>
  filter(room_type == "Entire home/apt" | room_type == "Private room") |>
  mutate(log_price = log(price))

# next let's explore the association of prices and some room characteristics
# it's intuitive that prices would be higher if a property can hold more people
# how can we visualize this relationship?


# 2. Scatter plots ----
# use a scatter plot to visualize the association between price and accommodates
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point()

# label the x-axis by 1, 2, ..., 10 using the breaks argument to scale_x_continuous
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point() +
  scale_x_continuous(breaks = 1:10)

# a lot of points lay on top of each other at the lower end of prices
# use the geom_point argument alpha = 0.1 to help visualize them
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(alpha = 0.1) +
  scale_x_continuous(breaks = 1:10)

# that's better, but it's still hard to see patterns due to overplotting
# another option is to add noise to the points to help differentiate them
# try this using the geom_point argument position = "jitter"
# adjust their size and transparency by setting size = 0.1, alpha = 0.5
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 0.5) +
  scale_x_continuous(breaks = 1:10)

# do price and accommodates show any correlation?
dat |>
  summarize(correlation = cor(accommodates, price))

# what if we use log_price on the y-axis?
dat |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  scale_x_continuous(breaks = 1:10)

# the relationship between log_price and accommodates looks a bit different
# now check the correlation coefficient between log_price and accommodation
dat |>
  summarize(correlation = cor(accommodates, log_price))

# let's go back to price (not log_price)
# add a layer with a flexible fit to the data using geom_smooth()
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth()

# does a linear model seem like a reasonable approximation to this line?


# 3. Building a univariate model ----
# 3.1: let's build a linear model of the relationship between price and accommodates

# use lm() to estimate a linear model of price as a function of accommodates
price_linear <- lm(price ~ accommodates, data = dat)

# use tidy() to tidy the model output as a data frame
tidy(price_linear, conf.int = TRUE)

# how do we interpret the coefficient on `accommodates`?
# do you think it reflects guest demand, host costs, or both?

# can you visualize this linear relationship using geom_smooth?
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth(method = "lm")


# 3.2: now let's estimate a model where the dependent variable is log_price
# continue to use the independent variable accommodates
price_loglinear <- lm(log_price ~ accommodates, data = dat)

# tidy the model output
tidy(price_loglinear, conf.int = TRUE)

# how do we interpret the coefficient of `accommodates` now?

# can you visualize this linear relationship using geom_smooth?
dat |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth(method = "lm")


# 4. Multivariate models ----
# listing prices might be correlated with lots of variables, not just accommodates
# what variables do you think might be associated with listing price?
# what happens if we add them into the regression model?

# 4.1 multivariate regression
# estimate a "big" linear model that includes:
# price, accommodates, bedrooms, room_type, and neighbourhood_group
price_model_big <- lm(
  price ~ accommodates + bedrooms + room_type + neighbourhood_group,
  data = dat
)

# tidy the results
tidy(price_model_big, conf.int = TRUE)

# what is the coefficient of `accommodates` now?
# is it the same as the one we obtained from the univariate model?
# how do we interpret this coefficient?
# how do we interpret the other coefficients?

# how do we visualize all the coefficients at one plot?

# 4.2 coefficient plots
# use geom_pointrange() to plot the point estimates and confidence intervals
price_coef <- tidy(price_model_big, conf.int = TRUE) |>
  filter(term != "(Intercept)")

price_coef |>
  ggplot(aes(x = estimate, y = fct_rev(term))) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0, color = "red")


# 4.3 marginal effects
# let's plot the marginal effect of accommodations with other attributes fixed
# use tibble to create a dataset `listings_new_data` with:
# accommodates 1, 2, 3, ..., 10
# hold bedrooms at its mean
# fix room_type at "Private room"
# fix neighbourhood_group at "Manhattan"
listings_new_data <- tibble(
  accommodates = 1:10,
  bedrooms = dat |> pull(bedrooms) |> mean(na.rm = TRUE),
  room_type = "Private room",
  neighbourhood_group = "Manhattan"
)

# use augment() to make predictions for these new data
# use the argument interval = "confidence" to include confidence intervals
predicted_price <- augment(
  price_model_big,
  newdata = listings_new_data,
  interval = "confidence"
)

# use geom_line to visualize marginal effects
# use geom_ribbon to visualize confidence intervals
# using geom_line after geom_ribbon will plot it on top
predicted_price |>
  ggplot(aes(x = accommodates, y = .fitted)) +
  geom_ribbon(
    aes(ymin = .lower, ymax = .upper),
    fill = "skyblue",
    alpha = 0.75
  ) +
  geom_line(linewidth = 1, color = "plum") +
  scale_x_continuous(breaks = seq(2, 10, 2)) +
  labs(
    x = "Number of guests an Airbnb accommodates",
    y = "Price per night (model predictions)"
  )


# OPTIONAL: BONUS MATERIAL ----
# visualize marginal effects for different room types
# hold bedrooms at its mean level, and fix neighbourhood group at Manhattan
# one way to do this is by using the function expand_grid() instead of tibble
# and a vector of multiple room types for room_type
listings_new_data_fancy <- expand_grid(
  accommodates = 1:10,
  bedrooms = dat |> pull(bedrooms) |> mean(na.rm = TRUE),
  room_type = c("Private room", "Entire home/apt"),
  neighbourhood_group = "Manhattan"
)

# use augment() to make predictions for these new data
predicted_price_fancy <- augment(
  price_model_big,
  newdata = listings_new_data_fancy,
  interval = "confidence"
)

# use geom_line to visualize marginal effects, coloring by room_type
# use geom_ribbon to visualize confidence intervals, filling by room_type
predicted_price_fancy |>
  ggplot(aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .lower,
                  ymax = .upper,
                  fill = room_type),
              alpha = 0.5) +
  geom_line(aes(color = room_type), linewidth = 1) +
  scale_x_continuous(breaks = seq(2, 10, 2)) +
  theme(legend.position = "bottom") +
  labs(
    x = "Number of guests an Airbnb accommodates",
    y = "Price per night (model predictions)",
    color = "Room type",
    fill = "Room type"
  )

# or facet the plot by room type
predicted_price_fancy |>
  ggplot(aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .lower,
                  ymax = .upper),
              alpha = 0.25) +
  geom_line(linewidth = 1) +
  scale_x_continuous(breaks = seq(2,10,2)) +
  facet_wrap(~room_type) +
  labs(
    x = "Number of guests an Airbnb accommodates",
    y = "Price per night (model predictions)"
  )

# how could you allow for different slopes for each room_type using lm?
# one way would be to estimate separate regressions for each room_type
# one way to achieve this is by including interaction effects
