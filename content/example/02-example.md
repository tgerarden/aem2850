---
title: "Basic Base R"
linktitle: "Basic Base R"
date: "2022-02-07 20:04:17"
output:
  blogdown::html_page:
    keep_md: true # do this to save results in .md file
    toc: false
    fig_caption: false
menu:
  examples:
    parent: Examples
    weight: 1
type: docs
weight: 1
editor_options:
  chunk_output_type: console
---

## RStudio Cloud links

[Click here to access this week's Example RStudio Cloud Project](https://rstudio.cloud/spaces/210747/project/3523530)

[**Solutions:** click here to access a project with a completed version](https://rstudio.cloud/spaces/210747/project/3539271)


## Plan for today
- Questions? :raising_hand_woman:
- As a group: briefly skim through `basic-base-r-intro.R`
- Then spend class working through `basic-base-r-practice.R`:
  - We will explore data from [this FiveThirtyEight article](https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/)
  - In breakout rooms: 1. Getting Comfortable with Data Frames
  - As a group: discuss results, answer questions
  - In breakout rooms: 2. Using Functions in Packages


## Installing R packages

The functionality provided by a fresh install of R is only a small fraction of what is possible. In fact, we refer to what you get after your first install as _base R_. To access additional functionality, we can use add-ons made by developers. There are currently hundreds of these available from CRAN and many others shared via other repositories such as GitHub. However, because not everybody needs all available functionality, R instead makes different components available via _packages_. R makes it very easy to install packages from within R. For example, to install the __tidyverse__ package, which we will use throughout the semester, you would just type:


```r
install.packages("tidyverse")
```

In RStudio, you can also do this by navigating to the _Tools_ tab and selecting install packages.

After installation is complete, we can then load the package into our current R session using the `library` function:


```r
library(tidyverse)
```

You only need to install a package once if you are working with a local installation of R. On RStudio Cloud, you may sometimes need to install packages within multiple projects, but I will usually do this for you in advance. After that, you can load it using `library` whenever you need it. The package remains loaded until we quit the R session (or `detach` it).

Note that installing __tidyverse__ actually installs several packages. This commonly occurs when a package has *dependencies*, or uses functions from other packages. When you load a package using `library`, you also load its dependencies.

You can see all the packages you have installed using the _Packages_ tab in RStudio or via the following function:


```r
installed.packages()
```

As we move through this course, we will learn more about packages and keep adding them to our toolbox.


<!-- **Note that in this course (at least, on most browsers), grey boxes are used to show R code typed into the R console. The symbol `##` is used to denote what the R console outputs.** -->

