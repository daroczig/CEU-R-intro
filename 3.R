## #############################################################################
## data.table and ggplot2 exercises from the last week
## #############################################################################

## * Visualize the below variables from the `mtcars` dataset with `ggplot2`:
##     * number of carburetors
library(ggplot2)
ggplot(mtcars, aes(carb)) + geom_bar()

##     * horsepower
ggplot(mtcars, aes(carb)) + geom_histogram(binwidth = 2)

##     * barplot on the number of carburetors per transmission
ggplot(mtcars, aes(carb)) + geom_bar() + facet_wrap(~am)

##     * boxplot on the horsepower by the number of carburetors
ggplot(mtcars, aes(factor(carb), hp)) + geom_boxplot()

##     * horsepower and weight by the number of carburetors
ggplot(mtcars, aes(hp, wt, color = factor(carb))) + geom_point()

##     * horsepower and weight by the number of carburetors with a trend line
ggplot(mtcars, aes(hp, wt, color = factor(carb))) + geom_point() + geom_smooth()

## * `data.table` exercises using the  `hflights` dataset:
library(data.table)
library(hflights)
dt <- data.table(hflights)

##     * compute the number of cancelled flights
dt[Cancelled == 1, .N]

##     * compute the shortest flight on each weekday
dt[, min(Distance), by = DayOfWeek]
dt[, min(Distance), by = DayOfWeek][order(DayOfWeek)]

##     * compute the average delay to all destination
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Dest]
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Dest][order(delay)]

##     * compute the average delay to all destination per origin
dt[, .(delay = mean(ArrDelay, na.rm = TRUE)), by = Origin]

##     * plot the average departure and arrival delays per destination
dta <- dt[, .(departure = mean(DepDelay, na.rm = TRUE),
              arrival = mean(ArrDelay, na.rm = TRUE)), by = Dest]
ggplot(dta, aes(departure, arrival, label = Dest)) + geom_text()

##     * plot the percentage of cancelled flights per destination
dta <- dt[, .(p = sum(Cancelled) / .N), by = Dest]
library(scales)
ggplot(dta, aes(Dest, p)) + geom_bar(stat = 'identity') + scale_y_continuous(label = percent)
setorder(dta, p)
dta[, Dest := factor(Dest, levels = dta$Dest)]
ggplot(dta, aes(Dest, p)) + geom_bar(stat = 'identity') +
  scale_y_continuous(label = percent) +
  theme(axis.text.x = element_text(angle = 45,))

## * Further exercises on the `nycflights13` dataset:
library(nycflights13)

## 	* count the number of flights to LAX
flights <- data.table(nycflights13::flights)
flights[dest == 'LAX', .N]

## 	* count the number of flights to LAX from JFK
flights[dest == 'LAX' & origin == 'JFK', .N]

## 	* compute the average delay (in minutes) for flights from JFK to LAX
flights[dest == 'LAX' & origin == 'JFK', mean(arr_delay, na.rm = TRUE)]

## 	* which destination has the lowest average delay from JFK?
dta <- flights[origin == 'JFK', .(delay = mean(arr_delay, na.rm = TRUE)), by = dest]
setorder(dta, delay)
head(dta)
dta[1]

## 	* plot the average delay to all destinations from JFK
ggplot(dta, aes(dest, delay)) + geom_bar(stat = 'identity')

## 	* plot the distribution of all flight delays to all destinations from JFK
ggplot(flights[origin == 'JFK'], aes(dest, arr_delay)) +
  geom_boxplot() +
  geom_jitter(size = 0.5, color = 'orange', alpha = .5)

## 	* compute a new variable in flights showing the week of day
flights[, weekday := weekdays(ISOdate(year, month, day))]

## 	* plot the number of flights per weekday
ggplot(flights[, .N, by = weekday], aes(weekday, N)) + geom_bar(stat = 'identity')

## 	* create a heatmap on the number of flights per weekday and hour of the day
ggplot(flights[, .N, by = .(weekday, hour)], aes(hour, weekday, fill = N)) + geom_tile()

## 	* plot the average temperature at noon in `EWR` for each month based on the `weather` dataset
dt <- data.table(weather)
ggplot(dt[origin == 'EWR', .(temp = mean(temp, na.rm = TRUE)), by = month], aes(month, temp)) +
  geom_bar(stat = 'identity')
