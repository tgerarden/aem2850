# AEM 2850 - Example 7-1
# Plan for today:
# - Questions?
# - On our own devices: work through this script
#   - Write your own code in place of "______"
# - As a group: discuss results, answer questions


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages


# 1. Grammar of graphics: putting it all together -----
# let's build a plot sequentially to see how each grammatical layer changes its appearance

?mpg # background on data

names(mpg) # what are the column names?

# let's start with data and aesthetics:
# map `displ` to x, `hwy` to y, and `drv` to color
___ |>
  ggplot(aes(x = _____,
             y = __,
             color = __))
# what do you see? why?
# no data! because we have not added any geometry layers

# now copy and paste your code from above, and add a point geom
_____ +
  geom_point()

# now copy and paste, and add a smooth geom
_____ +
  geom_smooth()

# let's modify that to make the smooth geom linear
_____ +
  geom_smooth(method = "lm")

# now add the viridis color scale scale_color_viridis_d()
_____ +
  scale_color_viridis_d()

# facet by drive train type
_____ +
  facet_wrap(vars(drv), ncol = 1)

_____ +
  labs(x = "Displacement", y = "Highway MPG",
       color = "Drive",
       title = "Larger engines use more fuel",
       subtitle = "Displacement measures engine size")

# add a theme: + theme_bw()
_____ +
  theme_bw()

# modify the theme
_____ +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"))

# finished! (note: slides contain for a slide version of this process)



# THE REST OF THESE EXERCISES ARE OPTIONAL, TIME PERMITTING / FOR REFERENCE ----



# 2. Independent warm up -----
# let's practice mapping from data to aesthetics using palmerpenguins::penguins
# install.packages("palmerpenguins")
library(palmerpenguins)

?penguins # background on data

names(penguins) # what are the column names?

# first, let's visualize body mass and flipper length for penguins
# map flipper_length_mm to the x-axis, body_mass_g to the y-axis, and add points
penguins |>
  ggplot(aes(x = ______, y = ______)) +
  geom_point()
# is this data pattern intuitive?

# now map bill_length_mm to the x-axis, bill_depth_mm to the y-axis, and add points
penguins |>
  ggplot(aes(______ = bill_length_mm, ______ = bill_depth_mm)) +
  geom_point()
# now add a line of best fit
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  ______() +
  geom_smooth(method = "lm")
# is this data pattern intuitive?

# augment the mapping: color by species
penguins |>
  ______(aes(x = bill_length_mm, y = bill_depth_mm, color = ______)) +
  geom_point()
# now add a line of best fit
penguins |>
  ______(______(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  ______() +
  ______(method = "lm")
# is this data pattern intuitive?
# why did writing `geom_smooth` once produce three different lines?

# this is an example of simpson's paradox
# https://en.wikipedia.org/wiki/Simpson%27s_paradox


# now facet by species
______ |>
  ggplot(______(______ = bill_length_mm, ______ = bill_depth_mm, ______ = species)) +
  ______() +
  ______(method = "lm") +
  facet_wrap(~species)

# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following additions to our mapping:
# 2.1: map sex to color, add points, and facet by species (but don't add lines)
______

# 2.2: why is there a color for sex that is labeled NA? make a version of the plot without it
______

# 2.3: make a new plot: map flipper_length_mm to x, bill_length_mm to y,
# species to color and shape, add points, and add a linear fit for each species
______


# 3. Aesthetic mappings ----
# Acknowledgement: Claus O. Wilke (https://wilkelab.org/SDS375/schedule.html)
# data prep for 3. Aesthetic mappings
temperatures <- read_csv("https://wilkelab.org/SDS375/datasets/tempnormals.csv") |>
  mutate(
    location = factor(
      location, levels = c("Death Valley", "Houston", "San Diego", "Chicago")
    )
  ) |>
  select(location, day_of_year, month, temperature)
temps_houston <- filter(temperatures, location == "Houston")

# let's work with data on average temperature for each day of the year for Houston, TX, birthplace of Queen Bey:
temps_houston

# recall our barebones ggplot template:
# DATA |>
# ggplot(aes(AESTHETIC MAPPINGS)) +
#   GEOM_FUNCTION()

# try this for yourself. map the column `day_of_year` onto the x axis,
# and the column `temperature` onto the y axis, and use `geom_line()` to display the data
temps_houston |>
  ggplot(aes(x = ______, y = ______)) +
  ______()

# try again, using `geom_point()` instead of `geom_line()`
temps_houston |>
  ggplot(aes(______ = day_of_year, ______ = temperature)) +
  ______()

# now swap which column you map to x and which to y
temps_houston |>
  ggplot(aes(x = ______, y = ______)) +
  geom_point()

# let's explore some more complex geoms
# try using `geom_boxplot()` to make boxplots
# for boxplots, we frequently want categorical data on the x or y axis

# try this out: put `month` on the x axis, `temperature` on the y axis, and use `geom_boxplot()`
temps_houston |>
  ggplot(aes(x = ______, y = ______)) +
  ______()

# now put the month on the y axis and the temperature on the x axis
______ |>
  ggplot(______) +
  ______()


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following changes to that last plot:
# 3.1: replace `geom_boxplot` with `geom_violin`
______

# 3.2: replace `geom_boxplot` with `geom_jitter`
______


# 4. Adding color ----
# next let's work with the dataset `temperatures`, contains data for three more locations:
temperatures


# Using the `color` aesthetic

# make a line plot of `temperature` against `day_of_year`, and map location to color
temperatures |>
  ggplot(aes(x = ______, y = ______, color = ______)) +
  ______()

# try again. this time map `day_of_year` to the x-axis, `location` to the y-axis,
# `temperature` to color, and add points
______ |>
  ggplot(______) +
  ______(size = 5) # use size =  to create larger points


# Using the `fill` aesthetic
# some geoms use a `fill` aesthetic, which is similar to `color` but applies to shaded areas (`color` applies to lines and points)

# try using the `fill` aesthetic with `geom_boxplot()` to color the interior of the box
# map `month` to x, `temperature` to y, and color the interior of the box by location
temperatures |>
  ggplot(aes(x = ______, y = ______, fill = ______)) +
  ______()

# can you color the lines of the boxplot by location and the interior by month?
temperatures |>
  ggplot(______) +
  geom_boxplot()


# Using aesthetics as parameters

# many of the aesthetics can be used as parameters inside a geom rather than inside an `aes()` statement
# examples include `color`, `fill`, and also `size` to change line size or point thickness

# try this with the boxplot example from the previous section
# map `location` onto the `fill` aesthetic but set the color of the lines to "navyblue"
temperatures |>
  ggplot(______) +
  ______(______)

# now do the reverse. map `location` onto the line colors but fill the box with the color "navyblue"
temperatures |>
  ggplot(______) +
  ______(______)

