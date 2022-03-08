---
title: "Mini project 1"
date: "2022-03-08 15:31:10"
menu:
  assignment:
    parent: Projects
    weight: 1
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

# Overview

In this project, we will use tools from the tidyverse to wrangle and visualize data for firms in the S&P 500. In practice, if you were to use R for investment research in industry, you would want to use additional packages such as `quantmod` and `PerformanceAnalytics` that provide specialized functions to process and visualize financial data. We do not have time to go into the details of these packages in this course, but this project should give you a taste of how R can be used in financial modeling.

The primary data for this project are in `sp500.RData`, which contains two data frames. `sp500_companies` contains information on the companies in the S&P 500, where each observation corresponds to a company. `sp500_prices` contains daily price records form 2017-2021 for companies in the S&P 500. Each observation corresponds to a symbol-day. For each observation, there are five prices (open, high, low, close, and adjusted) as well as the trading volume (volume).


# Details

Full instructions are posted in [this canvas assignment](https://canvas.cornell.edu/courses/38623/assignments/348809) and in each group's RStudio Cloud project.
