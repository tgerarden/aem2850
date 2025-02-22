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
listings <- read_csv("listings_text.csv")
# what variables do we have?
names(listings)

# create a data frame called amenities that contains just the variables:
# id, amenities, and review_scores_rating
amenities <- listings |>
  select(id, amenities, review_scores_rating)
# what does amenities look like? what are the column types?
amenities


# 1. Analyzing amenities ----
# for simplicity, let's reassign each modified data frame to the name amenities

# let's make a crude measure of the number of amenities each property has
# compute the length of the string amenities for each listing
# assign it to a new variable length
______

# count the number of individual amenities using str_count()
# assign it to a new variable count
# approximate this by counting commas (between each amenity)
# hint: how many commas are present if there is just one amenity?
______

# how similar are these measures?
# run the code below to plot count vs length
# note: these ggplot functions will not be on prelim 1!
amenities |>
  ggplot(aes(x = length, y = count)) +
  geom_point() +
  theme_bw()

# another way to assess this is by looking at their correlation:
# note: cor() will not be on prelim 1!
amenities |>
  select(length, count) |>
  cor()

# now let's focus on a few specific amenities

# use str_detect() to filter the data to find all listings with "Wifi"
______

# now filter to find all listings with "Wifi" in any case using regex()
______

# now do it by creating a variable amenities_lower using str_to_lower(),
# and then use str_detect() to filter for "wifi"
______

# how did these three approaches compare?
# find the instances that use wifi in any capitalization other than "Wifi"
______


# regular expressions can help us parse long strings like amenities
# run the code below to count the different types of wifi in amenities
amenities |>
  mutate(wifi = str_extract(
    string = amenities,
    pattern = regex("(\\w+\\s)?wifi", ignore_case = TRUE)
  )) |>
  count(wifi)

# what is the regular expression "(\\w+\\s)?wifi" doing?
# \\w+ matches one or more "word" characters (letters or numbers)
# \\s matches whitespace
# ? makes the word and space in () optional
# so this will extract wifi and the word that precedes it, if applicable
# `ignore_case = TRUE` this avoids case sensitivity of "wifi"


# now let's use str_detect() to create two new logical variables:
# 1. has_parking that indicates whether amenities include the word "parking"
# 2. has_wifi that indicates whether amenities include the word "Wifi" or "wifi"
______

# select has_wifi and has_parking, and
# pass them through the pipe to summarize_all(mean)
# to compute the share of listings with each one
amenities |>
  select(______, ______) |>
  summarize_all(mean)

# what is the average review_scores_rating of
# listings with and without parking?
# ignore NA values using "na.rm = TRUE" if needed
______


# 2. Regular expressions ----

# 2.1 Sometimes strings are not as they appear ----

# extract amenities for the first row as a string (not a data frame)
first_amenities <- amenities |>
  slice_head(n = 1) |>
  pull(amenities)

# write the name of the object you just created to print it
______

# now use str_view() to print the "real" data
______(first_amenities)

# what difference do you notice?

# certain characters need special representations in strings
# a good example is including single or double quotes in a string
# this is problematic since they define boundaries for strings!
# if you enter """ or ''' at the console, R will get confused
# because it expects you to finish the second string
# (you can hit Escape or ctrl-c to get unstuck)


# so things like this won't work:
str_view(""The worst thing about prison was the dementors," said Michael Scott.")
# to get a literal double quote within a string, "escape" it using \:
str_view("\"The worst thing about prison was the dementors,\" said Michael Scott.")
# or you can mix ' and " as follows:
str_view('"The worst thing about prison was the dementors," said Michael Scott.')

# the \" in `first_amenities` are representations of literal double quotes
# str_view() shows us what it "should" look like


# 2.2 Anchors ----
# anchors can be used to search for patterns in specific positions

# suppose you want to analyze whether local airbnb landlords
#   have better reviews that absentee landlords
# use filter() and str_detect() to find listings where
#   host_location includes "New York" and pass them
#   the pipe to count() to count how many there are
______

# did that work?
listings |>
  filter(id==15789384) |>
  select(contains("host"))

# no. we want to find hosts in NYC, not just NYS!
# we could anchor the search for "New York"
#   at the beginning of host_location
# ^ can be used to match the start of the string (e.g., "^New York")
# do that to see how many listings have
#   host_locations that start with "New York"
______

# similarly, use $ to match patterns at the end of a string
# find host_locations that end with "United States"
______


# 2.3 Repetition ----

# what if we want to search for strings with
#   patterns that are not contiguous?
# let's investigate this by looking at all the
#   descriptions that include "bedroom"
descriptions <- listings |> select(description)
descriptions |>
  filter(______(description, "______"))

# copy and modify the code above to find
#   descriptions that use "bed room"
______

# the metacharacter . will match any single character
# copy and modify the code above to match "bed" and "room"
#   separated by any 1 character (including a space)
______

# the metacharacter ? will match a character 0 or 1 times
# this can be combined with other characters
#   or with metacharacters like .
# copy and modify the code above to find
#   descriptions that include "bed" and "room"
#   separated by any 0 or 1 characters
# how is the result different from when you only used . above?
______

# the metacharacter * will match a character 0 or more times
# this can be combined with other characters
#   or with metacharacters like .
# copy and modify the code above to find
#   descriptions that include "bed" and "room"
#   separated by any 0 or more characters
# how is the result different from your results above?
______


# 3. Analyzing more strings ----
# - match the pattern "share" (regardless of case) to
#   find listings with shared vs not shared bathrooms
# - convert prices from strings to numbers by
#   - removing dollar signs: \\$
#   - removing commas: ,
#   - using as.numeric() to coerce
# - remove cases with missing reviews OR prices
# - for each group, compute the average
#   price and review_scores_rating
______


# how does having a shared bath correlate with reviews? prices?
