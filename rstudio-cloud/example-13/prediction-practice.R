# AEM 2850 - Example 13
# Plan for today:
# - Questions?
# - On our own devices: work through this script
# - As a group: discuss results, answer questions
# - Note: this week I am providing code scaffolding since the concepts are new


# 0. Loading packages and prepping data -----
# we need to install packages once before we can use them
# install.packages("tidyverse") # in this case, it has already been done for you in this project
library(tidyverse) # load the core tidyverse packages
library(glmnet) # load glmnet for ridge and lasso

# use theme_set to get clean plots without having to specify the theme each time
theme_set(theme_minimal()) # set the current theme to theme_minimal()
# you can use theme_set(theme()) to return to defaults if you prefer

# today we'll use ISLR::Hitters data on baseball players from 1986-1987
# the goal is to predict a baseball player's Salary based on performance stats
# ISLR is an R package companion to An Introduction to Statistical Learning (https://www.statlearning.com)
library(ISLR) # introduction to statistical learning data


# 1. Set up Hitters data ----
# we can't use rows/observations with missing data for prediction
# so let's start by filtering out players with missing Salary
hitters <- Hitters %>%
  filter(!is.na(Salary))
stopifnot(!is.na(hitters)) # check to make sure there are no more missing values
# note: another option is to use na.omit() to remove rows with ANY missing values

# what variables do we have?
names(hitters)
# player names are stored as row names (which we don't really need)
row.names(hitters)
# convert hitters to a tibble for pretty printing (note this removes row names)
hitters <- as_tibble(hitters)
# look at the basic structure of the data
hitters

# split hitters into train and test samples
set.seed(2850) # set a seed so that pseudorandom actions can be reproduced exactly
hitters <- hitters %>%
  mutate(train = sample(c(TRUE, FALSE), nrow(hitters), replace = TRUE)) # random indicator for train vs test
hitters_train <- hitters %>% # filter train data
  filter(train==TRUE) %>% select(-train)
hitters_test <- hitters %>% # filter test data
  filter(train==FALSE) %>% select(-train)
hitters <- hitters %>% select(-train) # remove train from hitters


# 2. Linear regression using hitters_train ----
# let's start by estimating three linear models and comparing their fit
lm_null <- lm(Salary ~ 1, data = hitters_train) # just an intercept
lm_small <- lm(Salary ~ CHmRun + Years + Errors, data = hitters_train) # a few variables
lm_big <- _____ # include all variables

# what is the R-squared for these three models?
summary(lm_null)$r.squared
summary(lm_small)$_____
summary(_____)$_____

# what is the mean squared error for these three models?
# "residuals" is another term for "errors"
mean(lm_null$residuals^2) # compute mse once
# let's put all this in a data frame
mse_train <- tibble(data = "train",
                    mse_null = mean(lm_null$residuals^2),
                    mse_small = mean(_____$residuals^2),
                    mse_big = _____(_____$_____))

# visualize prediction errors by making a scatter plot of data vs predictions
# use facets for each model and add a line at data = prediction
predictions_train <- hitters_train %>%
  mutate(null  = lm_null$fitted.values,
         small = _____$fitted.values,
         big   = _____$_____)

predictions_train %>%
  rename(data = Salary) %>%
  select(data, null, small, big) %>%
  pivot_longer(-data, names_to = "model", values_to = "predictions") %>%
  ggplot(aes(x = _____, y = _____, color = _____)) +
  geom______() +
  geom_abline(slope = 1) +
  facet_wrap(~fct_relevel(_____, c("null", "small", "big")),
             ncol = 2)


# 3. Evaluate out of sample file for linear regressions using hitters_test ----
# we saw in 1 that the most complex model does the best job of fitting the train data
# does it overfit the data, though?
# let's use the predict() to evaluate how it performs in the test data
predictions_test <- hitters_test %>%
  mutate(null  = predict(lm_null, newdata = .),
         small = predict(_____, newdata = .),
         big   = predict(_____, newdata = .))

# first, let's recycle our plot code above to visualize predictions
# which model's predictions look best?
predictions_test %>%
  rename(data = Salary) %>%
  select(data, null, small, big) %>%
  pivot_longer(-data, names_to = "model", values_to = "predictions") %>%
  ggplot(aes(x = _____, y = _____, color = _____)) +
  geom______() +
  geom______(slope = 1) +
  guides(color = "none") +
  facet_wrap(~fct_relevel(model, c("null", "small", "big")),
             ncol = 2)

# let's formalize the comparison of predictions
# what is the mean squared error for these three models?
mse_test <- predictions_test %>%
  mutate(mse_null  = _____,
         mse_small = _____,
         mse_big   = _____) %>%
  select(starts_with("mse_")) %>%
  summarize_all(mean) %>%
  mutate(data = "test") %>%
  relocate(data)

# how does it compare to what we saw before?
rbind(mse_train, _____)

# result: the more complex linear models continue to outperform simpler ones
# but the gains in terms of MSE reduction are much smaller for train data than test data
# this means it's possible, though not obvious, that the big model is overfitting the train data
# let's see whether we get different results using ridge regression and lasso


# 4. Estimate ridge regression using cross-validation ----
# start by converting x and y to matrix and vector for glmnet
x_train <- model.matrix(Salary ~ .,
                        data = hitters_train)
y_train <- hitters_train %>% pull(Salary)

# now estimate ridge regression using the defaults
# you just need to provide x, y, and alpha = 0
set.seed(2850) # set seed again because cv.glmnet is stochastic
ridge_cv <- cv.glmnet(x = _____, # predictors
                      y = _____, # outcome to be predicted
                      alpha = _____    # we want ridge regression
                      )

# use plot(ridge_cv) to visualize MSE as a function of lambda
_____(ridge_cv)

# use the cross-validated "lambda.min" that minimizes MSE for predictions
# first predict in the train data
predictions_train <- predictions_train %>%
  mutate(ridge = predict(_____, # use ridge model for predictions predict
                         s = "lambda.min", # set lambda to optimal lambda
                         newx = _____)) # use training data for prediction

# let's recycle our plot code above to visualize predictions
# note: this might be a good time to write a function...
# which model's predictions look best?
predictions_train %>%
  rename(data = Salary) %>%
  select(data, null, small, big, ridge) %>%
  pivot_longer(-data, names_to = "model", values_to = "predictions") %>%
  ggplot(aes(x = _____, y = _____, color = _____)) +
  geom_point() +
  geom_abline(_____ = 1) +
  guides(color = "_____") +
  facet_wrap(~fct_relevel(model, c("null", "small", "big", "ridge")),
             ncol = 2)

# let's compute MSE for ridge in the train data
# does it do better or worse than the big model?
mse_train_ridge <- predictions_train %>%
  transmute(mse_ridge = _____) %>%
  summarize_all(_____)
mse_train <- cbind(mse_train, _____)
rm(mse_train_ridge) # get rid of temporary object


# 5. Assess out-of-sample fit of ridge model ----
# now let's make predictions in the test data
# first we need to set up the test data for glmnet
x_test <- model.matrix(Salary ~ .,
                       data = hitters_test)
y_test <- _____ %>% pull(_____)

# then predict in the test data
predictions_test <- predictions_test %>%
  mutate(ridge = _____(ridge_cv, # use ridge model for predictions predict
                         s = "_____", # set lambda to optimal lambda
                         newx = _____)) # use testing data for prediction

# let's recycle our plot code above to visualize predictions
# note: this would be a REALLY good time to write a function, if only we had more time!
# which model's predictions look best?
predictions_test %>%
  rename(data = Salary) %>%
  select(data, null, small, big, ridge) %>%
  pivot_longer(-data, names_to = "_____", values_to = "_____") %>%
  ggplot(_____(x = predictions, y = data, color = model)) +
  geom_point() +
  geom_abline(slope = 1) +
  guides(color = "none") +
  facet_wrap(~fct_relevel(model, c("null", "small", "big", "ridge")),
             ncol = 2)

# let's compute MSE for ridge in the test data
# does it do better or worse than the big model?
mse_test_ridge <- predictions_test %>%
  _____(mse_ridge = _____) %>%
  summarize_all(_____)
mse_test <- cbind(mse_test, _____)
rm(mse_test_ridge) # get rid of temporary object

# how does it compare to what we saw before?
rbind(mse_train, mse_test)

# the ridge model performs better than the linear model out of sample!
# this is a case of mild overfitting
# caveat: we haven't accounted for/quantified uncertainty due to sampling variation
# so this is still kinda speculative
# but that's okay since it's just meant to be illustrative


# 6. Estimate lasso regression using cross-validation ----
# we can just recycle our ridge regression data from without any new prep

# estimate lasso regression using the defaults
# you just need to provide x, y, and alpha = 1
set.seed(2850) # set seed again because cv.glmnet is stochastic
lasso_cv <- cv.glmnet(x = _____, # predictors
                      y = _____, # outcome to be predicted
                      alpha = _____    # we want lasso regression this time!
                      )

# use plot() to visualize MSE as a function of lambda
plot(_____)

# use the cross-validated "lambda.min" that minimizes MSE for predictions
# first predict in the train data
predictions_train <- predictions_train %>%
  mutate(lasso = predict(_____, # use lasso model for predictions predict
                         s = "_____", # set lambda to optimal lambda
                         newx = _____)) # use training data for prediction

# let's compute MSE for lasso in the train data
# does it do better or worse than the big model?
mse_train_lasso <- predictions_train %>%
  transmute(mse_lasso = _____) %>%
  summarize_all(_____)
mse_train <- cbind(mse_train, _____)
rm(_____) # get rid of temporary object


# 7. Assess out-of-sample fit of lasso model ----
# we can just recycle our ridge prediction data from without any new prep

# predict in the test data
predictions_test <- predictions_test %>%
  mutate(lasso = _____(_____, # use ridge model for predictions predict
                         s = "lambda.min", # set lambda to optimal lambda
                         newx = _____)) # use testing data for prediction

# let's compute MSE for ridge in the test data
# does it do better or worse than the big model?
mse_test_lasso <- predictions_test %>%
  transmute(mse_lasso = (Salary - lasso)^2) %>%
  _____(_____)
mse_test <- cbind(mse_test, _____)
rm(mse_test_lasso) # get rid of temporary object

# how does it compare to what we saw before?
rbind(mse_train, _____)


# 8. Estimate ridge and lasso models on full sample and print coefficients ----
# prep data
x_full <- model.matrix(Salary ~ .,
                        data = _____)
y_full <- hitters %>% pull(_____)

# estimate ridge model
ridge_full <- glmnet(x = _____, # predictors
                     y = _____, # outcome to be predicted
                     alpha = _____   # ridge regression
                     )

# store ridge coefficients
ridge_coef <- predict(_____,             # ridge model
                      type = "coefficients",  # we want coefficients
                      s = ridge_cv$lambda.min # use the lambda we found earlier
                      )

# estimate lasso model
lasso_full <- glmnet(x = _____, # predictors
                     y = _____, # outcome to be predicted
                     alpha = _____   # lasso regression
)

# store ridge coefficients
lasso_coef <- predict(_____,             # lasso model
                      type = "coefficients",  # we want coefficients
                      s = lasso_cv$lambda.min # use the lambda we found earlier
)

# how do ridge and lasso coefficients compare? why? (see end of lecture slides)
cbind(ridge_coef, lasso_coef)
