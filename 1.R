## basic operations
1 + 3
3*2
3^2

## constants
pi
letters
month.name

## help
?pi
apropos('month')

## variables
x = 4
x <- 4
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

## custom functions
f <- function(x) 2 * x + 1
f(5)
f(pi)

## vectors
1:5
seq(1, 5)
?seq
seq(1, 5, 0.1)

x <- seq(1, 5, 0.1)
plot(x, f(x))
plot(x, f(x), type = 'l')

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

## TODO simulate Brownian motion in 1D
round(runif(5))

round(runif(5))*2 - 1

cumsum(round(runif(25))*2 - 1)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

set.seed(42)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

sample(c(-1, 1), 25, replace = TRUE)

## combine values into vector
h <- c(174, 170, 160)
h
(w <- c(90, 80, 70))

plot(h, w)
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')

cor(w, h)

lm(w ~ h)
fit <- lm(w ~ h)
summary(fit)

plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')
abline(fit, col = 'red')

## some basic modeling
predict(fit, list(h = c(56, 104)))

plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight',
     xlim = c(0, max(h)),
     ylim = c(0, max(w)))
abline(fit, col = 'red')

## polynomial model
fit <- lm(w ~ poly(h, 2, raw = TRUE))
fit <- lm(w ~ h + I(h^2))

2824 + 174 * -34.3571 + (174^2)*0.1071

plot(h, w)
lines(h, predict(fit), col = 'red')

predict(fit, data.frame(h = c(56, 104)))

plot(0:200, predict(fit, list(h = 0:200)), type = 'l')
abline(v = c(160, 174), col = 'red')

## data.frame
df <- data.frame(weight = w, height = h)
df
str(df)
df$weight

lm(weight ~ height, data = df)

?'$'

plot(df)
cor(df)

df$weight[3]
df[1, 1]
df[3, 2]

## TODO compute the Body Mass Index (BMI)
##      "weight in kilograms divided by the square of height in meters"
df$bmi <- df$weight / (df$height/100)^2

## importing data from text files
df <- read.csv('http://bit.ly/BudapestBI-R-csv')
str(df)

df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
str(df)

df$heightIn <- df$weightLb <- NULL
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

## TODO plot and analyze association between height and weight
plot(df$height, df$weight)

with(df, plot(height, weight))

with(df, plot(height, weight, col = sex))
abline(lm(df$weight ~ df$height))
abline(lm(weight ~ height, data = df))

plot(df$height, df$weight)
lines(130:180,
      predict(lm(weight ~ poly(height, 2), data = df),
              newdata = data.frame(height = 130:180)), col = 'red')

## TODO: compute and plot BMI index
df$bmi <- df$weight / (df$height/100)^2
hist(df$bmi)

## some quick exploratory data analysis
pairs(df)

## subset
dff <- subset(df, sex == 'f')
plot(dff$height, dff$weight)

## query
df[which(df$ageYear > 20), ]

which.max(df$ageYear)
df[131, ]
df[which.max(df$ageYear), ]

df[which(df$ageYear > 15 & df$ageYear <=18 & df$weight > 60 & df$sex == 'f'), ]

## aggregate
aggregate(height ~ sex, FUN = mean, data = df)
aggregate(weight ~ sex, FUN = mean, data = df)

## statistical test: t-test, ANOVA
t.test(height ~ sex, data = df)

aov(height ~ sex, data = df)
summary(aov(height ~ sex, data = df))
summary(aov(weight ~ sex, data = df))

## fetching data from online sources
library(XML)
df <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/FTSE_100_Index'),
                    which = 2, header = TRUE)
str(df)

## dirty data!
df$'Market cap (£bn)' <- as.numeric(df$'Market cap (£bn)')
df$Employees <- as.numeric(sub(',', '', as.character(df$Employees)))
str(df)

table(df$Sector)
hist(df$'Market cap (£bn)')
aggregate(Employees ~ Sector, FUN = mean, data = df)
aggregate(`Market cap (£bn)` ~ Sector, FUN = mean, data = df)

## TODO do exploratory data analysis on the classic mtcars dataset
str(mtcars)
?mtcars

table(mtcars$am, mtcars$gear)
plot(table(mtcars$am, mtcars$gear))
chisq.test(table(mtcars$am, mtcars$gear))

## GH
