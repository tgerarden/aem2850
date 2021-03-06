---
title: Syllabus
slug: syllabus
citeproc: true
bibliography: ../../static/bib/references.bib
csl: ../../static/bib/chicago-fullnote-bibliography-no-bib.csl
output:
  blogdown::html_page:
    keep_md: true # do this to save results in .md file
    toc: true
    fig_caption: false
---



Welcome to AEM 2850! I'd like to preface the syllabus with three points:

1. **Your success in this class is important to me.** These are difficult times, and I am committed to making appropriate accommodations that meet your needs and that also allow you to complete the requirements of this course. My goal is for you to learn everything you want to learn in this class.

2. **This course is a work in progress.** This is its first offering. This means you have a unique opportunity to help improve the class for yourself as well as for future students. Please take advantage of it! The best way to provide constructive feedback is by emailing me and/or the TA.

3. Get the semester off to a good start: **[read the syllabus](https://www.cameo.com/v/5f2b392a0299b100202e624a?utm_campaign=video_share_to_copy)**!



{{< toc >}}

{{< courseinfo >}}
<!-- `{{% courseinfo %}}`{=html} -->

## Meeting times and locations

### Class

Tuesdays and Thursdays 9:40 - 10:55 in Warren 150

### My office hours

- Tuesdays 11:00am - 12:00pm  in Warren 466
  - these are "drop-in" office hours---come at any time, in any number
- Other times by appointment at [aem2850.youcanbook.me](https://aem2850.youcanbook.me)

### TA office hours

#### Graduate TA: Hui Zhou ([hz423@cornell.edu](mailto:hz423@cornell.edu))

- Mondays 1:30pm - 3:30pm in Warren 372

#### Undergraduate TA: Sophie McComb ([sm2397@cornell.edu](mailto:sm2397@cornell.edu))

- Mondays 12:20pm - 1:20pm in Warren 372
- Fridays 10:00am - 11:00am in Warren 372

See below for tips on how to make the most of office hours and email.


## Course overview

### Course description

This course provides business students with an introduction to the most important tools in R for programming and data visualization. Students will learn the basics of R syntax, data structures, data wrangling, and data visualization using the grammar of graphics.

After taking this course, students will have the tools to complete basic tasks in R and interface effectively with statisticians and data scientists in business settings. This course also provides a foundation for future coursework to implement more advanced statistical methods in R.

### Course outcomes
1.	Develop basic proficiency in R programming
2.	Understand data structures and manipulation
3.	Describe effective techniques for data visualization and communication
4.	Construct effective data visualizations
5.	Utilize course concepts and tools for business applications

### Prerequisites
- AEM 2010, AEM 2011, or equivalent (Spreadsheet Modeling)
- AEM 2100 or equivalent (Introductory Statistics)

OR instructor???s approval

<!-- ## Class Notes -->
<!-- Enrollment preference given to Dyson students in the Business Analytics concentration. Non-Dyson students require permission of instructor. -->



<!-- ## Course objectives -->

<!-- **Data rarely speaks for itself.** On their own, the facts contained in raw data are difficult to understand, and in the absence of beauty and order, it is impossible to understand the truth that the data shows. -->

<!-- In this class, you'll learn how to use industry-standard graphic and data design techniques to create beautiful, understandable visualizations and uncover truth in data. -->

<!-- By the end of this course, you will become (1) literate in data and graphic design principles, and (2) an ethical data communicator, by producing beautiful, powerful, and clear visualizations of your own data. Specifically, you should: -->

<!-- - Understand the principles of data and graphic design -->
<!-- - Evaluate the credibility, ethics, and aesthetics of data visualizations -->
<!-- - Create well-designed data visualizations with appropriate tools -->
<!-- - Share data and graphics in open forums -->
<!-- - Be curious and confident in consuming and producing data visualizations -->

<!-- This class will expose you to [R](https://cran.r-project.org/)???one of the most popular, sought-after, and in-demand statistical programming languages. Armed with the foundation of R skills you'll learn in this class, you'll know enough to be able to find how to visualize and analyze any sort of data-based question in the future. -->


### Course materials

All of the readings and software used for this class are **free**.

#### Books, articles, and other materials

We will draw on multiple textbooks, all of which are available online (**for free!**). You also have the option to get print versions of these books if you are interested.

<!-- - Alberto Cairo, *The Truthful Art: Data, Charts, and Maps for Communication* (Berkeley, California: New Riders, 2016) -->

- [*R for Data Science*](https://r4ds.had.co.nz) by Hadley Wickham and Garrett Grolemund

- [*Data Visualization: A Practical Introduction*](http://socviz.co/) by Kieran Healy

- [*Fundamentals of Data Visualization*](https://clauswilke.com/dataviz/) by Claus E. Wilke

<!-- Another popular book is [*Storytelling with Data*](https://www.storytellingwithdata.com/books) by Cole Nussbaumer Knaflic, but we will not draw heavily on it because it is not free. -->


<!-- There will occasionally be additional articles and videos to read and watch. When this happens, links to these other resources will be included on the content page for that session. -->

<!-- I also highly recommend subscribing to the [R Weekly newsletter](https://rweekly.org/). This email is sent every Monday and is full of helpful tutorials about how to do stuff with R. -->

#### R and RStudio

You will do all of your analysis with the open source (and free!) programming language [R](https://cran.r-project.org/). You will use [RStudio](https://www.rstudio.com/) as the main program to access R. **Think of R as an engine and RStudio as a car dashboard**???R handles all the calculations produces the actual statistics and graphical output, while RStudio provides a nice interface for running R code.

R is free, but it can sometimes be a pain to install and configure. To make life easier, we'll start by using the free [RStudio.cloud](http://rstudio.cloud/) service, which lets you run a full instance of RStudio in your web browser. This means you won't have to install anything on your computer to get started with R!

<!-- We will have a shared class workspace in RStudio.cloud that will let you quickly copy templates for examples, exercises, and mini projects. -->

RStudio.cloud is convenient, but it can be slow and it is not designed to be able to handle larger datasets or more complicated analysis and graphics. You also can't use your own custom fonts with RStudio.cloud. So you'll want to install R, RStudio, and other R packages on your own computer and wean yourself off of RStudio.cloud over the first few weeks of the semester.

<!-- You can [find instructions for installing R, RStudio, and all the tidyverse packages here.](/resource/install/) -->

#### Online help

Programming can be difficult. Little errors in your code can cause hours of headache, even if you've been coding for years.

Fortunately there are tons of online resources to help you with this. Two of the most important are [StackOverflow](https://stackoverflow.com/) (a Q&A site with hundreds of thousands of answers to all sorts of programming questions) and [RStudio Community](https://community.rstudio.com/) (a forum specifically designed for people using RStudio and the `tidyverse???that's you!).

<!-- If you use Twitter, post R-related questions and content with [#rstats](https://twitter.com/search?q=%23rstats). The community there is exceptionally generous and helpful. -->

Searching for help with R on Google can sometimes be tricky because the program name is, ya know, the letter R. Google is generally smart enough to figure out what you mean when you search for "r scatterplot", but if it does struggle, try searching for "rstats" instead (e.g., "rstats scatterplot"). Also, since most of your R work will deal with `tidyverse` packages like `ggplot2`, it's often easier to use those keywords instead of the letter "r" (e.g., "ggplot scatterplot"). 

Finally, there are some excellent tutorials on R available through [Rstudio Clould Primers](https://rstudio.cloud/learn/primers).






## Success in this course

I *promise* you can succeed in this class.

Learning R can be difficult at first???it's like learning a new language, just like Spanish, French, or Chinese. Hadley Wickham???the chief data scientist at RStudio and the author of some amazing R packages you'll be using like `ggplot2`???[made this wise observation](https://r-posts.com/advice-to-young-and-old-programmers-a-conversation-with-hadley-wickham/): 

> It's easy when you start out programming to get really frustrated and think, "Oh it's me, I'm really stupid," or, "I'm not made out to program." But, that is absolutely not the case. Everyone gets frustrated. I still get frustrated occasionally when writing R code. It's just a natural part of programming. So, it happens to everyone and gets less and less over time. Don't blame yourself. Just take a break, do something fun, and then come back and try again later.

Even experienced programmers find themselves bashing their heads against seemingly intractable errors. If you're finding yourself taking way too long hitting your head against a wall and not understanding, take a break, talk to classmates, email me and the TAs, etc. 

<img src="images/horst_error_tweet.png" width="80%" /><img src="images/gator_error.jpg" width="80%" />


## Course schedule

The [schedule page](/schedule/) provides an overview of the topics we will cover. *Note:* the schedule will inevitably change throughout the semester as we develop the course together.


## Office hours and email

#### Office hours

Please watch this video:

<iframe src="https://player.vimeo.com/video/270014784" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen style="display: block; margin: 0 auto 1rem;"></iframe>

Office hours are set times dedicated to you. 
 <!-- (most professors call these "office hours"; I don't^[There's fairly widespread misunderstanding about what office hours actually are! [Many students often think that they are the times I *shouldn't* be disturbed](https://www.chronicle.com/article/Can-This-Man-Change-How-Elite/245714/), which is the exact opposite of what they're for!]) -->
This means that I or a TA will be in an office and/or on zoom neeting waiting for you to talk to us about whatever questions you have. This is the best and easiest way to find us and the best chance for discussing class material and concerns.

I highly encourage you to utilize Professor and TA office hours, especially if you have trouble with basic `R` programming. [Times and locations are listed at the top of the syllabus](#zoom-links).

#### Email

You can also reach us by email. The best approach for generic, time-sensitive questions is to email all of us at the same time (and reply-all in follow-up emails). You can do that with one click [here](mailto:gerarden@cornell.edu,hz423@cornell.edu,sm2397@cornell.edu).


Email is a blessing and a curse. Here are some tips to help us get the most out of our email exchanges:

<!-- - Always include `[AEM 2850]` in your subject line (brackets included). -->
- Use a short but informative subject line. For example: `AEM 2850 - Final Project Grading`
- Use your University-supplied email for University business. This helps me know who you are.
- Ask direct questions. If you???re asking multiple related questions in one email, use a bulleted list. If you have multiple questions that aren't related, use multiple emails.
- One topic, one email. If you have multiple questions that aren't related, I prefer multiple emails.
- Be concise.




## Learning during a pandemic

Life sucks right now. You probably aren't having the college experience of your dreams, to say the least.

<!-- You most likely know people who have lost their jobs, have tested positive for COVID-19, have been hospitalized, or perhaps have even died. You all have increased (or possibly decreased) work responsibilities and increased family care responsibilities???you might be caring for extra people (young and/or old) right now, and you are likely facing uncertain job prospects. -->

**I am fully committed to making sure that you learn everything you are hoping to learn from this class.** I will make whatever accommodations I can to help you finish your assignments, do well on your projects, and learn and understand the class material.

If you need extra help, or if you need more time with something, or if you feel like you're behind or not understanding everything, **do not suffer in silence!** Talk to me! I will work with you. **I promise.** If you tell me you're having trouble, I will not judge you or think less of you. I hope you'll extend me the same grace.

You *never* owe me personal information about your health (mental or physical). But you are *always* welcome to talk to me about things you're going through. Even if I can't help you, I may know someone who can.

*Please* come to meet with me during set office hours, or sign up for another time to meet with me [here](https://aem2850.youcanbook.me).

I want you to learn a lot in this class (R! the tidyverse! grammer of graphics!), but I primarily want you to stay healthy, balanced, and grounded.

<!-- ## Late work -->

<!-- With the exception of the mini projects and the final project, there's no such late work. I would **highly recommend** staying caught up as much as possible, but if you need to turn something in late, that's fine???there's **no penalty**. -->











## Assignments and grading

### Assignments

Your grade in this course will be based on weekly reflections, labs, projects:

- **Reflections** are short weekly writing assignments. They are intended as an easy way to get some points and a nudge to engage with readings.

- **Labs** are short weekly homework assignments that require you to practice programming.

- **Projects** are intended to synthesize and reinforce the individual skills you develop in class, and to provide examples of their application to business and life more generally.

<!-- **Class participation** can take many forms. The best form of participation is active participation during class. When we are on zoom you can do this using the zoom chat and hand-raising with camera and mic on. The bare minimum can best be described as ???showing your presence and having some engagement??? ??? questions typed in chat and questions posed after class count towards participation. To encourage some form of participation, I will often pose questions to the class. -->

Please read [the assignments page](/assignment/) for more details on the assignments and their underlying rationale.

Each type of assignment will contribute to the final grade as follows:





|Assignment                       | Points| Percent|
|:--------------------------------|------:|-------:|
|Reflections (14 x 5 points each) |     70|     16%|
|Labs (13 x 10 points each)       |    130|     30%|
|Mini project 1                   |     50|     12%|
|Mini project 2                   |     50|     12%|
|Final project                    |    130|     30%|
|Total                            |    430|    100%|



### Grading scale

| Grade | Range     | Grade | Range  | Grade | Range |
|:-----:|:---------:|:-----:|:------:|:-----:|:-----:|
| A+    | :unicorn: | A     | 92-100 | A-    | 90-91 |
| B+    | 88-89     | B     | 82-87  | B-    | 80-81 |
| C+    | 78-79     | C     | 72-77  | C-    | 70-71 |
| D+    | 68-69     | D     | 62-67  | D-    | 60-61 |
| F     | <60       |       |        |       |       |


**Dyson grading policy:** Dyson faculty policy mandates that grades reflect a range of outcomes distinguishing between failing, poor, good, and excellent performance. The latter category is awarded an A grade and is considered the top mark in this course. The grade of A+ is awarded only for extraordinary achievement far above the mean and will in no case make up more than 5% of total final grades.






## University policies

### Academic integrity
Each student in this course is expected to abide by the Cornell University Code of Academic Integrity: https://cuinfo.cornell.edu/aic.cfm. Any work submitted by a student in this course for academic credit will be the student's own work. You are encouraged to study together and to discuss information and concepts covered in this course and the sections with other students. However, this permissible cooperation should never involve one student having possession of a copy of all or part of work done by someone else, in the form of an electronic or hard copy. This policy extends beyond peers in the course: buying, selling, or otherwise sharing course materials is prohibited. Should copying occur, both the student who copied work from another student and the student who gave material to be copied will both automatically receive a zero for the assignment/exam. Penalty for violation of this Code can also be extended to include failure of the course and University disciplinary action.

### Sharing of course materials is prohibited

Sharing of course materials is prohibited. These materials include, but are not limited to: zoom recordings, lecture hand-outs, in-class materials, exercises, and assignments. Accessing course materials through friends or indirectly online is a violation of the Code of Academic Integrity.
<!-- https://theuniversityfaculty.cornell.edu/the-new-faculty-handbook/6-policies-and-assistance/6-1-instruction/33797-2/ -->


## University resources

### Counseling & Psychological Services (CAPS)

Life at Cornell can be complicated and challenging, especially during a pandemic. You might feel overwhelmed, experience anxiety or depression, or struggle with relationships or family responsibilities. [Counseling & Psychological Services (CAPS)](https://health.cornell.edu/services/mental-health-care) provides *confidential*, professional support for Cornell students. Please do not hesitate to contact CAPS for assistance.

### Accommodations for students with disabilities
Your access in this course is important. Please give me your Student Disability Services (SDS) accommodation letter in the first three weeks of the semester so that we have adequate time to arrange your approved academic accommodations. If you need an immediate accommodation for equal access, please speak with me after class, [email me](mailto:gerarden@cornell.edu), or email SDS at [sds_cu@cornell.edu](mailto:sds_cu@cornell.edu).If the need arises for additional accommodations during the semester, please contact SDS.

### Inclusivity
We understand that our members represent a rich variety of backgrounds and perspectives. The Dyson School of Applied Economics and Management is committed to providing an atmosphere for learning that respects diversity. While working together to build this community we ask everyone to:

- share their unique experiences, values and beliefs
- be open to the views of others
- honor the uniqueness of their colleagues
- appreciate the opportunity that we have to learn from each other
- value each other???s opinions and communicate in a respectful manner
- keep confidential discussions that the community has of a personal nature
- use this opportunity together to discuss ways in which we can create an inclusive environment in this course and across the Cornell community

## Acknowledgements

This site and many of the course materials build on the course [Data Visualization with R](https://datavizs21.classes.andrewheiss.com) by [Andrew Heiss](https://andrewheiss.com). Other materials and inspiration came from [Claus Wilke](https://clauswilke.com), [Grant McDermott](https://grantmcdermott.com), [Ivan Rudik](https://ivanrudik.com), [Justin Kirkpatrick](https://www.justinkirkpatrick.com), [Ed Rubin](https://edrub.in), [Jenny Bryan](https://jennybryan.org), [Allison Horst](https://www.allisonhorst.com), [Magdalena Bennett](https://www.magdalenabennett.com), [Ariel Ortiz-Bobea](https://ortiz-bobea.dyson.cornell.edu), and [Reza Moghimi](https://dyson.cornell.edu/faculty-research/faculty/am2393/).



<!-- ## Star Wars -->

<!-- Once you have read this entire syllabus and [the assignments page](/assignment/), please [click here](mailto:gerarden@cornell.edu) and email me a picture of a *cute* Star Wars character.^[Baby Yoda, Babu Frik, porgs, etc. are all super fair game.] Brownie points if it's animated.  -->

<!-- `{{% figure src="https://media.giphy.com/media/j4q4h9uWKWwnYT1k3Z/giphy.gif" alt="Baby Yoda with IG-11" lightbox="false" %}}`{=html} -->
