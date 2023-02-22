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
# install.packages("palmerpenguins")
library(palmerpenguins)

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# data prep for 2. Aesthetic mappings
temperatures <- read_csv("https://wilkelab.org/SDS375/datasets/tempnormals.csv") %>%
  mutate(
    location = factor(
      location, levels = c("Death Valley", "Houston", "San Diego", "Chicago")
    )
  ) %>%
  select(location, day_of_year, month, temperature)
temps_houston <- filter(temperatures, location == "Houston")



# 1. Warm up -----
# let's practice mapping from data to aesthetics using palmerpenguins::penguins

?penguins # background on data

names(penguins) # what are the column names?

# first, let's visualize body mass and flipper length for penguins
# map flipper_length_mm to the x-axis, body_mass_g to the y-axis, and add points
penguins %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
# is this data pattern intuitive?

# now map bill_length_mm to the x-axis, bill_depth_mm to the y-axis, and add points
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()
# now add a line of best fit
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  geom_smooth(method = "lm")
# is this data pattern intuitive?

# augment the mapping: color by species
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point()
# now add a line of best fit
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  geom_smooth(method = "lm")
# is this data pattern intuitive?
# why did writing `geom_smooth` once produce three different lines?

# this is an example of simpson's paradox
# https://en.wikipedia.org/wiki/Simpson%27s_paradox


# now facet by species
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species)

# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following additions to our mapping:
# 1.1: map sex to color, add points, and facet by species (but don't add lines)
# REMOVE CODE EXAMPLE HERE!
penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)

# 1.2: why is there a color for sex that is labeled NA? make a version of the plot without it
penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)

# 1.3: make a new plot: map flipper_length_mm to x, bill_length_mm to y,
# species to color and shape, add points, and add a linear fit for each species
penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(aes(x = flipper_length_mm, y = bill_length_mm,
             color = species, shape = species)) +
  geom_point() +
  geom_smooth(method = "lm")


# 2. Aesthetic mappings ----
# Acknowledgement: Claus O. Wilke (https://wilkelab.org/SDS375/schedule.html)

# let's work with data on average temperature for each day of the year for Houston, TX, birthplace of queen bey:
temps_houston

# recall our barebones ggplot template:
# ggplot(data = DATA,
#        mapping = aes(AESTHETIC MAPPINGS)) +
#   GEOM_FUNCTION()

# try this for yourself. map the column `day_of_year` onto the x axis,
# and the column `temperature` onto the y axis, and use `geom_line()` to display the data
ggplot(temps_houston, aes(x = day_of_year, y = temperature)) +
  geom_line()

# try again, using `geom_point()` instead of `geom_line()`
ggplot(temps_houston, aes(x = day_of_year, y = temperature)) +
  geom_point()

# now swap which column you map to x and which to y
ggplot(temps_houston, aes(x = temperature, y = day_of_year)) +
  geom_point()

# let's explore some more complex geoms
# try using `geom_boxplot()` to make boxplots
# for boxplots, we frequently want categorical data on the x or y axis

# try this out: put `month` on the x axis, `temperature` on the y axis, and use `geom_boxplot()`
ggplot(temps_houston, aes(x = month, y = temperature)) +
  geom_boxplot()

# now put the month on the y axis and the temperature on the x axis
ggplot(temps_houston, aes(x = temperature, y = month)) +
  geom_boxplot()


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following changes to that last plot:
# 2.1: replace `geom_boxplot` with `geom_violin`
ggplot(temps_houston, aes(x = temperature, y = month)) +
  geom_violin()
# 2.2: replace `geom_boxplot` with `geom_jitter`
ggplot(temps_houston, aes(x = temperature, y = month)) +
  geom_jitter()


# 3. Adding color ----
# next let's work with the dataset `temperatures`, contains data for three more locations:
temperatures

# Using the `color` aesthetic

# make a line plot of `temperature` against `day_of_year`, and map location to color
ggplot(temperatures, aes(x = day_of_year, y = temperature, color = location)) +
  geom_line()

# try again. this time map `day_of_year` to the x-axis, `location` to the y-axis,
# `temperature` to color, and add points
ggplot(temperatures, aes(x = day_of_year, y = location, color = temperature)) +
  geom_point(size = 5) # use size = 5 to create larger points


# Using the `fill` aesthetic
# some geoms use a `fill` aesthetic, which is similar to `color` but applies to shaded areas (`color` applies to lines and points)

# try using the `fill` aesthetic with `geom_boxplot()` to color the interior of the box
# map `month` to x, `temperature` to y, and color the interior of the box by location
ggplot(temperatures, aes(x = month, y = temperature, fill = location)) +
  geom_boxplot()

# can you color the lines of the boxplot by location and the interior by month?
ggplot(temperatures, aes(x = month, y = temperature, color = location, fill = month)) +
  geom_boxplot()


# Using aesthetics as parameters

# many of the aesthetics can be used as parameters inside a geom rather than inside an `aes()` statement
# examples include `color`, `fill`, and also `size` to change line size or point thickness

# try this with the boxplot example from the previous section
# map `location` onto the `fill` aesthetic but set the color of the lines to "navyblue"
ggplot(temperatures, aes(x = month, y = temperature, fill = location)) +
  geom_boxplot(color = "navyblue")

# now do the reverse. map `location` onto the line colors but fill the box with the color "navyblue"
ggplot(temperatures, aes(x = month, y = temperature, color = location)) +
  geom_boxplot(fill = "navyblue")



## 4. Additional, open-ended exercises that we did in class ----
temperatures %>%
  ggplot(aes(x = day_of_year, y = temperature, color = location)) +
  geom_line()


temperatures %>%
  ggplot(aes(x = month, y = location, fill = temperature)) +
  geom_tile()


temps_houston %>%
  ggplot(aes(x = temperature)) +
  geom_histogram()


temperatures %>%
  filter(location %in% c("Houston", "Chicago")) %>%
  ggplot(aes(x = temperature, fill = location)) +
  geom_histogram()
