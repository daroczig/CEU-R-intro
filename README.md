This is the R script repository of the "[Coding 3: Introduction to R](https://courses.ceu.edu/courses/2023-2024/coding-3-introduction-r)" course of the 2023/2024 Winter term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. In the previous years, most of these materials were part of the "Data Analysis 1a: Exploration" course that you can find in the [2015/2016 Winter](https://github.com/daroczig/CEU-R-lab/tree/2016), [2016/2017 Fall](https://github.com/daroczig/CEU-R-lab/tree/2017), [2017/2018 Fall](https://github.com/daroczig/CEU-R-lab/tree/2018) and [2018/2019 Fall](https://github.com/daroczig/CEU-R-lab/tree/2018-fall) branches.

## Table of Contents

* [Schedule](https://github.com/daroczig/CEU-DV2#schedule)
* [Syllabus](https://github.com/daroczig/CEU-DV2#syllabus)
* [Technical Prerequisites](https://github.com/daroczig/CEU-DV2#technical-prerequisites)
* [Class Schedule](https://github.com/daroczig/CEU-DV2#class-schedule)
* [Homework](https://github.com/daroczig/CEU-DV2#homework)
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
install.packages('ggplot2')
library(ggplot2)
ggplot(diamonds) +
  aes(x = price, fill = clarity) +
  geom_density(alpha = 0.5) + facet_grid(color ~ cut) +
  xlab('') + ylab('') +
  theme_bw() + theme('legend.position' = 'top') +
  guides(fill = guide_legend(nrow = 1))
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

For the curious mind, this is how the shared RStudio Server was set up in AWS: <details><summary>Click to expand ...</summary>

💪 Installing software:

```
# most recent R builds
wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
echo "deb [arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/cran_r.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67C2D66C4B1D4339 51716619E084DAB9
sudo apt update && sudo apt upgrade
sudo apt install r-base
# apt builds of all CRAN packages
wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | sudo tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc
echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main" | sudo tee -a /etc/apt/sources.list.d/cranapt.list
sudo apt update
# install some R packages
sudo apt install -y r-cran-ggplot2 r-cran-ggally r-cran-readxl
sudo apt install -y r-cran-data.table
sudo apt install -y r-cran-glue r-cran-logger
# install RStudio IDE
sudo apt install -y r-base gdebi-core
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb
sudo gdebi rstudio-server-*.deb
# never do this in prod
echo "www-port=80" | sudo tee -a /etc/rstudio/rserver.conf
sudo rstudio-server restart
```

💪 Creating users

```r
secret <- 'something super secret' # e.g. digest::digest(1, algo="sha1")
users <- c('list', 'of', 'users')

library(logger)
library(glue)
for (user in users) {

  ## remove invalid character
  user <- sub('@.*', '', user)
  user <- sub('-', '_', user)
  user <- sub('.', '_', user, fixed = TRUE)
  user <- tolower(user)

  log_info('Creating {user}')
  system(glue("sudo adduser --disabled-password --quiet --gecos '' {user}"))

  log_info('Setting password for {user}')
  system(glue("echo '{user}:{secret}' | sudo chpasswd")) # note the single quotes + placement of sudo

  log_info('Adding {user} to sudo group')
  system(glue('sudo adduser {user} sudo'))

}
```
</details>

## Class Schedule

### Week 1 (200 min): Introduction to R

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-intro-2023)
* Basic math operations: [1.R](1.R#L1)
* Numbers, strings, vectors: [1.R](1.R#L12)
* Functions: [1.R](1.R#L50)
* Basic plots: [1.R](1.R#L68)
* Basic stats: [1.R](1.R#L136)
* Intro to data frames: [1.R](1.R#L167)
* Introduction to data visualization with `ggplot2`: [1.R](1.R#L244)
* Introduction to `data.table`: [1.R](1.R#L323)

## Homework

Load the bookings dataset:

```r
library(ggplot2)
library(data.table)
hotels <- readRDS(url('http://bit.ly/CEU-R-hotels-2018-merged'))
```

* How many hotels are from Austria?
* What is the rating of the most expensive hotel (based on the price per night)?
* How many bookings are in 4-star hotels?
* Which country has the highest number of 5-star hotels?
* Plot the number of bookings per country!
* Flip the coordinates and use the "classic dark-on-light theme"!
* Drop the Y axis title, and rename the X axis to "Number of hotels"!
* Count the number of hotels per country!
* Order by alphabet!
* Count the number of bookings per country, order by the number of bookings!
* Compute the average rating per number of stars! Use the `weighted.mean` function to account for the number of ratings of the hotels, and experiment with the `na.rm` argument. Eliminate `NA`s. Order by stars.
* Plot this computed average rating per stars!
* Make sure that each star category is printed on the X axis!
* Create a boxplot on ratings per stars!
* Create histograms on the nightly prices for each star category! Check out the arguments and disable forcing the same Y axis range for the subplots.


## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-lab/issues).
