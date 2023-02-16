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
  filter(sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20)

# use mutate() to create a logical vector "my_logical" based on that condition
flights |> 
  mutate(my_logical = sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20)

# now summarize() my_logical using mean()
# what share of the flights are on-time daytime flights?
flights |> 
  mutate(my_logical = sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20) |> 
  summarize(share = mean(my_logical))
# uh-oh! some of our values are NA. let's ignore them for now
flights |> 
  mutate(my_logical = sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20) |> 
  summarize(share = mean(my_logical, na.rm = TRUE))


# 1.2 if_else()
# customize the cutoff for "too early!" below for you
# then use count() to find out how many flights are too early
flights |> 
  filter(dest == "MIA") |> 
  select(carrier, flight, dest, sched_dep_time) |> 
  mutate(too_early = if_else(sched_dep_time < 800, "too early!", "okay")) |> 
  count(too_early)

# use mutate() and if_else() to classify flights as "late" if their
# arr_delay was more than 15 minutes (and "not late" otherwise")
# how many flights were late? (hint: you could use count() again)
_____
flights |> 
  mutate(late = ifelse(arr_delay > 15, "late", "not late")) |> 
  count(late)


# 1.3 case_when()
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
  count(too_early)


# 1.4 delayed flights
# use case_when() to classify flights according to:
# early if their arr_delay was less than 0
# on-time if their arr_delay was less than 20
# ...
# ...
# ...
_____
flights |>
  mutate(delay = case_when(
    arr_delay < 0   ~ "early",
    arr_delay < 20   ~ "on-time",
    arr_delay < 60 ~ "late",
    arr_delay < 120  ~ "very late"
  )
  ) |> 
  count(delay)







