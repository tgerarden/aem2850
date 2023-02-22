# AEM 2850 - Example 14
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
library(lubridate) # load lubridate (from tidyverse) for working with dates

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer


# 1. Set up SelectorGadget ----
# we will use the extension/bookmarklet SelectorGadget to help find css selectors
# there is an extension available for chrome and a bookmarklet for other browsers
# go to https://selectorgadget.com and set it up on your laptop if you haven't already


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
# what does stock_html look like?
stock_html

# 2.3: use html_element() to try to extract html code for the table
# it's hard to use SelectorGadget to isolate the tabular data on yahoo finance
# instead, you can use the selector "table" (both in SelectorGadget and here)
stock_element <- html_element(stock_html, "table")

# 2.4: use html_table() to convert html code to a table
stock_table <- html_table(stock_element)

# 2.5: plot stock open prices over time
# this will require some modest data cleaning
stock_table %>%
  filter(!str_detect(Open, "Close price|Dividend")) %>%
  type_convert() %>%
  mutate(Date = mdy(Date)) %>%
  ggplot(aes(x = Date, y = Open)) +
  geom_line()


# 3. Use your code above to define a function to produce a plot for any ticker ----
# test that the script works for your ticker above
# use map to call this function for three tickers and look at the plots
plot_prices <- function(symbol_choice) {
  paste0("https://finance.yahoo.com/quote/", symbol_choice, "/history") %>%
    read_html() %>%
    html_element("table") %>%
    html_table() %>%
    filter(!str_detect(Open, "Close price|Dividend")) %>%
    type_convert() %>%
    mutate(Date = mdy(Date)) %>%
    ggplot(aes(x = Date, y = Open)) +
    geom_line() +
    labs(x = NULL,
         y = "Share price (open, $)",
         title = paste0("Symbol: ", symbol_choice)) +
    theme_bw()
}

plot_prices("AAPL")

plots <- map(c("AAPL", "NVDA", "TSLA"),
             plot_prices)

plots[[2]]

# nice work!
# though we might have some issues:
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
csv_url <- "https://query1.finance.yahoo.com/v7/finance/download/AAPL?period1=1620154969&period2=1651690969&interval=1d&events=history&includeAdjustedClose=true"

# use read_csv() to read this csv and assign it to csv_prices
csv_prices <- read_csv(csv_url)

# plot AAPL open prices over the past year
csv_prices %>%
  ggplot(aes(x = Date, y = Open)) +
  geom_line()

# now let's modify our function above to make a plot for any ticker
# test that the script works for your ticker above
# use map to call this function for three tickers and look at the plots
plot_csv_prices <- function(symbol_choice) {
  paste0("https://query1.finance.yahoo.com/v7/finance/download/",
         symbol_choice,
         "?period1=1620154969&period2=1651690969") %>%
  read_csv() %>%
    ggplot(aes(x = Date, y = Open)) +
    geom_line() +
    labs(x = NULL,
         y = "Share price (open, $)",
         title = paste0("Symbol: ", symbol_choice)) +
    theme_bw()
}

plot_csv_prices("AAPL")

csv_plots <- map(c("AAPL", "NVDA", "TSLA"),
             plot_csv_prices)

csv_plots[[2]]

# how could you modify this function to make plots for different date ranges?




# 5. Scraping bike prices ----
# let's look at bikes sold by the company Trek
# start by navigating to https://www.trekbikes.com
# click "Road" at top and then "All Bikes" at left
# let's focus on road bikes: filter Category: "Road bikes" on the left side
# how many pages of results are there?
# find a way to display as many results as possible on one page
# now copy the url and assign it to bike_url
bike_url <- "https://www.trekbikes.com/us/en_US/bikes/road-bikes/c/B200/?pageSize=72&q=%3Arelevance&sort=relevance#"

# use read_html() to read the site's html, and assign it to bike_html
bike_html <- read_html(bike_url)

# next use SelectorGadget to get the name and price of each bike
# use html_elements() to filter out this information, assign it to bike_elements
bike_elements <- bike_html %>%
  html_elements(".product-tile__title , .product-tile__price")

# what happens if we use html_table() to clean bike_elements?
html_table(bike_elements)

# what if we use html_text2() instead? assign the result to bike_text
bike_text <- html_text2(bike_elements)

# how can we convert this to a data frame for analysis?
# coercion!
# one approach is to start by making a matrix using matrix()
bike_matrix <- matrix(bike_text, ncol = 2, byrow = TRUE) # fill matrix by row
matrix(bike_text, nrow = 2) %>% t() # alternative: make a wide matrix, transpose

# now convert the matrix to a tibble using as_tibble(), and clean it up
bike_tibble <- as_tibble(bike_matrix) %>% # convert it to a tibble
  setNames(c("model", "price")) %>% # add column names
  mutate(price = parse_number(price)) # convert prices from chr to dbl

# now let's visualize the data!
# make a histogram of prices
bike_tibble %>%
  ggplot(aes(x = price)) +
  geom_histogram(color = "white") +
  scale_x_continuous(limits = c(0, NA), # start at zero
                     labels = scales::label_dollar()) +
  labs(x = "Price",
       y = "Number of bikes",
       title = "Histogram of Trek road bike prices")

# now split the data by eTap, and plot the distribution of bikes w/ and w/o eTap
# use alpha = 0.5 to adjust transparency to facilitate comparisons
bike_tibble %>%
  mutate(eTap = str_detect(model, "eTap")) %>%
  ggplot(aes(x = price, fill = eTap)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(limits = c(0, NA), # start at zero
                     labels = scales::label_dollar()) +
  labs(x = "Price",
       y = "Density",
       title = "Distribution of Trek road bike prices")


# did we miss any bikes on pages 2+?
# could we build on our code above to scrape prices for all bikes?


# nice work!
# will this always work?
# it turns out we get very different results for the company Specialized:
read_html("https://www.specialized.com/us/en/shop/bikes/c/bikes") %>%
  html_elements(".product-list__content-text") # from SelectorGadget

# but there's nothing there!
# for this page, the html code does not include all the data we see in a browser
# we need more tools for this site, which we don't have time to cover


# 5. Scrape prices for your own favorite product ----
# if time allows, extend your work above to another product on another site

