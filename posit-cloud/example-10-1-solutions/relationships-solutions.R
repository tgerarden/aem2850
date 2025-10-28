# AEM 2850 - Example 10-1
# Plan for today:
# - Go through slides
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages

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

# first, let's use a histogram to look at the distribution of price
# color the edges of the bars white, set the boundary at 0, and bindwidth to 200
listings |>
  ggplot(aes(x = price)) +
  geom_histogram(color = "white", binwidth = 200, boundary = 0)

# what is the minimum price?
listings |>
  summarize(min(price))

# now, let's look at the distribution of accommodates
# this time, set the binwidth to 1
listings |>
  ggplot(aes(x = accommodates)) +
  geom_histogram(color = "white", binwidth = 1, boundary = 0)

# what is the minimum accommodates?
listings |>
  summarize(min(accommodates))

# finally, let's look at the variable bathrooms_text
# here, instead of a histogram, map bathrooms_text to y and add geom_bar
listings |>
  ggplot(aes(y = bathrooms_text)) +
  geom_bar()

# let's explore the relationship between prices and some room characteristics
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

# it's intuitive that prices would be higher if a property
# has more bathrooms or can hold more people
# how can we visualize these relationships?


# 2. Relationships between numerical and categorical variables ----

# what type of variable is bathrooms_text?
prices |> pull(bathrooms_text) |> class()

# make a boxplot of price on the x axis and bathrooms_text on the y axis
# is there a clear relationship between the two variables?
prices |>
  ggplot(aes(x = price, y = bathrooms_text)) +
  geom_boxplot()

# let's filter the data:
# exclude bathrooms_text that contain shared or don't start with a number
# then reproduce the boxplot
# is there a clear relationship between the two variables now?
prices |>
  filter(!str_detect(bathrooms_text, "(s|S)hared")) |>
  filter(str_detect(bathrooms_text, "^[0-9]")) |>
  ggplot(aes(x = price, y = bathrooms_text)) +
  geom_boxplot()

# now let's look at the relationship between price and accommodates
# map accommodates to the x axis and price to the y axis, and add geom_boxplot
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_boxplot()

# what went wrong?
# fix it by treating accommodates as a factor (i.e., categorical) variable
prices |>
  ggplot(aes(x = as_factor(accommodates), y = price)) +
  geom_boxplot()


# 3. Scatter plots ----
# instead of treating accommodates as a factor with a fix set of values,
# we could treat it as a continuous numerical variable
# scatter plots are great for relationships between two numerical variables

# use a scatter plot to visualize the association between price and accommodates
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point()

# label the x-axis by 1, 2, ..., 10 using the breaks arg. to scale_x_continuous
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point() +
  scale_x_continuous(breaks = 1:10)

# a lot of points lay on top of each other at the lower end of prices
# use the geom_point argument alpha = 0.1 to help visualize them
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(alpha = 0.1) +
  scale_x_continuous(breaks = 1:10)

# that's better, but it's still hard to see patterns due to overplotting
# another option is to add noise to the points to help differentiate them
# try this using the geom_point argument position = "jitter"
# adjust their size and transparency by setting size = 0.1, alpha = 0.5
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 0.5) +
  scale_x_continuous(breaks = 1:10)

# do price and accommodates show any correlation?
prices |>
  summarize(correlation = cor(accommodates, price))

# what if we use log_price on the y-axis?
prices |>
  ggplot(aes(x = accommodates, y = log_price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  scale_x_continuous(breaks = 1:10)

# the relationship between log_price and accommodates looks a bit different
# now check the correlation coefficient between log_price and accommodation
prices |>
  summarize(correlation = cor(accommodates, log_price))

# let's go back to price (not log_price)
# add a layer with a flexible fit to the data using geom_smooth()
prices |>
  ggplot(aes(x = accommodates, y = price)) +
  geom_point(position = "jitter", size = 0.1, alpha = 1) +
  geom_smooth()

# does a linear model seem like a reasonable approximation to this line?

