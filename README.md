This is the R script repository of the "[Data Analysis 1a: Foundation of Data management in R](https://economics.ceu.edu/courses/data-analysis-1a-foundation-data-management-r)" course, part of the [MSc in Business Analytics](https://economics.ceu.edu/program/master-science-business-analytics) at CEU. For the previous years, see the [2016](https://github.com/daroczig/CEU-R-lab/tree/2016) and [2017 Winter](https://github.com/daroczig/CEU-R-lab/tree/2017) branches.

## Table of Contents

* [Syllabus](https://github.com/daroczig/CEU-R-lab#syllabus)
* [Technical Prerequisites](https://github.com/daroczig/CEU-R-lab#technical-prerequisites)
* [Class Schedule](https://github.com/daroczig/CEU-R-lab#class-schedule)

    * [Week 1: Introduction to R and General Programming](https://github.com/daroczig/CEU-R-lab#week-1-200-min-introduction-to-r-and-general-programming)
    * [Week 2: Introduction to Data Frames](https://github.com/daroczig/CEU-R-lab#week-2-200-min-introduction-to-data-frames)
    * [Week 3: Data Transformations and Visualization](https://github.com/daroczig/CEU-R-lab#week-3-200-min-data-transformations-and-data-visualization)
    * [Week 4: Text Parsing, Regular Expressions, Joins](https://github.com/daroczig/CEU-R-lab#week-4-200-min-text-parsing-regular-expressions-joins)

* [Contact](https://github.com/daroczig/CEU-R-lab#contacts)

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

Although the required software is already installed on the computers in the School Lab, but if you plan to use your own laptop, please make sure to install the below items **before** attending the first class:

1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://www.rstudio.com/products/rstudio/download
3. Register an account at https://github.com
4. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:

```r
install.packages('ggplot2')
library(ggplot2)
ggplot(diamonds, aes(cut)) + geom_bar()
```

Regarding coding style, I highly suggest reading the [related chapter from Hadley Wickham's "Advanced R" book](http://adv-r.had.co.nz/Style.html).

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

Full-time and part-time students attend the class on different weekdays, so below I will refer to only week numbers.

### Week 1 (200 min): Introduction to R and General Programming

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-1)
* [Basic math operations](https://github.com/daroczig/CEU-R-lab/blob/2018/1.R#L1)
* [Functions](https://github.com/daroczig/CEU-R-lab/blob/2018/1.R#L37)
* [Simulation of random walk in 1D](https://github.com/daroczig/CEU-R-lab/blob/2018/1.R#L90)
* [Association between vectors](https://github.com/daroczig/CEU-R-lab/blob/2018/1.R#L112)

* Supplementary materials: [loops](https://github.com/daroczig/CEU-R-lab/blob/2018/1-extra.R#L1)

### Week 2 (200 min): Introduction to Data Frames

You can find the recommended reading on data types and an overview of the `hotels` dataset uploaded to Moodle.

Also note, that as said in the class, `data.table` is not the only available `data.frame` extension, you could also use for example `dplyr`, see a quick overview in the related [cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) or the check the related DataCamp course that you can take for free until Jan 2018.

* [From vectors to data frames](https://github.com/daroczig/CEU-R-lab/blob/2018/2.R#L1)
* [Intro to plots](https://github.com/daroczig/CEU-R-lab/blob/2018/2.R#L50)
* [Intro to stats](https://github.com/daroczig/CEU-R-lab/blob/2018/2.R#L97)
* [Intro into business-like data](https://github.com/daroczig/CEU-R-lab/blob/2018/2.R#L114)
* [Intro into `data.table`](https://github.com/daroczig/CEU-R-lab/blob/2018/2.R#L151)

### Week 3 (200 min): Data Transformations and Data Visualization

* [Creating new variables: numeric to factor](https://github.com/daroczig/CEU-R-lab/blob/2018/3.R#L9)
* [Summary tables](https://github.com/daroczig/CEU-R-lab/blob/2018/3.R#L50)
* [`ggplot2`: Grammar of Graphics in R](https://github.com/daroczig/CEU-R-lab/blob/2018/3.R#L129)

### Week 4 (200 min): Text Parsing, Regular Expressions, Joins

* [Parsing text](https://github.com/daroczig/CEU-R-lab/blob/2018/4.R#L4)
* [Joins](https://github.com/daroczig/CEU-R-lab/blob/2018/4.R#L64)
* [Geocoding](https://github.com/daroczig/CEU-R-lab/blob/2018/4.R#L117)

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-lab/issues).
