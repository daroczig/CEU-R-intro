## #############################################################################
## PCA demo on image processing: http://bit.ly/CEU-R-PCA
## #############################################################################

library(jpeg)

## download the image to the current working directory
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
## H2O
## #############################################################################
## install H2O and while we wait: http://bit.ly/CEU-R-boosting

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
## mean of flight number? go to the H2O web interface to fix this

## convert numeric to factor/enum
hflights.hex[, 'FlightNum'] <- as.factor(hflights.hex[, 'FlightNum'])
summary(hflights.hex)

## fix multiple features in a loop
for (v in c('Month', 'DayofMonth', 'DayOfWeek', 'DepTime', 'ArrTime')) {
    hflights.hex[, v] <- as.factor(hflights.hex[, v])
}
summary(hflights.hex)

## feature engineering: departure time => hour of the day
library(data.table)
hflights <- data.table(hflights)
hflights[, hour := substr(DepTime, 1, 2)]
hflights[, .N, by = hour] # not OK

hflights[, hour := substr(DepTime, 1, nchar(DepTime) - 2)]
hflights[, hour := cut(as.numeric(hour), seq(0, 24, 4))]
hflights[, .N, by = hour]
hflights[is.na(hour)]

## unfortunately, this is not that useful,
## as hour is missing for all canceled flights
hflights[, .N, by = .(is.na(hour), Cancelled == 1)]

## drop columns
hflights <- hflights[, .(Month, DayofMonth, DayOfWeek, Dest, Origin,
                         UniqueCarrier, FlightNum, TailNum, Distance)]

## re-upload to H2O
h2o.ls()
h2o.rm('hflights')
write.csv(hflights, 'hflights.csv', row.names = FALSE)
hflights.hex <- h2o.uploadFile('hflights.csv', destination_frame = 'hflights')

## split the data into training and test datasets
h2o.splitFrame(data = hflights.hex , ratios = 0.75)
h2o.ls()

## build the first model
hflights.rf <- h2o.randomForest(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1')
hflights.rf

## Cancelled was an integer: a regression model instead of classification
hflights.hex[, 'Cancelled'] <- as.factor(hflights.hex[, 'Cancelled'])
h2o.splitFrame(data = hflights.hex , ratios = 0.75)

## rerun model
hflights.rf <- h2o.randomForest(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1')
hflights.rf

## improve model by creating more trees
hflights.rf <- h2o.randomForest(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1', ntrees = 500)
hflights.rf

## GBM
hflights.gbm <- h2o.gbm(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1',
    model_id = 'hflights_gbm')
hflights.gbm

## more trees should help again, right?
hflights.gbm <- h2o.gbm(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1',
    model_id = 'hflights_gbm2', ntrees = 250)
hflights.gbm
## but no: although the training AUC is higher, the validation AUC is lower => overfit

## cut back the trees
hflights.gbm <- h2o.gbm(
    x = setdiff(names(hflights), 'Cancelled'),
    y = 'Cancelled',
    training_frame = 'hflights_part0',
    validation_frame = 'hflights_part1',
    model_id = 'hflights_gbm2', ntrees = 250, learn_rate = 0.01)
hflights.gbm

## bye
h2o.shutdown()
