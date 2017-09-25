## #############################################################################
## from vectors to data frames
## #############################################################################

h <- c(174, 170, 160)
w <- c(90, 80, 70)

df <- data.frame(weight = w, height = h)

df[1, ]
df[, 1]
df[3, 2]
df$weight
df$weight[2]

## TODO how do you get 174 from the above matrix
df[1, 2]

## compute Body Mass Index (BMI) by:
## a person's weight in kilograms divided by the square of height in meters
df$height <- df$height / 100
df
df$bmi <- df$weight / df$height^2
df

summary(df$bmi)

## import more data with similar structure
df <- read.csv('http://bit.ly/CEU-R-heights')
str(df)

## TODO compute weight in kg, height in cm and BMI
df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / (df$height/100)^2
str(df)

summary(df$bmi)

## descriptive stats
min(df$ageYear)
max(df$ageYear)
range(df$ageYear)
sum(df$weightLb)
length(df$weight)
nrow(df)
ncol(df)
dim(df)

## #############################################################################
## intro to plots
## #############################################################################

## draw a histogram
hist(df$bmi)
## add two vertical lines with the limits of normal BMI
abline(v = c(18.5, 25), col = 'red')

## density plot on the same variable
plot(density(df$bmi))

## boxplot on the same variable
boxplot(df$bmi)
## with a split by gender
boxplot(bmi ~ sex, df)

library(beanplot)
beanplot(df$bmi)
beanplot(bmi ~ sex, df)

## example on the advantages of vioplot over boxplot
boxplot(
  rbeta(1e3, 0.1, 0.1),
  runif(1e3)*2-0.5,
  rnorm(1e3, 0.5, 0.75))

beanplot(
  rbeta(1e3, 0.1, 0.1),
  runif(1e3)*2-0.5,
  rnorm(1e3, 0.5, 0.75))

## some pie chart alternatives
pie(table(df$sex))
barplot(table(df$sex))
dotchart(table(df$sex))
dotchart(table(df$sex), xlim = c(0, 150))

## exploratory data analysis
pairs(df)

library(GGally)
ggpairs(df)

library(pairsD3)
pairsD3(df)

## #############################################################################
## intro to stats
## #############################################################################

t.test(height ~ sex, data = df) # note it's not Student's t-test, but Welch
t.test(weight ~ sex, data = df)
t.test(bmi ~ sex, data = df)

aov(height ~ sex, data = df)
summary(aov(height ~ sex, data = df))
summary(aov(weight ~ sex, data = df))

## Post hoc tests => Tukey Honest Significant Differences
TukeyHSD(aov(height ~ sex, data = df))
TukeyHSD(aov(weight ~ sex, data = df))
TukeyHSD(aov(bmi ~ sex, data = df))

## #############################################################################
## intro into business-like data
## #############################################################################

## NOTE see PDF on data structure + intro to data types on Moodle

## NOTE don't share this data outside of the class!
df <- read.csv('http://bit.ly/CEU-R-hotels-2017')
hotels <- read.csv('http://bit.ly/CEU-R-hotels-2017')
str(hotels)
## TODO check the dataset, column types, analyze (descriptive stats, plots, association)

hist(hotels$price_HUF)
summary(hotels$price_HUF)
table(cut(hotels$price_HUF, breaks = 10))
plot(table(cut(hotels$price_HUF, breaks = 50)))
pie(table(cut(hotels$price_HUF, breaks = 50)))
dotchart(table(cut(hotels$price_HUF, breaks = 50)))
dotchart(table(cut(hotels$price_HUF, breaks = 50, dig.lab = 8)))

## which is the most expensive hotels?
which(hotels$price_HUF > 100000)
pricey <- which(hotels$price_HUF > 100000)
hotels[pricey, ]
hist(hotels[pricey, 'stars'])
hist(hotels[pricey, 'rating'])

pricey_and_bad <- which(hotels$price_HUF > 100000 & hotels$rating < 3)
hotels[pricey_and_bad, ]

## TODO find the best rating hotels below 10K HUF
cheap <- which(hotels$price_HUF < 10000)
max(hotels[cheap, 'rating'], na.rm = TRUE)
cheap_and_good <- which(hotels$price_HUF < 10000 & hotels$rating == 5)
## NOTE no affil
hotels[cheap_and_good, ]

## #############################################################################
## intro into data.table
## #############################################################################

## NOTE there's also dplyr and tidyverse, feel free to use that
## https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

## introduction to data.table
install.packages('data.table')
library(data.table)
hotels <- data.table(hotels)
str(hotels)

## dt[i]
hotels[price_HUF < 100000] ## NOTE typo on purpose
hotels[price_HUF < 10000 & rating == 5]
hotels[price_HUF < 10000 & rating > 4]

## dt[i, j] => summaries
hotels[price_HUF < 10000 & rating > 4, .N]
hotels[price_HUF < 10000 & rating > 4, mean(rating)]

## TODO compute the avg price with rating > 4.5
hotels[rating > 4.5, mean(price_HUF)]

## TODO compute average stars of the cheap hotels
hotels[price_HUF < 10000, mean(stars)]
hotels[price_HUF < 10000, median(stars)]

## TODO average rating
hotels[, mean(rating)]
hotels[, mean(rating, na.rm = TRUE)]
hotels[, mean(rating, na.rm = TRUE)]

## group by
hotels[, mean(rating, na.rm = TRUE), by = stars]
hotels[, mean(rating, na.rm = TRUE), by = stars][order(stars)]

## name column
star_rating <- hotels[, mean(rating, na.rm = TRUE), by = stars]
star_rating
star_rating <- hotels[, list(avg_rating = mean(rating, na.rm = TRUE)), by = stars]
star_rating <- hotels[, .(avg_rating = mean(rating, na.rm = TRUE)), by = stars]
star_rating
setorder(star_rating, avg_rating)
star_rating

## multiple summaries / "j" expressions: avg rating and stars
hotels[, mean(rating, na.rm = TRUE)]
hotels[, median(stars, na.rm = TRUE)]
hotels[, .(avg_rating = mean(rating, na.rm = TRUE),
           avg_stars  = median(stars, na.rm = TRUE))]

hotels[, list(
    avg_price = mean(price_HUF),
    avg_stars = mean(stars, na.rm = TRUE),
    .N,
    with5stars = sum(stars == 5)
), by = city]

## TODO number of missing ratings per stars
hotels[, sum(is.na(rating)), by = stars]

