# AEM 2850 - Basic base R
# This script duplicates content from the slides for Week 2
# I recommend you read through this script line by line on your own time
# As a reminder, you can run code line by line using ⌘+↩ (mac) or Ctrl+↩ (pc)
# If you have any questions, come to office hours!


# This is a code section ----
# this is a comment
# note how there is a down arrow next to line 3. press it! what does it do?


# Running code ----
# as a reminder, you can run code line by line using ⌘+↩ (mac) or Ctrl+↩ (pc)
print("welcome to aem 2850")
# note how the cursor automatically advances


# Arithmetic operations ----
# you can use R as a calculator
1+2 # add
6-7 # subtract
5/2 # divide
2^3 # exponentiate
2+4*1^3 # standard order of precedence (`*` before `+`, etc.)


# Logical operations ----
# you also have logical operations
1 > 2
1 > 0.5
(1 > 2) & (1 > 0.5) # & is the and operator
(1 > 2) | (1 > 0.5) # | is the or operator

# we can negate expressions with !
1:10
is.na(1:10)
!is.na(1:10)

# for value matching we can use %in%
4 %in% 1:10
4 %in% 5:10

# use two equal signs to evaluate whether two expressions are equal
# 1 = 1 # this doesn't work -- uncomment this line using Cmd/Ctrl+Shift+c to see what happens
1 == 1 # this does
1 != 2 # != is "not equal to"

# floating point logic
0.1 + 0.2 == 0.3 # what happens?
0.1 + 0.2 - 0.3  # not zero! due to binary representation of numbers
all.equal(0.1 + 0.2, 0.3) # use a test for "near equality" instead


# Assignment ----
# in R, we can use either `=` or `<-` for assignment
# R purists use `<-`
# it's a lot easier if you use the keyboard shortcut Alt/Option -
# for most purposes it makes no difference, just be consistent
a <- 10 + 5
a


# Objects ----
# we already created the object a
class(a) # evaluate its class

# data frames
d <- data.frame(x = 1:2, y = 3:4) # create a small data frame called "d"
d # print d
View(d) # View d
str(d) # evaluate its structure
class(d) # evaluate its class

# we can convert between object types
mat <- as.matrix(d)
mat
class(mat) # objects can have multiple classes (so can use methods from multiple classes)
mat %*% mat # you can use matrix algebra and functions (not the focus of this class)

# lists
my_list <- list(
  a = "hello",
  b = c(1,2,3),
  c = data.frame(x = 1:5, y = 6:10))
my_list

# Indexing ----
# indexing with matrices
mat[1, 2] # get the first row and second column of mat
mat[1,  ] # get the first row and all columns of mat

# indexing with data frames
?pressure # what is pressure?
dim(pressure)  # how many rows and columns does it have?
head(pressure) # print the first part of pressure
# there are often multiple ways to get from point a to point
pressure[, 1] # get the first column of pressure by location
pressure[, "temperature"] # get the first column of pressure by name
pressure$temperature # get the first column using $

# indexing with lists
my_list[[2]]
my_list[[2]][3] # we can combine indexing operators

my_list$b
my_list$b[3] # we can combine different indexing operators

my_list$c
my_list$c$x
my_list$c$x[2]

# Cleaning up ----
rm(a) # use rm() to remove objects from your working environnment
rm(d, mat, my_list) # you can remove multiple objects at a time
