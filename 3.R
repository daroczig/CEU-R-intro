## #############################################################################
## data.table and ggplot2 exercises from the last week
## #############################################################################

## * Visualize the below variables from the `mtcars` dataset with `ggplot2`:
##     * number of carburetors
library(ggplot2)
ggplot(mtcars, aes(carb)) + geom_bar()

##     * horsepower
ggplot(mtcars, aes(carb)) + geom_histogram(binwidth = 2)

##     * barplot on the number of carburetors per transmission
ggplot(mtcars, aes(carb)) + geom_bar() + facet_wrap(~am)

##     * boxplot on the horsepower by the number of carburetors
ggplot(mtcars, aes(factor(carb), hp)) + geom_boxplot()

##     * horsepower and weight by the number of carburetors
ggplot(mtcars, aes(hp, wt, color = factor(carb))) + geom_point()

##     * horsepower and weight by the number of carburetors with a trend line
ggplot(mtcars, aes(hp, wt, color = factor(carb))) + geom_point() + geom_smooth()

## * `data.table` exercises using the  `hflights` dataset:
library(data.table)
library(hflights)
dt <- data.table(hflights)

##     * compute the number of cancelled flights
dt[Cancelled == 1, .N]

##     * compute the shortest flight on each weekday
dt[, min(Distance), by = DayOfWeek]
dt[, min(Distance), by = DayOfWeek][order(DayOfWeek)]

##     * compute the average delay to all destination
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Dest]
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Dest][order(delay)]

##     * compute the average delay to all destination per origin
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Origin]

##     * plot the average departure and arrival delays per destination
dta <- dt[, .(departure = mean(DepDelay, na.rm = TRUE),
              arrival = mean(ArrDelay, na.rm = TRUE)), by = Dest]
ggplot(dta, aes(departure, arrival, label = Dest)) + geom_text()

##     * plot the percentage of cancelled flights per destination
dta <- dt[, .(p = sum(Cancelled) / .N), by = Dest]
library(scales)
ggplot(dta, aes(Dest, p)) + geom_bar(stat = 'identity') + scale_y_continuous(label = percent)
setorder(dta, p)
dta[, Dest := factor(Dest, levels = dta$Dest)]
ggplot(dta, aes(Dest, p)) + geom_bar(stat = 'identity') +
  scale_y_continuous(label = percent) +
  theme(axis.text.x = element_text(angle = 45,))

## * Further exercises on the `nycflights13` dataset:
library(nycflights13)

## 	* count the number of flights to LAX
flights <- data.table(nycflights13::flights)
flights[dest == 'LAX', .N]

## 	* count the number of flights to LAX from JFK
flights[dest == 'LAX' & origin == 'JFK', .N]

## 	* compute the average delay (in minutes) for flights from JFK to LAX
flights[dest == 'LAX' & origin == 'JFK', mean(arr_delay, na.rm = TRUE)]

## 	* which destination has the lowest average delay from JFK?
dta <- flights[origin == 'JFK', .(delay = mean(arr_delay, na.rm = TRUE)), by = dest]
setorder(dta, delay)
head(dta)
dta[1]

## 	* plot the average delay to all destinations from JFK
ggplot(dta, aes(dest, delay)) + geom_bar(stat = 'identity')

## 	* plot the distribution of all flight delays to all destinations from JFK
ggplot(flights[origin == 'JFK'], aes(dest, arr_delay)) +
  geom_boxplot() +
  geom_jitter(size = 0.5, color = 'orange', alpha = .5)

## 	* compute a new variable in flights showing the week of day
flights[, weekday := weekdays(ISOdate(year, month, day))]

## 	* plot the number of flights per weekday
ggplot(flights[, .N, by = weekday], aes(weekday, N)) + geom_bar(stat = 'identity')

## 	* create a heatmap on the number of flights per weekday and hour of the day
ggplot(flights[, .N, by = .(weekday, hour)], aes(hour, weekday, fill = N)) + geom_tile()

## 	* plot the average temperature at noon in `EWR` for each month based on the `weather` dataset
dt <- data.table(weather)
ggplot(dt[origin == 'EWR', .(temp = mean(temp, na.rm = TRUE)), by = month], aes(month, temp)) +
  geom_bar(stat = 'identity')

## #############################################################################
## linear models
## #############################################################################

df <- read.csv('http://bit.ly/BudapestBI-R-csv')
setDT(df)

df[, height := heightIn * 2.54]
df[, weight := weightLb * 0.45]

fit <- lm(weight ~ height, data = df)
summary(fit)
## coefficients, P values, overall P value, R^2
## how close the data are to the fitted regression line OR explained variance of the model

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

## extrapoliation -- predict the weight of my son
summary(fit)

-59.8460 + 0.6764 * 104

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

?I
fit <- lm(weight ~ height + I(height^2), data = df)
fit <- lm(weight ~ poly(height, 2, raw = TRUE), data = df)

predict(fit, newdata = data.frame(height = 56))

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
ggplot(df, aes(x = height, y = weight)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
ggplot(df, aes(x = height, y = weight)) + geom_point() + geom_smooth(method = 'lm', formula = y ~ poly(x, 5))

## #############################################################################
## confounding variables
## #############################################################################

library(foreign)
download.file('http://bit.ly/math_and_shoes', 'math.csv', method = 'curl', extra = '-L')
df <- read.csv('math.csv')
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

residuals(lm(math ~ x, df))
residuals(lm(size ~ x, df))
cor(residuals(lm(math ~ x, df)), residuals(lm(size ~ x, df)))

library(psych)
partial.r(df, 1:2, 3)

## #############################################################################
## => feature selection based on domain knowledge or automated
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

##
## B
## R
## E
## A
## K
##

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
iris <- data.table(iris)
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

ct <- rpart(Species ~ ., data = train, minsplit = 3)
## ?rpart.control
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
## did you use test data?
## beware of overfitting
## #############################################################################

## random order
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
## other decision tree algorithms in R (optional)
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



## TODO check H2O install

##
## L
## U
## N
## C
## H
##

## #############################################################################
## PCA demo on image processing                       => http://bit.ly/CEU-R-PCA
## #############################################################################

library(jpeg)

## http://www.nasa.gov/images/content/694811main_pia16225-43_full.jpg
## http://bit.ly/BudapestBI-R-img
download.file('http://bit.ly/BudapestBI-R-img', 'image.jpg')
img <- readJPEG('image.jpg')
str(img)
dim(img)

h <- dim(img)[1]
w <- dim(img)[2]

img1d <- matrix(img, h*w)
pca <- prcomp(img1d)
pca
summary(pca)

m <- matrix(pca$x[, 3], h)
str(m)
image(m)

image(matrix(pca$x[, 3], h))
image(matrix(pca$x[, 2], h), col = gray.colors(100))

## #############################################################################
## PCA demo to show the steps in hierarchical clustering
## #############################################################################

PC <- prcomp(iris[, 1:4])$x
dm <- dist(iris[, 1:4])
hc <- hclust(dm)

for (i in 1:8) {
    plot(-PC[, 1:2], col = cutree(hc, i), pch = as.numeric(factor(iris$Species)) + 5)
    Sys.sleep(1)
}

library(animation)
ani.options(interval = 1)
saveGIF({
    for (i in 1:8) {
        plot(-PC[, 1:2], col = cutree(hc, i), pch = as.numeric(factor(iris$Species)) + 5)
    }
})

library(animation)
ani.options(interval = 1)
saveGIF({
    for (i in 2:8) {
        plot(hc)
        rect.hclust(hc, k = i, border = 'red')
    }
})

## #############################################################################
## TODO complex exercise: PCA on iris + hclust => compare with species
##      to demonstrate how this stuff works
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

library(readxl)
download.file('http://www.psoft.hu/letoltes/psoft/psoft-telepules-matrix-30000.xls', 'cities.xls')
cities <- read_excel('cities.xls')

## clean up Excel
cities <- cities[-nrow(cities), -1]

## this is a distance matrix, let R know that
citynames <- names(cities)
cities <- as.dist(cities)

mds <- cmdscale(cities)
plot(mds)
text(mds[, 1], mds[, 2], citynames)

mds <- -mds
plot(mds)
text(mds[, 1], mds[, 2], citynames)

## let's see how it works on some real live data
mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))

mds <- as.data.frame(mds)
library(ggplot2)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) + geom_text()

library(ggrepel)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) + geom_text_repel() + theme_bw()

TODO install H2O

##
## B
## R
## E
## A
## K
##

## #############################################################################
## H2O            => install H2O and while we wait: http://bit.ly/CEU-R-boosting
## #############################################################################
## first real analysis -> write a script

## start and connect to H2O
library(h2o)
h2o.init()

## write demo data to disk
library(hflights)
write.csv(hflights, 'hflights.csv', row.names = FALSE)
hflights.hex <- h2o.uploadFile('hflights.csv', destination_frame = 'hflights')
str(hflights.hex)
head(hflights.hex)
head(hflights.hex, 3)
summary(hflights.hex)
## flight number????
## go to H2O web interface at http://127.0.0.1:54321

## convert numeric to factor/enum
hflights.hex[, 'FlightNum'] <- as.factor(hflights.hex[, 'FlightNum'])
summary(hflights.hex)

## boring
hflights.hex$FlightNum <- as.factor(hflights.hex$FlightNum)
for (v in c('Month', 'DayofMonth', 'DayOfWeek', 'DepTime', 'ArrTime')) {
    hflights.hex[, v] <- as.factor(hflights.hex[, v])
}
summary(hflights.hex)

## feature engineering: departure time? is it OK? hour of the day?
## redo everything... just use the R script
library(data.table)
dt <- data.table(hflights)
dt[, hour := substr(DepTime, 1, 2)]
dt[, .N, by = hour]

dt[, hour := substr(DepTime, 1, nchar(DepTime) - 2)]
dt[, hour := cut(as.numeric(hour), seq(0, 24, 4))]
dt[, .N, by = hour]
dt[is.na(hour)]

## drop columns
str(dt)
dt <- dt[, .(Month, DayofMonth, DayOfWeek, hour, Dest, Origin,
             UniqueCarrier, FlightNum, TailNum, Distance, Cancelled)]

## transform to factor
for (v in c('Month', 'DayofMonth', 'DayOfWeek', 'hour', 'FlightNum', 'UniqueCarrier')) {
    set(dt, j = v, value = as.factor(dt[, get(v)]))
}
str(dt)

## re-upload to H2O
h2o.ls()
h2o.rm('hflights')
as.h2o(dt, 'hflights')

## split the data
hflights.hex <- h2o.getFrame('hflights')
h2o.splitFrame(data = hflights.hex , ratios = 0.75, destination_frames = c('train', 'test'))
h2o.ls()

## build the first model
hflights.rf <- h2o.randomForest(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test')
hflights.rf
## root mean square error
## R^2
dt[Cancelled == 1, .N, by = hour]

## taking into account the hour doesn't make much sense :S
## + "cancelled" was an integer instead of factor
hflights.hex$hour <- NULL
hflights.hex$Cancelled <- as.factor(hflights.hex$Cancelled)

## split again
h2o.splitFrame(data = hflights.hex , ratios = 0.75, destination_frames = c('train', 'test'))

## rerun model
hflights.rf <- h2o.randomForest(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test')
hflights.rf
## trying to minimize logloss -- in the test based on the train dataset

## more trees
hflights.rf <- h2o.randomForest(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test',
    ntrees = 500)

## GBM
hflights.gbm <- h2o.gbm(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test',
    model_id = 'hflights_gbm')

## more trees should help, again !!!
hflights.gbm <- h2o.gbm(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test',
    model_id = 'hflights_gbm2', ntrees = 500)
## but no: although higher training AUC, lower validation AUC => overfit

## cut back those trees
hflights.gbm <- h2o.gbm(
    x = names(dt),
    y = 'Cancelled',
    training_frame = 'train',
    validation_frame = 'test',
    model_id = 'hflights_gbm2', ntrees = 250, learn_rate = 0.01)

##http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/gbm-faq/tuning_a_gbm.html

## bye
h2o.shutdown()



## TODO check GitHub on Windows
