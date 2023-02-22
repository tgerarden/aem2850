# AEM 2850 - Example 4-2
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


# 1. Practice working with logicals using data from nycflights13 -----

# 1.1 boolean algebra
# use filter() to find all the flights scheduled between 6am and 8pm
# that arrived less than 20 minutes after their scheduled arrival time
flights |> 
  filter(_____)

# use mutate() to create a logical vector "on_time" based on that condition
flight_timeliness <- flights |> 
  mutate(on_time = _____)

# now summarize() my_logical using mean()
# what share of the flights are on-time daytime flights?
flight_timeliness |> 
  summarize(share = _____(_____))
# uh-oh! some of our values are NA. let's ignore them for now
flight_timeliness |> 
  _____(_____ = _____(_____, _____ = _____))


# 1.2 is.na()
# use filter() to find rows where dep_time and arr_time are not available
_____
# what do you think happened to these flights?

# now find rows where dep_time is available but arr_time is not
_____
# what do you think happened to these flights?


# 1.3 if_else()
# customize the cutoff for "too early!" below for you
# then use count() to find out how many flights are too early
flights |> 
  filter(dest == "MIA") |> 
  select(carrier, flight, dest, sched_dep_time) |> 
  mutate(too_early = if_else(sched_dep_time < 800, "too early!", "okay")) |> 
  _____(_____)

# use mutate() and if_else() to classify flights as "late" if their
# arr_delay was more than 15 minutes (and "not late" otherwise")
# how many flights were late? (hint: you could use count() again)
_____


# 1.4 case_when()
# customize the conditions below for you
# then use count() to find out how many flights are in each category
flights |> 
  filter(dest == "MIA") |> 
  select(carrier, flight, sched_dep_time) |> 
  mutate(too_early = case_when(
    sched_dep_time < 600   ~ "too early!",
    sched_dep_time < 800   ~ "still early",
    sched_dep_time <= 2000 ~ "okay",
    sched_dep_time > 2000  ~ "late"
    )
  ) |> 
  _____(_____)


# 1.5 delayed flights using case_when()
# create a variable "delay" that classifies flights according to:
# early if their arr_delay was less than 0 minutes
# on-time if their 0 <= arr_delay < 20
# late if their 20 <= arr_delay <60
# very late if 60 <= arr_delay < 180
# absurdly late if 180 <= arr_delay
# canceled (we think) if arr_delay is not available
# then count() delay
# tip: use the sequential nature of case_when to simplify your conditions!
_____


# bonus: let's revisit 1.1 and 1.2 using case_when()
# recompute the share of flights that are on-time daytime flights, treating
# arr_delay==NA as NOT being on time (as if it corresponds to a cancellation)
_____
