# AEM 2850 - Example 2
# Plan for today:
# - Questions?
# - As a group: briefly skim through basic-base-r.R
# - In breakout rooms: work through 1. Getting Comfortable with Data Frames
#   - Write your own code in place of "______"
#   - Note: you can select each set of underscores using Alt/Option + Shift + Left/Right, and then overwrite them
# - As a group: discuss results, answer questions
# - In breakout rooms: work through 2. Using Functions in Packages


# 1. Getting Comfortable with Data Frames: Intro -----
# we will use the data from this 538 article: https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/
# this comes from the package fivethirtyeight, but we will assign it to college_majors without actually loading the package

# we need to install packages once before we can use them
# install.packages("fivethirtyeight") # in this case, it has already been done for you in this project

# use Help to locate data documentation: what is stored in the variable median?
?fivethirtyeight::college_recent_grads

# assign the data to college_majors so we don't need to load fivethirtyeight
college_majors <- fivethirtyeight::college_recent_grads

# inspect its structure
str(college_majors)

# look at just the variable names
names(college_majors)

# view the data frame as a spreadsheet
View(college_majors)


# 1. Getting Comfortable with Data Frames: Breakout Groups -----
# use the indexing operator $ to print the variable major contained within college_majors
______

# look through the list manually to find "Finance" -- what number element is it?
______ # this corresponds to its row number in the data frame

# use the indexing operator [] to print the observation that contains data for the major Finance
college_majors[ , ] # do this manually using the row number for now (hint: put your number from above before the comma)

# now let's combine indexing with the combine function, c()
# use the indexing operator [] to get the variables major, major_category, median, and assign them to college_salaries
______

# how many rows and columns does this new data frame have?
dim(college_salaries)

# did you get the right number of variables?
dim(college_salaries)[2] == 3 # note the use of the indexing operator [] here to get the number of columns
ncol(college_salaries) == 3   # or we could use ncol() to get the number of columns

# use the indexing operator $ to get just the variable category and assign it to category
______

# use == to test whether each element of category is equal to "Business" and print the result
______

# the result above might not seem useful on its own
# but we can use logical expressions in indexing commands!
# use the indexing operator [] with your logical expression above to print the variables from college_salaries for majors within Business
______

# use the indexing operator [] to combine expressions: print just the major and median columns for majors within Business
______

# use the indexing operator [] to get just the name of the majors within Business, and assign these to business_majors
______

# let's zoom back out
# how do business majors rank by median earnings?
?fivethirtyeight::college_recent_grads # hint: what is the variable rank?
# print a data frame of the rank and major for majors within Business
______

# what are the top 10 majors by median salary? here are some hints:
______ # hint 1: start by using the <= operator to test whether rank is "less than or equals to" 10
______ # hint 2: use that conditional in the indexing operator to select the relevant rows
______ # hint 3: modify your inputs to the indexing operator [] to select the variable major

# cleaning up
ls() # what objects have you defined so far?
rm(category) # remove one (or more) of the objects
ls() # what objects are left?

# PLEASE STOP HERE AND LET US KNOW THAT YOUR GROUP IS DONE


# 2. Using Functions in Packages: Intro -----
# install.packages("maps") # do this once -- but in this case, it has already been done for you in this project

# we can use `::` to call functions without loading a package
maps::map("world") # call function `map` from package `maps` without loading `maps`

# we can use `::` notation to be explicit about objects generally
?maps::map

# in many situations you will want to load the package for convenience
library("maps") # the function library() loads whatever package you give as its argument
map("world")
map("usa")
map("state")
map("world")
map("state", add = TRUE) # what did this do?
?maps::map # look for "add" under arguments to see what `add=TRUE` does


# 2. Using Functions in Packages: Breakout Groups -----
# your turn! see if you can find a way to use `map` to plot a map of new york
?maps::map # hint 1: use the help and take a look at the argument "regions"
head(ggplot2::map_data("state")) # hint 2: convert the maps data into our favorite object class: data frame! (ggplot2::map_data does this for us)
ggplot2::map_data("state")$region # hint 3: use the indexing operator $ to isolate regions
unique(ggplot2::map_data("state")$region) # hint 4: use unique() to remove duplicates
______ # insert your code to make a map of new york here
# if it doesn't render properly the first time, try entering the command again

# now use map("world") to map your home country, or another country of interest
______ # insert your code to make a map of a country here
# if it doesn't render properly the first time, try entering the command again
