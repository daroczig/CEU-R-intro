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
## more data.table examples
## #############################################################################

library(data.table)
?fread # VS read.csv

bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
str(bookings)
bookings

## TODO count the number of bookings below 100 EUR
bookings[price < 100, .N]
## TODO count the number of bookings below 100 EUR without an offer
bookings[offer == 0 & price < 100, .N]

## TODO compute the average price of the bookings below 100 EUR
bookings[price < 100, mean(price)]

## TODO compute the average price of bookings on weekends
bookings[weekend == 1, mean(price)]
## TODO compute the average price of bookings on weekdays
bookings[weekend == 0, mean(price)]

bookings[, mean(price), by = weekend] # dt[, j, by]
bookings[, mean(price), by = weekend][order(weekend)] # dt[, j, by][i]
?setorder

## TODO include nnights, holiday and year as well in the aggregate variables
bookings[, mean(price), by = .(weekend, nnights, holiday, year)]

## TODO compute the average price per number of stars
?merge
## x[y] -> rolling joins, overlap joins

features <- fread('http://bit.ly/CEU-R-hotels-2018-features')
merge(bookings, features)

## NOTE hotel_id was picked as the join key
bookings[hotel_id == 1]
features[hotel_id == 1]
merge(bookings, features)[hotel_id == 1]

## NOTE there's a missing row??
bookings[, .N]
merge(bookings, features)[, .N]

features[is.na(hotel_id)]
bookings[!hotel_id %in% features$hotel_id]
features[hotel_id == 2]

## NOTE do we really need to merge features to all bookings??
booking_summary <- bookings[, .(price = mean(price)), by = hotel_id]
hotels <- merge(features, booking_summary, by = 'hotel_id')
hotels[, mean(price), by = stars][order(stars)]

## hm ... 4.5 stars more expensive than 5 stars?
## probably only a few cases with 4.5 stars ...
hotels[, .(price = mean(price), .N), by = stars][order(stars)]
hotels[, .(price = mean(price), bookings = .N), by = stars][order(stars)]
## seems like there are quote a few 4.5 star hotels .. then what?

## should we divide price per nnights?
bookings[hotel_id == 2]

booking_summary <- bookings[, .(bookings = .N, price = mean(price/ nnights)), by = hotel_id]
hotels <- merge(features, booking_summary, by = 'hotel_id')
hotels[, .(bookings = sum(bookings), price = mean(price)), by = stars][order(stars)]

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
## note missing x axis labels (e.g. 4.5 stars)
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
## modeling
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
points <- data.frame(x = rep(1:100, 100), y = rep(1:100, each = 100))
points$col <- 'white'
points$col[sqrt(rowSums((points[, 1:2] - c(50, 50))^2)) < 10] <- 'red'

## data.table approach
points <- data.table(x = rep(1:100, 100), y = rep(1:100, each = 100))
points[, col := 'white']

## small red dot in the middle
points[x == 50 & y == 50, col := 'red']

## let's make that a bit larger circle :)
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
