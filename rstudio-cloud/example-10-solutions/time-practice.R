# AEM 2850 - Example 9
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(lubridate) # load lubridate (part of tidyverse but not automatically loaded)
library(Quandl) # load Quandl package (https://data.nasdaq.com/tools/r)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore some economic data to learn about working with dates and visualizing time data
# the data come from FRED (https://fred.stlouisfed.org), though we'll access it via the quandl api
# FYI i included csv files of the three key datasets in backup-data in case of issues with the quandl api


# 0. it's your birthday ----
# before we get to visualization of time data, let's start with a special date: your birth date
# write your birthday as a string in "YYYY-MM-DD" format and assign it to my_bday
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
my_days <- ______ - ______

# what type of object is my_days?


# lubridate offers a **duration** type that is stored in second
# use as.duration() to convert my_days from difftime to duration, assign it to my_duration


# print my_duration



# 1. Import and visualize oil price data ----
# oil prices are an important economic indicator
# use quandl to import WTI (US) and Brent (EU) prices from FRED
oil_prices <- Quandl(c("FRED/DCOILWTICO", "FRED/DCOILBRENTEU"))

# tidy the data, filtering to post 2000
# renaming the variables by position for convenience
# i used the names "date" "wti" and "brent"


# use the tidy data to plot brent prices over time as points


# add a line


# now plot lines (only) for both wti and brent, coloring by type
# add a horizontal line at 0 using geom_hline()



# 2. Import and visualize GDP data ----
# use quandl to import FRED's seasonally adjusted GDP data
# use FRED/GDPC1, which is in real terms, rather than GDP (which is nominal)


# inspect the data frame's structure


# make a line plot of GDP over time


# put the y axis scale in logs
# many economic and business indicators exhibit constant growth rates, which lead to exponential trends
# plotting data in logs is often a convenient way to visualize these data


# let's go back to levels rather than logs
# use lubridate and dplyr functions to make the same plot for annual data
# create a year variable, group by that, and take the sum of Value within each year, then plot it


# plot gdp from my_bday to the present


# make a line plot of gdp from 2000 to the present



# 3. Make a more polished GDP plot ----
# try to make this: https://fred.stlouisfed.org/graph/fredgraph.png?g=MOiP

# 3.1. first you will need to process recessions data:
# 3.1.1. get data on the start and end dates of recessions (FRED/USREC)
# go ahead and filter to post-2000 data for convenience


# 3.1.2. use dplyr tools to isolate periods when recessions start/end
# (hint: think window functions for offsets)


# 3.1.3. make a data frame where each row is a recession, and columns are start/end dates


# 3.2. filter gpd to post-2000 data and convert GDP from billions to trillions
# assign resulting data frame to a variable


# 3.3. now make a plot using the two data frames
# we need to give data and mappings to each geometry without confusing them
# we can do this by calling ggplot without arguments, and then
# passing the data and aesthetic mappings directly to each geom function
# map start and end dates to xmin and xmax, -Inf and Inf to ymin and ymax
# fill your rectangles and color your line
# add informative labels
# state your data source


# 3.4. use ggsave to save the plot as a .png file



# 4. Bonus: use your code from 3 to make a plot of WTI prices with recession shading ----
# do you think the Great Recession and COVID affected oil prices? how? why?


# use ggsave to save the plot as a .png file

