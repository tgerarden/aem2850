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
prices |>
  filter(symbol == "NFLX") |>
  filter(date==min(date) | date==max(date)) |>
  mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
  filter(!is.na(cumulative_return)) |>
  transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
  pull(annualized_return)

# now generalize that into a function that takes the argument ticker
get_annual_return <- function(ticker){
  prices |>
    filter(symbol == ticker) |>
    filter(date==min(date) | date==max(date)) |>
    mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
    filter(!is.na(cumulative_return)) |>
    transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
    pull(annualized_return)
}

# test it out a few times
get_annual_return("NFLX")
get_annual_return("AAPL")
get_annual_return("AMZN")
get_annual_return("TSLA")

# what happens if we give a ticker that doesn't exist?
get_annual_return("WTF")


# 2. Conditional execution ----
# how can we avoid errors like this, or return a more informative error?
# we can use control flow based on conditions that are either TRUE or FALSE
# first use pull(symbol) to create an object symbols with all the tickers
# then use that in an if statement to either make the plot or return a message
get_annual_return <- function(ticker){
  symbols <- prices |> pull(symbol) # or instead put prices$symbol within the if()
  if(ticker %in% symbols){
    prices |>
      filter(symbol == ticker) |>
      filter(date==min(date) | date==max(date)) |>
      mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
      filter(!is.na(cumulative_return)) |>
      transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
      pull(annualized_return)
  } else {
    str_glue("The ticker {ticker} is not available.")
  }
}

get_annual_return("WTF")


# 3. Mapping over multiple tickers ----
# we can easily extend our computations to a vector of tickers by iteration or mapping
# how would we do that using map?
map(c("AAPL", "AMZN", "TSLA"),
    get_annual_return)

# what if we wanted to return these numbers as a double vector instead of a list vector?
map_dbl(c("AAPL", "AMZN", "TSLA"),
        get_annual_return)

# what happens if we try those again, but with a missing ticker?
map(c("AAPL", "AMZN", "TSLA", "WTF"),
    get_annual_return)

map_dbl(c("AAPL", "AMZN", "TSLA", "WTF"),
        get_annual_return)


# 4. Extending our function to multiple tickers ----
# now let's allow the function to compute returns for multiple tickers
# what type of object(s) should it return?

# one option is a data frame
# for a data frame, you can return errors for missing symbols,
# or just embed them as missing values in the data frame. try this option
get_annual_returns <- function(ticker){
  # compute annual returns for all the symbols in the argument ticker
  annual_returns <- prices |>
    filter(symbol %in% ticker) |>
    group_by(symbol) |>
    filter(date==min(date) | date==max(date)) |>
    mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
    filter(!is.na(cumulative_return)) |>
    transmute(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
    select(symbol, annualized_return)
  # join with original tickers to make sure missing values remain
  left_join(tibble(symbol = ticker),
            annual_returns, # these are our returns
            join_by(symbol))
}

# test it out with a short list of tickers
get_annual_returns(c("AAPL", "AMZN", "TSLA"))

# now include a ticker that doesn't exist -- what happens?
get_annual_returns(c("AAPL", "WTF", "TSLA"))


# 5. Get creative! ----
# you can take this a lot further. try...
# writing a function to compute portfolio returns
# generalizing the time range for calculations
# using some other metric(s) to compare and select between portfolios


