## #############################################################################
## basic math operations
## #############################################################################

1 + 3
3 * 3

## #############################################################################
## vectorized operations
## #############################################################################

# TODO what does the following code do? (hint: run it from inside-out)
sum((1:9)^3) + 1
# NOTE vectorized operations are first-class citizens in R e.g. versus plain Python without numpy
# sum([i**3 for i in range(10)]) + 1

# colon operator on a float (it's just a sequence from start to end by +/-1)
1.5:9

# we know vectors! do we?
as.Date("2026-05-04")
as.Date("2026-05-11")
as.Date("2026-05-04"):as.Date("2026-05-11")

# NOTE Python's str
str(as.Date("2026-05-04"))
str(as.Date("2026-05-04"):as.Date("2026-05-11"))

seq(as.Date("2026-05-04"), as.Date("2026-05-11"))
seq(as.Date("2026-05-04"), as.Date("2026-05-11"), by = 2)
seq(as.Date("2026-05-04"), as.Date("2026-05-11"), by = "2 day")
str(seq(as.Date("2026-05-04"), as.Date("2026-05-11"), by = "1 day"))

weekdays(seq(as.Date("2026-05-04"), as.Date("2026-05-11"), by = "1 day"))
substr(weekdays(seq(as.Date("2026-05-04"), as.Date("2026-05-11"), by = "1 day")), 1, 1)

## #############################################################################
## constants
## #############################################################################

pi
"pi"
'pi'

?pi

## #############################################################################
## vectors recap
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

# TODO what does the following code do?
hist(runif(100000))
?runif

runif(5, 5, 25)
# vs
runif(5, 5, n = 25)

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
x <- sample(c(1, -1), size = 100, replace = TRUE)

cumsum(x)
plot(cumsum(x), type = 's')

## vectorize more!
x <- round(runif(100))*2-1
cumsum(x)

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

# points to: https://gistcdn.githack.com/wch/4034323/raw/c77c7e9ca27f45ca989200f696f0ccc5aec4132a/heightweight.csv
df <- read.csv('https://bit.ly/height-weight-csv')
str(df)
plot(df)

## TODO check the number of observation
length(df)
str(df)
nrow(df)
?nrow
dim(df)

## dim returns same as
c(nrow(df), ncol(df))

## TODO check the height of the 2nd respondent
df$heightIn[2]
df[2, 4]
df[2, 'heightIn']
df[2, "heightIn"]

## TODO compute height in cm
df$heightIn * 2.54
str(df)
df$height <- df$heightIn * 2.54
str(df)

## drop a column
df$heightIn <- NULL
str(df)

## TODO compute weight in kg
df$weight <- df$weightLb * .45
str(df)

## TODO compute BMI
df$bmi <- df$weight / (df$height/100)^2

## removing 2 columns
df$weightLb <- df$ageMonth <- NULL
str(df)

## quick EDA
plot(df) ## data.frame

## interactivity
install.packages('pairsD3')
library(pairsD3)
pairsD3(df)

## why ggplot?
install.packages('GGally')
library(GGally)
ggpairs(df)

## #############################################################################
## intro to ggplot2
## #############################################################################

## the R implementation of the Grammar of Graphics
library(ggplot2)

## barplot with ggplot: you specify a dataset, then define an aesthetic and geom
ggplot(df, aes(x = height)) + geom_histogram()
## and optionally some further layers (theme)
ggplot(df, aes(x = height)) + geom_histogram() + theme_bw()
ggplot(df, aes(x = height)) + geom_histogram(colour = "darkgreen", fill = "white") + theme_bw()

## we can store the resulting plot as an R object for future reuse
p <- ggplot(df, aes(x = height)) + geom_histogram()
p
p + theme_bw()

## it's better to split long lines for easier reading
p <- ggplot(df, aes(x = height)) +
     geom_histogram() +
     theme_bw()
p

## coord transformations
library(scales)
p + scale_y_log10()
p + scale_y_sqrt()
p + scale_y_reverse()
p + coord_flip()

## other categorical variable: country
ggplot(df, aes(x = sex)) + geom_histogram() # ERROR
ggplot(df, aes(x = sex)) + geom_bar()
ggplot(df, aes(x = sex)) + geom_bar() + theme(axis.text.x = element_text(angle = 90))
## QQ ordering? later...
?theme

## other geoms
ggplot(df, aes(height, weight)) + geom_point()
ggplot(df, aes(height, weight)) + geom_point() + geom_smooth()
ggplot(df, aes(height, weight)) + geom_point() + geom_smooth(method = 'lm', color = 'red', se = FALSE)

## mix continious with a discrete variable
ggplot(df, aes(height)) + geom_boxplot()
ggplot(df, aes(sex, height)) + geom_boxplot()
ggplot(df, aes(sex, height)) + geom_violin()
ggplot(df, aes(sex, height)) + geom_boxplot() + geom_violin(alpha = .25)
ggplot(df, aes(sex, height)) + geom_boxplot() + geom_violin(alpha = .25) +  geom_jitter()

## facet => create separate plots per group
p <- ggplot(df, aes(x = height)) + geom_histogram()
p + facet_wrap( ~ sex)

## density plot
ggplot(df, aes(x = height)) + geom_density()
ggplot(df, aes(x = height, fill = sex)) + geom_density()
ggplot(df, aes(x = height, fill = sex)) + geom_density(alpha = 0.2) + theme_bw()
ggplot(df, aes(x = height, fill = sex)) + geom_density(alpha = 0.2) + theme_bw() +
    ggtitle("Height of boys and girls") +
    xlab("Height (cm)") + ylab("") +
    theme(legend.position = "top")

?theme
