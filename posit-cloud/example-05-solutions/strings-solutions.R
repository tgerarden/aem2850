# AEM 2850 - Example 5
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # this has already been done for you
library(tidyverse) # load the core tidyverse packages

# today we'll explore textual data on Airbnb listings from New York City
# the data come from Inside Airbnb, an activist project:
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
amenities <- amenities |>
  mutate(length = str_length(amenities))

# count the number of individual amenities using str_count()
# assign it to a new variable count
# approximate this by counting commas (between each amenity)
# hint: how many commas are present if there is just one amenity?
amenities <- amenities |>
  mutate(count = str_count(amenities, ",") + 1)

# how similar are these measures?
# run the code below to plot count vs length
# note: these ggplot, geom_point, theme_bw functions will not be on prelim 1!
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
amenities |>
  filter(str_detect(amenities, "Wifi"))

# now filter to find all listings with "Wifi" in any case:
# by creating a variable amenities_lower using str_to_lower(),
# and then use str_detect() to filter for "wifi"
amenities |>
  mutate(amenities_lower = str_to_lower(amenities)) |>
  filter(str_detect(amenities_lower, "wifi"))

# now filter to find all listings with "Wifi" in any case using regex()
amenities |>
  filter(str_detect(amenities, regex("Wifi", ignore_case = TRUE)))

# how did these three approaches compare?
# find the instances that use wifi in any capitalization other than "Wifi"
amenities |>
  filter(str_detect(amenities, regex("wifi", ignore_case = TRUE))) |>
  filter(!str_detect(amenities, "Wifi"))


# now let's use str_detect() to create two new logical variables:
# 1. has_parking that indicates whether amenities include the word "parking"
# 2. has_wifi that indicates whether amenities include the word "Wifi" or "wifi"
amenities <- amenities |>
  mutate(
    has_parking = str_detect(amenities, "parking"),
    has_wifi = str_detect(amenities, "Wifi|wifi")
  )

# use summarize to take the mean of each has_wifi and has_parking
# to compute the share of listings with each one
amenities |>
  summarize(
    has_wifi = mean(has_wifi),
    has_parking = mean(has_parking)
  )

# what is the average review_scores_rating of
# listings with and without parking?
# ignore NA values using "na.rm = TRUE" if needed
amenities |>
  group_by(has_parking) |>
  summarize(mean_review = mean(review_scores_rating, na.rm = TRUE))


# 2. Regular expressions ----

# 2.1 Sometimes strings are not as they appear ----

# extract amenities for the first row as a string (not a data frame)
first_amenities <- amenities |>
  slice_head(n = 1) |>
  pull(amenities)

# write the name of the object you just created to print it
first_amenities

# now use str_view() to print the "real" data
str_view(first_amenities)

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


# 2.2 Repetition ----

# what if we want to search for strings with
#   patterns that are not contiguous?
# let's investigate this by looking at all the
#   descriptions that include "bedroom"
descriptions <- listings |> select(description)
descriptions |>
  filter(str_detect(description, "bedroom"))

# copy and modify the code above to find
#   descriptions that use "bed room"
descriptions |>
  filter(str_detect(description, "bed room"))

# the metacharacter . will match any single character
# copy and modify the code above to match "bed" and "room"
#   separated by any 1 character (including a space)
descriptions |>
  filter(str_detect(description, "bed.room"))

# the metacharacter ? will match a character 0 or 1 times
# this can be combined with other characters
#   or with metacharacters like .
# copy and modify the code above to find
#   descriptions that include "bed" and "room"
#   separated by any 0 or 1 characters
# how is the result different from when you only used . above?
descriptions |>
  filter(str_detect(description, "bed.?room"))

# the metacharacter * will match a character 0 or more times
# this can be combined with other characters
#   or with metacharacters like .
# copy and modify the code above to find
#   descriptions that include "bed" and "room"
#   separated by any 0 or more characters
# how is the result different from your results above?
descriptions |>
  filter(str_detect(description, "bed.*room"))


# 2.3 Anchors ----
# anchors can be used to search for patterns in specific positions

# suppose you want to analyze whether local airbnb landlords
#   have better reviews that absentee landlords
# use filter() and str_detect() to find listings where
#   host_location includes "New York" and pass them
#   the pipe to count() to count how many there are
listings |>
  filter(str_detect(host_location, "New York")) |>
  count()

# did that work?
listings |>
  filter(id==15789384) |>
  select(contains("host"))

# no. we want to find hosts in NYC, not just NYS!
# we could anchor the search for "New York"
#   at the beginning of host_location
# ^ can be used to match the start of the string (e.g., "^New York")
# note: this is NOT the same as negation of character classes, [^aeiou]
# do that to see how many listings have
#   host_locations that start with "New York"
listings |>
  filter(str_detect(host_location, "^New York")) |>
  count()

# similarly, use $ to match patterns at the end of a string
# find host_locations that end with "United States"
listings |>
  filter(str_detect(host_location, "United States$")) |>
  count()


# 3. Analyzing more strings ----
# - start with listings
# - remove rows where `bathrooms_text` is missing (NA)
# - match "share" (regardless of case) in `bathrooms_text`
#   to find listings with shared vs not shared bathrooms
# - convert prices from strings to numbers by
#   - using str_replace to remove dollar signs: \\$
#   - using str_replace to remove commas: ,
#   - using as.numeric() to coerce
# - assign the result to bath_data
bath_data <- listings |>
  filter(!is.na(bathrooms_text)) |>
  mutate(shared_bath =
           str_detect(
             bathrooms_text,
             regex("share", ignore_case = TRUE)
           ),
         price = str_replace(price, "\\$", ""), # or use str_remove
         price = str_replace(price, ",", ""), # or use str_remove
         price = as.numeric(price)
         # or, we could simply use parse_number:
         # price = parse_number(price)
  )

# using bath_data:
# - remove cases with missing reviews OR missing prices
# - for each group of `shared_bath`, compute the
#   average price and review_scores_rating
# how does having a shared bath correlate with prices? reviews?
bath_data |>
  filter(!is.na(review_scores_rating) & !is.na(price)) |>
  group_by(shared_bath) |>
  summarize(
    price = mean(price),
    mean_review = mean(review_scores_rating)
  )
