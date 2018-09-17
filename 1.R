## #############################################################################
## basic math operations
## #############################################################################

1 + 3
3 * 3

pi
"pi"
'pi'

## #############################################################################
## vectors
## #############################################################################

letters
LETTERS
str(letters)

letters[1]
letters[5]
letters[1:5]
1:5
seq(1, 5)
?seq
seq(1, 5, by = 0.1)
seq(1, 5, 0.1)
seq(by = 0.1, from = 1, to = 5)

## #############################################################################
## variables
## #############################################################################

x = 4  # works, but not in sync with the common code style
x <- 4 # good!

x * 2

## TODO compute the square root of x
x ^ 2
x ^ 0.5

## #############################################################################
## functions
## #############################################################################

sqrt(x)

hist(runif(100000))
?runif

runif(5, 5, 25)

## TODO sine wave
x <- 1:20
x <- 'foobar'
x <- runif
x(5)
x <- 1:20
sin(x)

## #############################################################################
## basic plots
## #############################################################################

plot(x, sin(x))
plot(x, sin(x), type = 'l')
?plot

## ggplot2

x <- seq(0, pi*2, by = 0.1)
plot(x, sin(x), type = 'l', col = 'red')

curve(sin, to = pi * 2)
?curve

h <- c(174, 170, 160)
w <- c(90, 80, 70)

plot(h, w, main = 'Heights and weights of students',
     xlab = 'Height', ylab = 'Weight')

## #############################################################################
## basic stats
## #############################################################################

cor(w, h)
lm(w ~ h) # linear model
fit <- lm(w ~ h)
str(fit)
fit
summary(fit)

abline(fit, col = 'red')

165 * 1.3462 -146.1538
predict(fit, newdata = list(h = 156))

predict(fit, newdata = list(h = 56))

## #############################################################################
## data frames
## #############################################################################

df <- data.frame(weight = w, height = h)
df
str(df)
df$weight
df$weight[1]
df[1, 1]
df[2, 2]
df[1, ]
df[, 1]

## compute Body Mass Index (BMI)
df$bmi <- df$weight / (df$height/100)^2
str(df)
df

df <- read.csv('http://bit.ly/CEU-R-heights')
str(df)
plot(df)

## TODO compute height cm
## TODO compute weight kg
## TODO compute BMI
