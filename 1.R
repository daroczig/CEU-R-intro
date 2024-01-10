## #############################################################################
## basic math operations
## #############################################################################

1 + 3
3 * 3
3^2
## ~undocumented, but works like in Python
3**2

pi
"pi"
'pi'

?pi

## #############################################################################
## vectors
## #############################################################################

letters
LETTERS
str(letters)

## one-based indexing!
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
?plot.default

## later => ggplot2

x <- seq(0, pi*2, by = 0.1)
plot(x, sin(x), type = 'l', col = 'red')

curve(sin, to = pi * 2)
?curve
?plot
?plot.default
curve(cos, to = pi * 2, col = 'red', add = TRUE)

## NOTE TRUE is often abbreviated to T, but avoid by all means, see e.g.
## T <- FALSE

## TODO Brownian motion / random walk for 100 steps
x <- 0
# +1
# -1

for (i in 1:100) { # whitespace doesn't matter, but stick with a code style!
    if (runif(1) < 0.5) {
        x <- x - 1
    } else {
        x <- x + 1
    }
}
x

set.seed(42)

## vectorize (always)
x <- round(runif(100))*2-1
cumsum(x)

plot(cumsum(x), type = 's')

x <- sample(c(1, -1),
            size = 100,
            replace = TRUE)
cumsum(x)

w <- matrix(round(runif(1e3))*2-1, nrow = 10)
w <- apply(w, 1, cumsum)
w
w[100, ]

w <- matrix(round(runif(1e6))*2-1, nrow = 1e3)
w <- apply(w, 1, cumsum)
str(w)
w[1000, ]
hist(w[1000, ])

## DATA!
h <- c(174, 170, 160)
w <- c(90, 80, 70)

plot(h, w, main = 'Heights and weights of students',
     xlab = 'Height', ylab = 'Weight')

## #############################################################################
## basic stats
## #############################################################################

min(w)
max(w)
range(w)
diff(range(w))
mean(w)
median(w)
sum(w)
summary(w)

cor(w, h)
lm(w ~ h) # linear model


165 * 1.3462 -146.1538

fit <- lm(w ~ h)
predict(fit, newdata = list(h = 165))

## extrapolation + needs more data! e.g. on newborns..
predict(fit, newdata = list(h = 52))

str(fit)
fit
summary(fit)

abline(fit, col = 'red')

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

cor(df)
plot(df)
lm(df)

## compute Body Mass Index (BMI)
df$bmi <- df$weight / (df$height/100)^2
str(df)
df
