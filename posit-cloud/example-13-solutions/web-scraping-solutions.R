# AEM 2850 - Example 13
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages
library(rvest) # load rvest (from tidyverse) for web scraping

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


# 2. Scraping countries of the world ----
# for more practice, scrape from: https://www.scrapethissite.com/pages/simple/
# first, check robots.txt: https://www.scrapethissite.com/robots.txt
# does robots.txt disallow us from using data on sites under /pages/?

# read in the html code from the site once and assign it to countries_html
countries_html <- read_html("https://www.scrapethissite.com/pages/simple/")

# use SelectorGadget to identify a selector we could use to get country names
# use it to extract country names and convert them to text
# assign the result to `names`
names <- countries_html |>
  html_elements(".country-name") |>
  html_text2()

# do the same for `capitals`
capitals <- countries_html |>
  html_elements(".country-capital") |>
  html_text2()

# do the same for `populations`
populations <- countries_html |>
  html_elements(".country-population") |>
  html_text2()

# do the same for `areas`
areas <- countries_html |>
  html_elements(".country-area") |>
  html_text2()

# put all the data together in a data frame with one row per country
# and columns that contain capitals, populations, and areas
countries <- tibble(
  country = names,
  capital = capitals,
  population = populations,
  area = areas
)

# remove any countries without (human) inhabitants
# convert the population and area figures to numeric data using type_convert()
countries <- countries |>
  filter(population!=0) |>
  type_convert()

# what are the top 10 countries by land area?
countries |>
  slice_max(order_by = area, n = 10) |>
  arrange(desc(area))


# 3. Scraping hockey team stats ----
# stats at: https://www.scrapethissite.com/pages/forms/

# start by using the CSS selector "table" to scrape the data in the table
# how many results did you get?
hockey_stats <- read_html("https://www.scrapethissite.com/pages/forms/") |>
  html_element("table") |>
  html_table()
hockey_stats |>
  count()

# go back to the site and select 100 results Per Page
# copy the new url and scrape those 100
# how many results did you get?
more_hockey_stats <- read_html("https://www.scrapethissite.com/pages/forms/?page_num=1&per_page=100") |>
  html_element("table") |>
  html_table()
more_hockey_stats |>
  count()

# to get all the data, we have two options:
# 1. test whether we can modify the url above to return more results
# 4. write a function that can extract the results page-by-page
# let's try option #1 for time. see the solutions for option #2

# option 1:
# modify your url above to scrape 500 results rather than 100
# how many results did you get? did you get all of them?
all_hockey_stats <- read_html("https://www.scrapethissite.com/pages/forms/?page_num=1&per_page=500") |>
  html_element("table") |>
  html_table()
all_hockey_stats |>
  count()

# modify your url above to scrape 1000 results rather than 500
# how many results did you get? did you get all of them?
all_hockey_stats <- read_html("https://www.scrapethissite.com/pages/forms/?page_num=1&per_page=1000") |>
  html_element("table") |>
  html_table()
all_hockey_stats |>
  count()

# option 2:
# write a function that can extract the results on any page, not just page 1
get_hockey_stats <- function(this_page_num) {
  "https://www.scrapethissite.com/pages/forms/?page_num={this_page_num}&per_page=100" |>
    str_glue() |>
    read_html() |>
    html_element("table") |>
    html_table()
}

# use map with the function to extract data from all the pages
# use bind_rows() to combine the list of data frames into a single data frame
all_hockey_stats <- map(
  1:6,
  get_hockey_stats
) |>
  bind_rows()

# how many results does the final data frame have?
all_hockey_stats |>
  count()

# which team had the highest `Win %` in 2009?
all_hockey_stats |>
  filter(Year==2009) |>
  slice_max(`Win %`, n = 1) |>
  pull(`Team Name`)


# 4. Stock prices ----
# let's start by writing a script to get historical price data for one ticker

# 4.1: go to https://finance.yahoo.com and look up the ticker AAPL

# 4.2: navigate the site to find historical data
# by default the site displays daily prices for the past year
# later we could explore how to scrape other historical data
# copy and paste the url, strip tracking info, and assign to stock_url
stock_url <- "https://finance.yahoo.com/quote/AAPL/history"

# use read_html() to get the html code, assign to stock_html
stock_html <- read_html(stock_url)
# what does stock_html look like? what went wrong?
stock_html

# let's try again using: stock_url <- "https://stooq.com/q/d/?s=aapl.us"
stock_url <- "https://stooq.com/q/d/?s=aapl.us"
# use read_html() to get the html code, assign to stock_html
stock_html <- read_html(stock_url)
# did it work?
stock_html


# 4.3: use html_element() to extract the table code, assign it to stock_element
# the SelectorGadget tool may not work for you on this site
# so you can use the selector "table#fth1" here
stock_element <- stock_html |> html_element("table#fth1")

# 4.4: use html_table() to convert html code to a table, assign to stock_table
stock_table <- html_table(stock_element)
# what does stock_table look like?
stock_table

# we have a problem! the column headers are in the first row of data
# luckily, html_table() can fix this if we add the argument header = TRUE
stock_table <- html_table(stock_element, header = TRUE)
# what does stock_table look like now?
stock_table

# we have a new problem: two columns have the same name (Change)
# we are not interested in them, so let's remove them to avoid errors
stock_table <- stock_table |> select(-Change)

# 4.5: plot stock open prices over the past two months
# this will require converting dates from character to date format
stock_table |>
  mutate(Date = dmy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line()


# 5. Write a pipeline that produces a plot for any ticker ----
# first, combine the steps above into a single pipeline for the original ticker
# customize the plot title to include the ticker
stock_url |>
  read_html() |>
  html_element("table#fth1") |>
  html_table(header = TRUE) |>
  select(-Change) |>
  mutate(Date = dmy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line() +
  labs(x = NULL,
       y = "Share price (open, $)",
       title = str_glue("Symbol: AAPL")) +
  theme_bw()

# second, assign "AAPL" to the name symbol
symbol <- "AAPL" # "NVDA" # "TSLA"

# now start the pipeline by using str_glue() to construct a url based on symbol
# customize the title to include the ticker
str_glue("https://stooq.com/q/d/?s={symbol}.us") |>
  read_html() |>
  html_element("table#fth1") |>
  html_table(header = TRUE) |>
  select(-Change) |>
  mutate(Date = dmy(Date)) |>
  ggplot(aes(x = Date, y = Open)) +
  geom_line() +
  labs(x = NULL,
       y = "Share price (open, $)",
       title = str_glue("Symbol: {symbol}")) +
  theme_bw()

# go back and assign a new ticker to symbol, then run the code. did it work?
# if not, go back to revise your code so that it is robust to different cases!


# nice work!
# though our results are not perfect:
# - what if we want a longer time period?
# - a different time period?
# our options depend on the site(s) we can scrape data from


# 6. Scrape something else you are interested in ----
# if we have spare time, experiment with applying these tools elsewhere:
# https://books.toscrape.com
# https://www.billboard.com/charts/hot-100/
