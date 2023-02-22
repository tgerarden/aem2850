# AEM 2850 - Example 12
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(lubridate)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll use data on stock prices from the S&P 500
# these are the same data we used for mini project 1


# 0. Import S&P 500 data ----
# load S&P 500 data
load("sp500.RData")
# what variables do we have?
names(sp500_prices)
names(sp500_companies)

# for simplicity, let's start by filtering out companies that entered the S&P 500 during 2017-201
prices <- sp500_prices %>%
  group_by(symbol) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  filter(count == max(count)) %>%
  select(-count)


# 1. Writing a simple function ----
# let's write a function that takes one argument: a symbol
# and returns one number: that symbol's annualized return over 2017-2021
# where to start?

# let's try a test case!
# what company do you want to use? what symbol?
# for simplicity we can start by hard-coding the time length (5 years)
prices %>%
  filter(symbol == "NFLX") %>%
  filter(date==min(date) | date==max(date)) %>%
  mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) %>%
  filter(!is.na(cumulative_return)) %>%
  transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) %>%
  pull(annualized_return)

# now generalize that into a function
get_annual_return <- function(ticker){
  prices %>%
    filter(symbol == ticker) %>%
    filter(date==min(date) | date==max(date)) %>%
    mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) %>%
    filter(!is.na(cumulative_return)) %>%
    transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) %>%
    pull(annualized_return)
}

# test it out a few times
get_annual_return("NFLX")
get_annual_return("AAPL")
get_annual_return("NVDA")
get_annual_return("TSLA")

# what happens if we give a ticker that doesn't exist?
get_annual_return("WTF")


# 2. Conditional execution ----
# how can we avoid errors like this, or return a more informative error?
# we can use control flow based on conditions that are either TRUE or FALSE
get_annual_return <- function(ticker){
  if(ticker %in% prices$symbol){
    prices %>%
      filter(symbol == ticker) %>%
      filter(date==min(date) | date==max(date)) %>%
      mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) %>%
      filter(!is.na(cumulative_return)) %>%
      transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) %>%
      pull(annualized_return)
  } else {
    paste("The ticker", ticker, "is not available.")
  }
}

get_annual_return("WTF")


# 3. Mapping over multiple tickers ----
# we can easily extend our computations to a vector of tickers by iteration or mapping
# how would we do that using map?
map(c("AAPL", "NVDA", "TSLA"),
    get_annual_return)

# what if we wanted to return these numbers as a double vector instead of a list vector?
map_dbl(c("AAPL", "NVDA", "TSLA"),
        get_annual_return)

# what happens if we try those again, but with a missing ticker?
map(c("AAPL", "NVDA", "TSLA", "WTF"),
    get_annual_return)

map_dbl(c("AAPL", "NVDA", "TSLA", "WTF"),
        get_annual_return)


# 4. Extending our function to multiple tickers ----
# now let's allow the function to compute returns for multiple tickers
# what type of object(s) should it return?

# one option is a data frame
# for a data frame, you can return errors for missing symbols,
# or just embed them as missing values in the data frame. try this option
get_annual_returns <- function(ticker){
  prices %>%
    filter(symbol %in% ticker) %>%
    group_by(symbol) %>%
    filter(date==min(date) | date==max(date)) %>%
    mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) %>%
    filter(!is.na(cumulative_return)) %>%
    transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) %>%
    select(symbol, annualized_return) %>%
    left_join(tibble(symbol = ticker),
              ., # these are our returns
              by = "symbol")
}

# test it out with a short list of tickers
get_annual_returns(c("AAPL", "NVDA", "TSLA"))

# now include a ticker that doesn't exist
get_annual_returns(c("AAPL", "WTF", "TSLA"))


# 5. Get creative! ----
# you can take this a lot further. try...
# writing a function to compute portfolio returns
# generalizing the time range for calculations
# using some other metric(s) to compare and select between portfolios


