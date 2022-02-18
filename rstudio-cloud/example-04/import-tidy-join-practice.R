# AEM 2850 - Example 4
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
# install.packages("nycflights13") # in this case, it has already been done for you in this project
library(nycflights13) # load data frames we'll use later

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
______(______, "______") # write table1 to table1.csv


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
# did something go wrong? if so, can you modify the code fix it?


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 3. Import, tidy, and join data -----
excel_sheets("table4.xlsx") # list all sheets in table4.xlsx

# use read_excel to read in the sheet "cases" from table4.xlsx and assign it to table4a
table4a <- read_excel("______",
                      sheet = "______")
table4a # let's take a look

# tidy table4a so it matches the structure of table1
tidy_table4a <- table4a %>% 
  ______(-______, ______ = "country", values_to = "cases") %>% 
  relocate(country) # bring country back to the "front" of the data frame

# use read_excel to read in the sheet "population" from table4.xlsx and assign it to table4a
table4b <- read_excel("______",
                      sheet = "______",
                      range = "A2:C5")
table4b # let's take a look

# tidy table4b so it matches the structure of table1
tidy_table4b <- table4b %>% 
  ______(-______, ______ = "year", ______ = "population",
               names_transform = list(year = as.double)) # let's store years as doubles (not characters)

# now join the two tables
table4 <- inner_join(tidy_table4a, tidy_table4b)

# what does that look like?
table4

# did you manage to recreate table1?
all_equal(table1, table4)

# what happens if you reverse the order of the join arguments?
inner_join(tidy_table4b, tidy_table4a)


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 4. More joins using data from nycflights13 -----

# 4.1 use the data frames `flights` and `airlines` to get the names of airlines that flew from NYC to Miami (MIA)
# the result should be a 3 x 2 data frame
# hints:
# 1. the variable that links `flights` and `airlines` is "carrier"
# 2. start by using our dplyr verbs on `flights` to get a 3 x 1 data frame with the variable carrier, then join to airlines
______ # write your code here


# 4.2 did any of the carriers that flew to Miami also fly to Syracuse?
______ # write your code here


# 4.3 what is the oldest plane that flew from NYC to MIA?
# hint: you can use flights in conjunction with planes, which are connected by tailnum (as we saw in the slides)
______ # write your code here

