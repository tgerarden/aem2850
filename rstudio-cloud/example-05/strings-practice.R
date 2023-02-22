# AEM 2850 - Example 5
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages

# today we'll explore textual data on Airbnb listings from New York City
# the data come from Inside Airbnb, a mission driven activist project with the objective to:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; 
#   and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 0. Import airbnb listings ----
# import listings data and assign it to the name listings
______
# what variables do we have?
names(______)

# create a data frame called amenities that contains just the variables id, amenities, and review_scores_rating
______


# 1. Analyzing amenities ----
# note: for simplicity you can just reassign each modified data frame to the name amenities

# let's come up with a crude measure of the number of amenities each property has
# compute the length of the string amenities for each listing, and assign it to a new variable length
______

# count the number of individual amenities using str_count() and assign it to a new variable count
# hint: what character occurs once between each amenity?
# hint: how many of these characters are present if there is just one amenity?
______

# how similar are these measures? run the code below to make a scatter plot of count vs length
# note: this is just for illustrative purposes, ggplot2 functions will not be on prelim 1!
amenities |>
  ggplot(aes(x = length, y = count)) +
  geom_point() +
  theme_bw()

# another way to assess this is by looking at their correlation:
# note: this is just for illustrative purposes, cor() will not be on prelim 1!
amenities |> 
  select(length, count) |> 
  cor()

# now let's focus on a few specific amenities

# use str_detect() to filter the data to find all listings with "Wifi"
______

# now filter the data to find all listings with "Wifi" in any case using regex()
______

# now do it by first creating a variable amenities_lower using str_to_lower(),
# and then use str_detect() to filter for "wifi"
______

# how did these three approaches compare?
# find the instances that use wifi in any capitalization other than "Wifi"
______


# regular expressions can help us parse long strings like amenities
# try to fill in the blanks to count the different types of wifi in amenities
______ |> 
  ______(wifi = str_extract(______, 
                            regex("(\\w+\\s+)?wifi", # this will extract wifi and the word that precedes it, if applicable
                                  ignore_case = TRUE))) |> 
  count(______)


# now let's use str_detect() to create two new variables:
# 1. a logical variable has_parking that indicates whether each listing's amenities include the word "parking"
# 2. a logical variable has_wifi that indicates whether each listing's amenities include the word "Wifi" or "wifi"
______

# select has_wifi and has_parking, and pass them through the pipe to summarize_all(mean)
# this will compute the share of listings with wifi, and the share with parking
______

# what is the average review_scores_rating of listings with and without parking?
______


# 2. Intro to regular expressions ----

# 2a. Sometimes strings are not as they appear ----

# extract amenities for the first row as a string (not a data frame), and assign it to a name
# you can get the first row using bracket slice_head(n = 1)
# you can get the column amenities as a vector using pull()
first_amenities <- ______ |>
  ______(n = 1) |>
  pull(amenities)

# write the name of the object you just created to print it
______

# now use writeLines(.) to print the "real" data
______(first_amenities)

# what difference do you notice?


# as it turns out, certain characters need special representations in strings
# a good example is including single or double quotes in a string
# this is problematic because we use these to define boundaries for strings!
# try entering """ or ''' at the console, you will see that R will get confused
# it expects you to finish the second string; you can hit Escape or ctrl-c to get unstuck


# so things like this won't work:
writeLines(""The worst thing about prison was the dementors," said Michael Scott.")
# if you want a literal double quote within a string, you can "escape" it using \:
writeLines("\"The worst thing about prison was the dementors,\" said Michael Scott.")
# or you can mix ' and " as follows:
writeLines('"The worst thing about prison was the dementors," said Michael Scott.')

# all the the instances of \" in `first_amenities` are representations of literal double quotes
# writeLines() shows us what it "should" look like


# 2b. Anchors ----
# anchors can be used to search for patterns in specific locations within a string

# say you want to analyze whether local airbnb landlords have better reviews that absentee landlords
# use filter() and str_detect() to find listings where host_location includes "New York"
# pass that through the pipe to nrow() to count how many there are
______

# did that work?
listings |>
  filter(id==15789384) |>
  select(contains("host"))

# no. we want to find hosts in NYC, not just NYS!
# one way to solve this problem would be to anchor your search for "New York" at the beginning of host_location
# ^ can be used to match the start of the string (e.g., "^New York")
# try doing that to see how many listings have host_locations that start with "New York"
______

# similarly, you can search for things at the end of a string using $ (e.g., "United States$")


# 2c. Repetition ----

# another handy thing is to search for two components of a string that are separated by one or more characters
# let's illustrate this by looking at all the descriptions that include "bedroom"
descriptions <- listings |> select(description)
descriptions |>
  filter(______(description, "______"))

# copy and modify the code above to find descriptions that use "bed room"
______

# the metacharacter . can be used to match any single character
# copy and modify the code above to find descriptions that use "bed" and "room" separated by any 1 character (including a space)
______

# the metacharacter ? can be used to match a character 0 or 1 times
# this can be combined with other characters, or with metacharacters like .
# copy and modify the code above to find descriptions that include "bed" and "room" separated by any 0 or 1 characters
# how is the result different from when you only used . above?
______

# the metacharacter * can be used to match a character 0 or more times
# this can be combined with other characters, or with metacharacters like .
# copy and modify the code above to find descriptions that include "bed" and "room" separated by any 0 or more characters
# how is the result different from your results above?
______


# 3. Analyzing more strings ----
# identify listings that have shared bathrooms vs not shared bathrooms
# compute the average price and review_scores_rating for each group
# note: you may need to str_replace() non-numeric characters in price,
#   and use as.numeric() to convert the string data to numeric data
# tip: it's also a good idea to remove missing reviews and prices to compare apples to apples, 
#   and to ensure the listings we are using for comparison are active
______


# how does having a shared bath influence reviews? prices?
