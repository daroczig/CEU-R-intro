## #############################################################################
## reminder on data frames and pricey hotels
## #############################################################################

hotels <- read.csv('http://bit.ly/CEU-R-hotels-2018-prices')

## TODO list the most expensive hotel reservation
max(hotels$price)
hotels[which.max(hotels$price), ]
hotels[hotels$price == max(hotels$price), ]

## TODO list all hotel reservations > 10,000 EUR
pricey <- which(hotels$price > 10000)
hotels[pricey, ]

## TODO look up the related hotels
features <- read.csv('http://bit.ly/CEU-R-hotels-2018-features')
str(features)

features[features$hotel_id == 10921, ]
mean(features$rating, na.rm = TRUE)

## TODO let's drop all rows where there is no hotel_id
?is.na
which(is.na(features$hotel_id))
features <- features[-1, ]

features <- features[!is.na(features$hotel_id), ]

features[features$hotel_id == 10921, ]
features[features$hotel_id == 14797, ]

## TODO finding the cheapest 4 star hotel with 4.5+ rating
fourstarhotels <- features[features$stars == 4, ]
fourstarhotelswithgoodrating <- fourstarhotels[fourstarhotels$rating >= 4.5, ]
str(fourstarhotelswithgoodrating)
w <- fourstarhotelswithgoodrating$hotel_id
fourstarhotelbookings <- hotels[hotels$hotel_id %in% w, ]
which.min(fourstarhotelbookings$price)
fourstarhotelbookings[2660, ]

## TODO find the best rating hotel below 10,000 Hungarian Forints
cheapids <- hotels[hotels$price * 320 < 10000, 'hotel_id']

hotels$price_HUF <- hotels$price * 320
cheapids <- hotels[hotels$price_HUF < 10000, 'hotel_id']

str(cheapids)

cheapids <- unique(cheapids)

cheaphotels <- features[features$hotel_id %in% cheapids, ]
max(cheaphotels$rating, na.rm = TRUE)
cheaphotels[!is.na(cheaphotels$rating) & cheaphotels$rating == 5, ]

?subset

## #############################################################################
## intro into data.table
## #############################################################################

## intro to data.table
## intro to dplyr

## cheatsheet: https://s3.amazonaws.com/assets.datacamp.com/blog_assets/datatable_Cheat_Sheet_R.pdf

install.packages('data.table')
library(data.table)

str(hotels)
hotels <- data.table(hotels)
str(hotels)
hotels

hotels[1]

?fread

bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
features <- fread('http://bit.ly/CEU-R-hotels-2018-features')
rm(hotels)
hotels
str(bookings)

## dt[i]
bookings[1]
bookings[1:5]
bookings[price < 100]
bookings[offer == 0 & price < 100]
bookings[price < 100 & offer == 0 & nnights == 4 & holiday == 1]

## dt[i, j]
bookings[price < 100, .N]
bookings[price < 100, mean(price)]
bookings[price < 100, summary(price)]
bookings[price < 100, hist(price)]

## TODO compute the average price of bookings on weekends
## TODO compute the average price of bookings on weekdays
bookings[weekend == 1, mean(price)]
bookings[weekend == 0, mean(price)]
bookings[, mean(price), by = weekend]
bookings[, mean(price), by = weekend][order(weekend)] ## dt[i]
?setorder

str(bookings)
bookings[, mean(price), by = list(weekend, nnights)]
bookings[, mean(price), by = .(weekend, nnights, holiday, year)]

bookings[, .(price = mean(price)), by = .(weekend, nnights, holiday, year)]

bookings[, .(price = mean(price), .N), by = .(weekend, nnights, holiday, year)]
bookings[, .(price = mean(price), .N, min = min(price), max = max(price)),
         by = .(weekend, nnights, holiday, year)]

## TODO compute the average price per number of stars
?merge
## x[y] -> rolling joins, overlap joins
unique(bookings, by = c('hotel_id'))
bookings[, .(price = mean(price)), by = hotel_id] ## group by
merge(features, unique(bookings, by = 'hotel_id'), by = 'hotel_id')

booking_summary <- bookings[, .(price = mean(price)), by = hotel_id]
hotels <- merge(features, booking_summary, by = 'hotel_id')
hotels[, mean(price), by = stars] # weighted mean
