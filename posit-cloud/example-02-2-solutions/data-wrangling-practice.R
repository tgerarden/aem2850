# AEM 2850 - example-02-2
# Plan for today:
# - Questions?
# - As a group, work through 2. Developing our Data Wrangling Skills
# - Please don't hesitate to ask questions!
# - Time permitting: on your own, work through 3. Using Functions in Packages


# 0. Loading the tidyverse -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages

# today we will continue to use the data from this 538 article: https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/

# assign the data to college_majors so we don't need to load fivethirtyeight
college_majors <- fivethirtyeight::college_recent_grads

# use dplyr::select to create college_salaries
college_salaries <- college_majors |>
  select(major, major_category, median)


# 1. Developing our Data Wrangling Skills -----

# 1.1 dplyr::filter -----
# use dplyr::filter to find the row where major takes on the value "Finance"
college_salaries |>
  filter(major ______ "Finance")

# use dplyr::filter to find the row where major_category is "Business"
college_salaries |>
  filter(major_category ______ "______")

# now combine dplyr::filter with dplyr::select to print just
# the major and median columns for majors within Business
college_salaries |>
  ______(______ ______ "______") |> # subset majors within Business
  select(______, ______) # select major and median

# now get just the majors, and assign the result to business_majors
business_majors <- college_salaries |>
  ______(______ ______ "______") |> # subset majors within Business
  select(______)

# let's zoom back out
# how do majors rank by median earnings?
?fivethirtyeight::college_recent_grads # hint: what is the variable rank?
# get just the variable major for the top 10 of all the majors
college_majors |>
  ______(______ ______ ______) ______
  ______(______)

# how do business majors rank by median earnings?
# get just the rank and major for majors within Business. minimal hints this time!
______ ______
  ______(______ ______ ______) ______
  ______(______, ______)


# 1.2 dplyr::arrange -----
# let's print a data frame of the rank and major for majors within Business
# but now let's arrange Business majors alphabetically by major
______ ______
  ______(______ ______ ______) ______
  ______(______, ______) ______
  arrange(______)


# LET'S PAUSE HERE AND REGROUP
# ANY QUESTIONS?


# 1.3 dplyr::mutate -----
# let's revisit college_salaries with mutate
college_salaries |>
  ______(______ ______ ______) |>   # get Business majors only
  mutate(______ = median/______) |> # then create a variable median_salary in thousands of dollars
  ______(bitcoins = median/43075.60) |> # convert to bitcoins (based on 1/29/24 prices)
  ______(______ ______ ______) # what majors pay more than 1 bitcoin per year?

# let's clean up a bit
ls() # what objects have you defined so far?
rm(college_salaries) # money is not the only thing that matters in life!
ls() # what objects are left?


# LET'S PAUSE HERE AND REGROUP
# ANY QUESTIONS?


# 1.4 dplyr::summarize -----
# use dplyr::summarize to count the number of people across all majors
college_majors |>
  summarize(______ = sum(total))

# what went wrong there? use dplyr::filter to figure it out
college_majors |>
  filter(______(total))

# ok, take the sum excluding that major, in millions
college_majors |>
  ______(______ = sum(______, na.rm = TRUE)/10^6)


# 1.5 dplyr::group_by -----
# to make things more interesting, count students "by" major_category, in thousands
college_majors |>
  group_by(______) |>
  ______(______ = sum(______, na.rm = TRUE)/10^3)

# do it again, but now sort the data and compute category shares
college_majors |>
  ______(______) |>
  ______(______ = sum(______, ______ = ______)/10^3) |>
  ______(desc(______)) |> # sort categories from most to least students
  mutate(share = ______) # compute shares in percentage points


# LET'S PAUSE HERE AND REGROUP
# ANY QUESTIONS?


# 1.6 dplyr::distinct -----
# each row in college_majors corresponds to a college major
# use dplyr::select to get a data frame with just the major_category
college_majors |>
  ______(major_category)

# use dplyr::distinct to get a data frame of the distinct major_category
college_majors |>
  ______(major_category)

# 1.7 dplyr::count -----
# each row in college_majors corresponds to a college major
# use dplyr::count to count how many rows contain each major_category
# this is the same as counting how many majors are in each major_category
college_majors |>
  ______(major_category)

# use dplyr::count with argument "sort = TRUE" to arrange the categories
college_majors |>
  ______(major_category, ______ = ______)

# which major category has the largest number of individual majors?


# was that the same major category that had the largest number of students?


# LET'S PAUSE HERE AND REGROUP
# ANY QUESTIONS?


# 2. Using Functions in Packages: Practice -----
# install.packages("maps") # do this once -- but in this case, it has already been done for you in this project

# we can use `::` to call functions without loading a package
maps::map("world") # call function `map` from package `maps` without loading `maps`

# we can use `::` notation to be explicit about objects generally
?maps::map

# in many situations you will want to load the package for convenience
library(maps) # the function library() loads whatever package you give as its argument
map("world")
map("usa")
map("state")
map("world")
map("state", add = TRUE) # what did this do?
?maps::map # look for "add" under arguments to see what `add=TRUE` does


# 2.1 Using Functions in Packages: Breakout Groups -----
# your turn! see if you can find a way to use `map` to plot a map of new york
?maps::map # hint 1: use the help and take a look at the argument "regions"
ggplot2::map_data("state") |>  # hint 2: convert the maps data into our favorite object class: data frame! (ggplot2::map_data does this for us)
  as_tibble() # even better: convert it into a tibble for pretty printing
ggplot2::map_data("state") |>
  select(region) # hint 3: use select to isolate regions
ggplot2::map_data("state") |>
  distinct(region) # hint 4: use distinct() to remove duplicates
______ # insert your code to make a map of new york here
# if it doesn't render properly the first time, try entering the command again

# now use map("world") to map your home country, or another country of interest
______ # insert your code to make a map of a country here
# if it doesn't render properly the first time, try entering the command again
