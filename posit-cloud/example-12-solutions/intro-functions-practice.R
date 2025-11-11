# AEM 2850 - Example 12
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
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

# compute NVDA's return over 5 years
nvda_return <- prices |>
  filter(symbol == "NVDA") |>
  filter(date==min(date) | date==max(date)) |>
  mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
  filter(!is.na(cumulative_return)) |>
  pull(cumulative_return)

nvda_return

str_glue("NVDA's 5-year cumulative return was {round(nvda_return*100)}%.")


# 1. Computing annualized returns from cumulative returns ----
# let's write a function that:
#   - takes one argument: a cumulative return over 5 years
#   - returns one number: the annualized return
# where to start?

# let's try a test case using NVIDIA
((1 + nvda_return)^(1/5) - 1) * 100

# now generalize that into a function annualized_return
# that takes the argument cumulative_return


# call that function with the arguments:
# nvda_return, 0 (0%), 0.5 (50%)





# 2. Computing annualized returns over different time horizons ----
# let's write a function that:
#   - takes two arguments: a cumulative return, and a number of years
#   - returns one number: the annualized return
# where to start?

# let's try a test case using NVIDIA, with years <- 5
years <- 5
((1 + nvda_return)^(1/years) - 1) * 100

# now generalize that into a function annualized_return
# that takes the arguments cumulative_return and years




# call that function with the argument nvda_return

# what went wrong?
# note that the function did not find the object years from the test case. why?

# call that function with the arguments nvda_return, 5


# call that function with the arguments nvda_return, 50



# 3. Computing annualized returns from tickers ----
# let's write a function that:
#   - takes one argument: a symbol
#   - returns one number: that symbol's annualized return over the data period
# where to start?

# let's try a test case using NVIDIA
# for simplicity we can start by hard-coding the time length (5 years)
prices |>
  filter(symbol == "NVDA") |>
  filter(date==min(date) | date==max(date)) |>
  mutate(cumulative_return = (adjusted - lag(adjusted)) / lag(adjusted) ) |>
  filter(!is.na(cumulative_return)) |>
  mutate(annualized_return = ((1 + cumulative_return)^(1/5) - 1) * 100) |>
  pull(annualized_return)

# now generalize that into a function that takes the argument ticker


# test it out with a few different tickers






# 4. Mapping over multiple tickers ----
# we can easily extend our work to a vector of tickers by iteration or mapping
# how would we do that using map?


# what if we wanted to return these numbers as a double vector instead of a list vector?


# what happens if we try those again, but with a missing ticker?





# 5. Extending our function to multiple tickers ----
# now let's allow the function to compute returns for multiple tickers
# what type of object(s) should it return?

# one option is a data frame
# start by computing returns for all symbols in the data frame also in tickers


# test it out with a short list of tickers


# now include a ticker that doesn't exist
# what happens? how could we fix it?


# modify the function to include missing tickers in the output:
#   1. compute annualized returns as above
#   2. use tibble to create a data frame with column symbol based on ticker
#   3. join the tibble with annualized returns by symbol, return the result


# test this function. what happens now?



# 6. Time permitting: for loops----
# write a for loop that calls your original function `get_annual_return`
# for a number of tickers and combines the results in a double vector
# if you have extra time, try doing it again, but store the results in a list

