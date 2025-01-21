# AEM 2850 - Example 9
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages, which include lubridate
# library(Quandl) # load Quandl package (https://data.nasdaq.com/tools/r)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore some economic data to learn about working with dates and visualizing time data
# the data come from FRED (https://fred.stlouisfed.org), though accessed via the quandl api
# in order to use the API, you either need to work locally or register and then use your own API key
# for convenience, i created csv files store in data/ but also include the code used to get the data


# 1. it's your birthday ----
# before visualizing time, let's start with a special date: your birth date
# write your birth date below in "YYYY-MM-DD" format and assign it to my_bday
my_bday <- "____-__-__"

# what type of object is my_bday?
class(______)

# use lubridate::ymd() to convert my_bday to a date, and assign it to my_bdate
my_bdate <- ______(my_bday)

# what type of object is my_bday?
class(my_bdate)

# use an alternative date convention and convert it to a date
alt_bdate <- mdy("______")

# what month were you born in?
year(______)

# what month were you born in?
______(______)

# what month were you born in, labeled in english?


# what day of the year were you born on?
yday(______)

# what day of the month were you born on?
______(______)

# what day of the week were you born on?


# what day of the week were you born on, labeled in english?


# how many days old are you? assign this to my_days
______ - ______
my_days <- ______ - ______

# what type of object is my_days?


# lubridate offers a **duration** type that is stored in seconds
# use as.duration() to convert my_days from difftime to duration, assign it to my_duration


# print my_duration



# 2. Import and visualize oil price data ----
# oil prices are an important economic indicator
# could use quandl to import WTI (US) and Brent (EU) prices from FRED
# oil_prices <- Quandl(c("FRED/DCOILWTICO", "FRED/DCOILBRENTEU"))
# but we did this in advance, so we can just `data/oil_prices.csv`
oil_prices <- read_csv("data/oil_prices.csv")


# tidy the data, filtering to post 2000
# renaming the variables by position for convenience
# i used the names "date" "wti" and "brent"


# use the tidy data to plot wti prices over time as points


# add a line


# now plot lines (only) for both wti and brent, coloring by type
# add a horizontal line at 0 using geom_hline()



# 3. Import and visualize GDP data ----
# use quandl to import FRED's seasonally adjusted GDP data
# use FRED/GDPC1, which is in real terms, rather than GDP (which is nominal)
# gdp <- Quandl("FRED/GDPC1")
gdp <- read_csv("data/gdp.csv")

# inspect the data frame's structure


# make a line plot of GDP over time


# put the y axis scale in logs using scale_y_log10()
# many economic and business indicators exhibit constant growth rates, which lead to exponential trends
# plotting data in logs is often a convenient way to visualize these data


# let's go back to levels rather than logs
# use lubridate and dplyr functions to make the same plot for annual data
# create a year variable, group by that, and take the sum of Value within each year, then plot it


# plot gdp from my_bday to the present


# make a line plot of gdp from 2000 to the present



# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# IF YOU FINISH WITH TIME TO SPARE, YOU CAN JUMP AHEAD TO SECTION 6
# WE WILL COVER SECTIONS 4-5 ON THURSDAY


# 4. Gapminder animation revisited ----
# load the gapminder, gganimate, and gifski packages
library(gapminder)
library(gganimate)
library(gifski)

# use the gapminder data to recreate the animation from class
gapminder_points <- gapminder |>
  ggplot(aes(
    x = gdpPercap,
    y = lifeExp,
    size = pop,
    color = continent
  )) +
  geom_point(alpha = 0.5, show.legend = FALSE) +
  scale_color_manual(
    values = continent_colors # continent_colors comes from gapminder
  ) +
  scale_size_continuous(range = c(1, 15)) +
  scale_x_log10(labels = scales::label_dollar()) + # scales is a tidyverse package
  theme_classic(base_size = 20) +
  labs(
    x = "GDP per capita",
    y = "Life expectancy",
    title = "Year: {frame_time}"
  ) + # transition_time makes {frame_time} available
  transition_time(year) + # tell gganimate to use year for animation transitions
  ease_aes('linear') # default progression
animate(gapminder_points, renderer = gifski_renderer())

# find the outlier country with GDP per capita over $100,000 in the 1950s
# one way is using filters


# or plot text using geom_text (or geom_label) instead of geom_point
# note: for plotting text, the aesthetic mapping needs to include a `label`
# you might also want to omit the size mapping to make the chart more readable


# can you think of any reasons that country was an outlier in terms of gdp/capita?
# hint: it might related to some of the data we plotted earlier in this example
# note: don't read too far into this without doing more due diligence
# alternative economic measures could lead to very different conclusions


# 5. OJ prices and sales over time ----
# import data/oj.csv, which contains data from a retailer on oj prices and sales


# the data are organized by brand
# time in these data is represented by week
# what data type is the column/variable week? is it a date or something else?


# use the variable week to make a column plot of tropicana sales over time


# make a connected scatter plot using the tropicana data
# is this an effective data visualization? why or why not?


# make a scatter plot using the tropicana data, without using time at all


# modify your previous plot to use log scales (scale_x_log10, scale_y_log10)


# make a version of your last plot that includes all brands
# add a linear fit line using geom_smooth()


# as time allows:
# make a line plot of both sales and prices, in facets, over time for tropicana
# you will want to use the scales argument to facet_wrap here


# if you were the retailer, how could you use the data to inform your strategy?
# what are the pros and cons of your two different visualizations for this purpose?
# what more would you want to know, or to do with the data?


# 6. Make a more polished GDP plot ----
# try to make this: https://fred.stlouisfed.org/graph/fredgraph.png?g=MOiP

# 6.1. first you will need to process recessions data:
# 6.1.1. get data on the start and end dates of recessions (FRED/USREC)
# go ahead and filter to post-2000 data for convenience
# rec <- Quandl("FRED/USREC") |>
#   filter(Date >= "2000-01-01") |>
#   arrange(Date)
rec <- read_csv("data/rec.csv")

# 6.1.2. use dplyr tools to isolate periods when recessions start/end
# (hint: think window functions for offsets)


# 6.1.3. make a data frame where each row is a recession, and columns are start/end dates


# 6.2. filter gpd to post-2000 data and convert GDP from billions to trillions
# assign resulting data frame to a variable


# 6.3. now make a plot using the two data frames
# we need to give data and mappings to each geometry without confusing them
# we can do this by calling ggplot without arguments, and then
# passing the data and aesthetic mappings directly to each geom function
# geom_rect: map start and end dates to xmin and xmax, -Inf and Inf to ymin and ymax
# fill your rectangles and color your line
# add informative labels
# state your data source


# 6.4. use ggsave to save the plot as a .png file
# you will probably want to specify the dimensions (e.g., width = 8, height = 4.5)



# 7. Recessionary oil prices ----
# use your code from 3 to make a plot of WTI prices with recession shading


# use ggsave to save the plot as a .png file
# you will probably want to specify the dimensions (e.g., width = 8, height = 4.5)


# do you think the Great Recession and COVID affected oil prices? how? why?

