## #############################################################################
## Intro to R Syntax
## #############################################################################

## basic math operations
1 + 3
3*2
3^2

## constants
pi
letters
month.name

## how to get help
?pi
apropos('month')

month.abb
month.name

## variables
x = 4          # don't use this
x <- 4         # use this instead
x

x / 2
x^2

## TODO compute the square root of 2
x^0.5

## functions
sqrt(x)
sqrt(x = x)
sin(pi / 2)

## random numbers from uniform distribution (and NOT "run if")
runif(2)
round(runif(2))
round(runif(2), 1)

## define custom functions
f <- function(x) 2 * x + 1
f(5)
f(pi)

## #############################################################################
## Draw the first plot
## #############################################################################

## combine values into a vector
1:5
seq(1, 5)
?seq
seq(1, 5, 0.1)

## now we store a sequence from 1 to 5 by 0.1 as x and plot f(x)
x <- seq(1, 5, 0.1)
plot(x, f(x))
plot(x, f(x), type = 'l')

## adding a title and a grid to the plot
plot(x, f(x), type = 'l', xlab = '', main = '2x+1')
grid()

## TODO draw a sine wave
x <- seq(0, pi * 2, 0.1)
plot(x, sin(x), type = 'l')

## a simpler way for plotting functions
curve(f)
?curve

curve(2*x + 1, from = 0, to = 50)
curve(x + 1, add = TRUE, col = 'red')

## TODO draw a sine wave with curve
curve(sin, from = 0, to = 2*pi)

## #############################################################################
## Build the first model
## #############################################################################

## custom vectors -> combine values into vector
h <- c(174, 170, 160)
w <- c(90, 80, 70)

## render a scatterplot
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')

## compute the correlation coefficient
cor(w, h)

## build a basic linear model
lm(w ~ h)
fit <- lm(w ~ h)
174 * 1.3462 - 146.1538
summary(fit)

## plot this model as a straight line on the scatterplot
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')
abline(fit, col = 'red')

## polynomial model
lm(w ~ h + I(h^2))
2824.2857 + 174 * -34.3571 + 174^2 * 0.1071

## intro to data.frame object type
df <- data.frame(weight = w, height = h)
df
str(df)
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

## import more data with similar structure
df <- read.csv('http://bit.ly/BudapestBI-R-csv')
str(df)

## scatterplot + linear model
plot(df$heightIn, df$weightLb, main = "Demo", xlab = 'Height', ylab = 'Weight')
abline(lm(weightLb ~ heightIn, data = df), col = 'red')

## TODO compute weight in kg, height in cm and BMI
df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / (df$height/100)^2
str(df)

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
## Aggregate and filter data
## #############################################################################

## filter
subset(df, sex == 'f')
subset(df, sex == 'f' & ageYear > 14.2)

## aggregate
aggregate(height ~ sex, FUN = min, data = df)
aggregate(height ~ sex, FUN = mean, data = df)

## statistical test: t-test
t.test(height ~ sex, data = df)
