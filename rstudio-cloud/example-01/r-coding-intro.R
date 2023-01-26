# AEM 2850 - getting started with R

# Running code ----
# First, try running the following line of code using the Run button above
print("welcome to aem 2850")

# Note how the cursor automatically advances

# Now, try running the following line of code using ⌘+↩ (mac) or Ctrl+↩ (pc)
print("welcome to aem 2850")


# Arithmetic operations ----
# You can use R as a calculator
1+2 ## add
6-7 ## subtract
5/2 ## divide


# Logical operations ----
# You also have logical operations
1 > 2
1 > 0.5
(1 > 2) | (1 > 0.5) # | is the or operator
(1 > 2) & (1 > 0.5) # & is the and operator


# Assignment ----
# In R, we can use either `=` or `<-` for assignment
# R purists use `<-`
# It's a lot easier if you use the keyboard shortcut ⌥-
# For most purposes it makes no difference, just be consistent
a <- 10 + 5
a

# We can use the function c() ("combine") to form a vector
numbers <- c(1, 3, 5, 7, 9)
# Then we can manipulate those numbers elementwise
numbers + 1
numbers * 2
# Note that numbers itself is unchanged
numbers

# If we assign a new value to numbers, it would change
numbers <- numbers * 2
numbers
# Reassigning can change its length
length(numbers)
numbers <- 8
numbers
length(numbers)

# Reassigning can change its type
class(numbers)
numbers <- "not a number"
numbers
class(numbers)


# Functions ----
# We will cover lots of functions in the coming weeks
# For now, you can probably find and use some intuitive ones
sqrt(4)
log(1)

new_numbers <- 1:10
new_numbers
mean(new_numbers)


# Help ----
# You can search for help with named functions by using ?
?mean

# You can also use ?? to search for broader help
??tidyverse

# vignettes are nice introductions to many packages
vignette("dplyr")


# The Environment ----
# Take a look at the values in the environment
# Why are they there? Why are other values like `sqrt(4)` not there?

# History ----
# The history pane keeps track of your past commands
# You probably won't need this much since you will mostly work in scripts
# But you can use it if you need to recall or add an executed command to your script

# Files ----
# Lists your local files, think of this as Finder or File Explorer

# Plots ----
# A handy place to view plots you make
# For example:
plot(cars)

# Packages ----
# See what you have installed
# See what you have loaded

# Help ----
# Self-explanatory

# Viewer ----
# Another handy place to view things
# You will see an example shortly when we discuss R Markdown
