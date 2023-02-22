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
library(GGally)
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
names(listings)
# what variables do we have? 


# first, let's look at the distributions of price and accommodates
listings %>% 
  ggplot(aes(x = price)) +
  geom_histogram(color = "white", binwidth = 200, boundary = 0)
# what is the minimum price? 
min(listings$price)

listings %>% 
  summarize(min(price))

listings %>% 
  ggplot(aes(x = accommodates)) +
  geom_histogram(color = "white", binwidth = 1, boundary = 0)
# what is the minimum accommodates?
min(listings$accommodates)

unique(listings$room_type)

# let's drop listings with zero prices and accommodates,
# and focus on listings below $1000/night, and accommodates 10 or fewer people
# for simplicity, we only include listings of two room types: entire room/apt, and private room
# generate a variable logprice = log(price)
dat <- listings %>%
  filter(price>0 & price<=1000) %>% 
  filter(accommodates>0 & accommodates<=10) %>% 
  filter(room_type == "Entire home/apt" | room_type == "Private room") %>% 
  mutate(logprice = log(price))

# for the following analysis, we want to explore the association of prices and some room characteristics
# naturally, prices should be higher if a property can hold more people (higher accommodation)
# how do we visualize this relationship?

# 2. Scatter plots ----
# use a scatter plot to visualize the association between price and accommodates
dat %>% 
  ggplot(aes(x = accommodates, y = price)) +
  geom_point() 

# label the x-axis by 1, 2, ..., 10
dat %>% 
  ggplot(aes(x = accommodates, y = price)) +
  geom_point() +
  scale_x_continuous(breaks = 1:10)

# a lot of points lay on top of each other at the lower end of prices
# we can use posting = "jitter" to add a bit noise to separate them apart in the plot
# we can also adjust the size and transparency of the points by setting size = , and alpha = 
dat %>%
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 0.5) +
  scale_x_continuous(breaks = 1:10)

# do price and accommodates show any correlation?

# what if we use log price on the y-axis? 
dat %>%
  ggplot(aes(x = accommodates, y = logprice)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  scale_x_continuous(breaks = 1:10) 

# the correlation between log(price) and accommodates looks stronger 

# check the correlation coefficient btw. price and accommodation
cor(dat$accommodates, dat$price) %>% 
  round(.,3)

# check the correlation coefficient btw. log(price) and accommodation
cor(dat$accommodates, dat$logprice) %>% 
  round(.,3)



# 3. Building a univariate model ----
# now let's try building a univariate model to explore correlation between price and accommodates

# linear model
price_linear <- lm(price ~ accommodates, data = dat)

# use tidy() to tidy the model output
tidy(price_linear, conf.int = TRUE)

# how do we interpret the coefficient of `accommodates`?

# we can use glance() to check the model diagnostics
glance(price_linear)

# can you visualize this relationship?
results <- tidy(price_linear) %>% 
  select(term, estimate)

dat %>%
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_abline(slope = results$estimate[2], 
              intercept = results$estimate[1], 
              color = "blue",
              size = 1.5) 


# let's build a log-linear model
# the dependent variable is log(price), the independent variable is accommodates
price_loglinear <- lm(logprice ~ accommodates, data = dat)

# tidy the model output
tidy(price_loglinear, conf.int = TRUE)

# how do we interpret the coefficient of `accommodates`?

# glance the model diagnostic
glance(price_loglinear)

# can you visualize the relationship?
results <- tidy(price_loglinear) %>% 
  select(term, estimate)

dat %>%
  ggplot(aes(x = accommodates, y = logprice)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_abline(slope = results$estimate[2], 
              intercept = results$estimate[1], 
              color = "blue",
              size = 1.5) 


# 4. Multivariate models ----
# listing price might not only correlates with accommodates, but other variables
# what variables do you think might be associated with listing price?
# we can add them into the regression model

# big model: include accommodates, bedrooms, room_type, neighbourhood_group
price_model_big <- lm(price ~ accommodates+bedrooms+room_type+neighbourhood_group, data = dat)


# tidy the results
tidy(price_model_big, conf.int = TRUE)
# what is the coefficient of `accommodates` now? 
# is it the same as the one we obtained from univariate model?
# how do we interpret this coefficient?
# how to interpret other coefficients?

# how do we visualize all the coefficients at one plot?

# plot the point estimate and confidence intervals with geom_pointrange()
price_coef <- tidy(price_model_big, conf.int = TRUE) %>% 
  filter(term != "(Intercept)")
price_coef

ggplot(price_coef, 
       aes(x = estimate,
           y = fct_rev(term))) +
  geom_pointrange(aes(xmin = conf.low,
                      xmax = conf.high)) +
  geom_vline(xintercept = 0, color = "red")


# next, let's plot the marginal effect of accommodations
# we want to hold other attributes fixed 
# hold bedrooms at its mean, fix room_type at private room, and neighbourhood_group at Manhattan

# create a dataset with accommodates change from 1 to 10, and other variables hold constant at the chosen level
listings_new_data <- tibble(accommodates = c(1:10),
                            bedrooms = mean(dat$bedrooms, na.rm = T),
                            room_type = "Private room",
                            neighbourhood_group = "Manhattan")


predicted_price <- augment(price_model_big,
                            newdata = listings_new_data,
                            se_fit = TRUE)

predicted_price

ggplot(predicted_price,
       aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit)),
              fill = "skyblue",
              alpha = 0.5) +
  geom_line(size = 1, color = "blue") +
  scale_x_continuous(breaks = seq(2,10,2))

# how to visualize multiple marginal effects for different room types? 
# still hold bedrooms at its mean level, and fix neighbourhood group at Manhattan
listings_new_data_fancy <- expand_grid(accommodates = c(1:10),
                                        bedrooms = mean(dat$bedrooms, na.rm = T),
                                        room_type = c("Private room","Entire home/apt"),
                                        neighbourhood_group = "Manhattan") 

predicted_price_fancy <- augment(price_model_big,
                           newdata = listings_new_data_fancy,
                           se_fit = TRUE)

predicted_price_fancy

ggplot(predicted_price_fancy,
       aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit),
              fill = room_type),
              alpha = 0.5) +
  geom_line(aes(color = room_type), size = 1) +
  scale_x_continuous(breaks = seq(2,10,2))

# or facet the plot by room type
ggplot(predicted_price_fancy,
       aes(x = accommodates, y = .fitted)) +
  geom_ribbon(aes(ymin = .fitted+(-1.96 * .se.fit),
                  ymax = .fitted+(1.96 * .se.fit),
                  fill = room_type),
              alpha = 0.5) +
  geom_line(aes(color = room_type), size = 1) +
  scale_x_continuous(breaks = seq(2,10,2)) +
  facet_wrap(~room_type)


