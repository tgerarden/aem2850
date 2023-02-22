# AEM 2850 - Example 3
# Plan for today:
# - Questions?
# - Wrap up slides
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(readxl) # load readxl (installed as part of the tidyverse, but not loaded by default)


# 1. Warm up -----
# 1.1 import data
table2 <- read_csv("______") # use read_csv to read in table2.csv and assign it to table2
table2 # let's take a look

# 1.2 tidy data
# use pivot_wider to make the data tidy as follows:
# level of observation: country-year
# variables: country, year, cases, population
# in other words, we want to pivot cases and population data wider
table1 <- table2 %>% # assign the tidy data to table1
  pivot_wider(names_from = "______", values_from = "______")
table1 # let's take a look

# 1.3 work with tidy data
# compute the case rate per 10,000 people
table1 %>% 
  mutate(case_rate = ______ / ______ * 10000)

# compute the total number of cases in each country
table1 %>% 
  group_by(______) %>% 
  summarize(total_cases = ______(cases))

# compute the total number of cases in each year
table1 %>% 
  ______(______) %>% 
  ______(total_cases = ______(cases))

# it is possible to do each of these with table2
# but it's really easy if we use the tidy version (table1)

# 1.4 write tidy data in case you want to use it later
______("______") # write table1 to table1.csv


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 2. Import and tidy data -----
______ # use read_csv to read in table3.csv and assign it to table3
table3 # let's take a look

# use separate to split "rate" into "cases" and "population"
table3 %>% 
  separate(______, ______, ______)

# compute the case rate per 10,000 people
table3 %>% 
  separate(______, ______, ______) %>% # you can just copy this from the previous exercise above
  mutate(case_rate = ______ / ______ * 10000)
# did someting go wrong? if so, can you modify the code fix it?


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 3. Import, tidy, and transform zillow data -----
# zillow-data.xlsx contains Zillow Home Value Index data
# use read_excel to read in data from the sheet "ny" and assign it to zhvi
zhvi <- read_excel("______.xlsx", 
                   sheet = "______")
zhvi # let's take a look
# did something go wrong? try using the `skip` argument to fix it
?read_excel # if you get stuck, use the console to get help!
zhvi <- read_excel("______.xlsx", 
                   ______ = "______",
                   ______ = ______)
zhvi # let's take a look

# it looks like the column names are dates
# tidy the data so the variable date is stored in a single column "date"
# store the prices in a single column "price"
# rename RegionName, and remove RegionType and StateName from the data
# assign the resulting data frame to zhvi_tidy
zhvi_tidy <- zhvi |> 
  rename(______ = ______) |> 
  ______(-RegionType, -______) |> 
  pivot_longer(-______,
               names_to = "______",
               ______ = "______")

# use dplyr functions to find the mean home price for "Ithaca, NY" in thousands
zhvi_tidy |> 
  ______(city == "Ithaca, NY") |> 
  summarize(mean_price = ______(______) / ______)

# use dplyr functions to find the city with the highest mean price
zhvi_tidy |> 
  group_by(______) |> 
  ______(mean_price = ______(______) / ______) |> 
  arrange(______(______)) |> 
  slice_head(n = 1)

# use dplyr functions to find the city with the lowest mean price
______


# challenge: compute the ratio of the price in 2/28/22 over the price in 1/31/00
# which city has a higher ratio: ithaca or NYC?
______


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 4. Import, tidy, and transform retail sales data -----
# the census publishes estimates of state-level Monthly State Retail Sales
# at https://www.census.gov/retail/state_retail_sales.html
# let's look at retail sales year-over-year percentage changes
# use read_csv to read in data from the url https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv and assign it to retail
retail <- ______

# use pivot_longer() to construct a data frame where the level of observation is 
# the fips-stateabbr-naics-yearmonth, and the variable of interst is yoy_pct_change
retail_tidy <- ______

# what yearmonth had the highest yoy_pct_change for naics == "TOTAL" for the entire USA?
______

# what state had the highest yoy_pct_change for naics == "TOTAL" in february 2022?
# hint: you could use filter to circumvent the non-numeric data in yoy_pct_change
______

# make a plot of yoy_pct_change over time for naics == "TOTAL" for the entire USA
retail_tidy |> 
  filter(______ == "USA" & naics == "______") |> 
  mutate(yearmonth = str_replace(______, "______", "______"), # remove leading yy from yearmonth
         date = lubridate::______(yearmonth)) |> # find a lubridate function similar to ymd() to convert yearmonth to a date
  ggplot(aes(x = date, y = as.numeric(yoy_pct_change))) +
  geom_col() +
  theme_bw() +
  labs(x = "Month",
       y = "Year-over-Year Percentage Change",
       title = "U.S. Retail Spending Over Time",
       caption = "Data Source: U.S. Census Bureau's Monthly State Retail Sales")

# challenge: replicate the plot above for Gasoline Stations in NY
# how does it compare to the first plot?
