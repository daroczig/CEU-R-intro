This is the R script repository of the "[Data Analysis 1a: Exploration](https://courses.ceu.edu/courses/data-analysis-1-exploration-business-analytics-track)" course in the 2018/2019 Fall term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous years, see the [2015/2016 Winter](https://github.com/daroczig/CEU-R-lab/tree/2016), [2016/2017 Fall](https://github.com/daroczig/CEU-R-lab/tree/2017) and [2017/2018 Fall](https://github.com/daroczig/CEU-R-lab/tree/2018) branches.

## Table of Contents

* [Syllabus](https://github.com/daroczig/CEU-R-lab#syllabus)
* [Technical Prerequisites](https://github.com/daroczig/CEU-R-lab#technical-prerequisites)
* [Class Schedule](https://github.com/daroczig/CEU-R-lab#class-schedule)
* [Contact](https://github.com/daroczig/CEU-R-lab#contacts)

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

Please bring your own laptop and make sure to install the below items **before** attending the first class:

1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://www.rstudio.com/products/rstudio/download
3. Register an account at https://github.com
4. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:

```r
install.packages('ggplot2')
library(ggplot2)
ggplot(diamonds, aes(cut)) + geom_bar()
```

Optional steps I highly suggest to do as well before attending the class if you plan to use `git`:

4. Bookmark, watch or star this repository so that you can easily find it later
5. Install `git` from https://git-scm.com/
6. Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
7. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
8. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
9. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial if in doubt or [contact me](#contact).

## Class Schedule

### Week 1 (100 min): Introduction to R

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-1)
* Basic math operations: [1.R](1.RR#L1)
* Numbers, strings, vectors: [1.R](1.R#L12)
* Functions: [1.R](1.R#L43)
* Basic plots: [1.R](1.R#L62)
* Basic stats: [1.R](1.R#L84)
* Intro to data frames: [1.R](1.R#L102)

Suggested reading: [Hadley Wickham: Style guide. In *Advanced R*.](http://adv-r.had.co.nz/Style.html)

Homework: [DataCamp](https://campus.datacamp.com/courses/ceu-da1-2018-seminar-homeworks/42448)

### Week 2 (100 min): Introduction to Data Frames and column types

* Recap on data frames: [2.R](2.R#L1)
* Loading data from text and Excel files: [2.R](2.R#L73)
* Variable types, conversion between variable types: [2.R](2.R#L96)

Homework: [DataCamp]()

### Week 3 (100 min): Introduction to Data Transformations

* Recap on data frames: [3.R](3.R#L1)
* Creating new variables: [3.R](3.R#L45)
* Finding missing values [3.R](3.R#25) and duplicates [3.R](3.R#L50)
* Intro into `data.table`: [3.R](3.R#L58)
* Summarizing data, aggregates: [3.R](3.R#L92)
* Combining datasets: [3.R](3.R#L116)

Homework: DataCamp

### Week 4 (100 min): Exploratory Data Analysis

* Basic text parsing
* The five-number summary
* Data visualization with `ggplot2`

Homework: DataCamp

### Week 5 (100 min): Sampling and Simulations

* Simulation of random walk in 1D
* Introduction to writing loops and the `apply` function family
* Estimating the standard error

Homework: DataCamp

### Week 6 (100 min): Hypothesis Testing

* z-score
* t-test
* Confidence intervals
* Deep dive in the R object structures
* Computing required sample size for A/B testing

Homework

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-lab/issues).
