# AEM 2850 - Example 14
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll use data on stock prices from the S&P 500
# these are the same data we used for mini project 1


# 0. Import S&P 500 data ----
# load S&P 500 data
load("sp500.RData")
# what variables do we have in sp500_prices?
names(sp500_prices)

# for simplicity, let's start by filtering out companies that entered the S&P 500 during 2018-2022
prices <- sp500_prices |>
  group_by(symbol) |>
  mutate(count = n()) |>
  ungroup() |>
  filter(count == max(count)) |>
  select(-count)


# 1. Writing a simple function ----
# let's write a function that takes one argument: a symbol
# and returns one number: that symbol's annualized return over 2018-2022
# where to start?

# let's try a test case!
# what company do you want to use? what symbol?
# for simplicity we can start by hard-coding the time length (5 years)


# now generalize that into a function that takes the argument ticker


# test it out a few times




# what happens if we give a ticker that doesn't exist?



# 2. Conditional execution ----
# how can we avoid errors like this, or return a more informative error?
# we can use control flow based on conditions that are either TRUE or FALSE
# first use pull(symbol) to create an object symbols with all the tickers
# then use that in an if statement to either make the plot or return a message





# 3. Mapping over multiple tickers ----
# we can easily extend our computations to a vector of tickers by iteration or mapping
# how would we do that using map?


# what if we wanted to return these numbers as a double vector instead of a list vector?


# what happens if we try those again, but with a missing ticker?





# 4. Extending our function to multiple tickers ----
# now let's allow the function to compute returns for multiple tickers
# what type of object(s) should it return?

# one option is a data frame
# for a data frame, you can return errors for missing symbols,
# or just embed them as missing values in the data frame. try this option


# test it out with a short list of tickers


# now include a ticker that doesn't exist -- what happens?



# 5. Get creative! ----
# you can take this a lot further. try...
# writing a function to compute portfolio returns
# generalizing the time range for calculations
# using some other metric(s) to compare and select between portfolios
# or, write a function for a completely different purpose!

