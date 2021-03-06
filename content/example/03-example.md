---
title: "Welcome to the tidyverse"
linktitle: "Welcome to the tidyverse"
date: "2022-02-09 22:16:17"
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

[Click here to access this week's Example RStudio Cloud Project](https://rstudio.cloud/spaces/210747/project/3569822)

[**Solutions:** click here to access a project with a completed version](https://rstudio.cloud/spaces/210747/project/3569863)


## Plan for today
- Questions? :raising_hand_woman:
- Wrap up slides from Tuesday (`dplyr::summarize`)
- Work through `intro-tidyverse-practice.R`:
  - We will revisit data from [this FiveThirtyEight article](https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/)
  - On our own devices: 1. Getting Comfortable with Data Frames
  - As a group: discuss results, answer questions
  - On our own devices: 2. Using Functions in Packages


## tidyverse version

**Note:** If you are working locally, make sure you are running at least **dplyr** 1.0.0:


```r
# packageVersion('dplyr')
# install.packages('dplyr') # install updated version if < 1.0.0
```


## Data transformation with `dplyr` cheatsheet

[Click here to download the `dplyr` cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf)

<!-- https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf -->

<!-- week 4: -->
<!-- https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-import.pdf -->
<!-- https://raw.githubusercontent.com/rstudio/cheatsheets/main/tidyr.pdf -->

