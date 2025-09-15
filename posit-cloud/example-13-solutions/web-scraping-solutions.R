# AEM 2850 - Example 13
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions
# - Note: this week I am providing code scaffolding since the concepts are new


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages
library(rvest) # load rvest (from tidyverse) for web scraping

# set a user agent for simulating a web browser session later
library(httr) # load httr, which is installed as a dependency of the tidyverse
agent <- user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer


# 1. robots.txt ----
# so far we have scraped data from wikipedia without much on legality or ethics
# we acknowledged that scraping is costly to "us" and "them"
# but how do we know what we "should" and "should not" scrape?

# one way is the Robots Exclusion Protocol: https://en.wikipedia.org/wiki/Robots.txt
# this is a voluntary standard for web scraping
# in which site owners provide guidance via robots.txt files

# let's look at a simple example from reddit: https://www.reddit.com/robots.txt/
# do they want us to scrape data?

# let's take a look at wikipedia's version: https://en.wikipedia.org/robots.txt
# for generic users (User-agent: *), they say that
"Friendly, low-speed bots are welcome viewing article pages, but not dynamically-generated pages please."

# another site we will use in this example is yahoo finance
# look at https://finance.yahoo.com/robots.txt to see their scraping policy
# for scraping algorithms like anthropic-ai, they disallow the entire site
# for others, like us, they disallow specific pages (but not /quote)


# 2. SelectorGadget ----
# we will use the extension/bookmarklet SelectorGadget to help find css selectors

# 2.1 set up SelectorGadget
# there is an extension available for chrome and a bookmarklet for other browsers
# go to https://selectorgadget.com and set it up on your laptop if you haven't already

# 2.2 test out SelectorGadget on https://en.wikipedia.org/wiki/Cornell_Big_Red
# first, enable SelectorGadget and click on "Baseball" under "Championship teams
# what CSS selector appears in the SelectorGadget bar?
"dt"

# next, press Clear
# align your cursor so the entire table of sports is highlighted, and click
# what CSS selector appears in the SelectorGadget bar?
".wikitable"


# 3. Stock prices from Yahoo! Finance ----
# let's start by writing a script to get historical price data for one ticker

# 3.1: go to https://finance.yahoo.com and look up a ticker

# 3.2: navigate the site to find historical data
# by default the site displays daily prices for the past year
# later we could explore how to scrape other historical data
# copy and paste the url, strip tracking info, and assign to stock_url
stock_url <- "https://finance.yahoo.com/quote/AAPL/history"

# 3.2: use read_html() to get the html code, assign to stock_html
stock_html <- read_html(stock_url)
# what does stock_html look like? what went wrong?
stock_html

# one way to get around this is to using `session()` to simulate a web browser
#   here we use the arguments `stock_url` and `agent` specified above
#   then pass the session to `read_html()`
stock_html <- stock_url |>
  session(agent) |>
  read_html()
# what does stock_html look like? what went wrong?
stock_html

# NOTE: if you run into problems reading the site via the posit cloud server,
#   comment out the code below to load `stock_html` from disk
## xml2::write_xml(stock_html, file = "aapl.html")
# stock_html <- xml2::read_html("aapl.html")

# 3.3: use html_element() to extract the table's html code, assign to stock_element
# the SelectorGadget tool may not work for you on yahoo finance
# so you can use the selector "table" (both in SelectorGadget and here)
stock_element <- stock_html |> html_element("table")

# 3.4: use html_table() to convert html code to a table, assign to stock_table
stock_table <- html_table(stock_element)
# what does stock_table look like?
stock_table

# 3.5: plot stock open prices over time
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


# 4. Use your code above to write a pipeline that produces a plot for any ticker ----
# note: next week we will see how code like this can be called via functions

# first, combine the steps above into a single pipeline for the original ticker
# customize the plot title to include the ticker
stock_url |>
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
  filter(!str_detect(Open, "Close price|Dividend|Stock Splits")) |>
  type_convert() |>
  mutate(Date = mdy(Date)) |>
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
# Homework-13 will extend and generalize this example while practicing functions


# 5. Scraping countries of the world ----
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
# convert the population and area figures to numeric data using `type_convert`
countries <- countries |>
  filter(population!=0) |>
  type_convert()

# what are the top 10 countries by land area?
countries |>
  slice_max(order_by = area, n = 10) |>
  arrange(desc(area))


# 6. Scraping hockey team stats ----
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


# 7. Scrape something else you are interested in ----
# if we have spare time, experiment with applying these tools elsewhere

