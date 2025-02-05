# AEM 2850 - example-03-02
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
# use read_csv to read in table2.csv and assign it to table2
table2 <- read_csv("table2.csv")
table2 # let's take a look

# 1.2 tidy data
# use pivot_wider to make the data tidy as follows:
# level of observation: country-year
# variables: country, year, cases, population
# in other words, we want to pivot cases and population data wider
table1 <- table2 |> # assign the tidy data to table1
  pivot_wider(
    names_from = "______",
    values_from = "______"
  )
table1 # let's take a look

# 1.3 work with tidy data
# compute the case rate per 10,000 people
table1 |>
  mutate(case_rate = ______ / ______ * 10000)

# compute the total number of cases in each country
table1 |>
  group_by(______) |>
  summarize(total_cases = ______(cases))

# compute the total number of cases in each year
table1 |>
  ______(______) |>
  ______(total_cases = ______(cases))

# it is possible to do each of these with table2
# but it's really easy if we use the tidy version (table1)


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 2. Import and tidy data -----
table3 <- read_csv("table3.csv") # use read_csv to read in table3.csv and assign it to table3
table3 # let's take a look

# use separate_wider_delim to split "rate" into "cases" and "population"
table3 |>
  separate_wider_delim( # this is a new function so we've coded it up for you
    cols = rate,        # the existing column with data we want to separate
    delim = "/",      # the characters that separate (delimit) the data
    names = c("cases", "population") # names for the new columns
  )

# compute the case rate per 10,000 people
table3 |>
  separate_wider_delim( # this is a new function so we've coded it up for you
    cols = rate,        # the existing column with data we want to separate
    delim = "/",      # the characters that separate (delimit) the data
    names = c("cases", "population") # names for the new columns
  ) |>
  mutate(case_rate = ______ / ______ * 10000)
# did something go wrong? if so, can you modify the code fix it?
# hint: try using mutate with as.integer() to convert cases and population
table3 |>
  separate_wider_delim( # this is a new function so we've coded it up for you
    cols = rate,        # the existing column with data we want to separate
    delim = "/",      # the characters that separate (delimit) the data
    names = c("cases", "population") # names for the new columns
  ) |>
  mutate(
    cases = as.integer(______), # or as.numeric()
    population = as.integer(______), # or as.numeric()
    case_rate = ______ / ______ * 10000
    )


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 3. Import, tidy, and transform zillow data -----
# zillow-data.xlsx contains Zillow Home Value Index data
# use read_excel to read in data from the sheet "ny" and assign it to zhvi
# remember to skip the first row
zhvi <- read_excel(
  "______.xlsx",
  ______ = "______",
  skip = ______
)
zhvi # let's take a look

# it looks like the column names are dates
# tidy the data so the variable date is stored in a single column "date"
# store the prices in a single column "price"
# rename RegionName to city, and remove RegionType and StateName from the data
# assign the resulting data frame to zhvi_tidy
zhvi_tidy <- zhvi |>
  rename(______ = RegionName) |>
  ______(-RegionType, -______) |>
  pivot_longer(
    cols = -______, # pivot everything but the column city
    names_to = "______",
    ______ = "______"
  )

# print zhvi_tidy to make sure you got what you wanted
zhvi_tidy

# now the data will work with our code from example-03-01. for example:
# use dplyr functions to find the 4 cities with the highest mean prices
zhvi_tidy |>
  group_by(city) |>
  summarize(mean_price = mean(price) / 1000) |>
  slice_max(mean_price, n = 4)


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 4. Import, tidy, and transform retail sales data -----
# the census publishes estimates of state-level Monthly State Retail Sales
# at https://www.census.gov/retail/state_retail_sales.html
# let's look at retail sales year-over-year percentage changes
# use read_csv to read in data from the url https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv and assign it to retail
retail <- read_csv("https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv")

# use pivot_longer() to construct a data frame where the level of observation is
# the fips-stateabbr-naics-yearmonth, and the variable of interest is yoy_pct_change
______ |>
  pivot_longer(
    cols = starts_with("______"), # this is one of many ways to specify the columns to pivot
    names_to = "______",
    values_to = "______"
  )

# what happened?
# we can get around this by changing the way we import or pivot the data
# for example, we can force read_csv to treat all columns as characters:
retail <- read_csv(
  "https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv",
  col_types = cols(.default = "c")
)

# now try your pivot code again
______ |>
  pivot_longer(
    cols = starts_with("______"), # this is one of many ways to specify the columns to pivot
    names_to = "______",
    values_to = "______"
  )

# finally, let's convert yoy_pct_change from a character to a numeric
# assign the result to retail_tidy
retail_tidy <- ______ |>
  pivot_longer(
    cols = starts_with("______"), # this is one of many ways to specify the columns to pivot
    names_to = "______",
    values_to = "______"
  ) |>
  mutate(yoy_pct_change = as.numeric(______)) # convert yoy_pct_change into numbers

# print retail_tidy to make sure you got what you wanted
retail_tidy

# make a plot of yoy_pct_change over time for naics == "TOTAL" for the entire USA
retail_tidy |>
  filter(stateabbr == "USA" & naics == "TOTAL") |>
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

