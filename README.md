## SSI2007/3003 Data Analysis in Social Science 3, University of Exeter (2023-24, spring term)

### Module outline

#### Classes

- Tuesday, 2.30-4.30pm (Old Library 136)

#### Lecturer

- Professor Alexey Bessudnov (a.bessudnov [at] exeter.ac.uk)

#### Student support hours

- Monday, 4-5pm (Clayden 1.05). Please email me before coming to the office hours.
- Alternatively, please email me to arrange me a meeting in person or on Teams/Zoom.

#### Aims of the module

This is a fourth module in the data analysis in social science series. In the Introduction to Social Data (SSI1005) you learnt the basics of descriptive statistics and R. Data Analysis 1 (SSI1006) introduced you to statistical inference. Data Analysis 2 (SSI2005) covered linear regression analysis. In Data Analysis 3 we are not going to learn new statistical techniques, but will focus on how to apply the techniques you already know to the analysis of real-life data sets and how to produce good statistical reports.

This is a skill that you may need in a variety of jobs where data analytic expertise is required, such as market analysis, policy analysis in various fields, web analytics, data journalism, academic research, etc.

You already know how to use R to describe data and estimate simple statistical models. However, real-life data rarely come in the form of a perfectly formatted csv file ready for the analysis. The real life data sets often need to be reshaped, merged, recoded, aggregated and modified in various ways before you can even start your analysis. Unless you know how to do this you will not be able to conduct independent statistical analysis.

In this module we will use data from the Understanding Society, a large household panel study conducted in the UK. We will work with longitudinal data, which introduces a number of technical challenges.

We will use R, and you are expected to know the basics of data analysis in R already. The pre-requisites for this module are SSI1005 and SSI1006.

The only way to learn data analysis is to do data analysis. I will not be able to teach you this, but I can guide your independent learning. This is why in this module I use the "flipped classroom" approach. This means that you are expected to read and master the required material BEFORE you come to class. The videos for each week are available on ELE (these were mostly recorded in 2021). Please watch the videos, read the required parts of the textbook and do the exercises before coming to class. In class we'll work on additional exercises together and I'll clarify any questions / problems that you have.


#### Software

Please install the following software.

- [R](https://www.r-project.org/) (please update your distribution if already installed)
- [R Studio](https://www.rstudio.com/) (please update if already installed)
- [Git](https://git-scm.com/)
- [LaTeX](https://www.latex-project.org/)

All this software is free. 

#### Data

We will use data from the Understanding Society survey. You should download the data from the UK Data Service website (study number 6614): https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6614 . You will need to log in to the UK Data Service using your Exeter credentials, add this data set to a new project (providing its brief description) and download the data in the tabular format.

#### Attendance

This is a technical module, and it will require effort and time commitment from you. As with other technical skills, missing some initial bits means that you may not be able to catch up.

#### Assessment

The summative assessment for this module is a data report of 1,500 words (50% of your final mark) and an ELE test (one hour, 50% of the mark).

The one-hour ELE test will be conducted in week 6 (Tuesday 20 February). The test will be open book, timed, and it'll test your knowledge of the module content.

For the final data report you will conduct independent data analysis and produce a report of 1,500 words describing the results. The deadline for the report is Thursday 28 March, 2pm (week 11). The marking criteria for data reports are the following: originality of the approach, complexity of the analysis, correctness of the code, correctness of the interpretations, knowledge of the background literature, style and accuracy.

Formative assessment is optional and does not count towards your grade. For the formative assessment I will ask you to complete a mock ELE test with questions similar to the summative test. You can also complete two data assignments on Github (more details on this later) to prepare you for doing the analysis for your data reports.

#### Syllabus plan 

The plan below is flexible and I may change some topics as we proceed.

- 16 January (week 1). Introduction to the module. Data analysis workflow. Reproducible research.The Understanding Society data.
- 23 January (week 2). Data transformation. Relational data.
- 30 January (week 3). Tidy data and reshaping.
- 6 February (week 4). Data visualisation.
- 13 February (week 5). Modelling.
- 20 February (week 6). ELE test.
- 27 February (week 7). Functions. Iteration.
- 5 March (week 8). Data types in R.
- 12 March (week 9). Data import. Scraping data from the web.
- 19 March (week 10). Using API for social research.
- 26 March (week 11). Text analysis.

#### Reading list

The main text for this module is Grolemund and Wickham's *R for Data Science*.

- G.Grolemund & H.Wickham. R for Data Science. 2nd ed. Freely available at <https://r4ds.hadley.nz>.

For details on how to use R Markdown see:

- Y.Xie, J.J.Allaire, G.Grolemund. (2018). [R Markdown: The Definitive Guide](https://bookdown.org/yihui/rmarkdown/).

The guide on using Git and Github with R Studio:

- J.Bryant et al. [Happy Git and GitHub for the useR](https://happygitwithr.com/).

Data visualisation.

- W.Chang. (2019). R Graphics Cookbook. 2nd ed. https://r-graphics.org/
- K.Healy. (2018). Data Visualization: A Practical Introduction. Princeton University Press. You can access a draft of the book here: https://socviz.co/  and the code for graphs is available here: https://github.com/kjhealy/dataviz .

R Programming.

- R.Peng. (2016). R Programming for Data Science. https://bookdown.org/rdpeng/rprogdatascience/

There are many other resources that can help you with R. [DataCamp](https://www.datacamp.com/) is an online learning platform that covers most topics in this module. Also see a list of other resources here <https://www.tidyverse.org/learn/>.

Full documentation for the *Understanding Society* is available at <https://www.understandingsociety.ac.uk/>.
