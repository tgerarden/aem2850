# AEM 2850 - example-04-2
# Plan for today:
# - Questions?
# - Go through slides
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages
# install.packages("nycflights13") # this has already been done for you
library(nycflights13) # load data frames we'll use later


# 1. Basics of logicals and Boolean algebra -----

# 1.1 the simplest logical vector is a single logical
class(TRUE)
class(FALSE)
class(NA)


# 1.2 comparisons create logical vectors
"a" == "a"
"a" != "a"

"a" == "b"
"a" != "b"

# use all the operators from slide 40 to compare numbers to the number 2
numbers <- c(1, 2, 3)
numbers
numbers == 2 # ==
numbers != 2 # !=
numbers >= 2 # >=
numbers > 2  # >
numbers <= 2 # <=
numbers < 2  # <

# we can do math with logical vectors
numbers
# how many elements of numbers are == 2? (what is the sum of numbers == 2?)
sum(numbers==2)
# what fraction of the elements of numbers are == 2?
mean(numbers==2)


# 1.3 review Boolean operators using TRUE and FALSE
TRUE             # x
!TRUE            # !x
FALSE            # y
!FALSE           # !y
TRUE & FALSE     # x & y
TRUE | FALSE     # x | y
TRUE & !FALSE    # x & !y
!TRUE & FALSE    # !x & y
xor(TRUE, FALSE) # xor(x, y)
xor(TRUE, TRUE)  # xor(x, x)


# 1.4 apply Boolean algebra to compare numbers to the number 2
numbers < 2
numbers > 2
numbers < 2 & numbers > 2   # &
numbers <= 2 & numbers >= 2 # &
numbers < 2 | numbers > 2   # |
numbers <= 2 | numbers >= 2 # |


# 1.5 is.na() is useful for checking with something is NA
numbers==NA
is.na(numbers)

NA==NA
is.na(NA)


# 2. Practice working with logicals using data from nycflights13 -----

# 2.1 Boolean algebra
# use filter() to find all the flights scheduled between 6am and 8pm
# that arrived less than 20 minutes after their scheduled arrival time
# 6am is 600; 8pm is 2000
flights |>
  filter(sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20)

# use mutate() to create a logical vector "on_time" based on that condition
# you can just copy and paste your condition from above to the right of the =
flight_timeliness <- flights |>
  mutate(on_time = sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20)

# now summarize() my_logical using mean()
# what share of the flights are on-time daytime flights?
flight_timeliness |>
  summarize(share = mean(on_time))
# uh-oh! some of our values are NA. let's ignore them for now
flight_timeliness |>
  summarize(share = mean(on_time, na.rm = TRUE))


# 2.2 is.na()
# use filter() to find rows where dep_time and arr_time are not available
flights |>
  filter(is.na(dep_time) & is.na(arr_time))
# what do you think happened to these flights?

# now find rows where dep_time is available but arr_time is not
flights |>
  filter(!is.na(dep_time) & is.na(arr_time))
# what do you think happened to these flights?

# let's revisit our results on the share of on-time daytime flights
# what share of flights seem to be canceled daytime flights, based on arr_delay?
flights |>
  mutate(canceled = (sched_dep_time > 600 & sched_dep_time < 2000 & is.na(arr_delay))) |>
  summarize(share = mean(canceled))

# how can we combine the two conditions on arr_delay to get the share
# of daytime flights that are on-time daytime flights
# (treating canceled flights as NOT on time)
flights |>
  mutate(on_time = sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20 & !is.na(arr_delay)) |>
  summarize(share = mean(on_time))


# 2.3 if_else()
# customize the cutoff for "too early!" below for you
# then use count() to find out how many flights are too_early
flights |>
  filter(dest == "MIA") |>
  select(carrier, flight, dest, sched_dep_time) |>
  mutate(too_early = if_else(sched_dep_time < 800, "too early!", "okay")) |>
  count(too_early)

# use mutate() and if_else() to classify flights as "late" if their
# arr_delay was more than 15 minutes (and "not late" otherwise")
# how many flights were late? (hint: you could use count() again)
flights |>
  mutate(late = ifelse(arr_delay > 15, "late", "not late")) |>
  count(late)


# 2.4 case_when()
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


# 2.5 delayed flights using case_when()
# create a variable delay that classifies flights according to:
# early if their arr_delay was less than 0 minutes
# on-time if their 0 <= arr_delay < 20
# late if their 20 <= arr_delay <60
# very late if 60 <= arr_delay < 180
# absurdly late if 180 <= arr_delay
# canceled (we think) if arr_delay is not available
# then count() delay
# tip: use the sequential nature of case_when to simplify your conditions!
flights |>
  mutate(delay = case_when(
    arr_delay < 0   ~ "early",
    arr_delay < 20   ~ "on-time",
    arr_delay < 60 ~ "late",
    arr_delay < 180  ~ "very late",
    arr_delay >= 180 ~ "absurdly late",
    is.na(arr_delay) ~ "canceled (we think)"
  )
  ) |>
  count(delay)


# bonus: let's revisit 2.1 and 2.2 using case_when()
# recompute the share of flights that are on-time daytime flights, treating
# arr_delay==NA as NOT being on time (as if it corresponds to a cancellation)
flights |>
  mutate(on_time = case_when(
    is.na(arr_delay) ~ FALSE, # treat missing values as not on time
    sched_dep_time > 600 & sched_dep_time < 2000 & arr_delay < 20 ~ TRUE,
    .default = FALSE) # this fills all remaining cells of my_logical with "FALSE"
  ) |>
  summarize(share = mean(on_time))


# solutions for both examples will be posted by the end of this week
# if you ran into trouble with either example, please review the solutions
# and then come to office hours with questions!
