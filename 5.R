## #############################################################################
## `data.table` exercises on the `nycflights13` dataset
## #############################################################################

library(nycflights13)
flights <- data.table(nycflights13::flights)

##  count the number of flights to LAX
flights[dest == 'LAX', .N]

##  count the number of flights to LAX from JFK
flights[dest == 'LAX' & origin == 'JFK', .N]

##  compute the average delay (in minutes) for flights from JFK to LAX
flights[dest == 'LAX' & origin == 'JFK', mean(arr_delay, na.rm = TRUE)]

##  which destination has the lowest average delay from JFK?
flights[origin == 'JFK', mean(arr_delay, na.rm = TRUE), by = dest][which.min(V1)]

##  plot the average delay to all destinations from JFK
ggplot(flights[origin == 'JFK', .(delay = mean(arr_delay, na.rm = TRUE)), by = dest],
       aes(x = dest, delay)) + geom_bar(stat = 'identity')

##  plot the distribution of all flight delays to all destinations from JFK
ggplot(flights[origin == 'JFK'], aes(x = dest, arr_delay)) + geom_boxplot()

##  compute a new variable in flights showing the week of day
flights[, weekday := weekdays(as.Date(paste(year, month, day, sep = '-')))]

##  plot the number of flights per weekday
ggplot(flights, aes(weekday)) + geom_bar()

##  create a heatmap on the number of flights per weekday and hour of the day (see `geom_tile`)
ggplot(flights[, .N, by = .(weekday, hour)], aes(weekday, hour, fill = N)) + geom_tile()

##  merge the `airports` dataset to `flights` on the FAA airport code
merge(flights, airports, by.x = 'dest', by.y = 'faa', all.x = TRUE)

setkey(flights, dest)
setkey(airports, faa)
airports[flights]

##  order the `weather` dataset by `year`, `month`, `day` and `hour`
weather <- data.table(nycflights13::weather)
setorder(weather, year, month, day, hour)

##  plot the average temperature at noon in `EWR` for each month based on the `weather` dataset
ggplot(weather[origin == 'EWR' & hour == 12, mean(temp), by = month],
       aes(factor(month), V1)) + geom_bar(stat = 'identity')

##  aggregate the `weather` dataset and store as `daily_temperatures` to show the daily average temperatures based on the `EWR` records
daily_temperatures <- weather[, .(avg_temp = mean(temp)), by = .(year, month, day)]

##  merge the `daily_temperatures` dataset to `flights` on the date
setkey(daily_temperatures, year, month, day)
setkey(flights, year, month, day)
daily_temperatures[flights]

## #############################################################################
## linear models
## #############################################################################

df <- read.csv('http://bit.ly/BudapestBI-R-csv')
setDT(df)

df[, height := heightIn * 2.54]
df[, weight := weightLb * 0.45]

fit <- lm(weight ~ height, data = df)
summary(fit)
## discuss: coefficients, P values, overall P value, R^2

## diagnose plot
plot(df$height, df$weight)
abline(fit, col = 'red')

plot(df$height, df$weight)
points(df$height, predict(fit), col = 'red', pch = 19)
lines(df$height, predict(fit), col = 'red')

plot(df$height, df$weight)
abline(fit, col = 'red')
segments(df$height, df$weight, df$height, predict(fit), col = 'green', pch = 19)
## http://psycho.unideb.hu/statisztika/pages/interaktiv.html

par(mfrow = c(2, 2))
plot(fit)

qqplot(df$height, df$weight)

## extrapolation -- predict my son
summary(fit)
predict(fit)
predict(fit, newdata = data.frame(height = 104))
predict(fit, newdata = data.frame(height = 56))

plot(df$height, df$weight, xlim = c(0, 200))
abline(fit, col = 'red')

plot(df$height, df$weight, xlim = c(0, 200), ylim = c(-100, 100))
abline(fit, col = 'red')

## polynomial model
fit <- lm(weight ~ height + height * height, data = df)   # not OK
fit

## use the "I" function to refer to height-squared "as is"
fit <- lm(weight ~ height + I(height^2), data = df)
fit <- lm(weight ~ poly(height, 2, raw = TRUE), data = df)

## compute manually
x <- 56
-7.79 + x * 0.004275 + (x^2) * 0.002161

## TODO plot and analyze association between height and weight
plot(df$height, df$weight)

## plot polynomial model
x <- 130:180
y <- predict(fit, newdata = data.frame(height = 130:180))
lines(x, y, col = 'red')

x <- 0:200
y <- predict(fit, newdata = data.frame(height = x))
plot(df$height, df$weight, xlim = range(x))
plot(df$height, df$weight, xlim = range(x), ylim = c(0, 200))
lines(x, y, col = 'red')

## TODO plot a polynomial model of higher degree
fit <- lm(weight ~ poly(height, 5, raw = TRUE), data = df)

y <- predict(fit, newdata = data.frame(height = x))
plot(df$height, df$weight, xlim = range(x), ylim = c(0, 200))
lines(x, y, col = 'red')

## same with ggplot2
ggplot(df, aes(x = height, y = weight)) + geom_point() +
    geom_smooth(method = 'lm', se = FALSE)
ggplot(df, aes(x = height, y = weight)) + geom_point() +
    geom_smooth(method = 'lm', formula = y ~ poly(x, 5))

## #############################################################################
## confounding variables
## #############################################################################

df <- read.csv('http://bit.ly/math_and_shoes')
df$id <- NULL

plot(df$size, df$math)
summary(lm(math ~ size, df))

plot(df$x, df$math)
plot(df$x, df$size)

## 3D scatterplot with plane
library(scatterplot3d)
p <- scatterplot3d(df[, c('size', 'x', 'math')])
fit <- lm(math ~ size + x, df)
p$plane3d(fit)

## interactive 3D scatterplot with plane
library(rgl)
plot3d(df$x, df$size, df$math, col = 'red', size = 3)
planes3d(5.561, 4.563, -1, -178.496, col = 'orange')

cor(df)

## computing partial correlation
residuals(lm(math ~ x, df))
residuals(lm(size ~ x, df))
cor(residuals(lm(math ~ x, df)), residuals(lm(size ~ x, df)))

library(psych)
partial.r(df, 1:2, 3)

## #############################################################################
## feature selection
## #############################################################################

## TODO analyze iris dataset
str(iris)
plot(iris$Sepal.Length, iris$Sepal.Width)

fit <- lm(Sepal.Width ~ Sepal.Length, data = iris)
fit
summary(fit)

## now try
plot(iris$Sepal.Length, iris$Sepal.Width, col = iris$Species)
summary(lm(Sepal.Width ~ Sepal.Length + Species, data = iris))

ggplot(iris, aes(Sepal.Length, Sepal.Width, col = Species)) +
    geom_point() + geom_smooth(method = 'lm')

ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
    geom_point(aes(col = Species)) +
        geom_smooth(aes(col = Species), method = 'lm') +
            geom_smooth(method = 'lm', col = 'black')

## #############################################################################
## clustering
## #############################################################################

## hierarchical method
dm <- dist(iris[, 1:4])
str(dm)
summary(dm)

hc <- hclust(dm)

plot(hc)

rect.hclust(hc, k = 3, border = 'red')

cn <- cutree(hc, k = 3)
plot(iris$Sepal.Length, iris$Sepal.Width, col = cn)
plot(iris$Sepal.Length, iris$Sepal.Width, pch = cn, col = iris$Species)

library(cluster)
clusplot(iris[, 1:4], cn, color = TRUE, shade = TRUE, labels = 2)

table(iris$Species, cn)

## how many clusters?
library(NbClust)
NbClust(iris[, 1:4], method = 'complete')

## k-means
kc <- kmeans(iris[, 1:4], 3)
str(kc)
kc$cluster

table(kc$cluster, cn)
table(iris$Species, kc$cluster)

## #############################################################################
## introduction to supervised classification methods
## #############################################################################

## K-Nearest Neighbors algorithm
setDT(iris)
iris[, rnd := runif(150)]
setorder(iris, rnd)
iris
iris[, rnd := NULL]

train <- iris[1:100]
test  <- iris[101:150]

library(class)
knn(train[, 1:4, with = FALSE], test[, 1:4, with = FALSE], train$Species)

res <- knn(train[, 1:4, with = FALSE], test[, 1:4, with = FALSE], train$Species)
table(test$Species, res)

res <- knn(train[, 1:4, with = FALSE], test[, 1:4, with = FALSE], train$Species, k = 2)
table(test$Species, res)

## decision trees for classification
library(rpart)
ct <- rpart(Species ~ ., data = train)
summary(ct)

plot(ct); text(ct)

predict(ct, newdata = test)
predict(ct, newdata = test, type = 'class')

table(test$Species, predict(ct, newdata = test, type = 'class'))

## ?rpart.control
ct <- rpart(Species ~ ., data = train, minsplit = 3)
plot(ct); text(ct)

## #############################################################################
## exercises
## #############################################################################

## TODO model gender from the height/weight dataset
df <- read.csv('http://bit.ly/BudapestBI-R-csv')
ct <- rpart(sex ~ heightIn + weightLb, data = df)
plot(ct); text(ct)

ct <- rpart(sex ~ heightIn + weightLb, data = df, minsplit = 1)
table(df$sex, predict(ct, type = 'class'))

## #############################################################################
## beware of overfitting: did you use test data?
## #############################################################################

## reorder data in random order
set.seed(7)
df <- df[order(runif(nrow(df))), ]

## create training and test datasets
train <- df[1:100, ]
test  <- df[101:237, ]

## pretty impressing results!
ct <- rpart(sex ~ heightIn + weightLb, data = train, minsplit = 1)
table(train$sex, predict(ct, type = 'class'))

## but oops
table(test$sex, predict(ct, newdata = test, type = 'class'))

## with a more generalized model
ct <- rpart(sex ~ heightIn + weightLb, data = train)
table(train$sex, predict(ct, type = 'class'))
table(test$sex, predict(ct, newdata = test, type = 'class'))

## #############################################################################
## other decision tree algorithms in R
## #############################################################################

## a uniform interface to ML models
library(caret)
tree <- train(sex ~ heightIn + weightLb, data = train, method = 'rpart')
summary(tree)

names(getModelInfo())

train(sex ~ heightIn + weightLb, data = train, method = 'ctree')

library(C50)
tree <- train(sex ~ heightIn + weightLb, data = train, method = 'C5.0')
summary(tree)

## #############################################################################
## PCA
## #############################################################################

setDF(iris)
prcomp(iris[, 1:4])
summary(prcomp(iris[, 1:4]))

pc <- prcomp(iris[, 1:4], scale = TRUE)

iris$pc1 <- pc$x[, 1]

cutree(hclust(dist(iris$pc1)), 3)

table(iris$Species, cutree(hclust(dist(iris$pc1)), 3))

## #############################################################################
## MDS
## #############################################################################

eurodist

cmdscale(eurodist)

m <- cmdscale(eurodist)
plot(m)

plot(m, type = 'n')
text(m[, 1], m[, 2], labels(eurodist))

m <- as.data.frame(m)
ggplot(m, aes(V1, -V2, label = rownames(m))) + geom_text()

library(ggrepel)
ggplot(m, aes(V1, -V2, label = rownames(m))) + geom_text_repel()
