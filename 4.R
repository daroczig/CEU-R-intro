## #############################################################################
## recap on summaries
## #############################################################################

library(data.table)
bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
features <- fread('http://bit.ly/CEU-R-hotels-2018-features')

## TODO count the number of 4 stars hotels in Hungary
features[stars == 4 & country == 'Hungary', .N]
nrow(features[stars == 4 & country == 'Hungary'])

## TODO compute the average rating of 4 and 5 star hotels in Hungary and Germany
features[stars >= 4 & country %in% c('Hungary', 'Germany'), mean(rating, na.rm = TRUE)]
features[stars >= 4 & country %in% c('Hungary', 'Germany') & !is.na(rating), mean(rating)]

## TODO round up the average rating to 2 digits
features[stars >= 4 & country %in% c('Hungary', 'Germany') & !is.na(rating), round(mean(rating), 2)]

## TODO do we have any bookings in unknown hotels (as per the features dataset)?
bookings[!hotel_id %in% unique(features$hotel_id)]
features

## TODO clean up the bookings dataset from bookings from unknown hotels
bookings <- bookings[hotel_id %in% unique(features$hotel_id)]

## TODO what's the average distance of hotels from the city central in Budapest
features[city_actual == 'Budapest', mean(distance)]

## TODO list all neighbourhoods in Budapest
features[city_actual == 'Budapest', unique(neighbourhood)]
features[city_actual == 'Budapest', mean(distance), by = neighbourhood][, neighbourhood]

## TODO compute the average distance from the city center for the neighbourhoods in Budapest
features[city_actual == 'Budapest', mean(distance), by = neighbourhood]

## #############################################################################
## recap on summaries and merging
## #############################################################################

## TODO create a new dataset on Hungarian bookings
hunbookings <- bookings[country == 'Hungary']
## NOTE not found

features[, .(hotel_id, country)]
hunbookings <- merge(bookings, features[, .(hotel_id, country)],
                     by = 'hotel_id')[country == 'Hungary']

## NOTE remove helper variable
hunbookings$country <- NULL
hunbookings[, country := NULL]
## NOTE without helper variable
hunbookings <- bookings[hotel_id %in% features[country == 'Hungary', hotel_id]]

## TODO create a new (potentially joined) dataset with all the features +
##      number of bookings + avg price per night of hotels
?data.table::merge
str(features)
str(bookings)

## new variable via the data.frame way
bookings$price_per_night <- bookings$price / bookings$nnights
## new variable via data.table's in-place update operator
bookings[, price_per_night := price / nnights]

hotels <- merge(
  features,
  bookings[, .(bookings = .N, price_per_night = mean(price_per_night)), by = hotel_id],
  by = 'hotel_id')

## TODO compute average price per number of stars
hotels[, mean(price_per_night), by = stars]
hotels[, mean(price_per_night), by = stars][order(stars)]
hotels[!is.na(stars), mean(price_per_night), by = stars][order(stars)]
hotels[!is.na(stars), .(rating = mean(price_per_night)), by = stars][order(stars)]
## NOTE we have not weighted ...
hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)]

plot(hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)])

## TODO list countries above average rating
countries <- hotels[, .(
    price = mean(price_per_night),
    rating = mean(rating, na.rm = TRUE),
    stars = mean(stars, na.rm = TRUE)
), by = country]
countries[country == 'Hungary']

mean(countries$rating, na.rm = TRUE)
countries[rating > mean(rating, na.rm = TRUE)]

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
  price_mean - price_sd ,
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
  avg_price_per_country[1] - sd_price_per_country[1],
  avg_price_per_country[1] + sd_price_per_country[1],
  Inf),
  labels = c('below avg', 'avg', 'above avg')),
  by = country]

hotels[, .N, by = pricecat]

## NOTE the above not working due to
hotels[, hotels_per_country := .N, by = country]
hotels[hotels_per_country == 1]
hotels <- hotels[hotels_per_country > 1]

## TODO create a new variable on city type: small / big <- number of hotels in the city
hotels[, hotels_per_city := .N, by = city_actual]
hotels[, citytype := cut(hotels_per_city, 2, labels = c('small', 'big'))]
hotels[, .N, by = citytype]

## TODO number of cases by citytype + pricecat
hotels[, .N, by = .(pricecat, citytype)][order(pricecat, citytype)]
hotels[, .N, by = .(pricecat, citytype)][order(-N)]

hotels[citytype == 'big', .N, by = country]

## TODO compute percentages of price categories withing city typex
price_per_type <- hotels[, .N, by = list(pricecat, citytype)][order(citytype, pricecat)]
price_per_type[, P := N / sum(N), by = citytype]
price_per_type[, P := round(N / sum(N) * 100, 2), by = citytype]
price_per_type

## #############################################################################
## FOR FUTURE REFERENCE: creating new variables: numeric to numeric
## #############################################################################

## TODO create a new variable with the count of hotels in the same country
hotels[, hotels_in_country := .N, by = country]

## TODO create a new variable with the count of cities in the same country
hotels[, cities_in_country := length(unique(city_actual)), by = country]

## TODO create a new variable with the count of small cities in the same country
## NOTE longer example if we have time
unique(hotels, by = 'city_actual')
unique(hotels, by = 'city_actual')[, .(city_actual, citytype)]
unique(hotels, by = 'city_actual')[, .(city_actual, citytype)][citytype == 'big']
## NOTE Rome?

hotels[, citytype := cut(hotels, 2)]
hotels[, .N, by = citytype]
hotels[, citytype := cut(hotels, 2, dig.lab = 8)]
hotels[, .N, by = citytype]

hotels[, citytype := cut(hotels, c(0, 250, Inf), labels = c('small', 'big'))]
hotels[, .N, by = citytype]

unique(hotels, by = 'city_actual')[, .(city_actual, citytype)][citytype == 'big']

hotels[, .N, by = .(country, citytype)][citytype == 'small']
hotels[citytype == 'small', .N, by = .(country, citytype)]
## NOTE drop citytype from group by

hotels[citytype == 'small', unique(length(city_actual)), by = country]
country_summary <- hotels[citytype == 'small',
                          .(small_cities_in_country = unique(length(city_actual))),
                          by = country]

hotels <- merge(hotels, country_summary, by = 'country')

## #############################################################################
## FOR FUTURE REFERENCE: multiple summaries
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

numcols <- c('price_per_night', 'rating', 'stars', 'distance', 'bookings')
hotels[, lapply(.SD, mean, na.rm = TRUE), by = city, .SDcols = numcols]

sapply(hotels, is.numeric)
numcols <- which(sapply(hotels, is.numeric))
hotels[, lapply(.SD, mean, na.rm = TRUE), by = city, .SDcols = numcols]

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

mystats <- function(x) list(
    min = min(x),
    mean = mean(x),
    median = median(x),
    max = max(x))

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
