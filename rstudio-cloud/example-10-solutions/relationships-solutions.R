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

# for the following analysis, we want to explore the association of prices and some room characteristics
# it seems intuitive that prices would be higher if a property can hold more people (higher accommodation)
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
# we can use the geom_point argument position = "jitter" to help visualize them
# we can also adjust the size and transparency of the points by setting size = , and alpha = 
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 0.5) +
  scale_x_continuous(breaks = 1:10)

# do price and accommodates show any correlation?
dat |> 
  summarize(correlation = cor(accommodates, price))

# what if we use log(price) on the y-axis? 
dat |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  scale_x_continuous(breaks = 1:10) 

# the correlation between log(price) and accommodates looks stronger
# now check the correlation coefficient between log(price) and accommodation
dat |> 
  summarize(correlation = cor(accommodates, log_price))

# add a layer with a flexible fit to the data using geom_smooth()
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth()

# does a linear model seem like a reasonable approximation to this line?


# 3. Building a univariate model ----
# let's build a linear model of the relationship between price and accommodates

# use lm() to estimate a linear model of price as a function of accommodates
price_linear <- lm(price ~ accommodates, data = dat)

# use tidy() to tidy the model output as a data frame
tidy(price_linear, conf.int = TRUE)

# how do we interpret the coefficient on `accommodates`?

# can you visualize this linear relationship using geom_smooth?
dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth(method = "lm")

# bonus: can you visualize this relationship using your regression estimates?
# i recommend that you skip this during class and come back to it as time allows
results <- tidy(price_linear) |> 
  select(term, estimate)

dat |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_abline(slope = results$estimate[2], 
              intercept = results$estimate[1], 
              color = "gold",
              linewidth = 1.5)


# now let's estimate a model where the dependent variable is log(price)
# continue to use the independent variable accommodates
price_loglinear <- lm(log_price ~ accommodates, data = dat)

# tidy the model output
tidy(price_loglinear, conf.int = TRUE)

# how do we interpret the coefficient of `accommodates`?

# can you visualize this linear relationship using geom_smooth?
dat |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth(method = "lm")

# bonus: can you visualize this relationship using your regression estimates?
# i recommend that you skip this during class and come back to it as time allows
results <- tidy(price_loglinear) |> 
  select(term, estimate)

dat |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_abline(slope = results$estimate[2], 
              intercept = results$estimate[1], 
              color = "hotpink",
              linewidth = 1.5) 


# 4. Multivariate models ----
# listing prices might be correlated with lots of variables, not just accommodates
# what variables do you think might be associated with listing price?
# what happens if we add them into the regression model?

# 4.1 multivariate regression
# estimate a "big" linear model that includes:
# price, accommodates, bedrooms, room_type, and neighbourhood_group
price_model_big <- lm(price ~ accommodates + bedrooms + room_type + neighbourhood_group, 
                      data = dat)


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

ggplot(price_coef, 
       aes(x = estimate,
           y = fct_rev(term))) +
  geom_pointrange(aes(xmin = conf.low,
                      xmax = conf.high)) +
  geom_vline(xintercept = 0, color = "red")


# 4.3 marginal effects
# let's plot the marginal effect of accommodations holding other attributes fixed
# hold bedrooms at its mean, fix room_type at private room, and neighbourhood_group at Manhattan

# create a dataset with accommodates change from 1 to 10, and other variables hold constant at the chosen level
listings_new_data <- tibble(accommodates = c(1:10),
                            bedrooms = mean(dat$bedrooms, na.rm = T),
                            room_type = "Private room",
                            neighbourhood_group = "Manhattan")

# use augment() to make predictions for these new data
predicted_price <- augment(price_model_big,
                            newdata = listings_new_data,
                            se_fit = TRUE)

# use geom_line to visualize marginal effects
# use geom_ribbon to visualize confidence intervals
predicted_price |> 
  ggplot(aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit)),
              fill = "skyblue",
              alpha = 0.5) +
  geom_line(linewidth = 1, color = "dodgerblue") +
  scale_x_continuous(breaks = seq(2,10,2))


# bonus: visualize marginal effects for different room types
# still hold bedrooms at its mean level, and fix neighbourhood group at Manhattan
listings_new_data_fancy <- expand_grid(accommodates = c(1:10),
                                        bedrooms = mean(dat$bedrooms, na.rm = T),
                                        room_type = c("Private room","Entire home/apt"),
                                        neighbourhood_group = "Manhattan") 

# use augment() to make predictions for these new data
predicted_price_fancy <- augment(price_model_big,
                           newdata = listings_new_data_fancy,
                           se_fit = TRUE)

# use geom_line to visualize marginal effects, coloring by room_type
# use geom_ribbon to visualize confidence intervals, filling by room_type
predicted_price_fancy |> 
  ggplot(aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit),
                  fill = room_type),
              alpha = 0.5) +
  geom_line(aes(color = room_type), linewidth = 1) +
  scale_x_continuous(breaks = seq(2,10,2))

# or facet the plot by room type
ggplot(predicted_price_fancy,
       aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit),
                  fill = room_type),
              alpha = 0.5) +
  geom_line(aes(color = room_type), linewidth = 1) +
  scale_x_continuous(breaks = seq(2,10,2)) +
  facet_wrap(~room_type)

# how would you allow for different slopes for each room_type?
