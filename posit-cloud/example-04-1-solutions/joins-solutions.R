# AEM 2850 - Example 4-1
# Plan for today:
# - Questions?
# - Go through slides
# - On our own devices: work through sections 0-2 as a group, 3 on your own
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
# install.packages("nycflights13") # in this case, it has already been done for you in this project
library(nycflights13) # load data frames we'll use later


# 1. Let's use two small data frames to learn the join command basics -----

# 1.0 run these lines of code so superheroes and publishers are available to us
superheroes <- tribble(
  ~name,          ~alignment,   ~publisher,
  "Magneto",      "bad",        "Marvel",
  "Storm",        "good",       "Marvel",
  "Mystique",     "bad",        "Marvel",
  "Batman",       "good",       "DC",
  "Joker",        "bad",        "DC",
  "Catwoman",     "bad",        "DC",
  "Hellboy",      "good",       "Dark Horse Comics"
)

publishers <- tribble(
  ~publisher,    ~year_founded,
  "DC",          1934L,
  "Marvel",      1939L,
  "Image",       1992L
)

# look at the structure of superheroes and publishers
superheroes
publishers


# 1.1 use left_join(x, y) to join superheroes and publishers
# left_join is a mutating join: it adds variables to x
# it does not affect the rows of x, just the columns
left_join(superheroes, publishers)


# 1.2 use right_join(x, y) to join superheroes and publishers
# right_join is a mutating join: it adds variables to y
# it does not affect the rows of y, just the columns
right_join(superheroes, publishers)


# 1.3 use inner_join(x, y) to join superheroes and publishers
# inner_join returns all rows in x AND y
# how many rows do you think this inner join will produce?
inner_join(superheroes, publishers)


# 1.4 use full_join(x, y) to join superheroes and publishers
# full_join returns all rows in x OR y
# how many rows do you think this full join will produce?
full_join(superheroes, publishers)


# 1.5 use semi_join(x, y) to join superheroes and publishers
# semi_join is a filtering join: it keeps rows in x that have a match in y
# it does not affect the columns of x, just the rows
superheroes # remind ourselves what superheroes looks like
semi_join(superheroes, publishers)


# 1.6 use anti_join(x, y) to join superheroes and publishers
# anti_join is a filtering join: it keeps rows in x that DO NOT match y
# it does not affect the columns of x, just the rows
superheroes # remind ourselves what superheroes looks like
anti_join(superheroes, publishers)

# and just like that, you've learned dplyr's six join verbs!


# 2. Key variables -----
# let's dig a little deeper into how these join commands work
# how do the join commands know what variables to use as keys?

# by default, they use all variables that are common across x and y
# one way to see what those are is using intersect() in conjunction with names()
# what variable names were used to join superheroes and publishers?
intersect(names(superheroes), names(publishers))

# alternatively, we can specify keys using the function join_by()
# let's left join superheroes and publishers, but
# this time include explicit keys: left_join(..., by = join_by(publisher))
left_join(superheroes, publishers, by = join_by(publisher))

# you can also do this without explicitly naming the `by` argument:
left_join(superheroes, publishers, join_by(publisher))


# 2.1 let's explore keys using the nycflights13 data
library(nycflights13) # make sure to load nycflights13 if you haven't already
# print the first 10 rows of flights and take a look
flights
# print the first 10 rows of planes and take a look
planes

# let's perform a left join on planes and flights
# did it work?
# do you notice any problems?
# look closely at the join output: what keys did it use?
left_join(planes, flights)

# by default, it uses columns with the same name
## Joining with `by = join_by(tailnum, year)`
# do you see a potential problem here?

# what does the variable `year` mean in `planes`? (try typing ?planes)
?planes
## year manufactured
# what does the variable `year` mean in `flights`? (try typing ?flights)
?flights
## year of departure
# uh oh!
# the variable `year` does not have a consistent meaning across the data frames

# luckily we can avoid this by using the argument `join_by(...)`
# what should we join planes and flights by?
# do it:
left_join(planes, flights, join_by(tailnum))

# what happened to the two year variables? (select them after the join to check)
left_join(planes, flights, join_by(tailnum)) |>
  select(contains("year"))

# how could we get around this?
# one option would be to rename the year in planes before the join:
planes |>
  rename(year_built = year) |>
  left_join(flights, join_by(tailnum)) |>
  select(contains("year"))

# if we do this, we actually don't need the join_by() function, since
# there are no longer two different variables with the same name
planes |>
  rename(year_built = year) |>
  left_join(flights) |>
  select(contains("year"))

# how many rows are in the joined data? how many rows are in flights?
planes |>
  rename(year_built = year) |>
  left_join(flights) |>
  select(contains("year")) |>
  nrow()

flights |>
  nrow()

# how could we modify our join code above to make sure we get all the flights
# in flights, even if the detailed plane information is missing from planes?
planes |>
  rename(year_built = year) |>
  right_join(flights) # right_join will preserve the rows in flights


# 3. Practice joins using data from nycflights13 -----

# 3.0 get to know the data frames we will work with
# print the data in flights
flights
# observations in flights are at the level of:
#   year - month - day - sched_dep_time - carrier - flight number
# so "time_hour - carrier - flight" can be used as the compound primary key for `flights`

# print the data in airlines
airlines
# observations in airlines are at the level of: carrier
# so "carrier" is the primary key for `airlines`

# check to make sure "carrier" uniquely identifies observations (rows)
# since this is a small data frame, you could confirm it visually using
airlines |>
  count(carrier)
# for larger data frames, combining count with filter makes this scalable
airlines |>
  count(carrier) |>
  filter(n > 1)
# checks out! there are no carriers that show up more than once

# which name(s) seem likely to link `flights` and `airlines`?
# hint: we already did this kind of thing using intersect()
intersect(names(airlines), names(flights))
# checks out! the primary key for `airlines` is also in `flights`


# 3.1 use `flights` and `airlines` to get the names of the airlines
#     that flew from NYC to Miami International Airport (MIA)
# the result should be a 3 x 2 data frame
# hints:
# - see above for the variable that links `flights` and `airlines`
# - use dplyr verbs on `flights` to get a 3 x 1 data frame with:
#    only rows that correspond to `dest == "MIA"`,
#    only the variable carrier,
#    only one row per carrier,
#    then join to airlines
mia_carriers <- flights |>
  filter(dest == "MIA") |>
  distinct(carrier)
mia_airlines <- left_join(mia_carriers, airlines)
mia_airlines


# 3.2 did any of the carriers that flew to Miami also fly to Syracuse (SYR)?
syr_carriers <- flights |>
  filter(dest == "SYR") |>
  distinct(carrier)
syr_airlines <- left_join(syr_carriers, airlines)
syr_airlines
# use inner join to find rows in both x and y
inner_join(mia_airlines, syr_airlines)
# answer: no, no carriers that flew to Miami also flew to Syracuse
# well... ExpressJet and Endeavor flew for legacy carriers United and Delta


# 3.3 did any of the carriers that flew to Miami also fly to Ithaca (ITH)?
ith_carriers <- flights |>
  filter(dest == "ITH") |>
  distinct(carrier)
ith_airlines <- left_join(ith_carriers, airlines)
ith_airlines
# use inner join to find rows in both x and y
inner_join(mia_airlines, ith_airlines)
# did anything go wrong?
# no, but apparently there were no flights from NYC airports to Ithaca in 2013


# 3.4 what is the oldest plane that flew from NYC to MIA in 2013?
# hint: you can use flights in conjunction with the data frame planes,
#       which are connected by tailnum (as we saw earlier in this example)
mia_tailnums <- flights |>
  filter(dest == "MIA") |>
  distinct(tailnum)
left_join(mia_tailnums, planes) |>
  slice_min(year, n = 1)
# or:
left_join(mia_tailnums, planes) |>
  slice_min(year)
# answer: the oldest plane was from 1956

# bonus question: which carrier flew that plane?
flights |>
  filter(dest == "MIA") |>
  distinct(tailnum, carrier) |>
  left_join(planes) |>
  filter(year == min(year, na.rm = TRUE)) |>
  select(tailnum, year, carrier) |>
  left_join(airlines)
# answer: American Airlines Inc.
