This is the R script repository of the "[Tools for Analytics Lab - R-track](http://economics.ceu.edu/courses/1-tools-analytics-lab-r-track)" course, part of the [MSc in Business Analytics](http://business.ceu.edu/msc-in-business-analytics) at CEU.

## Table of Contents
* Jan 28: [Introduction to R and General Programming](#jan-28-210-min-introduction-to-r-and-general-programming)
* Jan 29: [Data Visualization and Data Preparations](#jan-29-300-min-data-visualization-and-data-preparations)
* [Exercises on data preparations and visualization](#exercises-on-data-preparations-and-visualization)
* Feb 04: [Modeling](#feb-04-300-min-modeling)
* [Exercises for the exam](#exercises-on-data-preps-visualization-and-modeling)
* Feb 05: [Exam](#feb-05-90-min-exam)

---

### Jan 28 (210 min): Introduction to R and General Programming

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-1)
* Introduction to R: [variables, functions and vectors](1.R)

### Jan 29 (300 min): Data Visualization and Data Preparations

* [Univariate plots in `base` R](2.R#L55)
* [Data Visualization with `ggplot2`](2.R#L78)
* [Filtering and summarizing data with `data.table`](2.R#L253)
* [Wide and long tables](2.R#L351)

### Exercises on data preparations and visualization

* Visualize the below variables from the `mtcars` dataset with `ggplot2`:
    * number of carburetors
    * horsepower
    * barplot on the number of carburetors per transmission
    * boxplot on the horsepower by the number of carburetors
    * horsepower and weight by the number of carburetors
    * horsepower and weight by the number of carburetors with a trend line
	
* `data.table` exercises using the  `hflights` dataset:
    * compute the number of cancelled flights
    * compute the shortest flight on each weekday
    * compute the average delay to all destination
    * compute the average delay to all destination per origin
    * plot the average departure and arrival delays per destination
    * plot the percentage of cancelled flights per destination
	
* Further exercises on the `nycflights13` dataset:
	* count the number of flights to LAX
	* count the number of flights to LAX from JFK
	* compute the average delay (in minutes) for flights from JFK to LAX
	* which destination has the lowest average delay from JFK?
	* plot the average delay to all destinations from JFK
	* plot the distribution of all flight delays to all destinations from JFK
	* compute a new variable in flights showing the week of day
	* plot the number of flights per weekday
	* create a heatmap on the number of flights per weekday and hour of the day
	* plot the average temperature at noon in `EWR` for each month based on the `weather` dataset

* [Solutions](3.R#L1)

### Feb 04 (300 min): Modeling

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-1)
* [Recap in linear models](3.R#L100)
* [Hierarchical and k-means clustering](3.R#L253)
* [Classification](3.R#L289)
* [Intro to PCA with image processing](http://bit.ly/CEU-R-PCA)
* [Dimension reduction with PCA](3.R#L395)
* [Multidimensional scaling](3.R#L470)
* [High level overview on decision trees, bagging, random forest and boosting](http://bit.ly/CEU-R-boosting)
* [Intro to `h2o`](3.R#L515)

## Exercises on data preps, visualization and modeling

* Plot the weight and horsepower of cars from the `mtcars` dataset (bundled with R, see `?mtcars`)
* Add a linear trend line to the above plot
* Add a 3rd degree polynomial model to the above plot
* Fit a linear model on `hp` to predict weight
* Estimate the weight based on the above model for a car with 98 horsepower
* Estimate the weight based on the above model for `Lotus Europa`
* What's the average fuel consumption?
* Build a linear model to describe fuel consumption based on the horsepower and weight
* Compute a new variable in the dataset for the ratio of `wt` and `hp`
* Plot the distribution of this new variable on a boxplot
* Create an aggregated dataset on `mtcars` including the average `hp` and `wt` grouped by the number of gears
* Compute a new variable for fuel consumption using the "liters per 100 kilometers" unit based on `mpg`
* Which car has the best fuel consumption?
* Compute `wt2` to store the weight in kilograms based on `wt`
* Apply k-means clustering on the dataset to split the observations into 3 groups
* Perform hierarchical clustering on the dataset and plot the dendogram
* Compare the cluster memberships returned by the hierarchical and k-means methods
* Build a decision tree to tell if a car has automatic or manual transmission (hint: you might want to convert the number to factor first)
* Visualize the above decision tree
* Create a confusion matrix for the above model
* Use the k-NN algorithm to fit a similar model and decide on the best number of neighbors to use
* Did you use a training and validation dataset?
* Visualize the (dis)similarity of cars using PCA or MDS
* Load the [weight.csv](http://bit.ly/BudapestBI-R-csv) and build a model to classifying observation if BMI is above the normal threshold (25)

### Feb 05 (90 min): Exam

1. Transform the `mtcars` dataset to a new `data.table` object called `dt`
2. Count the number of cars with less than `4` gears
3. Count the number of cars with more than `4` gears and less than 90 horsepower
4. What's the average weight of cars with `4` gears?
5. What's the weight of the car with the best fuel consumption?
6. Plot the distribution of the number of cylinders
7. Plot the distribution of the number of cylinders grouped by carburetors
8. Plot the average weight of cars grouped by the number of cylinders
9. Plot the distribution of the performance of the cars (horsepower) per number of cylinders
10. Install and load the `ISLR` package and use its `Auto` dataset for the below exercises
11. Plot the weight and horsepower of cars
12. Add a linear trend line to the above plot
13. Fit a linear model using the weight of cars to predict acceleration
14. What's the estimated acceleration of a car with `weight = 3`?
15. Filter for cars from America (1) and Europe (2) and store the results in a new object called `auto` (mind the lower case letters)
16. Remove the `name` column
17. Apply k-means or hierarchical clustering on this dataset to split the observations into 3 groups, and show the number of observations in the clusters

* Bonus points: Build and visualize a decision tree to tell if a car was made in America or Europe, show the confusion matrix, do the same with k-NN

### Feb 05 (60 min): R Markdown

Resources:
* [UK dialect maps in a web service](http://blog.rapporter.net/2013/07/uk-dialect-maps.html)
* [useR! 2015 tutorial](https://github.com/daroczig/user2015-markdown-tutorial)
* [RStudio R Markdown cheat sheet](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)

### Feb 05 (60 min): Git and GitHub

1. Register an account at https://github.com
2. Install git from https://git-scm.com/
3. Install R from https://www.r-project.org/
4. Install RStudio from https://www.rstudio.com/products/RStudio/#Desktop
5. Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
6. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
7. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
8. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial

### Feb 05 (90 min): Shiny dashboards

Resources:
* [Network analysis of the Hungarian interbank lending market](https://daroczig.shinyapps.io/rinfinance_Berlinger-Daroczi-demo/)
* [RStudio Shiny cheat sheet](http://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
