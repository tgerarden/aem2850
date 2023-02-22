# AEM 2850 - Example 4-1
# Plan for today:
# - Questions?
# - Go through slides
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
# install.packages("nycflights13") # in this case, it has already been done for you in this project
library(nycflights13) # load data frames we'll use later


# 1. Practice joins using data from nycflights13 -----

# 1.0 get to know the data frames we will work with
flights # print the first 10 rows of flights
# observations in flights are at the level of:
#   year - month - day - sched_dep_time - carrier - flight number
# so "time_hour - carrier - flight" can be used as the compound primary key for `flights`

airlines # print the first 10 rows of airlines
# observations in airlines are at the level of: carrier
# so "carrier" is the primary key for `airlines`

# check to make sure "carrier" uniquely identifies observations (rows)
# since this is a small data frame, you could also confirm it visually using
airlines |> 
  count(carrier)
# for larger data frames, combining count with filter make this scalable
airlines |> 
  count(carrier) |> 
  filter(n > 1)
# checks out! there are no carriers that show up more than once

# which name(s) seem likely to link `flights` and `airlines`?
intersect(names(airlines), names(flights)) # look for variables in both data frames
# checks out! the primary key for `airlines` is also in `flights`


# 1.1 use `flights` and `airlines` to get the names of the airlines 
#     that flew from NYC to Miami (MIA)
# the result should be a 3 x 2 data frame
# hints:
# 1. see above for the variable that links `flights` and `airlines`
# 2. use dplyr verbs on `flights` to get a 3 x 1 data frame with:
#    only rows that correspond to `dest == "MIA"`,
#    only the variable carrier,
#    only one row per carrier,
#    then join to airlines
mia_carriers <- flights |> 
  filter(dest == "MIA") |> 
  select(carrier) |> 
  distinct()
mia_airlines <- left_join(mia_carriers, airlines)
mia_airlines


# 1.2 did any of the carriers that flew to Miami also fly to Syracuse (SYR)?
syr_carriers <- flights |> 
  filter(dest == "SYR") |> 
  select(carrier) |> 
  distinct()
syr_airlines <- left_join(syr_carriers, airlines)
syr_airlines
# use inner join to find rows in both x and y
inner_join(mia_airlines, syr_airlines)
# answer: no, no carriers that flew to Miami also flew to Syracuse
# at least by name: ExpressJet and Endeavor flew for legacy


# 1.3 did any of the carriers that flew to Miami also fly to Ithaca (ITH)?
ith_carriers <- flights |> 
  filter(dest == "ITH") |> 
  select(carrier) |> 
  distinct()
ith_airlines <- left_join(ith_carriers, airlines)
ith_airlines
# use inner join to find rows in both x and y
inner_join(mia_airlines, ith_airlines)
# did anything go wrong?
# no, but apparently there were no flights from NYC airports to Ithaca in 2013


# 1.4 what is the oldest plane that flew from NYC to MIA in 2013?
# hint: you can use flights in conjunction with the data frame planes, 
#       which are connected by tailnum (as we saw in the slides)
mia_tailnums <- flights |> 
  filter(dest == "MIA") |> 
  select(tailnum) |> 
  distinct()
left_join(mia_tailnums, planes) |> 
  arrange(year) |> 
  filter(row_number() == 1)
# answer: the oldest plane was from 1956

# bonus question: which carrier flew that plane?
flights |> 
  filter(dest == "MIA") |> 
  select(tailnum, carrier) |> 
  distinct() |> 
  left_join(planes) |> 
  arrange(year) |> 
  filter(year == min(year, na.rm = TRUE)) |> 
  select(tailnum, year, carrier) |> 
  left_join(airlines)
# answer: American Airlines Inc.
