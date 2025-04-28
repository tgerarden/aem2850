# AEM 2850 - Example 14
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


# 1. Import airbnb listings ----
# import listings data

# what variables do we have?
names(listings)


# 2. Tokenizing airbnb listing names ----
# use tidytext::unnest_tokens to tokenize all the words in the name variable
#   put the tokens in a column named word
# filter out stop words contained in the object tidytext::stop_words
# assign the resulting data frame to name_words


# what does the resulting data frame look like?


# how do its dimensions compare to listings?
dim(_____)
dim(_____)

# use count() to identify the most frequently used words


# there are a bunch of airbnb-specific words we may want to treat as stop words
# use the combine function c() to make your own list of about 10-20 words like bedroom, apartment, etc.
# assign them to the name airbnb_stop_words


# filter out those words and then count again
# you may want to revise your stop words above and do this again
# what are the most commonly used words to describe properties (not locations)?



# 3. Quantifying review sentiment ----
# read in the data in reviews_text.csv


# select listing_id, id, and comments
# then use unnest_tokens to tokenize comments by word
# assign the result to reviews_words


# read in the sentiments data stored in afinn_sentiments.csv and join it to the review_words
# assign the result to reviews_sentiments


# compute the average sentiment of words in all the reviews for each (review) id
# slice_min to get the reviews with the 5 worst average sentiments
# join those listings back to reviews to read the specifics of their comments
# you can pull() the comments if you want to read them in their entirety


# how do you think this sentiment analysis performed?
# what are some advantages and disadvantages of this approach?


# now repeat the exercise above, but use slice_max to get the best reviews
# do you think this performed better or worse?


# now compute average sentiment of words in all the reviews for each listing_id
# filter to get just the listings with reviews that have average sentiment less than or equal to -2
# join those listing_id back to reviews to read the specifics of the comments


# how well do you think this method worked? do you notice anything interesting?
# how do you think this sentiment analysis could be improved?


# do most listings have reviews with positive or negative (average) sentiment?
# how could you visualize the range of different sentiments across listings?

