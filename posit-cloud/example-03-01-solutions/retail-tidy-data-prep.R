# 0. Loading packages -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(readxl) # load readxl (installed as part of the tidyverse, but not loaded by default)


# X. Import, tidy, and transform retail sales data -----
# the census publishes estimates of state-level Monthly State Retail Sales
# at https://www.census.gov/retail/state_retail_sales.html
# let's look at retail sales year-over-year percentage changes
# use read_csv to read in data from the url https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv and assign it to retail
retail <- read_csv("https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv")

retail <- read_csv(
  "https://www.census.gov/retail/mrts/www/statedata/state_retail_yy.csv",
  col_types = cols(.default = "c")
)

# use pivot_longer() to construct a data frame where the level of observation is
# the fips-stateabbr-naics-yearmonth, and the variable of interest is yoy_pct_change
# you'll need to convert yoy_pct_change from a character to a numberic
retail_tidy <- retail |>
  pivot_longer(
    cols = starts_with("yy"), # this is one of many ways to specify the columns to pivot
    names_to = "yearmonth",
    values_to = "yoy_pct_change"
  ) |>
  mutate(yoy_pct_change = as.numeric(yoy_pct_change)) # convert yoy_pct_change into numbers

retail_tidy |>
  write_csv("posit-cloud/example-03-01/retail_tidy.csv")
retail_tidy |>
  write_csv("posit-cloud/example-03-01-solutions/retail_tidy.csv")

retail_tidy |>
  write_csv("posit-cloud/example-03-02/retail_tidy.csv")
retail_tidy |>
  write_csv("posit-cloud/example-03-02-solutions/retail_tidy.csv")
