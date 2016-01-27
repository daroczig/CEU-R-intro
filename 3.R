## warm-up exercises (similar to the exam) on the mtcars dataset
## TODO number of carburators
ggplot(mtcars, aes(x = carb)) + geom_bar()
## TODO distribution of horsepowe
ggplot(mtcars, aes(x = hp)) + geom_histogram()
## TODO barplot of number of carburetors per transmission
ggplot(mtcars, aes(x = carb)) + geom_bar() + facet_grid(. ~ am)
## stacked bar chart
str(mtcars)
mtcars$am <- factor(mtcars$am)
ggplot(mtcars, aes(x = carb, fill = am)) + geom_bar()
mtcars$am <- factor(mtcars$am, levels = c(1, 0))
ggplot(mtcars, aes(x = carb, fill = am)) + geom_bar()
## grouped/dodged
ggplot(mtcars, aes(x = carb, fill = factor(am))) + geom_bar(position = 'dodge')
## TODO boxplot of horsepower by the number of carburetors
ggplot(mtcars, aes(x = factor(am), y = hp)) + geom_boxplot()
## TODO horsepower and weight by the number of carburetors
ggplot(mtcars, aes(x = hp, y = wt)) + geom_point() + facet_grid(. ~ carb)
## TODO horsepower and weight by the number of carburetors with a trend line
ggplot(mtcars, aes(x = hp, y = wt)) + geom_point() + facet_grid(. ~ carb) + geom_smooth()
ggplot(mtcars, aes(x = hp, y = wt)) + geom_point(aes(color = factor(carb))) + geom_smooth()
ggplot(mtcars, aes(x = hp, y = wt, color = factor(carb))) + geom_point() + geom_smooth()

## a custom ggplot theme
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
p <- ggplot(mtcars, aes(x = hp, y = wt)) + geom_point(aes(color = factor(carb))) + geom_smooth()
p + theme_custom()
## pick a color palette from http://colorbrewer2.org/
p + theme_custom() + scale_color_brewer(palette = "Greens")
## custom color palette
cols <- c('black', 'pink', 'yellow', 'orange', 'blue', '#18BA34', 'white')
p + scale_color_manual(values = cols)
## http://www.cookbook-r.com

## quick example on fetching data from the Internet
library(XML)
df <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/FTSE_100_Index'),
                    which = 2, header = TRUE, stringsAsFactors = FALSE)
str(df)

## quick fix some dirty data
df$'Market cap (£bn)' <- as.numeric(df$'Market cap (£bn)')
df$Employees <- as.numeric(sub(',', '', df$Employees))
str(df)

## some descriptive stats
min(df$Employees)
max(df$Employees)
range(df$Employees)
sum(df$Employees)
length(df$Employees)
nrow(df)
ncol(df)
dim(df)

summary(df)
summary(df$Employees)
fivenum(df$Employees)

## first summaries
table(df$Sector)
hist(df$'Market cap (£bn)')
aggregate(Employees ~ Sector, FUN = mean, data = df)
aggregate(Employees ~ Sector, FUN = min, data = df)
aggregate(Employees ~ Sector, FUN = sd, data = df)
aggregate(Employees ~ Sector, FUN = var, data = df)
aggregate(Employees ~ Sector, FUN = range, data = df)

aggregate(`Market cap (£bn)` ~ Sector, FUN = mean, data = df)
names(df)[4] <- 'cap'
str(df)

## TODO plot employees as the function of the cap with a linear model
plot(Employees ~ cap, df)
abline(lm(Employees ~ cap, df), col = 'red')

## same with ggplot
library(ggplot2)
ggplot(df, aes(x = cap, y = Employees)) +
    geom_point() +
    geom_smooth(method = 'lm', se = FALSE, col = 'red')

## verify that the association is low between these two variables
cor(df$Employees, df$cap)

## filter for the top 10 largest company by market cap
head(df[order(df$cap, decreasing  = TRUE), ], 10)

## subset
subset(df, cap > 100)
subset(df, cap > 100 & Employees > 1e5)

ggplot(subset(df, Sector == 'Banking'), aes(x = cap, y = Employees)) +
    geom_text(aes(label = Company))

## avoid overlapping labels
library(ggrepel)
ggplot(subset(df, Sector == 'Banking'), aes(x = cap, y = Employees)) +
    geom_point() +
    geom_text_repel(aes(label = Company)) +
    theme_bw()

## #############################################################################
## intro to data.table
## #############################################################################

library(data.table)
library(hflights)
dt <- data.table(hflights)
str(dt)

## filtering with data.table
subset(dt, Dest == 'LAX')
dt[Dest == 'LAX']

dt[Dest == 'LAX', list(DepTime, ArrTime)]
dt[Dest == 'LAX', .(DepTime, ArrTime)]

## summaries with data.table
dt[, mean(Cancelled)]
dt[, mean(Cancelled), by = DayOfWeek]
dta <- dt[, mean(Cancelled), by = DayOfWeek]
setnames(dta, 'V1', 'Cancelled')
dta
dt[, .(Cancelled = mean(Cancelled)), by = DayOfWeek]

dt[, .N, by = list(DayOfWeek)]
dt[Dest == 'LAX', .N, by = list(DayOfWeek)]
dt[Dest == 'LAX', .(P = .N / dt[, .N] * 100), by = list(DayOfWeek)]

## ordering
dta <- dt[, .(Cancelled = mean(Cancelled)), by = DayOfWeek]
setorder(dta, Cancelled)
dta
setorder(dta, DayOfWeek)
dta

## creating new features
dt$DistanceKMs <- dt$Distance / 0.62137
dt[, DistanceKMs := Distance / 0.62137]

dt[, DayOfWeek := weekdays(as.Date(paste(Year, Month, DayofMonth, sep = '-')))]

## data.table exercises
## TODO find the shortest flight on each weekday
dt[, min(Distance), by = DayOfWeek]
dt[Distance == 79]
## TODO find the number of cancelled flights
dt[Cancelled == 1, .N]
dt[, sum(Cancelled)]
## TODO find the average delay to all destination
dt[, mean(ArrDelay), by = Dest]
dt[, mean(ArrDelay, na.rm = TRUE), by = Dest]
## TODO is it only due to a small number of flights?
dt[, .(.N, mean(ArrDelay, na.rm = TRUE)), by = Dest]
dt[, .(.N, min(ArrDelay, na.rm = TRUE), mean(ArrDelay, na.rm = TRUE)), by = Dest]
## TODO add some further metrics
dt[, .(.N,
       min(ArrDelay, na.rm = TRUE),
       mean(ArrDelay, na.rm = TRUE),
       max(ArrDelay, na.rm = TRUE)), by = Dest]
dta <- dt[, .(.N,
       min = min(ArrDelay, na.rm = TRUE),
       avg = mean(ArrDelay, na.rm = TRUE),
       max = max(ArrDelay, na.rm = TRUE)), by = Dest]
setorder(dta, avg)
dta
## TODO plot the departure and arrival delays
ggplot(dt, aes(x = DepDelay, y = ArrDelay)) + geom_point()
ggplot(dt, aes(x = DepDelay, y = ArrDelay)) + geom_hex()
## TODO plot the average departure and arrival delays per destination
ggplot(dt[, .(ArrDelay = mean(ArrDelay, na.rm = TRUE),
              DepDelay = mean(DepDelay, na.rm = TRUE)),
          by = Dest], aes(x = DepDelay, y = ArrDelay, col = Dest)) + geom_point()
ggplot(dt[, .(ArrDelay = mean(ArrDelay, na.rm = TRUE),
              DepDelay = mean(DepDelay, na.rm = TRUE)),
          by = Dest], aes(x = DepDelay, y = ArrDelay, label = Dest)) + geom_text()
## TODO plot the average departure and arrival delays per flight (tail number) + size
ggplot(dt[Distance < 2000,
          .(dist  = mean(Distance, na.rm = TRUE),
            delay = mean(ArrDelay, na.rm = TRUE),
            .N),
          by = TailNum], aes(x = dist, y = delay, size = N)) + geom_point(alpha = .3)


## now let's do the same on the nycflights13::flights dataset
library(nycflights13)
flights <- data.table(flights)
## TODO compute DayOfWeek
flights[, DayOfWeek := weekdays(as.Date(paste(year, month, day, sep = '-')))]
## TODO find the number of flights on each weekday
flights[, .N, by = DayOfWeek]
## TODO plot the average delay to all destination
flights[, mean(arr_delay, na.rm = TRUE), by = dest]
ggplot(flights[, mean(arr_delay, na.rm = TRUE), by = dest],
       aes(x = dest, y = V1)) + geom_bar(stat = 'identity') + coord_flip()
## TODO plot the average departure and arrival delays per destination
ggplot(flights[, .(ArrDelay = mean(arr_delay, na.rm = TRUE),
                   DepDelay = mean(dep_delay, na.rm = TRUE)),
               by = dest], aes(x = DepDelay, y = ArrDelay, label = dest)) + geom_text()

## #############################################################################
## joins
## #############################################################################

str(airports)
airports <- data.table(airports)
airports[faa == 'LAX']

merge(flights, airports, by.x = 'dest', by.y = 'faa')
merge(flights[, .N, by = dest], airports, by.x = 'dest', by.y = 'faa')
merge(flights[, .N, by = dest], airports, by.x = 'dest', by.y = 'faa', all.x = TRUE)
merge(flights[, .N, by = dest], airports, by.x = 'dest', by.y = 'faa', all.x = TRUE)[is.na(name)]
merge(flights[, .N, by = dest], airports, by.x = 'dest', by.y = 'faa', all.y = TRUE)
## we could merge eg state data etc

str(planes)
planes <- data.table(planes)
dt <- merge(flights[, .(delay = mean(arr_delay, na.rm = TRUE)), by = tailnum], planes, by = 'tailnum')
dt[, mean(delay), by = type]
dt[, mean(delay), by = engine]
dt[, mean(delay), by = manufacturer]
