# AEM 2850 - Example 11
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(tidytext) # load tidytext package (https://www.tidytextmining.com)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll explore textual data on Airbnb listings from New York City
# the data come from Inside Airbnb, a mission driven activist project with the objective to:
#   Provide data that quantifies the impact of short-term rentals on housing and residential communities; and also provides a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals.
# http://insideairbnb.com


# 0. Import airbnb listings ----
# import listings data
listings <- read_csv("listings_text.csv")
# what variables do we have?
names(listings)

# create a data frame called amenities that contains just the variables id, amenities, and review_scores_rating
amenities <- listings %>%
  select(id, amenities, review_scores_rating)


# 1. Intro to regular expressions ----

# 1a. Sometimes strings are not as they appear ----

# extract amenities for the first row as a string (not a data frame), and assign it to a name
# you can get the first row using bracket indexing or slice_head(n = 1)
# you can get the column amenities as a vector using $ or pull()
first_amenities <- amenities[1, ]$amenities

first_amenities <- amenities %>%
  slice_head(n = 1) %>%
  pull(amenities)

# enter the name of the object you just created in the console to print it
first_amenities

# now use writeLines(.) to print the "real" data
writeLines(first_amenities)

# what difference do you notice?

# as it turns out, certain characters need special representations
# a good example is including single or double quotes in a string: we usually use these to define boundaries for strings!
# if you type """ at the console, R will get confused
# if you want a literal double quote within a string, you need to "escape" it
# for example:
writeLines("\"The worst thing about prison was the dementors,\" said Michael Scott.")


# 1b. Anchors ----
# anchors can be used to search for patterns in specific locations within a string

# say you want to analyze whether local airbnb landlords have better reviews that absentee landlords
# use filter() and str_detect() to find listings where host_location includes "New York"
# pass that through the pipe to nrow() to count how many there are
listings %>%
  filter(str_detect(host_location, "New York")) %>%
  nrow()

# did that work?
listings %>%
  filter(id==15789384) %>%
  select(contains("host"))

# one way to solve this problem would be to anchor your search for "New York" at the beginning of host_location
# ^ can be used to match the start of the string (e.g., "^New York")
# try doing that to see how many listings have host_locations that start with "New York"
listings %>%
  filter(str_detect(host_location, "^New York")) %>%
  nrow()

# similarly, you can search for things at the end of a string using $ (e.g., "United States$")


# 1c. Repetition ----

# another handy thing is to search for two components of a string that are separated by one or more characters
# let's illustrate this by looking at all the descriptions that include "bedroom"
descriptions <- listings %>% select(description)
descriptions %>%
  filter(str_detect(description, "bedroom"))

# copy the code from above and check whether any descriptions use the term "bed room"
descriptions %>%
  filter(str_detect(description, "bed room"))

# the metacharacter . can be used to match any single character
# copy and modify the code above to find descriptions that include "bed" and "room" separated by any 1 character (including a space)
descriptions %>%
  filter(str_detect(description, "bed.room"))

# the metacharacter ? can be used to match a character 0 or 1 times
# copy and modify the code above to find descriptions that include "bed" and "room" separated by any 0 or 1 characters
descriptions %>%
  filter(str_detect(description, "bed.?room"))

# the metacharacter * can be used to match a character 0 or more times
# copy and modify the code above to find descriptions that include "bed" and "room" separated by 0 or more characters
descriptions %>%
  filter(str_detect(description, "bed.*room"))

# for more on basic regular expressions and working with strings in r, see
# chapter 14: Strings of R4DS (https://r4ds.had.co.nz/strings.html)


# 2. Analyzing amenities ----
# note: for simplicity you can just reassign modified objects to the name amenities throughout this section

# let's come up with a crude measure of the number of amenities each property has
# compute the length of the string amenities for each listing, and assign it to a new variable length
amenities <- amenities %>%
  mutate(length = str_length(amenities))

# count the number of individual amenities using str_count() and assign it to a new variable count
# hint: what character occurs once between each amenity?
amenities <- amenities %>%
  mutate(count = str_count(amenities, ",") + 1)

# how similar are these measures? use geom_point() to make a scatter plot of count vs length
amenities %>%
  ggplot(aes(x = length, y = count)) +
  geom_point()


# let's focus on a few specific amenities

# use str_detect() to create two new variables:
# 1. a logical variable has_wifi that indicates whether each listing's amenities include the word "Wifi"
# 2. a logical variable has_parking that indicates whether each listing's amenities include the word "parking"
amenities <- amenities %>%
  mutate(
    has_parking = str_detect(amenities, "parking"),
    has_wifi = str_detect(amenities, "Wifi")
    )

# select has_wifi and has_parking, and pass them through the pipe to summarize_all(mean)
# in order to compute the share of listings with wifi and parking
amenities %>%
  select(has_wifi, has_parking) %>%
  summarize_all(mean)

# what is the average review_scores_rating of listings with and without parking?
amenities %>%
  group_by(has_parking) %>%
  summarize(mean_review = mean(review_scores_rating, na.rm = TRUE))


# 3. Tokenizing names ----
# use tidytext::unnest_tokens to tokenize all the words in the name variable
# filter out stop words contained in the object tidytext::stop_words
title_words <- listings %>%
  unnest_tokens(output = word,
                input = name) %>%
  anti_join(., stop_words, by = "word")

# use count() to identify the most frequently used words
title_words %>%
  count(word, sort = TRUE)

# it's clear that there are a bunch of airbnb-specific words we want to treat as stop words
# use the combine function c() to make your own list of about 10-20 words like bedroom, apartment, etc.
airbnb_stop_words <- c("private", "bedroom", "bed", "apartment", "studio", "manhattan", "apt",
                       "east", "west", "central", "midtown", "upper", "village", "harlem", "times",
                       "1", "2", "1br",
                       "nyc", "location")

# filter out those words and then count again
# you may want to revise your stop words above and do this again
# what are the most commonly used adjectives?
title_words %>%
  filter(!(word %in% airbnb_stop_words)) %>%
  count(word, sort = TRUE)


# 4. Quantifying review sentiment ----
# read in the data in reviews_text.csv
reviews <- read_csv("reviews_text.csv")

# use unnest_tokens to tokenize the data by word
reviews_words <- reviews %>%
  select(listing_id, comments) %>%
  unnest_tokens(
    output = word,
    input = comments
    )

# read in the sentiments data stored in afinn_sentiments.csv and join it to the review_words
afinn_sentiments <- read_csv("afinn_sentiments.csv")
reviews_sentiments <- inner_join(reviews_words, afinn_sentiments)

# compute the average sentiment of words in all the reviews for each listing_id
# filter to get just the listings with reviews that have average sentiment less than or equal to -2
# join those listings back to reviews to read the specifics of their comments
reviews_sentiments %>%
  group_by(listing_id) %>%
  summarize(value = mean(value)) %>%
  filter(value <= -2) %>%
  inner_join(., reviews) %>%
  arrange(value) %>%
  select(comments) %>%
  head(20)

# how well do you think this method worked? do you notice anything interesting?

# do most listings have reviews with positive or negative sentiment?
# how could you visualize the range of different sentiments across listings?
reviews_sentiments %>%
  group_by(listing_id) %>%
  summarize(value = mean(value)) %>%
  ggplot(aes(x = value)) +
  geom_density()

