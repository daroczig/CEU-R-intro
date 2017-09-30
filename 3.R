## NOTE if you get lost with the commands, then stop typing -- pay attention to what we do
##      and you will be able to rerun all these commands later at home.
## NOTE if in doubt, check the related books or the DataCamp courses

hotels <- read.csv('http://bit.ly/CEU-R-hotels-2017')
hotels <- data.table(hotels)
str(hotels)

## #############################################################################
## creating new variables: numeric to factor
## #############################################################################

## TODO compute required budget (EUR) to try all hotels for a night

## TODO categorize hotels into 3 buckets by price

## stats approach to categorize hotels by price: using average and std deviation
avg_price <- hotels[, mean(price_EUR)]
sd_price <- hotels[, sd(price_EUR)]
hotels[, pricecat := cut(price_EUR, c(0,
                                      avg_price - sd_price,
                                      avg_price + sd_price,
                                      Inf), dig.lab = 8)]
hotels[, .N, by = pricecat]
## skewed distribution
## also very different by city

## TODO avg price in EUR per city

## #############################################################################
## summaries
## #############################################################################

## compute aggregated variable within the dataset
hotels[, price_avg := mean(price_EUR), by = city]
hotels[, price_sd := sd(price_EUR), by = city]

hotels[, pricecat := cut(price_EUR, c(0,
                                      price_avg[1] - price_sd[1],
                                      price_avg[1] + price_sd[1],
                                      Inf),
                         labels = c('below avg', 'avg', 'above avg')),
       by = city]
hotels[, .N, by = pricecat]

## TODO compute the number of hotels in the city

## TODO merge this metric to the actual dataset

## TODO create a new variable on city type: small or big depending on the number of hotels

## number of cases per multiple variables
hotels[, .N, by = list(pricecat, citytype)]
hotels[, .N, by = list(pricecat, citytype)][order(pricecat, citytype)]
## wrong order!
hotels[, .N, by = list(pricecat, citytype)][order(citytype, pricecat)]
## compute percentages
price_per_type <- hotels[, .N, by = list(pricecat, citytype)][order(citytype, pricecat)]
price_per_type[, P := N / sum(N), by = citytype]
price_per_type[, P := round(N / sum(N) * 100, 2), by = citytype]
price_per_type

## #############################################################################
## multiple summaries
## #############################################################################

## reminder
hotels[, .(price_avg = mean(price_EUR)), by = city]

## TODO min, avg, median and max price in EUR per city

## TODO round it up to EUR

## TODO compute the average price, rating, stars per city in a new dataset

## check the same on rating and stars
hotels[, lapply(.SD, mean), by = city, .SDcols = c('price_EUR', 'rating', 'stars')]
hotels[, lapply(.SD, mean, na.rm = TRUE), by = city, .SDcols = c('price_EUR', 'rating', 'stars')]

## save data for later use
write.csv(hotels, 'hotels-with-two-new-factors.csv')

## #############################################################################
## Wilkinson: The Grammar of Graphics
## #############################################################################
## R implementation by Hadley Wickham: ggplot2
## Suggested reading: R Graphics Cookbook
## #############################################################################

## read data and store as a data.table object
hotels <- read.csv('http://bit.ly/CEU-R-hotels-2017-v2')
hotels <- data.table(hotels)
setDT(hotels)

## do the same in one step and a bit faster
hotels <- fread('http://bit.ly/CEU-R-hotels-2017-v2')

## the R implementation of the Grammar of Graphics
library(ggplot2)

## barplot with ggplot: you specify a dataset, then define an aesthetic and geom
ggplot(hotels, aes(x = pricecat)) + geom_bar()
## and optionally some further layers (theme)
ggplot(hotels, aes(x = pricecat)) + geom_bar() + theme_bw()
ggplot(hotels, aes(x = pricecat)) + geom_bar(colour = "darkgreen", fill = "white") + theme_bw()

## we can store the resulting plot as an R object for future reuse
p <- ggplot(hotels, aes(x = pricecat)) + geom_bar()
p
p + theme_bw()

## it's better to split long lines for easier reading
p <- ggplot(hotels, aes(x = pricecat)) +
     geom_bar() +
     theme_bw()
p

## coord transformations
library(scales)
p + scale_y_log10()
p + scale_y_sqrt()
p + scale_y_reverse()
p + coord_flip()

## other geoms
ggplot(hotels, aes(stars, rating)) + geom_point()
## overlapping points ...
ggplot(hotels, aes(stars, rating)) + geom_hex()
ggplot(hotels, aes(stars, rating)) + geom_hex() + geom_smooth(method = 'lm')
ggplot(hotels, aes(stars, rating)) + geom_hex() + geom_smooth(method = 'lm', color = 'red')
## stars is actually a discrete variable
ggplot(hotels, aes(stars, rating)) + geom_boxplot()
ggplot(hotels, aes(factor(stars), rating)) + geom_boxplot()

## facet => create separate plots per group
p <- ggplot(hotels, aes(factor(stars), rating)) + geom_boxplot()
p + facet_wrap( ~ citytype)

## fix ordering
hotels[, citytype := factor(citytype, labels = c('small', 'big'))]
p + facet_wrap( ~ citytype)
p + facet_grid(citytype ~ pricecat)

## TODO fix order of the labels

## stacked, clustered bar charts
p <- ggplot(hotels, aes(x = pricecat, fill = citytype))
p + geom_bar()
p + geom_bar(position = 'fill')
p + geom_bar(position = 'dodge')

## histogram
ggplot(hotels, aes(x = rating)) + geom_bar()
## note the gaps between the bars
ggplot(hotels, aes(x = rating)) + geom_histogram()
ggplot(hotels, aes(x = rating)) + geom_histogram(binwidth = 1)
ggplot(hotels, aes(x = rating)) + geom_histogram(binwidth = 0.25)

## density plot
ggplot(hotels, aes(x = rating)) + geom_density()
ggplot(hotels, aes(x = rating, fill = pricecat)) + geom_density(alpha = 0.2) + theme_bw()
ggplot(hotels, aes(x = rating, fill = citytype)) + geom_density(alpha = 0.2) + theme_bw()

## themes
library(ggthemes)
p <- ggplot(hotels, aes(x = rating, fill = citytype)) + geom_density(alpha = 0.2) + theme_bw()
p + theme_economist() + scale_fill_economist()
p + theme_stata() + scale_fill_stata()
p + theme_excel() + scale_fill_excel()
p + theme_wsj() + scale_fill_wsj('colors6', '')
p + theme_gdocs() + scale_fill_gdocs()

## create a custom theme for future usage
theme_custom <- function() {
    theme(
        axis.text = element_text(
            family = 'Times New Roman',
            color  = "orange",
            size   = 12,
            face   = "italic"),
        axis.title = element_text(
            family = 'Times New Roman',
            color  = "orange",
            size   = 16,
            face   = "bold"),
        axis.text.y = element_text(angle = 90, hjust = 0.5),
        panel.background = element_rect(
            fill = "orange",
            color = "white", # => snow
            size = 2)
    )
}
p + theme_custom()
## pick a color palette from http://colorbrewer2.org/
p + theme_custom() + scale_fill_brewer(palette = "Greens")
## see more examples at http://docs.ggplot2.org/dev/vignettes/themes.html

## TODO plot a barplot on the number of hotels per city type
## TODO plot a histogram on the prices in EUR
## TODO plot a histogram on the prices in EUR split by city type
## TODO plot a boxplot on the prices in EUR split by city type
## TODO plot a scatterplot on the prices in EUR and the distance from city center
## TODO add a model to the previous plot
## TODO plot a boxplot on the prices in EUR split by cat(rating)

## #############################################################################
## creating new variables: parsing text
## #############################################################################

## TODO avg price in EUR per country

## parsing the country out of the city column
hotels[, city := as.character(city)]

x <- 'Budapest, Hungary'
strsplit(x, ', ')
str(strsplit(x, ', '))
strsplit(x, ', ')[[1]]
strsplit(x, ', ')[[1]][2]

hotels[, country := strsplit(city, ', ')[[1]][2], by = city]

sub('.*, ', '', x)
hotels[, country := sub('.*, ', '', city)]

hotels[, sum(price_EUR), by = country]

## TODO compute the avg price in Hungary rating > 4.5

## TODO histogram on the same prices

## more summaries => percentage of high rated hotels in Hungary
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
hotels <- merge(hotels, gdp, by = 'country')

## TODO compute the avg price of hotels and the GDP per country

## TODO visualize association

## TODO which are the countries with relatively low GDP but high hotel prices?

## let's exclude these
country_stats[price < 200, .(gdp, price)]
cor(country_stats[price < 200, .(gdp, price)])
ggplot(country_stats[price < 200, .(gdp, price)],
       aes(gdp, price)) + geom_point() + geom_smooth(method = 'lm')

## #############################################################################
## restructure long and wide tables
## #############################################################################

library(reshape2)

cities <- hotels[, list(
    min_price = min(price_EUR),
    avg_price = mean(price_EUR),
    med_price = median(price_EUR),
    max_price = max(price_EUR)
), by = city]
str(cities)

cities <- melt(cities)
str(cities)

cities <- melt(cities, id.vars = 'city')
str(cities)
cities

## #############################################################################
## revisit aggregates for dataviz
## #############################################################################

ggplot(hotels, aes(country, price_HUF)) + geom_boxplot()

ggplot(hotels, aes(country, price_HUF)) + geom_boxplot() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

library(scales)
ggplot(hotels, aes(country, price_HUF)) + geom_boxplot() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_y_continuous(labels = dollar_format(suffix = 'Ft', prefix = '')) +
    xlab('') + ylab('') + ggtitle('Hotel prices on Dec 31')

## TODO show the ratings per country on a boxplot

## TODO show the average rating per country

## custom ggplot theme
mytheme <- function() {
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          panel.background = element_rect(fill = 'snow1'))
}
ggplot(ratings, aes(country, avg_rating, color)) + geom_bar(stat = 'identity') + mytheme()

## TODO plot the min, max and avg price per country

## move and rename legend
ggplot(countries, aes(country, value, color = variable, group = variable)) +
    geom_line() + mytheme() +
    theme(legend.position = 'top') + scale_color_brewer('Metrics', palette = 'Greens')

## using facets
ggplot(countries, aes(country, value, group = 1)) +
    geom_line() + mytheme() + facet_grid(variable ~ .)
ggplot(countries, aes(country, value, group = 1)) +
    geom_line() + mytheme() + facet_grid(variable ~ ., scales = 'free')
