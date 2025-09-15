# AEM 2850 - Example 9
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages, which include lubridate

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll use economic data from FRED
# (https://fred.stlouisfed.org)
# for convenience, i created csv files store in data/


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

# what year were you born in?
year(______)

# what month were you born in?
______(my_bdate)

# what month were you born in, labeled in english?
______(my_bdate, label = ______)

# what day of the year were you born on?
yday(______)

# what day of the month were you born on?
______(my_bdate)

# what day of the week were you born on?


# what day of the week were you born on, labeled in english?


# how many days old are you? assign this to my_days
today() - ______
my_days <- ______ - ______

# what type of object is my_days?


# lubridate offers a **duration** type that is stored in seconds
# use as.duration() to convert my_days from difftime to duration, assign it to my_duration


# print my_duration



# 2. Import and visualize oil price data ----
# oil prices are an important economic indicator
# let's see how they varied over the past 25 years
# import the data in data/oil_prices.csv
oil_prices <- read_csv("data/oil_prices.csv")


# tidy the data so that each row only contains one price
# make sure the date variable is a date object, not character


# use the tidy data to plot wti prices over time as points


# add a line to the plot of wti prices


# now plot only lines, for both prices, coloring by type
# add a horizontal line at 0 using geom_hline()



# 3. Import and visualize GDP data ----
# import the data in data/gdp.csv
gdp <- read_csv("data/gdp.csv")

# make a line plot of GDP over time


# put the y axis scale in logs using scale_y_log10()
# many economic indicators exhibit constant growth rates,
# which lead to exponential trends
# using logs is often a good way way to visualize these data


# let's go back to levels rather than logs
# the gdp data are quarterly
# use lubridate and dplyr functions to an annual plot:
# 1. create a year variable
# 2. group by year
# 3. take the sum of gdp within each year
# 4. then plot it


# plot gdp from my_bday to the present
# filter the data by comparing date to my_bday


# make a line plot of gdp from 2000 to the present
# filter the data by comparing date to "2000-01-01"



# PLEASE PUT YOUR NAME TENT DOWN LET US KNOW THAT YOU ARE DONE


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
  scale_x_log10(labels = scales::label_dollar()) + # scales is a tidyverse package
  scale_size_continuous(range = c(1, 15)) +
  theme_classic(base_size = 20) +
  labs(
    x = "GDP per capita",
    y = "Life expectancy",
    title = "Year: {frame_time}" # transition_time makes {frame_time} available
  ) +
  transition_time(year) + # tell gganimate to use year for animation transitions
  ease_aes('linear') # default progression
animate(gapminder_points, renderer = gifski_renderer())

# one way is using filters:
# find the outlier country with GDP per capita over $100,000 in the 1950s


# another option is to create an animation with labels:
# 1. copy and paste the plot code above
# 2. replace geom_point with geom_text
# note: for plotting text, the aesthetic mapping needs to include a `label`
# 3. omit the size mapping to make the chart more readable
# 4. use animate to create the animation


# can you think of any reasons that country was an outlier in terms of gdp/capita?
# hint: it might related to some of the data we plotted earlier in this example
# note: don't read too far into this without doing more due diligence
# alternative economic measures could lead to very different conclusions


# 5. OJ prices and sales over time ----
# import data/oj.csv, which contains retailer data on oj prices and sales


# the data are organized by brand
# time in these data is represented by week
# what data type is the column/variable week? is it a date or something else?


# use the variable week to make a column plot of tropicana sales over time


# make a connected scatter plot using the tropicana data
# is this an effective data visualization? why or why not?


# make a scatter plot using the tropicana data, without using time at all


# modify your previous plot to use log scales (scale_x_log10 + scale_y_log10)


# make a version of your last plot that includes all brands
# map brand to color
# add a linear fit line using geom_smooth(method = "lm")


# as time allows:
# make a line plot of both sales and prices, in facets, over time for tropicana
# you will want to use the scales = "free_y" argument to facet_wrap here


# if you were the retailer, how could you use the data to inform your strategy?
# what are the pros and cons of your two visualizations for this purpose?
# what more would you want to know, or to do with the data?


# OPTIONAL, TIME PERMITTING:
# 6. Make a more polished GDP plot ----
# try to make this: https://fred.stlouisfed.org/graph/fredgraph.png?g=MOiP

# 6.1. first you will need to process recessions data:
# 6.1.1. get data on the start and end dates of recessions (FRED/USREC)
# import the data from data/rec.csv
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
# specify the dimensions; width = 8, height = 4.5
ggsave(
  "_____",
  width = 8,
  height = 4.5
)


# OPTIONAL, TIME PERMITTING:
# 7. Recessionary oil prices ----
# use your code from 3 to make a plot of WTI prices with recession shading


# use ggsave to save the plot as a .png file
# specify the dimensions; width = 8, height = 4.5


# do you think the Great Recession and COVID affected oil prices? how? why?
