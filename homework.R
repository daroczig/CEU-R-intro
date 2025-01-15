library(data.table)
library(nycflights13)
dt <- data.table(flights)

## NOTE copy/paste questions + comment out from menu

## 1. How many flights originated from JFK?
dt[origin == "JFK", .N]

## 2. Count the number of flights per month.
dt[, .N, by = month]
dt[, .N, by = month][order(month)]

## 3. Visualize the number of flights per destination.
library(ggplot2)
ggplot(dt, aes(x=dest)) + geom_bar()
# rotate x axis labels
ggplot(dt, aes(x=dest)) + geom_bar() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
# order
ggplot(dt[, .N, by = dest][order(-N)][, dest := factor(dest, levels = dest)], aes(x=dest, N)) + geom_col() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
# map
library(maps)
world <- map_data('world')
dta <- dt[, .N, by = dest]
dta <- merge(dta, data.table(airports)[, .(dest=faa, lat, lon)])
ggplot() +
    geom_map(data = world, map = world, aes(long, lat, map_id = region)) +
    geom_point(data = dta, aes(lon, lat, size = N), color = 'orange') +
    coord_fixed(1.3) +
    theme_void() +
    theme(legend.position = 'top')

## 4. Count the number of flights with an arrival delay of more than 100 mins.
dt[arr_delay > 100, .N]

## 5. Visualize the maximum arrival delay per destination.
## NOTE missing values
ggplot(dt[, .(max_arr_delay = max(arr_delay, na.rm = TRUE)), by = dest], aes(dest, max_arr_delay)) + geom_col()

## 6. Aggregate the min and max arrival delay per origin.
dt[, .(min_arr_delay = min(arr_delay, na.rm = TRUE), max_arr_delay = max(arr_delay, na.rm = TRUE)), by = origin]
dt[!is.na(arr_delay), .(min_arr_delay = min(arr_delay), max_arr_delay = max(arr_delay)), by = origin]

## 7. Visualize the distribution of the arrival delay per origin.
ggplot(dt, aes(x=arr_delay, fill = origin)) + geom_density(alpha = .5)

## 8. Visualize the distribution of the arrival delay per destination.
ggplot(dt, aes(x=arr_delay, fill = dest)) + geom_density(alpha = .5)
ggplot(dt, aes(dest, arr_delay)) + geom_boxplot() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

## 9. List the top 5 destinations being the furthest from NYC!
dt[, .(dist = max(distance)), by = dest][order(-dist)][1:5, dest]

## 10. How many flights were scheduled to departure before 11 am?
dt[hour < 11, .N]

## NOTE R markdown
