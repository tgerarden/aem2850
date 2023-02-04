---
title: "Welcome to the tidyverse"
linktitle: "Welcome to the tidyverse"
date: "2023-02-04 14:25:34"
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

## Posit Cloud links

[Click here to access this week's example Posit Cloud project](https://posit.cloud/spaces/328615/content/5261012)

[**Solutions:** click here to access a project with a completed version](https://posit.cloud/spaces/328615/content/5261013)


## Plan for this week's example
- Questions? :raising_hand_woman:
<!-- - Wrap up slides from Tuesday (`dplyr::summarize`) -->
- Work through `intro-tidyverse-practice.R`:
  - We will explore data from [this FiveThirtyEight article](https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/)
  <!-- - On our own devices: 1. Getting Comfortable with Data Frames -->
  <!-- - As a group: discuss results, answer questions -->
  <!-- - On our own devices: 2. Using Functions in Packages -->


## Cheatsheets

[Click here to download the `dplyr` cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf)


## tidyverse version

**Note:** If you are working locally, make sure you are running at least **dplyr** 1.0.0:


```r
# packageVersion('dplyr')
# install.packages('dplyr') # install updated version if < 1.0.0
```


## Installing R packages

The functionality provided by a fresh install of R is only a small fraction of what is possible. In fact, we refer to what you get after your first install as _base R_. To access additional functionality, we can use add-ons made by developers. There are currently hundreds of these available from CRAN and many others shared via other repositories such as GitHub. However, because not everybody needs all available functionality, R instead makes different components available via _packages_. R makes it very easy to install packages from within R. For example, to install the __tidyverse__ package, which we will use throughout the semester, you would just type:


```r
install.packages("tidyverse")
```

In RStudio, you can also do this by navigating to the _Packages_ pane or via the _Tools_ menu > Install Packages.

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

