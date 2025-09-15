# AEM 2850 - example-02-1
# Plan for today:
# - Questions?
# - As a group, work through this script
#   - Write your own code in place of "______"
#   - Note: you can select each set of underscores using Alt/Option + Shift + Left/Right, and then overwrite them
# - Please don't hesitate to ask questions!


# 0. Loading the tidyverse -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages


# 1. Getting Comfortable with Data Frames: Intro -----
# we will use the data from this 538 article: https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/
# this comes from the package fivethirtyeight, but we will assign it to college_majors without actually loading the package

# we need to install packages once before we can use them
# install.packages("fivethirtyeight") # in this case, it has already been done for you in this project

# use Help to locate data documentation: what is stored in the variable median?
?fivethirtyeight::college_recent_grads

# assign the data to college_majors so we don't need to load fivethirtyeight
college_majors <- fivethirtyeight::college_recent_grads

# college_majors is a tibble, so we can just print it
# to get a sense of its structure, variable names, etc.
college_majors


# 2. Getting Comfortable with Data Frames -----
# 2.1 dplyr::select -----
# use dplyr::select to print the variable major contained within college_majors
select(college_majors, major)

# now do it with the pipe
college_majors |> select(major)

# do it again, but with more whitespace to improve readability
# recall the keyboard shortcut to insert the pipe: Ctrl/Cmd + Shift + M
college_majors |>
  select(major)

# select returned a data frame even though you only asked for one variable
# see what happens when you use the function pull to get just the vector:
college_majors |>
  pull(major)

# now print college_majors
college_majors
# why doesn't R "remember" the results of the command we just used?
# we never used the assignment operator! # replace "______" with your answer

# use dplyr::select to extract three variables: rank, major, and median salary
college_majors |>
  select(rank, major, median)

# or: use dplyr::relocate to move rank, major, and median to the "front" of the data frame
college_majors |>
  relocate(rank, major, median)

# now use dplyr::select to get major, major_category, median salary and assign result to college_salaries
college_salaries <- college_majors |>
  select(major, major_category, median)

# how many rows and columns does this new data frame have?
# did you get the right number of variables?
dim(college_salaries)

# use dplyr::select to get the major and total number of people with the major
college_majors |>
  select(major, total)

# use contains() to select major, total, and any column that contains "job"
college_majors |>
  select(major, total, contains("job"))

# use contains() to select major, total, and any column that contains "employed"
college_majors |>
  select(major, total, contains("employed"))

# get the names of the columns in the data frame college_majors
college_majors |>
  names()
# or:
names(college_majors)

# how could we select column names that contain employed but NOT unemployed?
# first, select major and all the columns that contain "employed"
college_majors |>
  select(major, contains("employed"))

# second, find a way to remove columns that contain unemployed
college_majors |>
  select(major, contains("employed"), -unemployed, -unemployment_rate)
# or:
college_majors |>
  select(major, contains("employed"), -contains("unemployed"))

# let's try to do the same thing a different way using starts_with()
college_majors |>
  select(major, starts_with("employed"))
