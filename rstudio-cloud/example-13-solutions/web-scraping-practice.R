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

# next, press Clear
# align your cursor so the entire table of sports is highlighted, and click
# what CSS selector appears in the SelectorGadget bar?


# 2. Stock prices from Yahoo! Finance ----
# let's start by writing a script to get historical price data for one ticker

# 2.1: go to https://finance.yahoo.com and look up a ticker

# 2.2: navigate the site to find historical data
# by default the site displays daily prices for the past year
# later we could explore how to scrape other historical data
# copy and paste the url, strip tracking info, and assign to stock_url


# 2.2: use read_html() to get the html code, assign to stock_html

# what does stock_html look like?


# 2.3: use html_element() to try to extract html code for the table
# it's hard to use SelectorGadget to isolate the tabular data on yahoo finance
# instead, you can use the selector "table" (both in SelectorGadget and here)


# 2.4: use html_table() to convert html code to a table


# 2.5: plot stock open prices over time
# this will require some modest data cleaning
# tip: type_convert() is handy for automatically detecting column types



# 3. Use your code above to write a pipeline that produces a plot for any ticker ----
# note: next week we will see how code like this can be called via functions

# first, assign "AAPL" to the name symbol


# now start the pipeline by using str_glue() to construct a url based on symbol
# see if you can customize the title to include the ticker


# go back and assign a new ticker to symbol, then run your code. did it work?


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


# use read_csv() to read this csv and assign it to csv_prices


# plot open prices for your stock over the past year


# now let's modify our code above to make a plot for any ticker
# you can strip the end of the url starting at "interval" for convenience
# as before, assign "AAPL" to symbol and test that it works


# go back and assign a new ticker to symbol, then run the code. did it work?


# how could you modify this function to make plots for different date ranges?



# 5. Scraping bike prices ----
# let's look at bikes sold by the company Trek
# start by navigating to https://www.trekbikes.com
# click "Road" at top and then "All Bikes" at left
# let's focus on road bikes: filter Category: "Road bikes" on the left side
# how many pages of results are there?
# find a way to display as many results as possible on one page
# now copy the url and assign it to bike_url. here it is for convenience:
bike_url <- "https://www.trekbikes.com/us/en_US/bikes/road-bikes/c/B200/?pageSize=72&q=%3Arelevance&sort=relevance#"


# use read_html() to read the site's html, and assign it to bike_html


# next use SelectorGadget to get the name and price of each bike
# use html_elements() to filter out this information, assign it to bike_elements


# what happens if we use html_table() to clean bike_elements?


# what if we use html_text2() instead? assign the result to bike_text


# how can we convert this to a data frame for analysis?
# one option is to convert the vector to a data frame using as_tibble()
# then tidy it up so that rows correspond to bikes using tidyverse tools
# parse_number() is a handy function for converting character prices to numbers


# (another option is coercion: filling a matrix or data frame element by element)
# (then convert the matrix to a tibble using as_tibble(), and clean it up)


# now let's visualize the data!
# make a histogram of prices


# now split the data by AXS, and plot the distribution of bikes w/ and w/o AXS
# use alpha = 0.5 to adjust transparency to facilitate comparisons



# did we miss any bikes on pages 2+?
# could we build on our code above to scrape prices for all bikes?


# nice work!
# will this always work?
# it turns out we get very different results for the company Specialized:
read_html("https://www.specialized.com/us/en/shop/bikes/c/bikes") |>
  html_elements(".product-list__content-text") # from SelectorGadget

# there's nothing there!
# for this page, the html code does not include all the data we see in a browser
# we need more tools for this site, which we don't have time to cover


# 5. Scrape prices for your own favorite product ----
# if time allows, extend your work above to another product on another site
