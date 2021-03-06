---
title: "Intro to R, RStudio, and RMarkdown"
linktitle: "Intro to R, RStudio, and RMarkdown"
date: "2022-02-07 20:03:46"
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

# Introduction to Examples

Examples contain material we will discuss and use to learn R in class. These notes are *not* comprehensive. Instead, they are meant as a helpful resource during and after class in case you are confused or have trouble remembering something we discussed.


## RStudio Cloud link

[Click here to access this week's Example RStudio Cloud Project](https://rstudio.cloud/spaces/210747/project/3486782)


## Plan for today
- Did anyone have trouble making an RStudio Cloud account?
  - [Here is the link to join the course workspace if you haven't already](https://rstudio.cloud/spaces/210747/join?access_code=S%2B2RP6rPpen%2BtHGCQ4wg3A%2F7yeuf9%2F%2Ft74uqnZYS)
  - **IMPORTANT NOTE:** I and our TAs will be able to view your work. This is a feature but could also be a bug -- please don't write or store anything in your course projects that you don't want us to see. :wink:
- R, RStudio, RStudio Cloud basics
  - overview on this site, then move to rstudio.cloud
  - together: `rcoding-intro.R`
  - breakout groups: `rcoding-practice.R`
- R Markdown basics
  - overview on this site, then move to rstudio.cloud
  - together: `rmarkdown-formatting-example.Rmd`
  - breakout groups: `rmarkdown-practice.Rmd`
- Questions? Concerns?
- Feedback on class format welcome!
  - slides vs website vs walking through code, etc.


## Cheatsheets

[Click here to download the RStudio IDE cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf)

[Click here to download the rmarkdown cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/rmarkdown.pdf)



## Getting started with R and RStudio {#getting-started}

R is not a programming language like `C` or `Java`. It was not created by software engineers for software development. Instead, it was developed by statisticians as an interactive environment for data analysis. This interactivity makes it easy to explore data quickly, which is an indispensable feature for many tasks in business analytics, statistics, data science, and other fields.

If you have prior programming experience, you may be surprised by differences between R and other programming languages.

If you have no prior programming experience, you may initially be frustrated when learning R. That is normal! Learning to program is essentially learning to speak a new language. But in some ways it's even more difficult, because your interlocutor is a computer who isn't always great at telling you when you said something that made no sense.

Regardless of your prior experience, if you are patient, you will come to appreciate the power of R for data analysis and data visualization.

<!-- However, like in other programming languages, you can save your work as scripts that can be easily executed at any moment. These scripts serve as a record of the analysis you performed, a key feature that facilitates reproducible work. -->

## R, and the R console

As we already discussed, R is the engine that will power our work. One way to control that engine is to use the _R console_ to execute commands as you type them, or to run scripts you have already written. There are several ways to gain access to the R console. One way is to install R on your computer and open the built-in console, which looks like this:

![Rconsole](/example/images/01/Rconsole.png)

However, most people don't use this console. Instead, they use an _integrated development environment_ (or IDE) to write, debug, and execute their code.

## RStudio {#rstudio}

The IDE we will use in this class is RStudio. RStudio includes an editor with many R-specific features, a console to execute your code, and other useful panes, including one to show figures or view html documents you produce. RStudio looks like this:

![rstudio](/example/images/01/rstudio.png)

RStudio will be our launching pad for data science projects. It not only provides an editor for us to create and edit our scripts but also provides many other useful tools. In this section, we go over some of the basics.

### RStudio panes

When you start RStudio for the first time, you will see three panes by default. The left pane shows the R console. On the right, the top pane includes tabs such as  _Environment_ and _History_, while the bottom pane shows five tabs: _File_, _Plots_, _Packages_, _Help_, and _Viewer_ (these tabs may change in new versions). You can click on each tab to move across the different features.

To start a new R script, you can click on File, then New File, then R Script.

This starts a new pane on the left and it is here where you can start writing your script.

### Keyboard shortcuts

Many tasks we perform with the mouse can be achieved with a combination of key strokes instead, or keyboard shortcuts For example, we just showed how to use the mouse to start a new script, but you can also use a shortcut: Ctrl+???+N on Windows and ???+???+N on macs.

Although using the mouse to explore RStudio's dropdown menus is a good place to start, **I highly recommend that you memorize key bindings for the operations you use most**. RStudio provides a useful cheat sheet with the most widely used commands. If you're on a mac, you can access a list of keyboard by pressing ???+???+K. You might want to keep this in mind so you can look up keyboard shortcuts when you find yourself doing the same point-and-click operations repeatedly.

### Tab completion

One advantage of using RStudio is that it has context-aware tab completion. This means that when you start typing the name of a package, function, or object you want to use, RStudio will automatically suggest ways to complete your input. You can take advantage of this by scrolling through the suggestions using up/down arrows and hitting tab to use the selected completion.

RStudio also does handy things like adding a close parentheses when you type an open parentheses, such as if you type `library(`.

### Running commands while editing scripts

There are many editors specifically made for coding. These are useful because color and indentation are automatically added to make code more readable. RStudio is one of these editors, and it was specifically developed for R. One of the main advantages provided by RStudio over other editors is that we can test our code easily as we edit our scripts.

You can see this by opening a new script. Give the script a name. You can do this through the editor by saving the current new unnamed script. To do this, click on the save icon or use the key binding Ctrl+S on Windows and ???+S on the Mac.

When you ask for the document to be saved for the first time, RStudio will prompt you for a name. A good convention is to use a descriptive name, with lower case letters, no spaces, only hyphens to separate words, and then followed by the suffix _.R_. Call your script _my-first-script.R_.

Now we are ready to start editing our first script. For example, you could write:


```r
print("welcome to RStudio")
```

If you do this and hit ??? in the editor, nothing will happen in the console.

To _execute_ your new script, you can click on the _Run_ button on the upper right side of the editing pane or use the keyboard shortcut: Ctrl+???+??? on Windows or ???+???+??? on Mac. When you do this, the console will show the command as well as its output:


```
## [1] "welcome to RStudio"
```

To run one line at a time instead of the entire script, you can use Ctrl+??? on Windows and ???+??? on Mac.

### Let's explore RStudio Cloud

[Click here to access this week's Example RStudio Cloud Project](https://rstudio.cloud/spaces/210747/project/3486782)

<!-- :::fyi -->
<!-- **SETUP TIP** -->

<!--   Change the option _Save workspace to .RData on exit_ to _Never_ and uncheck the _Restore .RData into workspace at start_. By default, when you exit R saves all the objects you have created into a file called .RData. This is done so that when you restart the session in the same folder, it will load these objects. I find that this causes confusion especially when sharing code with colleagues or peers. -->
<!-- ::: -->


## R Markdown

R Markdown provides a unified authoring framework for data science, combining your code, its results, and your prose commentary. R Markdown documents are fully reproducible and support dozens of output formats, like PDFs, Word files, slideshows, and more.

R Markdown files are designed to be used in three ways:

1.  For communicating to decision makers, who want to focus on the conclusions, not the code behind the analysis.

2.  For collaborating with others (including future you!) who are interested in your conclusion *and* how you reached them.

3.  As an environment in which to *do* business analytics, where you can capture not only what you did, but also what you were thinking.

All three of these are relevant for this course. Hopefully you can see how the first could be useful in business settings where you need to present a summary of ideas or findings to a decision maker.

RStudio includes two links to Cheatsheets that are a great resource as you begin to work with R Markdown:

-   R Markdown Cheat Sheet: *Help \> Cheatsheets \> R Markdown Cheat Sheet*,

-   R Markdown Reference Guide: *Help \> Cheatsheets \> R Markdown Reference Guide*.

See [https://rmarkdown.rstudio.com](https://rmarkdown.rstudio.com) for a more detailed summary of R Markdown's functionality.

### R Markdown basics

R Markdown files contain three types of content:

1.  An (optional) **YAML header** surrounded by `---`s.
2.  **Chunks** of R code surrounded by ```` ``` ````.
3.  Text mixed with simple text formatting like `# heading` and `_italics_`.

You can edit each of these to affect the final output.

When you are done composing your document, you can **knit** it by clicking Knit or by using the keyboard shorcut ???+???+K. This will process the file through several steps to produce your output in the format you specify.

### Markdown basics

Markdown is a set of formatting conventions for plain text files that is widely used (beyond R). We will use an example file on RStudio Cloud to learn about some basic text formatting using Markdown. You can also read more about this in [R for Data Science](https://r4ds.had.co.nz/r-markdown.html#text-formatting-with-markdown).



<!-- **Note that in this course (at least, on most browsers), grey boxes are used to show R code typed into the R console. The symbol `##` is used to denote what the R console outputs.** -->

