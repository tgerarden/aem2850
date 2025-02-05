# AEM 2850 - example-03-01
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


# 1. Warm up: import data using read_csv -----

# use read_csv to read in table2.csv and assign it to table2
table2 <- read_csv("______")
table2 # let's take a look

# use read_csv to read in table3.csv and assign it to table3
table3 <- ______("______")
table3 # let's take a look


# 2. Import and transform zillow data -----
# zillow-data.xlsx contains Zillow Home Value Index data

# use read_excel to read in data from the sheet "usa" using the range "B2:E3
read_excel(
  "______.xlsx",
  sheet = "______"
  range = "______"
)

# do that again, but only using the range formula
read_excel(
  "______.xlsx",
  range = "______"
)

# use read_excel to read in data from the sheet "ny" and assign it to zhvi
zhvi <- read_excel(
  "______.xlsx",
  sheet = "______"
)
zhvi # let's take a look
# did something go wrong? try using the `skip` argument to fix it
# hint: visually inspect zillow-data.xlsx by clicking on it in the Files pane
?read_excel # if you get stuck, use the console to get help!
zhvi <- read_excel(
  "______.xlsx",
  ______ = "______",
  skip = ______
)

# print zhvi to make sure you got what you wanted
zhvi

# it looks like the column names are dates

# how would you compute Ithaca's mean home price over this time period?
# it can be done, but it's not easy using what we know so far
zhvi |>
  filter(______=="______") |>
  ______
# ...
# ...

# we will learn how to tidy these data on thursday
# for now, import the already-tidy version from the sheet "ny_tidy"
# assign the resulting data frame to zhvi_tidy
zhvi_tidy <- read_excel(
  "______.xlsx",
  ______ = "______"
)

# print zhvi_tidy to make sure you got what you wanted
zhvi_tidy

# use dplyr functions to find the mean home price for Ithaca, NY
zhvi_tidy |>
  ______(city == "Ithaca, NY") |>
  summarize(mean_price = ______(______))

# use dplyr functions to find the city with the highest mean price
# sort mean prices from highest to lowest, then slice_head() the first row
zhvi_tidy |>
  group_by(______) |>
  ______(mean_price = ______(______)) |>
  arrange(desc(______)) |>
  slice_head()

# do that again, but get the top 3 cities
zhvi_tidy |>
  group_by(______) |>
  ______(mean_price = ______(______)) |>
  arrange(desc(______)) |>
  slice_head(n = ______)

# now use the convenience function slice_max to get the top city
zhvi_tidy |>
  group_by(______) |>
  ______(mean_price = ______(______)) |>
  slice_max(______)

# do that again, but get the top 3 cities
zhvi_tidy |>
  group_by(______) |>
  ______(mean_price = ______(______)) |>
  slice_max(______, n = ______)

# use a new dplyr function to find the city with the LOWEST mean price
______





# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 2. Import, tidy, and transform retail sales data -----
# the census publishes estimates of state-level Monthly State Retail Sales
# at https://www.census.gov/retail/state_retail_sales.html
# let's look at retail sales year-over-year percentage changes
# use read_csv to read in data from the url https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv and assign it to retail
retail <- ______

# take a look
retail

# we will learn how to tidy this data on thursday
# for now, import a tidy version from retail_tidy.csv, assign it to retail_tidy
retail_tidy <- ______("______")

# print retail_tidy to make sure you got what you wanted
retail_tidy

# what yearmonth had the highest yoy_pct_change for naics == "TOTAL" for the entire USA?
______

# what state had the highest yoy_pct_change for naics == "TOTAL" in february 2022?
______

# make a plot of yoy_pct_change over time for naics == "TOTAL" for the entire USA
# note: you just need to fill in the missing pieces of the filter() command
retail_tidy |>
  filter(______ == "USA" & naics == "______") |>
  mutate(yearmonth = str_replace(yearmonth, "yy", ""), # remove leading yy from yearmonth
         date = ym(yearmonth)) |> # convert yearmonth to a date for plotting
  ggplot(aes(x = date, y = as.numeric(yoy_pct_change))) +
  geom_col() +
  theme_bw() +
  labs(x = "Month",
       y = "Year-over-Year Percentage Change",
       title = "U.S. Retail Spending Over Time",
       caption = "Data Source: U.S. Census Bureau's Monthly State Retail Sales")

# challenge: replicate the plot above for Gasoline Stations in NY
# you can start by copying and pasting the code you wrote above, then editing it
# you can look up NAICS codes, but for convenience the relevant code is 447
# how does it compare to the first plot?
______
