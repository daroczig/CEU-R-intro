## #############################################################################
## antipatterns
## #############################################################################

## how to list programatically objects from RStudio IDE's environment tab?
ls()

## clean your R session from past objects ...
## and the set RStudio to never save your session again
rm(list = ls())

## running an R script from a trusted source
## NOTE never do this again!
source('http://bit.ly/CEU-R-heights-2018')
ls()
heights

## TODO compute the average height of this group
mean(heights, na.rm = TRUE)
## TODO visualize the data
library(ggplot2)
ggplot(data.frame(heights), aes(heights)) + geom_histogram()
ggplot(data.frame(heights), aes(heights)) + geom_boxplot()

## had enough .. let's clean up the session
rm(list = ls())

## but wow:
ls(all = TRUE)
.secret # "A warm hello from the Internet."

## learnings: don't `source` from the Internet, and don't rm(list = list())
## https://twitter.com/hadleywickham/status/940021008764846080

## #############################################################################
## creating new variables: numeric
## #############################################################################

library(data.table)
bookings <- fread("http://bit.ly/CEU-R-hotels-2018-prices")
features <- fread("http://bit.ly/CEU-R-hotels-2018-features")

## TODO count the number of bookings in Austria!
## NOTE need to merge first!
merge(bookings, features)[country == 'Austria', .N]

## TODO which hotel is the cheapest in Vienna within 1 km distance of the city central?
## NOTE need to merge, compute price per night, aggregate, order and filter data!
dt <- merge(bookings, features)
dt[city_actual == 'Vienna' & distance < 1][, list(price = mean(price/nnights)), by = hotel_id][order(price)][1, hotel_id]
dt[city_actual == 'Vienna' & distance < 1][, list(price = mean(price/nnights)), by = hotel_id][which.min(price), hotel_id]
dt[city_actual == 'Vienna' & distance < 1][, list(price = mean(price/nnights)), by = hotel_id][price == min(price), hotel_id]

## new variable via the data.frame way
dt$price_per_night <- dt$price / dt$nnights
## new variable via data.table's in-place update operator
dt[, price_per_night := price / nnights]

## TODO create a new dataset on hotels (aka features) that includes
##      the number of bookings and avg price per night
hotels <- merge(
  features,
  dt[, .(bookings = .N, price_per_night = mean(price_per_night)), by = hotel_id],
  by = 'hotel_id')

## TODO compute average price per number of stars
hotels[, mean(price_per_night), by = stars]
hotels[, mean(price_per_night), by = stars][order(stars)]
## drop NAs
hotels[!is.na(stars), mean(price_per_night), by = stars][order(stars)]
hotels[!is.na(stars), .(price = mean(price_per_night)), by = stars][order(stars)]
## NOTE we have not weighted ...
hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)]

## let's plot this
agg <- hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)]
ggplot(agg, aes(stars, rating)) + geom_col()
ggplot(agg, aes(factor(stars), rating)) + geom_col()

## split by country!
agg <- hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = .(stars, country)]
ggplot(agg, aes(factor(stars), rating)) + geom_col() + facet_wrap(~country)

## what if we don't want to use the same scale?
ggplot(agg, aes(factor(stars), rating)) + geom_col() + facet_wrap(~country, scales = "free")

## TODO list countries above average rating
countries <- hotels[, .(
    price = mean(price_per_night),
    rating = mean(rating, na.rm = TRUE),
    stars = mean(stars, na.rm = TRUE)
), by = country]
countries[country == 'Austria']

mean(countries$rating, na.rm = TRUE)
countries[rating > mean(rating, na.rm = TRUE)]

## TODO alphabet order
countries[rating > mean(rating, na.rm = TRUE)][order(country)]

## #############################################################################
## creating new variables: numeric to factor
## #############################################################################

## TODO add a new column to hotels: categorize price into 3 buckets
?cut
hotels[, pricecat := cut(price_per_night, 3, dig.lab = 8)]
str(hotels)
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_per_night, c(0, 100, 250, Inf))]
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_per_night, c(0, 100, 250, Inf),
                         labels = c('cheap', 'average', 'expensive'))]
hotels[, .N, by = pricecat]

## TODO use a stats approach to categorize hotels into below avg, avg, above avg price groups
price_mean <- mean(hotels$price_per_night)
price_sd <- sd(hotels$price_per_night)

## NOTE below avg: 0 -> mean - sd
## NOTE avg: mean - sd -> mean + sd
## NOTE above avg: mean + sd

hotels[, pricecat := cut(price_per_night, c(
  0,
  price_mean - price_sd,
  price_mean + price_sd,
  Inf),
  labels = c('below avg', 'avg', 'above avg'))]
hotels[, .N, by = pricecat]
## NOTE skewed distribution & very different by country

## TODO avg and sd by country
hotels[, avg_price_per_country := mean(price_per_night), by = country]
hotels[, sd_price_per_country := sd(price_per_night), by = country]
str(hotels)

hotels[, pricecat := cut(price_per_night, c(
  0,
  avg_price_per_country - sd_price_per_country,
  avg_price_per_country + sd_price_per_country,
  Inf),
  labels = c('below avg', 'avg', 'above avg')),
  by = country]
## OH NOOO!!

hotels[, pricecat := cut(price_per_night, c(
  0,
  avg_price_per_country[1] - sd_price_per_country[1], # NOTE one per group
  avg_price_per_country[1] + sd_price_per_country[1],
  Inf),
  labels = c('below avg', 'avg', 'above avg')),
  by = country]
## OH NOOO!!

## NOTE the above not working due to
hotels[, .N, by = country]
hotels[is.na(sd_price_per_country)]

hotels <- hotels[!is.na(sd_price_per_country)]

hotels[, pricecat := cut(price_per_night, c(
  0,
  avg_price_per_country[1] - sd_price_per_country[1], # NOTE one per group
  avg_price_per_country[1] + sd_price_per_country[1],
  Inf),
  labels = c('below avg', 'avg', 'above avg')),
  by = country]

hotels[, .N, by = pricecat]

## TODO visualize the number of hotels in each category per country
hotels[, .N, by = .(pricecat, country)]
ggplot(hotels[, .N, by = .(pricecat, country)], aes(pricecat, country, fill = N)) + geom_tile()

## TODO looks bad with the 3 categories we made in the last 30 mins .. let's do 10!
hotels[, pricecat := cut(price_per_night, 10, dig.lab = 8)]
ggplot(hotels[, .N, by = .(pricecat, country)], aes(pricecat, country, fill = N)) + geom_tile()

ggplot(hotels[, .N, by = .(country, pricecat)], aes(country, N, fill = pricecat)) + geom_col()
ggplot(hotels[, .N, by = .(country, pricecat)], aes(country, N, fill = pricecat)) + geom_col(position = 'fill')

## TODO still not the best categories .. let's apply a manual one
hotels[, pricecat := cut(price_per_night, c(0, 50, 100, 150, 200, 250, 400, 800, 1500, Inf))]
ggplot(hotels[, .N, by = .(country, pricecat)], aes(country, N, fill = pricecat)) + geom_col(position = 'fill')
## TODO better color palette: https://colorbrewer2.org
ggplot(hotels[, .N, by = .(country, pricecat)], aes(country, N, fill = pricecat)) +
    geom_col(position = 'fill') + scale_fill_brewer(palette = 'Greens')

ggplot(hotels[, .N, by = .(country, pricecat)], aes(country, N, fill = pricecat)) +
    geom_col(position = 'fill') + scale_fill_brewer(palette = 'Greens') + theme_minimal()

## #############################################################################
## FOR FUTURE REFERENCE: creating new variables: numeric to numeric
## #############################################################################

## TODO create a new variable with the count of hotels in the same country
hotels[, hotels_in_country := .N, by = country]

## TODO create a new variable with the count of cities in the same country
hotels[, cities_in_country := length(unique(city_actual)), by = country]

## #############################################################################
## multiple summaries
## #############################################################################

## reminder
hotels[, .(price_avg = mean(price_per_night)), by = city]

## TODO compute the average price, rating and stars per city in a new dataset
hotels[, .(price_avg = mean(price_per_night),
           rating_avg = mean(rating),
           stars_avg = mean(stars)), by = city]

## NOTE we need to remove NAs
hotels[, .(price_avg = mean(price_per_night),
           rating_avg = mean(rating, na.rm = TRUE),
           stars_avg = mean(stars, na.rm = TRUE)), by = city]

## TODO check the same on distance and the number of bookings as well ...
hotels[, lapply(.SD, mean), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]

hotels[, lapply(.SD, mean, na.rm = TRUE), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]

## TODO round up to 2 digits
hotels[, lapply(.SD, function(x) round(mean(x, na.rm = TRUE), 2)), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]

roundmean <- function(x) round(mean(x, na.rm = TRUE), 2)
hotels[, lapply(.SD, roundmean), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]


numcols <- c('price_per_night', 'rating', 'stars', 'distance', 'bookings')
hotels[, lapply(.SD, roundmean), by = city, .SDcols = numcols]

sapply(hotels, is.numeric)
numcols <- which(sapply(hotels, is.numeric))
hotels[, lapply(.SD, roundmean), by = city, .SDcols = numcols]

## #############################################################################
## FOR FUTURE REFERENCE: extra examples on multiple summaries
## #############################################################################

## TODO min, avg, median and max price in EUR per city
hotels[, list(
    min_price = min(price_per_night),
    price_per_night = mean(price_per_night),
    med_price = median(price_per_night),
    max_price = max(price_per_night)
), by = city]

## TODO round it up to EUR
hotels[, list(
    min_price = round(min(price_per_night)),
    price_per_night = round(mean(price_per_night)),
    med_price = round(median(price_per_night)),
    max_price = round(max(price_per_night))
), by = city]

mystats <- function(x) {
    list(
        min = min(x),
        mean = mean(x),
        median = median(x),
        max = max(x))
}
mystats
mystats(1:10)

hotels[, lapply(.SD, mystats), .SDcols = c('price_per_night')]
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = c('price_per_night')]

mystats <- function(x) list(
    min = round(min(x, na.rm = TRUE), 2),
    mean = round(mean(x, na.rm = TRUE), 2),
    median = round(median(x, na.rm = TRUE), 2),
    max = round(max(x, na.rm = TRUE), 2))
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = c('price_per_night', 'rating')]
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = which(sapply(hotels, is.numeric))]
summary(hotels)

hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = which(sapply(hotels, is.numeric)), by = country]

## #############################################################################
## ML
## #############################################################################

library(png)
## TODO search for the flag of Japan
## https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/320px-Flag_of_Japan.svg.png
download.file(
    'https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/320px-Flag_of_Japan.svg.png',
    'flag-jp.png', mode = 'wb')
img <- readPNG('flag-jp.png')
str(img)

## TODO let's rather create this data frame using R! data.frame approach:
## points <- data.frame(x = rep(1:100, 100), y = rep(1:100, each = 100))
## points$col <- 'white'
## points$col[sqrt(rowSums((points[, 1:2] - c(50, 50))^2)) < 10] <- 'red'

## data.table approach
points <- data.table(x = rep(1:100, 100), y = rep(1:100, each = 100))
points[, col := 'white']
points[(x - 50) ^ 2 + (y - 50) ^ 2 < 50, col := 'red']
## or
points[sqrt((x - 50) ^ 2 + (y - 50) ^ 2) < 10, col := 'red']

## number of white and red pixels
points[, .N, by = col]

## visualize it!
plot(points$x, points$y, col = points$col)
plot(points$x, points$y, col = points$col, pch = 19, cex = .5)
image(matrix(points$col == "red", nrow = 100))

## .. using ggplot2
library(ggplot2)
ggplot(points, aes(x, y, color = col)) + geom_point()
ggplot(points, aes(x, y, color = col)) + geom_point() +
    scale_color_manual(values = c("red", "white")) +
    theme_void() + theme(legend.position = 'none')
ggplot(points, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## TODO let's build a model on the color of a pixel based on x and y!

## cannot use lm due to categorical dependent variable
lm(col ~ x + y, data = points)
## logistic?
points$col <- factor(points$col)
fit <- glm(col ~ x + y, data = points, family = binomial(link = logit))
summary(fit)

str(predict(fit, points))
table(predict(fit, points))
## ?predict: The default [type] is on the scale of the linear predictors;
## the alternative ‘"response"’ is on the scale of the response variable.
str(predict(fit, points, type = 'response'))
table(predict(fit, points, type = 'response'))
points$pred <- predict(fit, points, type = 'response')
str(points)

ggplot(points, aes(x, y, fill = pred)) + geom_tile()
image(matrix(points$pred, nrow = 100))

## let's try feature engineering
points$x2 <- abs(50 - points$x)
points$y2 <- abs(50 - points$y)
fit <- glm(col ~ x2 + y2, data = points, family = binomial(link = 'logit'))
summary(fit)

points$pred <- predict(fit, points, type = 'response')
ggplot(points, aes(x, y, fill = pred)) + geom_tile()

## categorize to 2 colors
points$pred <- factor(round(predict(fit, points, type = 'response')))
ggplot(points, aes(x, y, fill = pred)) + geom_tile()

ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## better features!
points$x2 <- (50 - points$x)^2
points$y2 <- (50 - points$y)^2
fit <- glm(col ~ x2 + y2, data = points, family = binomial(link = 'logit'))
summary(fit)

points$pred <- factor(round(predict(fit, points, type = 'response')))
ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## let's try something without feature engineering
library(rpart)
fit <- rpart(col ~ x + y, points)
fit

plot(fit)
text(fit)

library(partykit)
plot(as.party(fit))

points$pred <- predict(fit, points, type = "response") # note error
points$pred <- predict(fit, points, type = "class")
ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## overlay actual on predicted
ggplot(points, aes(x, y)) +
    geom_tile(aes(fill = col)) +
    geom_tile(aes(fill = pred), alpha = .25) +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## TODO how to improve?
?rpart
?rpart.control

## stub
fit <- rpart(col ~ x + y, points, maxdepth = 1)
points$pred <- predict(fit, points, type = "class")
ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))
## what happened?
fit
plot(as.party(fit))

fit <- rpart(col ~ x + y, points, control = rpart.control(cp = 0, minsplit = 1))
points$pred <- predict(fit, points, type = "class")
ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

fit
plot(as.party(fit))
## "nicely" overfitted model!

## now what was that partykit?
library(party)
fit <- ctree(col ~ x + y, data = points)
?ctree
?ctree_control

plot(fit) # all white

## let's check random forest
library(randomForest)

fit <- randomForest(col ~ x + y, data = points)
fit

points$pred <- predict(fit, points, type = "class")
ggplot(points, aes(x, y, fill = pred)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white"))

## TODO confusion matrix manually
points[, .N, by = .(col, pred)]

## reshape: long to wide
cm <- points[, .N, by = .(col, pred)]
dcast(cm, col ~ pred)
dcast(cm, col ~ pred, fill = 0)

## TODO look into h2o!
