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

#solution for the homework from the presentation: 
#check if the 1/10th of the number of carburetors in a Toyota Corolla (in mtcars) plus 0.05 equals to 0.15
all.equal(mtcars["Toyota Corolla","carb"] / 10 + 0.05, 0.15)
