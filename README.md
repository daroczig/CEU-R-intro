This is the R script repository of the "[Tools for Analytics Lab - R-track](http://economics.ceu.edu/courses/1-tools-analytics-lab-r-track)" course, part of the [MSc in Business Analytics](http://business.ceu.edu/msc-in-business-analytics) at CEU.

## Table of Contents
* Jan 28: [Introduction to R and General Programming](#jan-28-210-min-introduction-to-r-and-general-programming)
* Jan 29: [Data Visualization and Data Preparations](#jan-29-300-min-data-visualization-and-data-preparations)
* Feb 04: [Modeling](#feb-04-300-min-modeling)

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
