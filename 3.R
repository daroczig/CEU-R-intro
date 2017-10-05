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
hotels[, sum(price_HUF)]
hotels[, sum(price_HUF) / 310]
hotels$price_EUR <- hotels$price_HUF / 310
hotels[, price_EUR := price_HUF / 310]
hotels[, sum(price_EUR)]

## TODO categorize hotels into 3 buckets by price
hotels[, pricecat := cut(price_EUR, 3)]
hotels[, .N, by = pricecat]
hotels[, pricecat := cut(price_EUR, 3, dig.lab = 8)]
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_EUR, c(0, 10000, 100000, Inf), dig.lab = 8)]
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_EUR,
                         c(0, 10000, 100000, Inf),
                         labels = c('cheap', 'average', 'expensive'))]
hotels[, .N, by = pricecat]

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
hotels[, mean(price_EUR), by = city]
## use named expressions to name columns
hotels[, list(avg_price = mean(price_EUR)), by = city]

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
hotels[, .(hotels = .N), by = city]

## TODO merge this metric to the actual dataset
hotels[, hotels := .N, by = city]

## TODO create a new variable on city type: small or big depending on the number of hotels
hotels[, .N, by = city]
hotels[, citytype := cut(hotels, 2)]
hotels[, .N, by = citytype]
hotels[, citytype := cut(hotels, 2, labels = c('small', 'big'))]
hotels[, .N, by = citytype]

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
hotels[, list(
    min_price = min(price_EUR),
    avg_price = mean(price_EUR),
    med_price = median(price_EUR),
    max_price = max(price_EUR)
), by = city]

## TODO round it up to EUR
hotels[, list(
    min_price = round(min(price_EUR)),
    avg_price = round(mean(price_EUR)),
    med_price = round(median(price_EUR)),
    max_price = round(max(price_EUR))
), by = city]

## TODO compute the average price, rating, stars per city in a new dataset
hotels[, .(price_avg = mean(price_EUR),
           rating_avg = mean(rating),
           stars_avg = mean(stars)), by = city]

hotels[, .(price_avg = mean(price_EUR),
           rating_avg = mean(rating, na.rm = TRUE),
           stars_avg = mean(stars, na.rm = TRUE)), by = city]

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
hotels[, citytype := factor(citytype, levels = c('small', 'big'))]
p + facet_wrap( ~ citytype)
p + facet_grid(citytype ~ pricecat)

## TODO fix order of the labels
hotels[, pricecat := factor(pricecat, levels = c('below avg', 'avg', 'above avg'))]
p + facet_grid(citytype ~ pricecat)

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
ggplot(hotels, aes(citytype)) + geom_bar()

## more difficult approach with custom summary
ggplot(hotels[, .N, by = citytype], aes(citytype, y = N)) + geom_bar(stat = 'identity')

## TODO plot a histogram on the prices in EUR
ggplot(hotels, aes(price_EUR)) + geom_histogram()

## TODO plot a histogram on the prices in EUR
##      split by city type
ggplot(hotels, aes(price_EUR)) + geom_histogram() +
    facet_wrap(~ citytype)

## TODO plot a boxplot on the prices in EUR split by city type
ggplot(hotels, aes(citytype, price_EUR)) + geom_boxplot()

## TODO plot a scatterplot on the prices in EUR and
## the distance from city center
ggplot(hotels, aes(price_EUR, dist_center_km)) + geom_point()

## TODO add a model to the previous plot
ggplot(hotels, aes(dist_center_km, price_EUR)) +
    geom_point() + geom_smooth(method = 'lm')

## TODO plot a boxplot on the prices in EUR split by cat(rating)
hotels[, ratingcat := cut(rating, 5)]
ggplot(hotels, aes(ratingcat, price_EUR)) + geom_boxplot()
