---
title: Data
date: "2022-04-29"
menu:
  resource:
    parent: Resources
type: docs
weight: 2
---

There are a ton of places to find data related to business online. Here are some examples:

- [**Kaggle**](https://www.kaggle.com/datasets): Kaggle hosts machine learning competitions. A byproduct of these competitions is a host of fascinating datasets that are generally free and open to the public. The datasets are sometimes accompanied with suggestions for how to analyze them. Here are a few examples:
  - [Chase Bank Branch Deposits, 2010–2016](https://www.kaggle.com/chasebank/bank-deposits): Records for every branch of Chase Bank in the United States. This dataset is not quite tidy and will require a little bit of reshaping with `gather()` or `pivot_longer()`, since there are individual columns of deposits per year.
  - [Credit Card Approvals](https://www.kaggle.com/datasets/rikdifos/credit-card-approval-prediction): a credit card dataset for prediction methods.
  - [Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud): anonymous credit card transactions labeled as fraudulent or genuine.
  - [515K Hotel Reviews Data in Europe](https://www.kaggle.com/jiashenliu/515k-hotel-reviews-data-in-europe): 515,000 customer reviews and scoring of 1,493 luxury hotels across Europe.
  - [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)
  - [IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset): simulated data created by IBM data scientists to model employee attrtition.
  - And many, many more!

- [**Quandl**](https://data.nasdaq.com/tools/r): Nasdaq Data Link provides some datasets related to finance and economics for free (though many require a paid subscription). The datasets are listed in [this data catalog](https://data.nasdaq.com/search?filters=%5B%22Free%22%5D).

- [**FRED**](https://fred.stlouisfed.org): Economic Data from the St. Louis Fed.

- [**Yahoo Finance**](https://finance.yahoo.com)
  - There are many ways to access data from Yahoo Finance. One option is to scrape data. Another is to use a package like `tidyquant` to `tq_get()` quantative data in a tibble format. This package can also be used to get data from FRED, Quandl, and other sources.

- [**Twitter**](http://www.twitter.com): You could collect data on tweets that reference a specific company via [the twitter API](https://developer.twitter.com/en/docs/tutorials/getting-started-with-r-and-v2-of-the-twitter-api) or by using a package like [`twitteR`](https://cran.r-project.org/web/packages/twitteR/index.html) to access the API. Then you could use this on its own or in conjunction with some other data (e.g., stock prices/returns) to do an analysis of consumer sentiment, for example.

- [**Inside Airbnb**](http://insideairbnb.com/get-the-data/): Inside Airbnb is a mission-driven activist project with the objective to provide data that quantifies the impact of short-term rentals on housing and residential communities, as well as create a platform to support advocacy for policies to protect our cities from the impacts of short-term rentals. The post data for many different cities. Please note these [community guidelines](http://insideairbnb.com/data-policies/):

  > - Only take the data you need
  > - Do not scrape data from the site
  > - Only download the data once. Do not write scripts that download the data every time they are executed.

- [**Yelp Open Dataset**](https://www.yelp.com/dataset): A subset of Yelp businesses, reviews, and user data for use in personal, educational, and academic purposes.
  - Note: the data are stored in JSON files and will require special steps to import into data structures we are familiar with (e.g., by using the package [`jsonlite`](https://cran.r-project.org/web/packages/jsonlite/index.html)). Feel free to come to office hours for help.

- [**Taxi and Ridehailing Usage in New York City**](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

- [**Zillow Housing Data**](https://www.zillow.com/research/data/)

- [**Amazon Review Data**](https://nijianmo.github.io/amazon/index.html)
  - Note: the data are stored in JSON files and will require special steps to import into data structures we are familiar with (e.g., by using the package [`jsonlite`](https://cran.r-project.org/web/packages/jsonlite/index.html)). Feel free to come to office hours for help.
  - The same group provides a collection of dataset on many other platforms and topics [here](https://cseweb.ucsd.edu/~jmcauley/datasets.html).

- [**Bank Marketing Data**](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing): data on direct marketing campaigns and whether they succeeded in convincing customers to make a deposit.

- [**Data from Intro to Statistical Learning**](https://cran.r-project.org/web/packages/ISLR/index.html): The `ISLR` package contains several interesting (if dated and or/simulated) datasets:
  - `ISLR::Caravan` contains 5,822 real records on whether customers purchased a caravan insurance policy, along with product ownsership information and sociodemographic data based on their zip codes.
  - `ISLR::Default` is a simulated dataset of 10,000 credit card customers that can be used to predict which customers will default on their credit card debt.
  - `ISLR::OJ` contains 1,070 purchases of orange juice for two brands, along with customer and product characteristics (like prices) that could be used to study pricing strategies.

- [**Data is Plural Newsletter**](https://tinyletter.com/data-is-plural): Jeremy Singer-Vine sends a weekly newsletter of the most interesting public datasets he's found. [He also has an archive of all the datasets he's highlighted.](https://docs.google.com/spreadsheets/d/1wZhPLMCHKJvwOkP4juclhjFgqIY8fQFMemwKL2c64vk/edit#gid=0)

- [**Google Dataset Search**](https://toolbox.google.com/datasetsearch): Google indexes thousands of public datasets; search for them here.
