# AEM 2850 - Example 12
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




# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----
# 1. NEED TO REVISE THIS EXAMPLE AFTER SHIFTING MATERIAL TO WEEK 5 ----




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
# what are the most commonly used words to describe properties (not locations)?
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
# how do you think this sentiment analysis could be improved?


# do most listings have reviews with positive or negative (average) sentiment?
# how could you visualize the range of different sentiments across listings?
reviews_sentiments %>%
  group_by(listing_id) %>%
  summarize(value = mean(value)) %>%
  ggplot(aes(x = value)) +
  geom_density()
