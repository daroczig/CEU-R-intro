This is the R script repository of the "[Tools for Analytics Lab - R-track](http://economics.ceu.edu/courses/1-tools-analytics-lab-r-track)" course, part of the [MSc in Business Analytics](http://business.ceu.edu/msc-in-business-analytics) at CEU.

## Table of Contents
* Jan 25: [Introduction to R and General Programming](#jan-25-90-min-introduction-to-r-and-general-programming)
* Jan 26: [First Steps with Data Visualization](#jan-26-90-min-first-steps-with-data-visualization)
* Jan 27: [Data Preparation](#jan-27-140-min-data-preparation)
* Jan 28: [Introduction to modeling](#jan-28-140-min-models)
* Jan 30: [Modeling & introduction to ML methods on qualitative data](#jan-28-180--100-min-modeling--intro-to-ml-methods-on-qualitative-data)
* [Sample exam questions](#sample-exam-questions)
* Feb 01: [Random forest and GBM with H2O](#feb-1-90-min-random-forest-and-gbm-with-h2o)
* Feb 02: [Exam](#feb-2-90-min-exam)

### List of optional take-home exercises
* [ggplot](#ggplot-ex1)
* data.table: [1](#data-table-ex1), [2](#data-table-ex2), [3](#data-table-ex3)

---

### Jan 25 (90 min): Introduction to R and General Programming

* General overview of the R ecosystem: [slides](http://bit.ly/CEU-R-1)
* Introduction to R: [variables, functions and vectors](https://github.com/daroczig/CEU-R-lab/blob/master/1.R)

### Jan 26 (90 min): [First Steps with Data Visualization](https://github.com/daroczig/CEU-R-lab/blob/master/2.R)

* Introducing `data.frame`
* Exploratory data analysis with histogram, boxplot, bar chart and scatterplot
* Plots outside of Excel: `dotchart` and `vioplot` examples
* The Grammar of Graphics in R with `ggplot2`

### Jan 27 (140 min): [Data Preparation](https://github.com/daroczig/CEU-R-lab/blob/master/3.R)

* [Register a GitHub account](https://github.com/join)

<a id="ggplot-ex1"></a>

* `ggplot2` exercises
    * number of carburetors
    * horsepower
    * barplot of number of carburetors per transmission
    * boxplot of horsepower by the number of carburetors
    * horsepower and weight by the number of carburetors
    * horsepower and weight by the number of carburetors with a trend line

* Filtering and summarizing data with base `R`
* Intro to `data.table`

<a id="data-table-ex1"></a>

* `data.table` exercises with `hflights`
    * the number of cancelled flights
    * the shortest flight on each weekday
    * the average delay to all destination
    * the average delay to all destination per destination
    * plot the departure and arrival delays
    * plot the average departure and arrival delays per destination
    * plot the average departure and arrival delays per flight + size
    * estimate the delay to Budapest

* Some quick examples on string and date manipulations
* Left joins

### Jan 28 (140 min): [Models](https://github.com/daroczig/CEU-R-lab/blob/master/4.R)

* Revisiting GitHub integration in RStudio:
    1. Install git from https://git-scm.com/
    2. Install R from https://www.r-project.org/
    3. Install RStudio from https://www.rstudio.com/products/RStudio/#Desktop
    4. Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
	5. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
    6. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
    7. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

	    ```
        $ git config --global user.name "Your Name"
        $ git config --global user.email "Your e-mail address"
		```
		
		Close this window, commit, push changes, all set.

<a id="data-table-ex2"></a>

* `data.table` exercises with the following dataset:

	```r
	set.seed(42)
	tx <- data.table(
        item   = sample(letters[1:3], 10, replace = TRUE),
        time   = as.POSIXct(as.Date('2016-01-01')) - runif(10) * 36*60^2,
        amount = rpois(10, 25))
	prices <- data.table(
        item  = letters[1:3],
        date  = as.Date('2016-01-01') - 1:2,
        price = as.vector(outer(c(100, 200, 300), c(1, 1.2))))
	items <- data.table(
        item   = letters[1:3],
       color  = c('red', 'white', 'red'),
      weight = c(2, 4, 2.5))
	```
    * filter for transactions with "b" items
	* filter for transactions with less than 25 items
	* filter for transactions with less then 25 "b" items
	* count the number of transactions for each items
	* count the number of transactions for each day
	* count the overall number of items sold on each day

* Further `data.table` examples on
    * left joins
    * transforming wide and long tables with `reshape2`
	* rolling and overlap joins

* ANOVA
* Crosstable
* Simpson's paradox

Datasets for the model examples:
* [height & weight dataset](http://bit.ly/BudapestBI-R-csv)
* [Bickel et al 1975](http://bit.ly/bickel-1975)

<a id="data-table-ex3"></a>

Further `data.table` exercises on the `nycflights13` dataset to practice for the exam:

* count the number of flights to LAX
* count the number of flights to LAX from JFK
* compute the average delay (in minutes) for flights from JFK to LAX
* which destination has the lowest average delay from JFK?
* plot the average delay to all destinations from JFK
* plot the distribution of all flight delays to all destinations from JFK
* compute a new variable in flights showing the week of day
* plot the number of flights per weekday
* create a heatmap on the number of flights per weekday and hour of the day (see `geom_tile`)
* merge the `airports` dataset to `flights` on the FAA airport code
* order the `weather` dataset by `year`, `month`, `day` and `hour`
* plot the average temperature at noon in `EWR` for each month based on the `weather` dataset
* aggregate the `weather` dataset and store as `daily_temperatures` to show the daily average temperatures based on the `EWR` records
* merge the `daily_temperatures` dataset to `flights` on the date
* do the above two steps on daily + hourly temperature averages

### Jan 28 (180 + 100 min): [Modeling & intro to ML methods on qualitative data](https://github.com/daroczig/CEU-R-lab/blob/master/4.5)

Basic models:

* Linear regression
* Diagnose plots
* Extrapolation
* Polynomial regression
* Confounders
* Correlation & causality
* Importance of feature selection and engineering

Clustering:

* distance matrix
* hierarchical clustering
* identifying the optimal number of clusters
* k-means clustering

Classification:

* confusion matrix
* k-Nearest Neighbors algorithm
* decision trees with `rpart`
* overfitting
* other decision tree algorithms in R and the `caret` package

Dimension reduction methods:

* Principal Component Analysis
* Multidimensional Scaling

Datasets and references for the model examples:

* [height & weight dataset](http://bit.ly/BudapestBI-R-csv)
* [OLS trend line distance from actual points](http://psycho.unideb.hu/statisztika/pages/interaktiv.html)
* [Shoe size & math](http://bit.ly/math_and_shoes)

### Sample exam questions

1. Load the content of the https://bit.ly/mtcars-csvO CSV file and save as `df` (check the variable names in the manual of `mtcars`)
2. Transform `df` to a `data.table` object
3. Count the number of cars with `4` gears
4. Count the number of cars with `4` gears and less than 100 horsepower
5. What's the overall weight of cars with `4` cylinders?
6. Which car is the heaviest?
7. Plot the distribution of weights
8. Plot the distribution of gears
9. Plot the distribution of weights per gears
10. Plot the average weight per gears
11. Which car has the best fuel consumption?
12. Plot the weight and horsepower of cars
13. Add a linear trend line to the above plot
14. Add a 3rd degree polynomial model to the above plot
15. Fit a linear model on `hp` to predict weight
16. Estimate the weight based on the above model for `Lotus Europa`
17. Compute a new variable in the dataset for the ratio of `wt` and `hp`
18. Plot the distribution of this new variable on a boxplot
19. Create an aggregated dataset on `mtcars` including the average `hp` and `wt` grouped by the number of gears
20. Merge the average `hp` and `wt` per gears from the above dataset to the original `df` object based on the number of gears
21. Compute a new variable for fuel consumption using the "liters per 100 kilometers" unit based on `mpg`
22. Which car has the best fuel consumption?
23. Compute `wt2` to store the weight in kilograms based on `wt`
24. Apply k-means clustering on the dataset to split the observations into 3 groups
25. Perform hierarchical clustering on the dataset and plot the dendogram
26. Build a decision tree to tell if a car has automatic or manual transmission
27. Visualize the above decision tree
28. Create a confusion matrix for the above model
29. Use the k-NN algorithm to fit a similar model and decide on the best number of neighbors to use

### Feb 1 (90 min): Random forest and GBM with H2O

Slides:
* [PCA and `hclust` examples](http://bit.ly/CEU-R-PCA)
* [General overview on bagging, random forest and boosting methods](http://bit.ly/CEU-R-boosting)

Install the `h2o` package then start H2O in the R console:

```r
library(h2o)
h2o.init()
```

If you get an error on the Blue Lab computers, then open a Windows Command Prompt in Start Menu/All Programs/Accessories and run the following command:

```
java -jar "c:\Program Files\R\R-3.2.3\library\h2o\java\h2o.jar"
```

And connect to H2O from R via rerunning the `h2o.init()` function from above.

### Feb 2 (90 min): Exam

1. Transform the `mtcars` dataset to `data.table` and store as a new object
2. Count the number of cars with less than `4` gears
3. Count the number of cars with more than `4` gears and less than 100 horsepower
4. What's the average weight of cars with `4` cylinders?
5. Which car has the best fuel consumption?
6. Plot the distribution of the number of carburetors 
7. Plot the distribution of the number of carburetors grouped by gears
8. Plot the average weight grouped by the number of carburetors
9. Plot the weight and horsepower of cars
10. Add a linear trend line to the above plot
11. Add a 3rd degree polynomial model to the above plot
12. Fit a linear model on the weight of cars to predict fuel consumption
13. What's the estimated fuel consumption of a car with `wt = 5`?
14. Install the `ISLR` package and use its `Auto` for the below exercises
15. Build and visualize a decision tree to tell if a car was made in America, Europe or Japan
16. Apply k-means or hierarchical clustering on the dataset to split the observations into 3 groups

Bonus exercise: train a reasonable k-NN or other ML model classifying cars as American VS other origin (target for AUC > 0.95)

### Feb 3 (140 min): Dynamic Reports and Reproducible Research

For a formal introduction, see my [tutorial slides presented at useR! 2015](https://github.com/daroczig/user2015-markdown-tutorial) or for a quick intro: [7.Rmd](https://github.com/daroczig/CEU-R-lab/blob/master/7.Rmd)
