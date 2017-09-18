## #############################################################################
## basic math operations
## #############################################################################

1 + 3
3*2
3^2

## constants
pi
"pi"
'pi'
letters
LETTERS

letters[1:3]

month.name
month.abb

## how to get help
?pi
apropos('month')

## variables
x = 4
x <- 4
x

x / 2
x^2

## TODO compute the square root of 4
x^0.5

## #############################################################################
## functions
## #############################################################################

sqrt(x)
sqrt(x = x)
sin(pi / 2)

## random numbers from uniform distribution (and NOT "run if")
runif(2)
round(runif(2))
round(runif(2), 1)

hist(rnorm(5000))

## define custom functions
f <- function(x) 2 * x + 1
f(5)
f(pi)

## combine values into a vector
c(1, 2, 3, 4, 5)
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
## simulate Brownian motion / random walk in 1D
## #############################################################################

## first steps
round(runif(5))

## we transform the previously generated floating random numbers between 0 and 1
## to either -1 or 1
round(runif(5))*2 - 1

## we compute the cumulative sum to identify the actual value for each iteration
cumsum(round(runif(25))*2 - 1)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

## set the random number generator to a specific state for reproducibility
set.seed(42)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

## a much simpler solution for the above
plot(cumsum(sample(c(-1, 1), 25, replace = TRUE)), type = 's')

## looping
for (i in 2:6) {
  lines(cumsum(round(runif(25))*2 - 1), type = 's', col = i)
}

## TODO check the distribution of values after the 25th iteration
x <- sum(round(runif(25))*2 - 1)
for (i in 1:50) { # 5000
    x <- c(x, sum(round(runif(25))*2 - 1))
}
hist(x)
## rings a bell?

hist(replicate(5000, sum(round(runif(25))*2 - 1)))

## #############################################################################
## from vectors to data frames
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
summary(fit)

## plot this model
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')
abline(fit, col = 'red')

## intro to data.frame object type
df <- data.frame(weight = w, height = h)
df

plot(df)
cor(df)
lm(df)

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

summary(df$bmi)

## import more data with similar structure
df <- read.csv('http://bit.ly/CEU-R-heights')
str(df)

## TODO compute weight in kg, height in cm and BMI
df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / (df$height/100)^2
str(df)

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

t.test(height ~ sex, data = df)
t.test(weight ~ sex, data = df)
t.test(bmi ~ sex, data = df)

aov(height ~ sex, data = df)
summary(aov(height ~ sex, data = df))
summary(aov(weight ~ sex, data = df))

## Post hoc tests => Tukey Honest Significant Differences
TukeyHSD(aov(height ~ sex, data = df))
TukeyHSD(aov(weight ~ sex, data = df))
TukeyHSD(aov(bmi ~ sex, data = df))

