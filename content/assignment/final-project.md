---
title: "Final project"
date: "2022-05-12 09:41:59"
due_date: "2022-05-19"
due_time: "4:30 PM"
menu:
  assignment:
    parent: Projects
    weight: 2
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

You've made it to the end of our whirlwind intro to R programming! Way to go!

Now you get to show off all the tools you learned with an insightful and informative analysis of your own construction. For your final project, you will take a dataset, explore it, tinker with it, and use it to tell a nuanced story or produce a useful product.

I want this project to be as useful for you and your future career as possible, so you get to choose what data you use (within reason). I've linked to some suggested business datasets below, but you are welcome (and encouraged!) to look for other datasets that you are interested in.


## Summary of key steps and timeline

### Step 1. Choose a group by Friday, April 29

Create groups of 3 and submit the list of group members on canvas.

### Step 2. Choose data and make a plan by Thursday, May 5

Find some interesting data to work with! Ideally this would be related to business. [Here is a list of suggested data sources](/resource/data/). Any data we have used in the class is also fair game, though you would need to do something new and different with it.

Or you might want to start by sketching out a project idea and then thinking through how to get the necessary data. [See below for a list of example project ideas](#examples).

Either way you approach it, you need to figure out both your data and plan at this stage and then submit a few sentences describing them on canvas.

**Note:** You are expected to use programming and data visualization skills we have developed throughout class. In addition, **you are required to use at least one of the following special topics we covered in the last part of the semester**:

- space
- text
- functions
- prediction methods
- web scraping

### Step 3. Execute your plan

Teamwork makes the dream work.

### Step 4. Submit your final project by Thursday, May 19 at 4:30pm

Upload the following files to canvas once for each group:

1. Your memo **in PDF format** (see full instructions below).
2. A **.zip file** of your project directory that is self-contained: the .Rmd source file, .RProj, data files, etc. I should be able to open your project and knit your document with one click.

**No late work will be accepted for this project since the final project counts as your final and the deadline is set by the university.**

We will use [this rubric](final-project-rubric.xlsx) to grade the final product.


## Instructions

Use R to:

1. **Download** a dataset and explore it using all the tools and tricks we learned in lectures, examples, and labs throughout the semester.

2. **Analyze** the data according to your plan. This could include finding patterns in the data like relationships and changes over time that could be visualized and/or summarized using linear regression. You could build a prediction model using OLS, ridge, or lasso. Alternatively, you could focus on analysis and visualization of spatial or textual data. You could build a tool to guide investment strategy or evaluate firm performance. etc. etc.

3. **Create** multiple graphs to illustrate your analysis. You must use at least **three** different chart *types* (i.e., don't just make three scatter plots or three maps).

4. **Write** a PDF memo using R Markdown to introduce your project, provide background on your data and the data cleaning process, and describe your figure and findings. You should include the following sections in the memo:

    - Executive summary
    - Data description
    - Data cleaning description
    - Analysis description
    - Findings

  Write the memo with a non-technical supervisor in mind???someone who will be more interested in your approach and findings than the code you wrote. But don't forget the importance of clearly communicating key steps when the source code is not included in the primary deliverable!
  
  **Do not include your source code in the memo** unless you think it is crucial for communicating your methods or findings. You can avoid printing the code in all the chunks in a document by including a code chunk with the following global option at the start of the .Rmd file (but below the yaml header):
  
```
  knitr::opts_chunk$set(echo = FALSE)
```

  Follow R Markdown etiquette rules and style that we introduced throughout the semester in labs???don't output extraneous messages or warnings, use nice formatting for tables, and adjust the dimensions for your figures as needed. Some of this can be achieved by modifying code chunk options (see lab solutions for examples).
  
  You might want to customize your memo, for example by including section headings and a table of contents for clarity. [This site](https://bookdown.org/yihui/rmarkdown/pdf-document.html) provides a summary of some basic options for PDF documents you may find helpful. You can also consult [the rmarkdown cheat sheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/rmarkdown.pdf).


## Grading rubric

We will use [this rubric](final-project-rubric.xlsx) to grade the final product.


## Reminders
- **Don't forget to utilize your teaching staff!** You can email us or set up appointments to get help. Grad TA Hui will have office hours from 2-4pm on Friday, May 13. Prof. Gerarden has posted extra office hours by appointment at [aem2850.youcanbook.me](https://aem2850.youcanbook.me).
- **Part of your individual grade will be based on your contribution to the group.** I will conduct an anonymous peer-review survey to help assess each person's contribution.
- **You will be graded on both the content and its presentation.** Follow best practices from class and readings when making visuals. Make each graphic clear and comprehensible (even on its own). When writing text to summarize your work and discuss takeaways, please be concise.

  To drive home the importance of presentation, here are some lessons learned from making COVID data dashboards ([source](https://flowingdata.com/2022/04/06/lessons-learned-from-making-covid-dashboards/)):

  > *Among the shared themes for the dashboards were simplicity and clarity. Whether you are producing visuals and analytical tools for policymakers or for the public, Blauer says, the same rules of thumb apply. **???Don???t overcomplicate your visualization, make the conclusions as clear as possible, and speak in the most basic of plain-language terms,???** she says.*

  > *Yet, as other data scientists point out, presenting data simply might not be enough to ensure viewers get the message. For one thing, **attention to detail matters. Ritchie recalls how she and her team spent hours focused on the titles and subtitles of charts**, ???because that is ultimately what most people will look at???. And in those titles and subtitles, the analysts made sure to specify ???confirmed??? deaths or ???confirmed??? cases. ???An emphasis on ???confirmed??? is really important because we know that it???s an underestimate of the total,??? says Ritchie. ???It might seem very basic, but it???s really crucial to how you understand the data and the scale of the pandemic.???*


## Example project ideas {#examples}

We do not have any examples from past years sine this class is brand new. Here is a list of off-the-cuff project ideas to give you a sense of the scope of the project and range of possibilities. You are welcome to use one of these, but that is not expected or required.

- Write a program to automate an investment plan. For example, you could write functions to take a set of stock tickers and derive portfolio weights for each ticker based on some (sensible) investment strategy. This could be done using a fixed time period of historical data or a user-specified time window.
- Use functions to compute business analytics metrics for different companies and/or time periods. For example you could use data from SEC filings to summarize the evolution of companies' fundamentals over time.
- Use twitter data to study the relationship between a company's twitter activity (e.g., tweets, mentions, etc.) and some performance metric (e.g., excess daily returns in the stock market).
- Construct a prediction model for future stock (or index) price movements based on past movements.
- Develop a pricing strategy you would use if you were in charge of a specific product, and provide a sophisticated and compelling rationale for your strategy that is grounded in data.
