# AEM 2850 - Example 7 part 1
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
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv))
# what do you see? why?
# no data! because we have not added any geometry layers

# now copy and paste your code from above, and add a point geom
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point()

# now copy and paste, and add a smooth geom
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth()

# let's modify that to make the smooth geom linear
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm")

# now add the viridis color scale scale_color_viridis_d()
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d()

# facet by drive train type
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d() +
  facet_wrap(vars(drv), ncol = 1)

# add labels
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d() +
  facet_wrap(vars(drv), ncol = 1) +
  labs(x = "Displacement", y = "Highway MPG",
       color = "Drive",
       title = "Larger engines use more fuel",
       subtitle = "Displacement measures engine size")

# add a theme: + theme_bw()
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d() +
  facet_wrap(vars(drv), ncol = 1) +
  labs(x = "Displacement", y = "Highway MPG",
       color = "Drive",
       title = "Larger engines use more fuel",
       subtitle = "Displacement measures engine size") +
  theme_bw()

# modify the theme
mpg |>
  ggplot(aes(x = displ,
             y = hwy,
             color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d() +
  facet_wrap(vars(drv), ncol = 1) +
  labs(x = "Displacement", y = "Highway MPG",
       color = "Drive",
       title = "Larger engines use more fuel",
       subtitle = "Displacement measures engine size") +
  theme_bw() +
  theme(legend.position = "bottom",
        plot.title = element_text(face =))

# finished! (note: slides contain for a slide version of this process)



# THE REST OF THESE EXERCISES ARE HERE OPTIONAL, FOR REFERENCE ----



# 2. Independent warm up -----
# let's practice mapping from data to aesthetics using palmerpenguins::penguins
# install.packages("palmerpenguins")
library(palmerpenguins)

?penguins # background on data

names(penguins) # what are the column names?

# first, let's visualize body mass and flipper length for penguins
# map flipper_length_mm to the x-axis, body_mass_g to the y-axis, and add points
penguins |>
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
# is this data pattern intuitive?

# now map bill_length_mm to the x-axis, bill_depth_mm to the y-axis, and add points
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()
# now add a line of best fit
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  geom_smooth(method = "lm")
# is this data pattern intuitive?

# augment the mapping: color by species
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point()
# now add a line of best fit
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  geom_smooth(method = "lm")
# is this data pattern intuitive?
# why did writing `geom_smooth` once produce three different lines?

# this is an example of simpson's paradox
# https://en.wikipedia.org/wiki/Simpson%27s_paradox


# now facet by species
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species)

# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following additions to our mapping:
# 2.1: map sex to color, add points, and facet by species (but don't add lines)
# REMOVE CODE EXAMPLE HERE!
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)

# 2.2: why is there a color for sex that is labeled NA? make a version of the plot without it
penguins |>
  filter(!is.na(sex)) |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)

# 2.3: make a new plot: map flipper_length_mm to x, bill_length_mm to y,
# species to color and shape, add points, and add a linear fit for each species
penguins |>
  filter(!is.na(sex)) |>
  ggplot(aes(x = flipper_length_mm, y = bill_length_mm,
             color = species, shape = species)) +
  geom_point() +
  geom_smooth(method = "lm")


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
  ggplot(aes(x = day_of_year, y = temperature)) +
  geom_line()

# try again, using `geom_point()` instead of `geom_line()`
temps_houston |>
  ggplot(aes(x = day_of_year, y = temperature)) +
  geom_point()

# now swap which column you map to x and which to y
temps_houston |>
  ggplot(aes(x = temperature, y = day_of_year)) +
  geom_point()

# let's explore some more complex geoms
# try using `geom_boxplot()` to make boxplots
# for boxplots, we frequently want categorical data on the x or y axis

# try this out: put `month` on the x axis, `temperature` on the y axis, and use `geom_boxplot()`
temps_houston |>
  ggplot(aes(x = month, y = temperature)) +
  geom_boxplot()

# now put the month on the y axis and the temperature on the x axis
temps_houston |>
  ggplot(aes(x = temperature, y = month)) +
  geom_boxplot()


# PLEASE STOP HERE AND LET US KNOW THAT YOU ARE DONE
# if you are waiting, try the following changes to that last plot:
# 3.1: replace `geom_boxplot` with `geom_violin`
temps_houston |>
  ggplot(aes(x = temperature, y = month)) +
  geom_violin()
# 3.2: replace `geom_boxplot` with `geom_jitter`
temps_houston |>
  ggplot(aes(x = temperature, y = month)) +
  geom_jitter()


# 4. Adding color ----
# next let's work with the dataset `temperatures`, contains data for three more locations:
temperatures

# Using the `color` aesthetic

# make a line plot of `temperature` against `day_of_year`, and map location to color
temperatures |>
  ggplot(aes(x = day_of_year, y = temperature, color = location)) +
  geom_line()

# try again. this time map `day_of_year` to the x-axis, `location` to the y-axis,
# `temperature` to color, and add points
temperatures |>
  ggplot(aes(x = day_of_year, y = location, color = temperature)) +
  geom_point(size = 5) # use size = 5 to create larger points


# Using the `fill` aesthetic
# some geoms use a `fill` aesthetic, which is similar to `color` but applies to shaded areas (`color` applies to lines and points)

# try using the `fill` aesthetic with `geom_boxplot()` to color the interior of the box
# map `month` to x, `temperature` to y, and color the interior of the box by location
temperatures |>
  ggplot(aes(x = month, y = temperature, fill = location)) +
  geom_boxplot()

# can you color the lines of the boxplot by location and the interior by month?
temperatures |>
  ggplot(aes(x = month, y = temperature, color = location, fill = month)) +
  geom_boxplot()


# Using aesthetics as parameters

# many of the aesthetics can be used as parameters inside a geom rather than inside an `aes()` statement
# examples include `color`, `fill`, and also `size` to change line size or point thickness

# try this with the boxplot example from the previous section
# map `location` onto the `fill` aesthetic but set the color of the lines to "navyblue"
temperatures |>
  ggplot(aes(x = month, y = temperature, fill = location)) +
  geom_boxplot(color = "navyblue")

# now do the reverse. map `location` onto the line colors but fill the box with the color "navyblue"
temperatures |>
  ggplot(aes(x = month, y = temperature, color = location)) +
  geom_boxplot(fill = "navyblue")



## 5. Additional, open-ended exercises that we did in class (Spring) ----
temperatures |>
  ggplot(aes(x = day_of_year, y = temperature, color = location)) +
  geom_line()


temperatures |>
  ggplot(aes(x = month, y = location, fill = temperature)) +
  geom_tile()


temps_houston |>
  ggplot(aes(x = temperature)) +
  geom_histogram()


temperatures |>
  filter(location %in% c("Houston", "Chicago")) |>
  ggplot(aes(x = temperature, fill = location)) +
  geom_histogram()
