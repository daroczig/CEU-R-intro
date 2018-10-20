## clean your R session from past objects ...
## and the set RStudio to never save your session again
rm(list = ls())

## running an R script from a trusted source
## NOTE never do this again!
source('http://bit.ly/CEU-R-heights-2018')
ls()
heights

## but wow:
ls(all = TRUE)
.secret # "A warm hello from the Internet."

## compute the average height of the students
mean(heights, na.rm = TRUE)

## what if we got only 10 responses?
mean(heights[1:10], na.rm = TRUE)
mean(heights[5:14], na.rm = TRUE)
mean(heights[8:17], na.rm = TRUE)

## random sampling
sample(heights, 10)
mean(sample(heights, 10), na.rm = TRUE)

for (i in 1:10) {
    cat(i, 'st/nd/rs iteration:', mean(sample(heights, 10), na.rm = TRUE), '\n')
}

set.seed(42)
for (i in 1:10) {
    cat(i, 'st/nd/rs iteration:', mean(sample(heights, 10), na.rm = TRUE), '\n')
}

replicate(n = 5, expr = mean(sample(heights, 10), na.rm = TRUE))


x <- replicate(n = 100, expr = mean(sample(heights, 10), na.rm = TRUE))
hist(x)
abline(v = mean(x, na.rm = TRUE), col = 'red')

## add confidence interval
sd(x, na.rm = TRUE)
se <- sd(x, na.rm = TRUE) / sqrt(length(x))

abline(v = mean(heights, na.rm = TRUE) - se*1.96, col = 'blue')
abline(v = mean(heights, na.rm = TRUE) + se*1.96, col = 'blue')

## larger sample
df <- read.csv('http://bit.ly/CEU-R-heights')
heights <- df$heightIn

x <- replicate(n = 100, expr = mean(sample(heights, 10), na.rm = TRUE))
hist(x)
abline(v = mean(x, na.rm = TRUE), col = 'red')

se <- sd(x, na.rm = TRUE) / sqrt(length(x))
abline(v = mean(heights, na.rm = TRUE) - se*1.96, col = 'blue')
abline(v = mean(heights, na.rm = TRUE) + se*1.96, col = 'blue')

## TODO ggplot
library(ggplot2)
ggplot(data.frame(averages = replicate(n = 100, expr = mean(sample(heights, 10), na.rm = TRUE)))) +
    geom_histogram(aes(averages)) +
    geom_vline(xintercept = mean(heights, na.rm = TRUE), col = 'red') +
    geom_vline(xintercept = mean(heights, na.rm = TRUE) - se*1.96, col = 'blue') +
    geom_vline(xintercept = mean(heights, na.rm = TRUE) + se*1.96, col = 'blue')

## TODO the students are higher than 60 inches? T/F
TRUE

## TODO is there any difference between the average height of a female or male student?
str(df)

library(data.table)
df <- data.table(df)

df[, mean(heightIn), by = sex]

## we need confidence intervals!
females <- df[sex == 'f']
males <- df[sex == 'm']

mean(males$heightIn) + sd(males$heightIn, na.rm = TRUE) / sqrt(length(males$heightIn))
mean(males$heightIn) - sd(males$heightIn, na.rm = TRUE) / sqrt(length(males$heightIn))

mean(females$heightIn) + sd(females$heightIn, na.rm = TRUE) / sqrt(length(females$heightIn))
mean(females$heightIn) - sd(females$heightIn, na.rm = TRUE) / sqrt(length(females$heightIn))

## TODO plot it!
library(ggplot2)
ggplot(df, aes(sex, heightIn)) + geom_boxplot()

library(ggpubr)
ggplot(df, aes(sex, heightIn)) + geom_boxplot() + stat_compare_means()
?stat_compare_means
ggplot(df, aes(sex, heightIn)) + geom_boxplot() + stat_compare_means(method = 't.test')

?wilcox.test
?t.test

t.test(females$heightIn, males$heightIn)
t.test(females$heightIn, males$heightIn, var.equal = TRUE)
wilcox.test(females$heightIn, males$heightIn)

## check the structure of these objects
test <- t.test(females$heightIn, males$heightIn)
str(test)
test$p.value

## TODO what about weight?
t.test(females$weightLb, males$weightLb)

## QQ sample size for weight?
?power.t.test
power.t.test(delta = 5, sd = sd(df$weightLb),
             ## target confidence to detect if difference is significant
             sig.level = 0.05,
             ## probability of detecting the difference if it exists
             power = 0.8)

power.t.test(delta = 1, sd = sd(df$weightLb), sig.level = 0.05, power = 0.8)

## TODO sample size for an online A/B test?

power.prop.test(p1 = 100 / 1000, p2 = 300 / 2500, sig.level = 0.05, power = 0.8)
