# AEM 2850 - Example 12-2
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

# today we'll use data on stock prices from the S&P 500 from 2020-2025


# 0. Import S&P 500 data ----
# load S&P 500 data
load("sp500.RData")
# what variables do we have in sp500_prices?
names(sp500_prices)

# for simplicity, filter out companies that entered S&P 500 during data period
prices <- sp500_prices |>
  group_by(symbol) |>
  mutate(count = n()) |>
  ungroup() |>
  filter(count == max(count)) |>
  select(-count)


# 1. Conditional execution ----
# recall our function from last week to compute returns for a ticker:
get_annual_return <- function(ticker){
  prices |>
    filter(symbol == ticker) |>
    filter(date==min(date) | date==max(date)) |>
    mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
    filter(!is.na(cumulative_return)) |>
    transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
    pull(annualized_return)
}

# what happens if we give a ticker that doesn't exist?
get_annual_return("WTF")


# how can we avoid errors like this, or return a more informative error?
# we can use control flow based on conditions that are either TRUE or FALSE
# first use pull(symbol) to create an object symbols with all the tickers
# then use that in an if statement to either make the plot or print a message
# after printing the message, add NA so the function returns a missing value


# test your revised function using a ticker that does exist


# test your revised function using a ticker that doesn't exist

































# X. Get creative! ----
# you can take this a lot further. try...
# writing a function to compute portfolio returns
# generalizing the time range for calculations
# using some other metric(s) to compare and select between portfolios
# or, write a function for a completely different purpose!

