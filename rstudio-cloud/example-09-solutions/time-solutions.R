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


# 0. it's your birthday ----
# before we get to visualization of time data, let's start with a special date: your birth date
# write your birthday as a string in "YYYY-MM-DD" format and assign it to my_bday
my_bday <- "1991-02-03" # (not really my birthday)

# what type of object is my_bday?
class(my_bday)

# use lubridate::ymd() to convert my_bday to a date, and assign it to my_bdate
my_bdate <- ymd(my_bday)

# what type of object is my_bday?
class(my_bdate)

# use an alternative date convention and convert it to a date
alt_bdate <- mdy("March 3, 1994")

# what month were you born in?
year(my_bdate)

# what month were you born in?
month(my_bdate)

# what month were you born in, labeled in english?
month(my_bdate, label = TRUE)

# what day of the year were you born on?
yday(my_bdate)

# what day of the month were you born on?
mday(my_bdate)

# what day of the week were you born on?
wday(my_bdate)

# what day of the week were you born on, labeled in english?
wday(my_bdate, label = TRUE)

# how many days old are you? assign this to my_days
today() - my_bdate
my_days <- today() - my_bdate

# what type of object is my_days?
class(my_days)

# lubridate offers a **duration** type that is stored in seconds
# use as.duration() to convert my_days from difftime to duration, assign it to my_duration
my_duration <- as.duration(my_days)

# print it
my_duration


# 1. Import and visualize oil price data ----
# oil prices are an important economic indicator
# use quandl to import WTI (US) and Brent (EU) prices from FRED
# oil_prices <- Quandl(c("FRED/DCOILWTICO", "FRED/DCOILBRENTEU"))
# write_csv(oil_prices, "data/oil_prices.csv")
oil_prices <- read_csv("data/oil_prices.csv")

# tidy the data, filtering to post 2000
# renaming the variables by position for convenience
# i used the names "date" "wti" and "brent"
tidy_oil_prices <- oil_prices |>
  rename(date = 1, wti = 2, brent = 3) |>
  filter(date >= "2000-01-01") |>
  pivot_longer(-date, names_to = "type", values_to = "price")

# use the tidy data to plot wti prices over time as points
tidy_oil_prices |>
  filter(type=="wti") |>
  ggplot(aes(x = date, y = price)) +
  geom_point(size = 0.5, alpha = 0.5)

# add a line
tidy_oil_prices |>
  filter(type=="wti") |>
  ggplot(aes(x = date, y = price)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_line()

# now plot lines (only) for both wti and brent, coloring by type
# add a horizontal line at 0 using geom_hline()
tidy_oil_prices |>
  ggplot(aes(x = date, y = price, color = type)) +
  geom_line() +
  geom_hline(yintercept = 0)


# 2. Import and visualize GDP data ----
# use quandl to import FRED's seasonally adjusted GDP data
# use GDPC1, which is in real terms, rather than GDP (which is nominal)
# gdp <- Quandl("FRED/GDPC1")
# write_csv(gdp, "data/gdp.csv")
gdp <- read_csv("data/gdp.csv")

# inspect the data frame's structure
str(gdp)

# make a line plot of GDP over time
gdp |>
  ggplot(aes(Date, Value)) +
  geom_line()

# put the y axis scale in logs
# many economic and business indicators exhibit constant growth rates, which lead to exponential trends
# plotting data in logs is often a convenient way to visualize these data
gdp |>
  ggplot(aes(Date, Value)) +
  geom_line() +
  scale_y_log10()

# let's go back to levels rather than logs
# use lubridate and dplyr functions to make the same plot for annual data
# create a year variable, group by that, and take the sum of Value within each year, then plot it
gdp |>
  mutate(year = year(Date)) |>
  group_by(year) |>
  summarize(gdp = sum(Value)) |>
  ggplot(aes(x = year, y = gdp)) +
  geom_line()

# plot gdp from my_bday to the present
gdp |>
  filter(Date >= my_bday) |>
  ggplot(aes(Date, Value)) +
  geom_line()

# make a line plot of gdp from 2000 to the present
gdp |>
  filter(Date >= "2000-01-01") |>
  ggplot(aes(Date, Value)) +
  geom_line()


# 3. Make a more polished GDP plot ----
# try to make this: https://fred.stlouisfed.org/graph/fredgraph.png?g=MOiP

# 3.1. first you will need to process recessions data:
# 3.1.1. get data on the start and end dates of recessions (FRED/USREC)
# go ahead and filter to post-2000 data for convenience
# rec <- Quandl("FRED/USREC") |>
#   filter(Date >= "2000-01-01") |>
#   arrange(Date)
# write_csv(rec, "data/rec.csv")
rec <- read_csv("data/rec.csv")

# 3.1.2. use dplyr tools to isolate periods when recessions start/end
# (hint: think window functions for offsets)
rec_start_end <- rec |>
  mutate(change = Value - lag(Value)) |>
  filter(change != 0)

# 3.1.3. make a data frame where each row is a recession, and columns are start/end dates
recessions <- tibble(start = filter(rec_start_end, change == 1) |> pull(Date),
                     end = filter(rec_start_end, change == -1) |> pull(Date))
recessions

# 3.2. filter gpd to post-2000 data and convert GDP from billions to trillions
# assign resulting data frame to a variable
gdp_recent <- gdp |>
  filter(Date >= "2000-01-01") |>
  mutate(Value = Value/1e3)

# 3.3. now make a plot using the two data frames
# we need to give data and mappings to each geometry without confusing them
# we can do this by calling ggplot without arguments, and then
# passing the data and aesthetic mappings directly to each geom function
# geom_rect: map start and end dates to xmin and xmax, -Inf and Inf to ymin and ymax
# fill your rectangles and color your line
# add informative labels
# state your data source
ggplot() +
  geom_line(data = gdp_recent,
            aes(x = Date, y = Value),
            color = "#B31B1B", size = 1) +
  geom_rect(data = recessions,
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
            fill = "#222222", alpha = 0.2) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_date(minor_breaks = "years") +
  labs(y = "Trillions of 2012 dollars",
       x = NULL,
       title = "US Gross Domestic Product",
       subtitle = "Quarterly data; seasonally adjusted and in real 2012 dollars",
       caption = "Shaded areas indicate U.S recessions\nData sources: FRED's GDPC1 and USREC via Quandl") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"))

# 3.4. save the plot as a .png file using ggsave
# you will probably want to specify the dimensions (e.g., width = 8, height = 4.5)
ggsave("my_gdp_plot.png", width = 8, height = 4.5)


# 4. Recessionary oil prices ----
# use your code from 3 to make a plot of WTI prices with recession shading
wti_prices <- tidy_oil_prices |>
  filter(type == "wti")

ggplot() +
  geom_line(data = wti_prices,
            aes(x = date, y = price),
            color = "#B31B1B", size = 1) +
  geom_hline(yintercept = 0) +
  geom_rect(data = recessions,
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
            fill = "#222222", alpha = 0.2) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_date(minor_breaks = "years") +
  labs(y = "Dollars per barrel",
       x = NULL,
       title = "Crude Oil Prices: West Texas Intermediate (WTI)",
       subtitle = "Daily data; not seasonally adjusted",
       caption = "Shaded areas indicate U.S recessions\nData sources: FRED's DCOILWTICO and USREC via Quandl") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"))

# use ggsave to save the plot as a .png file
# you will probably want to specify the dimensions (e.g., width = 8, height = 4.5)
ggsave("my_wti_plot.png", width = 8, height = 4.5)

# do you think the Great Recession and COVID affected oil prices? how? why?


# 5. OJ prices and sales over time ----
# data/oj.csv contains data from a real retailer on oj prices and sales
# if time allows, we can explore the data to:
# make a column plot of tropicana sales over time (time = "week")
oj <- read_csv("data/oj.csv")
oj |> 
  filter(brand == "tropicana") |> 
  ggplot(aes(x = week, y = sales)) + 
  geom_col()

# make a line plot of both sales and prices, in facets, over time for tropicana
# you will want to use the scales argument to facet_wrap here
oj |> 
  filter(brand == "tropicana") |> 
  pivot_longer(c(sales, price), names_to = "type", values_to = "value") |> 
  ggplot(aes(x = week, y = value, color = type)) + 
  geom_line() +
  guides(color = "none") +
  facet_wrap(~type, scales = "free_y", ncol = 1)

# make a plot that would be good for tropicana data, without using time at all
oj |> 
  filter(brand == "tropicana") |> 
  ggplot(aes(x = price, y = sales)) + 
  geom_point()

oj |> 
  filter(brand == "tropicana") |> 
  ggplot(aes(x = price, y = sales)) + 
  geom_point() +
  scale_x_log10() + 
  scale_y_log10()

# make a version of your last plot that includes all brands
oj |> 
  ggplot(aes(x = price, y = sales, color = brand)) + 
  geom_point(alpha = 0.5) +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE) +
  theme(legend.position = "bottom")

# if you were the retailer, how could you use the data to inform your strategy?
# what are the pros and cons of your two different visualizations for this purpose?
# what more would you want to know, or to do with the data?
