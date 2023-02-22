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
table2 <- read_csv("table2.csv") # use read_csv to read in table2.csv and assign it to table2
table2 # let's take a look

# 1.2 tidy data
# use pivot_wider to make the data tidy as follows:
# level of observation: country-year
# variables: country, year, cases, population
# in other words, we want to pivot cases and population data wider
table1 <- table2 %>% # assign the tidy data to table1
  pivot_wider(names_from = "type", values_from = "count")
table1 # let's take a look

# 1.3 work with tidy data
# compute the case rate per 10,000 people
table1 %>% 
  mutate(case_rate = cases / population * 10000)

# compute the total number of cases in each country
table1 %>% 
  group_by(country) %>% 
  summarize(total_cases = sum(cases))

# compute the total number of cases in each year
table1 %>% 
  group_by(year) %>% 
  summarize(total_cases = sum(cases))

# it is possible to do each of these with table2
# but it's really easy if we use the tidy version (table1)

# 1.4 write tidy data in case you want to use it later
write_csv(table1, "table1.csv") # write table1 to table1.csv


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 2. Import and tidy data -----
table3 <- read_csv("table3.csv") # use read_csv to read in table3.csv and assign it to table3
table3 # let's take a look

# use separate to split "rate" into "cases" and "population"
table3 %>% 
  separate(rate, c("cases", "population"), sep = " / ")

# compute the case rate per 10,000 people
table3 %>% 
  separate(rate, c("cases", "population"), sep = " / ") %>% # you can just copy this from the previous exercise above
  mutate(case_rate = cases / population * 10000)
# did something go wrong? if so, can you modify the code fix it?
# you could use `convert = TRUE` to convert the separate characters to an appropriate type
table3 %>% 
  separate(rate, c("cases", "population"), sep = " / ",
           convert = TRUE) %>% 
  mutate(case_rate = cases / population * 10000)
# or you can use use mutate to do this yourself:
table3 %>% 
  separate(rate, c("cases", "population"), sep = " / ") %>% 
  mutate(cases = as.integer(cases),
         population = as.integer(population),
         case_rate = cases / population * 10000)


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE


# 3. Import, tidy, and join data -----
excel_sheets("table4.xlsx") # list all sheets in table4.xlsx

# use read_excel to read in the sheet "cases" from table4.xlsx and assign it to table4a
table4a <- read_excel("table4.xlsx",
                      sheet = "cases")
table4a # let's take a look

# tidy table4a so it matches the structure of table1
tidy_table4a <- table4a %>% 
  pivot_longer(-year, names_to = "country", values_to = "cases") %>% 
  relocate(country) # bring country back to the "front" of the data frame

# use read_excel to read in the sheet "population" from table4.xlsx and assign it to table4a
table4b <- read_excel("table4.xlsx",
                      sheet = "population",
                      range = "A2:C5")
table4b # let's take a look

# tidy table4b so it matches the structure of table1
tidy_table4b <- table4b %>% 
  pivot_longer(-country, names_to = "year", values_to = "population",
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
mia_carriers <- flights %>% 
  filter(dest == "MIA") %>% 
  select(carrier) %>% 
  distinct()
mia_airlines <- left_join(mia_carriers, airlines)
mia_airlines


# 4.2 did any of the carriers that flew to Miami also fly to Syracuse?
syr_carriers <- flights %>% 
  filter(dest == "SYR") %>% 
  select(carrier) %>% 
  distinct()
syr_airlines <- left_join(syr_carriers, airlines)
syr_airlines
# use inner join to find rows in both x and y
inner_join(mia_airlines, syr_airlines)
# answer: no, no carriers that flew to Miami also flew to Syracuse


# 4.3 what is the oldest plane that flew from NYC to MIA?
# hint: you can use flights in conjunction with planes, which are connected by tailnum (as we saw in the slides)
mia_tailnums <- flights %>% 
  filter(dest == "MIA") %>% 
  select(tailnum) %>% 
  distinct()
left_join(mia_tailnums, planes) %>% 
  arrange(year) %>% 
  filter(row_number() == 1)
