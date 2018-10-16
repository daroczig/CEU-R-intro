## loading data for the data visualization examples
library(data.table)
bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
features <- fread('http://bit.ly/CEU-R-hotels-2018-features')

## TODO create bookings_summary from bookings to include
##      * hotel_id
##      * avg_price_per_night
##      * sd_price_per_night
##      * bookings
bookings[, price_per_night := price / nnights]
bookings_summary <- bookings[, .(
    avg_price_per_night = mean(price_per_night),
    sd_price_per_night = sd(price_per_night),
    bookings = .N), by = hotel_id]

## TODO merge these two datasets to include all features for each hotels + bookings summary
hotels <- merge(features, bookings_summary, by = 'hotel_id')

## TODO create a categorical variable (pricecat) on avg_price_per_night to tag
##      * cheap: anything below 50 EUR
##      * ok: from 50 to 150 EUR
##      * expensive: anything above 150 EUR
hotels[, pricecat := cut(avg_price_per_night, c(0, 50, 150, Inf),
                         labels = c('cheap', 'average', 'expensive'))]
hotels[, .N, by = pricecat]

## TODO create a categorical variable (popularity) on bookings to tag
##      * unpopular: 1-3 bookings
##      * average: 4-7 bookings
##      * popular: 8+ bookings
hotels[, popularity := cut(bookings, c(0, 3, 7, Inf),
                           labels = c('unpopular', 'average', 'popular'))]
hotels[, .N, by = popularity]
hotels[, .N, by = .(popularity, bookings)]
hotels[, .N, by = .(popularity, bookings)][order(popularity, bookings)]

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

## other categorical variable: country
ggplot(hotels, aes(x = country)) + geom_bar()
ggplot(hotels, aes(x = country)) + geom_bar() + theme(axis.text.x = element_text(angle = 90))
ggplot(hotels, aes(x = country)) + geom_bar() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(hotels, aes(x = country)) + geom_bar() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) + xlab('')
## QQ ordering? later...
?theme

## other geoms
ggplot(hotels, aes(stars, rating)) + geom_point()
## NOTE Removed 6862 rows containing missing values (geom_point).
## overlapping points ...
ggplot(hotels, aes(stars, rating)) + geom_hex()
ggplot(hotels, aes(stars, rating)) + geom_hex() + geom_smooth(method = 'lm')
ggplot(hotels, aes(stars, rating)) + geom_hex() + geom_smooth(method = 'lm', color = 'red')

## stars is actually a discrete variable
ggplot(hotels, aes(stars, rating)) + geom_boxplot()
ggplot(hotels, aes(factor(stars), rating)) + geom_boxplot()
## fix it in the data
hotels[, stars := factor(stars)]
ggplot(hotels, aes(stars, rating)) + geom_boxplot()

## now we can fix the order of the countries as well ... right?
ggplot(hotels, aes(x = country)) + geom_bar()
## NOTE the current order (in ABC)
hotels[, country := factor(country, levels = hotels[, .N, by = country][order(N), country])]
ggplot(hotels, aes(x = country)) + geom_bar()

## facet => create separate plots per group
p <- ggplot(hotels, aes(x = country)) + geom_bar()
p + facet_wrap( ~ pricecat)
p + facet_wrap( ~ pricecat, ncol = 1)
p + facet_wrap( ~ pricecat, nrow = 3)

## using multiple variables as facet
p + facet_grid(pricecat ~ popularity)
p + facet_grid(pricecat ~ popularity, scales = 'free')
## NOTE the correct order of the labels

## stacked, clustered bar charts
p <- ggplot(hotels, aes(x = pricecat, fill = popularity))
## stacked
p + geom_bar()
p + geom_bar(position = 'fill')
## clustered
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
ggplot(hotels, aes(x = rating, fill = popularity)) + geom_density(alpha = 0.2) + theme_bw()

## themes
library(ggthemes)
p <- ggplot(hotels, aes(x = rating, fill = popularity)) + geom_density(alpha = 0.2) + theme_bw()
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
            color = "white",
            size = 2)
    )
}
p + theme_custom()

## pick a color palette from http://colorbrewer2.org/
p + theme_custom() + scale_fill_brewer(palette = "Greens")
p + scale_fill_brewer(palette = "Greens")
p + scale_fill_brewer(palette = "Blues")
p + scale_fill_brewer(palette = "Dark2")
