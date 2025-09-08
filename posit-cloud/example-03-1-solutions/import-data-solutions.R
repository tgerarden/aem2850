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
table2 <- read_csv("table2.csv")
table2 # let's take a look

# use read_csv to read in table3.csv and assign it to table3
table3 <- read_csv("table3.csv")
table3 # let's take a look

# use read_csv to read in table4.csv and assign it to table4
table4 <- read_csv("table4.csv")

# what went wrong? try again:
table4 <- read_csv("data/table4.csv")
table4 # let's take a look

# use write_csv to write table 4 to mytable4.csv (not within data/)
table4 |>
  write_csv("mytable4.csv")
# why don't we need assignment here?

# now try the code that failed before, but using mytable4.csv. does it work?
mytable4 <- read_csv("mytable4.csv")
mytable4 # let's take a look


# 2. Import and transform zillow data -----
# zillow-data.xlsx contains Zillow Home Value Index data

# use read_excel to read in data from the sheet "usa" using the range "B2:E3
read_excel(
  "zillow-data.xlsx",
  sheet = "usa",
  range = "B2:E3"
)

# do that again, but only using the range formula
read_excel(
  "zillow-data.xlsx",
  range = "usa!B2:E3"
)

# use read_excel to read in data from the sheet "ny" and assign it to zhvi
zhvi <- read_excel(
  "zillow-data.xlsx",
  sheet = "ny"
)
zhvi # let's take a look
# did something go wrong? try using the `skip` argument to fix it
# hint: visually inspect zillow-data.xlsx by clicking on it in the Files pane
?read_excel # if you get stuck, use the console to get help!
zhvi <- read_excel(
  "zillow-data.xlsx",
  sheet = "ny",
  skip = 1
)

# print zhvi to make sure you got what you wanted
zhvi

# it looks like the column names are dates

# how would you compute Ithaca's mean home price over this time period?
# it can be done, but it's not easy using what we know so far
zhvi |>
  filter(RegionName=="Ithaca, NY") |>
  select(-RegionName, -RegionType, -StateName) |>
  as.numeric() |>
  mean()

# we will learn how to tidy shortly
# for now, import the already-tidy version from the sheet "ny_tidy"
# assign the resulting data frame to zhvi_tidy
zhvi_tidy <- read_excel(
  "zillow-data.xlsx",
  sheet = "ny_tidy"
)

# print zhvi_tidy to make sure you got what you wanted
zhvi_tidy

# use dplyr functions to find the mean home price for Ithaca, NY
zhvi_tidy |>
  filter(city == "Ithaca, NY") |>
  summarize(mean_price = mean(price))


# 3. Practice transforming zillow data -----
# WORK INDEPENDENTLY THROUGH THIS SECTION AND RAISE YOUR HAND WITH QUESTIONS

# use dplyr functions to find the city with the highest mean price
# sort mean prices from highest to lowest, then slice_head() the first row
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price)) |>
  arrange(desc(mean_price)) |>
  slice_head()

# do that again, but get the top 3 cities
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price)) |>
  arrange(desc(mean_price)) |>
  slice_head(n = 3)

# now use the convenience function slice_max() to get the top city
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price)) |>
  slice_max(mean_price)

# do that again, but get the top 3 cities with the highest mean price
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price)) |>
  slice_max(mean_price, n = 3)

# use a new dplyr function to find the city with the LOWEST mean price
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price)) |>
  slice_min(mean_price)


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 4. Import and transform retail sales data -----
# the census publishes estimates of state-level Monthly State Retail Sales
# at https://www.census.gov/retail/state_retail_sales.html
# let's look at retail sales year-over-year percentage changes
# use read_csv to read in data from the url https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv and assign it to retail
retail <- read_csv("https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv")

# take a look
retail

# we will learn how to tidy this data on thursday
# for now, import a tidy version from retail_tidy.csv, assign it to retail_tidy
retail_tidy <- read_csv("retail_tidy.csv")

# print retail_tidy to make sure you got what you wanted
retail_tidy

# what yearmonth had the highest yoy_pct_change for naics == "TOTAL" for the entire USA?
retail_tidy |>
  filter(stateabbr == "USA" & naics == "TOTAL") |>
  filter(yoy_pct_change == max(yoy_pct_change))
# or:
retail_tidy |>
  filter(stateabbr == "USA" & naics == "TOTAL") |>
  slice_max(yoy_pct_change, n = 1)

# what state had the highest yoy_pct_change for naics == "TOTAL" in february 2022?
retail_tidy |>
  filter(naics == "TOTAL" & yearmonth == "yy202202") |>
  filter(yoy_pct_change == max(yoy_pct_change))
# or:
retail_tidy |>
  filter(naics == "TOTAL" & yearmonth == "yy202202") |>
  slice_max(yoy_pct_change, n = 1)

# make a plot of yoy_pct_change over time for naics == "TOTAL" for the entire USA
# note: you just need to fill in the missing pieces of the filter() command
retail_tidy |>
  filter(stateabbr == "USA" & naics == "TOTAL") |>
  mutate(
    yearmonth = str_replace(yearmonth, "yy", ""), # remove leading yy
    date = ym(yearmonth) # convert yearmonth to a date for plotting
  ) |>
  ggplot(aes(x = date, y = yoy_pct_change)) +
  geom_col() +
  theme_bw() +
  labs(
    x = "Month",
    y = "Year-over-Year Percentage Change",
    title = "U.S. Retail Spending Over Time",
    caption = "Data Source: U.S. Census Bureau's Monthly State Retail Sales"
  )

# challenge: replicate the plot above for Gasoline Stations in NY
# you can start by copying and pasting the code you wrote above, then editing it
# you can look up NAICS codes, but for convenience the relevant code is 447
# how does it compare to the first plot?
retail_tidy |>
  filter(stateabbr == "NY" & naics == "447") |>
  mutate(
    yearmonth = str_replace(yearmonth, "yy", ""), # remove leading yy
    date = ym(yearmonth) # convert yearmonth to a date for plotting
  ) |>
  ggplot(aes(x = date, y = yoy_pct_change)) +
  geom_col() +
  theme_bw() +
  labs(
    x = "Month",
    y = "Year-over-Year Percentage Change",
    title = "Retail Spending Over Time at Gas Stations in NY",
    caption = "Data Source: U.S. Census Bureau's Monthly State Retail Sales"
  )
