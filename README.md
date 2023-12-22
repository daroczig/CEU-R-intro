This is the R script repository of the "[Coding 3: Introduction to R](https://courses.ceu.edu/courses/2023-2024/coding-3-introduction-r)" course of the 2023/2024 Winter term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. In the previous years, most of these materials were part of the "Data Analysis 1a: Exploration" course that you can find in the [2015/2016 Winter](https://github.com/daroczig/CEU-R-lab/tree/2016), [2016/2017 Fall](https://github.com/daroczig/CEU-R-lab/tree/2017), [2017/2018 Fall](https://github.com/daroczig/CEU-R-lab/tree/2018) and [2018/2019 Fall](https://github.com/daroczig/CEU-R-lab/tree/2018-fall) branches.

## Table of Contents

* [Schedule](https://github.com/daroczig/CEU-DV2#schedule)
* [Syllabus](https://github.com/daroczig/CEU-DV2#syllabus)
* [Technical Prerequisites](https://github.com/daroczig/CEU-DV2#technical-prerequisites)
* [Class Schedule](https://github.com/daroczig/CEU-DV2#class-schedule)
* [Contact](https://github.com/daroczig/CEU-DV2#contacts)

## Schedule

2 x 300 mins on Jan 10 and 17:

* 13:30 - 15:10 session 1
* 15:10 - 15:40 break
* 15:40 - 17:20 session 2
* 17:20 - 17:40 break
* 17:40 - 19:20 session 3

## Location

In-person at the Vienna campus (QS B-421).

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

Please bring your own laptop* and make sure to install the below items **before** attending the first class:

0. Join the Slack channel dedicated to the class (`#ba-r-intro-2023`)
1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://posit.co/download/rstudio-desktop/
3. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:

```r
install.packages(c('ggplot2', 'gganimate', 'transformr', 'gifski'))
library(ggplot2)
library(gganimate)
ggplot(diamonds, aes(cut)) + geom_bar() +
    transition_states(color, state_length = 0.1)
```

Optional steps I highly suggest to do as well before attending the class if you plan to use `git`:

4. Register an account at https://github.com
5. Bookmark, watch or star this repository so that you can easily find it later
6. Install `git` from https://git-scm.com/
7. Verify in RStudio that you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
8. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
9. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
10. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```sh
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial if in doubt or [contact me](#contact).

(*) If you may not be able to use your own laptop, there's a shared RStudio Server set up in AWS - including all the required R packages already installed for you. Look up the class Slack channel for how to access.

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-lab/issues).
