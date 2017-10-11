library(data.table)
hotels <- fread('http://bit.ly/CEU-R-hotels-2017-v2')

## #############################################################################
## creating new variables: parsing text
## #############################################################################

## TODO avg price in HUF per country

## parsing the country out of the city column
hotels[, city := as.character(city)]

x <- 'Budapest, Hungary'
strsplit(x, ', ')
str(strsplit(x, ', '))
strsplit(x, ', ')[[1]]
strsplit(x, ', ')[[1]][2]

hotels[, country := strsplit(city, ', ')[[1]][2], by = city]

## another approach using regular expressions
sub('.*, ', '', x)
hotels[, country := sub('.*, ', '', city)]

hotels[, sum(price_HUF), by = country]

## rename original variable and store actual city in the city column
setnames(hotels, 'city', 'citycountry')
hotels[, city := strsplit(citycountry, ', ')[[1]][1], by = citycountry]

## TODO count the number of cities with hotels in Hungary
hotels[, .N, by = country]
hotels[country == 'Hungary', .N]
hotels[country == 'Hungary', length(unique(city))]
## TODO count the number of cities with hotels in Germany
hotels[country == 'Germany', length(unique(city))]
## TODO count the average number of hotels per city
hotels[, .N, by = city][, mean(N)]
## TODO count the average number of hotels per city per country
hotels_per_city <- hotels[, .N, by = .(country, city)]
hotels_per_city[, mean(N), by = country]
## TODO compute the percentage of national hotels per city
hotels_per_city[, P := N / sum(N) * 100, by = country]
hotels_per_city
hotels_per_city[order(country, city)]

## TODO compute the avg price in Hungary rating > 4.5
hotels[country == 'Hungary' & rating > 4.5, mean(price_HUF, na.rm = TRUE)]

## TODO histogram on the same prices
library(ggplot2)
library(scales)
ggplot(hotels[country == 'Hungary' & rating > 4.5], aes(price_HUF)) +
    geom_histogram(binwidth = 10000) +
    scale_x_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') +
    ggtitle('Number of hotels', subtitle = 'Budapest, Hungary')

## TODO more summaries => percentage of high rated hotels in Hungary
hotels[country == 'Hungary', sum(rating > 4.5, na.rm = TRUE)]
hotels[country == 'Hungary', sum(rating > 4.5, na.rm = TRUE) / .N]
hotels[country == 'Hungary', sum(rating > 4.5, na.rm = TRUE) / .N * 100]

## #############################################################################
## joining external data
## #############################################################################

library(XML)
gdp <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita'), which = 3)
gdp <- readHTMLTable(readLines('http://bit.ly/CEU-R-gdp'), which = 3)
head(gdp)

## convert to data.table
gdp <- data.table(gdp)
gdp <- as.data.table(gdp)
setDT(gdp)

gdp[, country := iconv(`Country/Territory`, to = 'ASCII', sub = '')]
gdp[, gdp := as.numeric(sub(',', '', `Int$`))]

countries <- hotels[, unique(country)]
countries %in% gdp$country
## \o/

merge(hotels, gdp, by = 'country')
gdp <- gdp[, .(country, gdp)]
gdp
hotels <- merge(hotels, gdp, by = 'country')

## TODO compute the avg price of hotels and the GDP per country
hotels[, .(price = mean(price_HUF), gdp = gdp[1]), by = country]
country_stats <- hotels[, .(price = mean(price_HUF), gdp = gdp[1]), by = country]

## TODO visualize association
ggplot(country_stats,
       aes(gdp, price)) + geom_point()

ggplot(country_stats,
       aes(gdp, price, label = country)) + geom_text()
ggplot(country_stats,
       aes(gdp, price, label = country)) + geom_text() + geom_smooth()
ggplot(country_stats,
       aes(gdp, price, label = country)) + geom_text() + geom_smooth(method = 'lm')

cor(country_stats[, .(gdp, price)])

## TODO which are the countries with relatively low GDP but high hotel prices?
country_stats[price > 70000]
country_stats[price > 70000 & gdp < 30000]

## let's exclude these
country_stats[price < 70000, .(gdp, price)]
cor(country_stats[price < 70000, .(gdp, price)])
ggplot(country_stats[price < 70000, .(gdp, price)],
       aes(gdp, price)) + geom_point() + geom_smooth(method = 'lm')

## #############################################################################
## restructure long and wide tables
## #############################################################################

## TODO plot the average price of hotels per cities
ggplot(hotels[, mean(price_HUF), by = city], aes(city, V1)) +
    geom_bar(stat = 'identity')

cities <- hotels[, list(avg_price = mean(price_HUF)), by = city]

ggplot(cities, aes(city, avg_price)) + geom_bar(stat = 'identity') +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31') +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = ''))

## reorder cities by prices
cities[, city := factor(city, levels = cities[order(avg_price), city])]

ggplot(cities, aes(city, avg_price)) + geom_bar(stat = 'identity') +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) + xlab('')

## TODO plot the min, avg, med and max price of hotels per cities

## almost there ...
ggplot(hotels, aes(country, price_HUF)) + geom_boxplot()

ggplot(hotels, aes(country, price_HUF)) + geom_boxplot() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31')

## compute the stats
cities <- hotels[, list(
    min_price = min(price_HUF),
    avg_price = mean(price_HUF),
    med_price = median(price_HUF),
    max_price = max(price_HUF)
), by = city]
str(cities)

## we need to restructure the data!
library(reshape2)
melt(cities)

cities <- melt(cities, id.vars = 'city')
str(cities)
cities

## plotting with 4 lines
ggplot(cities, aes(city, value, color = variable, group = variable)) + geom_line() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31')

## reorder cities as last time
cities[, city := factor(city, levels = cities[variable == 'avg_price'][order(value)][, city])]

ggplot(cities, aes(city, value, color = variable, group = variable)) + geom_line() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31')

## very skewed distribution ... revert back to boxplot
ggplot(hotels, aes(city, price_HUF)) + geom_boxplot() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31')

## TODO plot the min, max and avg rating per country on a lineplot
##      ordered by the avg rating
countries <- hotels[, list(
    min_price = min(rating, na.rm = TRUE),
    avg_price = mean(rating, na.rm = TRUE),
    max_price = max(rating, na.rm = TRUE)
), by = country]
countries[, country := factor(country, levels = countries[order(avg_price), country])]
countries
countries <- melt(countries)
countries
ggplot(countries, aes(country, value, color = variable, group = variable)) + geom_line()

## using facets
ggplot(countries, aes(country, value, group = 1)) +
    geom_line() + facet_grid(variable ~ .)
ggplot(countries, aes(country, value, group = 1)) +
    geom_line() + facet_grid(variable ~ ., scales = 'free')


## #############################################################################
## geocoding in a loop
## #############################################################################

i <- 1
hotels[i]

library(ggmap)
geocode <- geocode(hotels[i, citycountry], source = 'dsk')
geocode$lon
geocode$lat

## TODO instead of iterating on hotels, iterate on cities!
geocodes <- hotels[, .N, by = citycountry]
geocodes[i]

for (i in 1:nrow(cities)) {
    geocode <- geocode(geocodes[i, citycountry], source = 'dsk')
    geocodes[i, lon := geocode$lon]
    geocodes[i, lat := geocode$lat]
}

## download from bit.ly
write.csv(geocodes, file = 'hotels-2017-geocodes.csv', row.names = FALSE, na = '')
geocodes <- fread('http://bit.ly/CEU-R-hotels-2017-geocodes')

## plot
ggplot(geocodes, aes(lon, lat, size = N)) + geom_point()

worldmap <- map_data('world')
ggplot() +
    geom_polygon(data = worldmap, aes(x =long, y = lat, group = group)) +
    geom_point(data = geocodes, aes(lon, lat, size = N)) +
    coord_fixed(1.3)

## using ggmap
europe <- get_map(location = 'Berlin', zoom = 4, maptype = 'terrain')
europe <- get_map(location = 'Berlin', zoom = 4, maptype = 'terrain', api_key = key)
europe <- get_map(location = 'Berlin', zoom = 4, source = 'stamen', maptype = 'toner')
ggmap(europe) + geom_point(data = geocodes, aes(lon, lat, size = N), color = 'red')

## TODO merge back
hotels <- merge(hotels, geocodes, by = 'citycountry')

## TODO render city labels
ggmap(europe) + geom_text(data = unique(hotels, by = 'city'),
                           aes(lon, lat, label = city), color = 'red')

## TODO render points for cities coloring by avg price per night
ggmap(europe) + geom_point(data = hotels[, mean(price_HUF), by = .(lat, lon)],
                           aes(lon, lat, color = V1), size = 10)

## get more data with a key => Google for geocoding:
## => https://developers.google.com/maps/
## => https://console.cloud.google.com
geocode(..., output = 'all')
library(googleway)
google_geocode(hotels[i, citycountry], key = key)

## #############################################################################
## extra exercises
## #############################################################################

## TODO on what affects the price of a hotel
str(hotels)

library(GGally)
ggpairs(hotels[, .(rating, stars, price_HUF, dist_center_km, dist_other,
                   gdp, N)])

ggplot(hotels, aes(factor(stars), price_EUR)) +
    geom_point() + geom_boxplot() + facet_wrap(~country)

## #############################################################################
## further text parsing examples
## #############################################################################

## TODO distance from other
str(hotels)
hotels[, dist_other := strsplit(dist_other_km, ': ')[[1]][2], by = dist_other_km]
hotels[, dist_other := as.numeric(dist_other)]

## TODO analysis

