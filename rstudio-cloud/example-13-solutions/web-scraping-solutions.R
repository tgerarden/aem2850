# AEM 2850 - Example 13
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions
# - Note: this week I am providing code scaffolding since the concepts are new


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(rvest) # load rvest (from tidyverse) for web scraping

# set a user agent for simulating a web browser session later
library(httr) # load httr, which is installed as a dependency of the tidyverse
agent <- user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer


# 1. SelectorGadget ----
# we will use the extension/bookmarklet SelectorGadget to help find css selectors

# 1.1 set up SelectorGadget
# there is an extension available for chrome and a bookmarklet for other browsers
# go to https://selectorgadget.com and set it up on your laptop if you haven't already

# 1.2 test out SelectorGadget on https://en.wikipedia.org/wiki/Cornell_Big_Red
# first, enable SelectorGadget and click on "Baseball" under "Championship teams
# what CSS selector appears in the SelectorGadget bar?
"dt"

# next, press Clear
# align your cursor so the entire table of sports is highlighted, and click
# what CSS selector appears in the SelectorGadget bar?
".wikitable"


# 2. Stock prices from Yahoo! Finance ----
# let's start by writing a script to get historical price data for one ticker

# 2.1: go to https://finance.yahoo.com and look up a ticker

# 2.2: navigate the site to find historical data
# by default the site displays daily prices for the past year
# later we could explore how to scrape other historical data
# copy and paste the url, strip tracking info, and assign to stock_url
stock_url <- "https://finance.yahoo.com/quote/AAPL/history"

# 2.2: use read_html() to get the html code, assign to stock_html
stock_html <- read_html(stock_url)
# what does stock_html look like? what went wrong?
stock_html

# one way to get around this is to using `session()` to simulate a web browser
#   here we use the arguments `stock_url` and `agent` specified above
#   then pass the session to `read_html()`
stock_html <- session(stock_url, agent) |>
  read_html()
# what does stock_html look like? what went wrong?
stock_html

# NOTE: if you run into problems reading the site via the posit cloud server,
#   comment out the code below to load `stock_html` from disk
## xml2::write_xml(stock_html, file = "aapl.html")
# stock_html <- xml2::read_html("aapl.html")

# 2.3: use html_element() to extract the table's html code, assign to stock_element
# it may be hard to use SelectorGadget to isolate the tabular data on yahoo finance
# instead, you can use the selector "table" (both in SelectorGadget and here)
stock_element <- stock_html |> html_element("table")

# 2.4: use html_table() to convert html code to a table, assign to stock_table
stock_table <- html_table(stock_element)
# what does stock_table look like?
stock_table

# 2.5: plot stock open prices over time
# this will require some modest data cleaning. you can either:
#   (1) coerce Open to numeric and filter out NA values, or
#   (2) filter out rows with characters in Open and then
#     use type_convert() to detect/convert column types
stock_table |>
  filter(!str_detect(Open, "Close price|Dividend")) |>
  type_convert() |>
  mutate(Date = mdy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line()


# 3. Use your code above to write a pipeline that produces a plot for any ticker ----
# note: next week we will see how code like this can be called via functions

# first, combine the steps above into a single pipeline for the original ticker
# customize the plot title to include the ticker
session(stock_url, agent) |>
  read_html() |>
  html_element("table") |>
  html_table() |>
  filter(!str_detect(Open, "Close price|Dividend")) |>
  type_convert() |>
  mutate(Date = mdy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line() +
  labs(x = NULL,
       y = "Share price (open, $)",
       title = str_glue("Symbol: AAPL")) +
  theme_bw()

# second, assign "AAPL" to the name symbol
symbol <- "AAPL" # "NVDA" # "TSLA"

# now start the pipeline by using str_glue() to construct a url based on symbol
# see if you can customize the title to include the ticker
str_glue("https://finance.yahoo.com/quote/{symbol}/history") |>
  session(agent) |>
  read_html() |>
  html_element("table") |>
  html_table() |>
  filter(!str_detect(Open, "Close price|Dividend")) |>
  type_convert() |>
  mutate(Date = mdy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line() +
  labs(x = NULL,
       y = "Share price (open, $)",
       title = str_glue("Symbol: {symbol}")) +
  theme_bw()

# go back and assign a new ticker to symbol, then run the code. did it work?


# nice work!
# though our results are not perfect:
# - what if we want a longer time period?
# - a different time period?
# - what if we don't like dealing with cleaning/type conversion?
# Option 1: is we could revisit and tweak our approach to scraping data
# Option 2: approach this same problem in a totally different way...


# 4. Write a script to download csv files from yahoo finance ----
# look back at the historical data and you'll see a download link
# if you download the file you will see it is a csv file
# let's write a function to get data by reading these csv files
# right-click and Copy Link, then paste here and assign it to csv_url
csv_url <- "https://query1.finance.yahoo.com/v7/finance/download/AAPL?period1=1682384546&period2=1714006946&interval=1d&events=history&includeAdjustedClose=true"

# use read_csv() to read this csv and assign it to csv_prices
csv_prices <- read_csv(csv_url)

# plot AAPL open prices over the past year
csv_prices |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line()

# now let's modify our code above to make a plot for any ticker
# you can strip the end of the url starting at "interval" for convenience
# as before, assign "AAPL" to symbol and test that it works
symbol <- "AAPL"

str_glue("https://query1.finance.yahoo.com/v7/finance/download/{symbol}?period1=1651022448&period2=1682558448") |>
  read_csv() |>
    ggplot(aes(x = Date, y = Open)) +
    geom_line() +
    labs(x = NULL,
         y = "Share price (open, $)",
         title = paste0("Symbol: ", symbol)) +
    theme_bw()

# go back and assign a new ticker to symbol, then run the code. did it work?


# how could you modify this function to make plots for different date ranges?



# 5. Scrape something else you are interested in ----
# if we have spare time, experiment with applying these tools to some other site(s)
# for example: prices for your own favorite product

