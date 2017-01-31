## Review R object types from yesterday
df <- read.csv('http://bit.ly/BudapestBI-R-csv')
str(df)

## TODO 5th respondent's weight
df[5, 5]
df$weightLb[5]

## TODO what's the minimum weight
min(df$weightLb)

## TODO what's the minimum weight among males
males <- subset(df, sex == 'm')
min(males$weightLb)

min(subset(df, sex == 'm')$weightLb)

## TODO what's the weight of the tallest man in the sample
max(males$heightIn)
subset(males, heightIn == 72)
subset(males, heightIn == 72)$weightLb

mh <- max(males$heightIn)
subset(males, heightIn == mh)$weightLb

subset(males, heightIn == max(males$heightIn))$weightLb

## look for row index
which(df$heightIn == mh)
which(df$sex == 'm')

## BMI
df$height <- df$heightIn * 2.54 / 100
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / df$height ^ 2

## yesterday we saw there’s a sign diff in BMI between males and females
## TODO how does BMI change over time/age?
str(df)
plot(df$ageYear, df$ageMonth)

plot(df$ageYear, df$bmi)
fit <- lm(bmi ~ ageYear, df)
abline(fit, col = 'red')
fit
summary(fit)

summary(df$ageYear)

## TODO what's the avg BMI per age
aggregate(bmi ~ ageYear, FUN = mean, data = df)
df$year <- round(df$ageYear)
aggregate(bmi ~ year, FUN = mean, data = df)

## univariate plots
hist(df$bmi)
abline(v = c(18.5, 25), col = 'red')

boxplot(df$bmi)
boxplot(bmi ~ sex, df)

install.packages("beanplot")
library(beanplot)
beanplot(df$bmi)

par(mfrow = c(1, 2))
boxplot(df$bmi)
beanplot(df$bmi)

str(df)
table(df$sex)
pie(table(df$sex))
barplot(table(df$sex))
dotchart(table(df$sex))

pairs(df)

## ggplot: the Grammar of Graphics implementation in R
## http://www.cookbook-r.com/Graphs/
## RStudio ggplot2 cheatsheet

install.packages('ggplot2')
library(ggplot2)
?diamonds

## bar plot
ggplot(diamonds, aes(x = cut)) + geom_bar()

p <- ggplot(diamonds, aes(x = cut))
p <- p + geom_bar()
p

p + theme_bw()

ggplot(diamonds, aes(x = cut)) +
  geom_bar(color = "darkgreen", fill = 'white')

ggplot(diamonds, aes(x = cut)) +
  geom_bar() + coord_flip()

## coord transformations
library(scales)
p + scale_y_log10()
p + scale_y_sqrt()
p + scale_y_reverse()
p + coord_flip()

ggplot(diamonds, aes(x = cut)) +
  geom_bar() + scale_y_reverse()

ggplot(diamonds, aes(x = carat, y = price,
                     color = color,
                     shape = cut)) +
  geom_point() + facet_wrap(~ clarity) +
  theme_bw()

## stacked, clustered bar charts
p <- ggplot(diamonds, aes(x = color, fill = cut))
p + geom_bar()
p + geom_bar(position = "fill")
p + geom_bar(position = "dodge")

## TODO histogram on price
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 100) +
 facet_wrap(~ cut)

ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 1000) +
  facet_wrap(~ cut)

## show kernel density per cut
ggplot(diamonds, aes(x = price, fill = cut)) +
  geom_density(alpha = 0.3)

## TODO heatmap on cut and color
ggplot(diamonds, aes(x = cut, y = color,
                     fill = price)) +
  geom_tile()

## TODO scatterplot on x, y, z
ggplot(diamonds, aes(x, y)) + geom_point()
dim(diamonds)

## slow
ggplot(diamonds, aes(x, y)) + geom_hex()
install.packages('hexbin')

## fit model caret and price
ggplot(diamonds, aes(carat, price,
                     color = cut)) +
  geom_point() + geom_smooth(method = 'lm')

## adding further layers
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(color = cut)) +
  geom_smooth(method = 'lm') +
  geom_smooth() +
  facet_wrap(~ color)


## themes
library(ggthemes)
p <- ggplot(diamonds, aes(carat, price, color = cut)) + geom_point()
p + theme_economist() + scale_colour_economist()
p + theme_stata() + scale_colour_stata()
p + theme_excel() + scale_colour_excel()
p + theme_wsj() + scale_colour_wsj("colors6", "")
p + theme_gdocs() + scale_colour_gdocs()

## custom theme
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
?theme

p + theme_classic()
p + theme_minimal()
theme_classic

library(GGally)
pairs(df)
ggpairs(df)

library(pairsD3)
pairsD3(df)

## fetching data from online sources
install.packages('XML')
library(XML)
df <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/FTSE_100_Index'),
                which = 2, header = TRUE, stringsAsFactors = FALSE)
str(df)

## fix column name
names(df)[4] <- 'Cap'
names(df)
str(df)

## dirty data
df$Cap <- as.numeric(df$Cap)
df$Employees <- as.numeric(sub(',', '', df$Employees))

## TODO min/max number of Employees
range(df$Employees)

## TODO min/max number of Employees in Banking sector
range(subset(df, Sector == 'Banking')$Employees)

## TODO min employees  per sector
aggregate(Employees ~ Sector, FUN = min, data = df)

## TODO visualize the employees & cap per sector
library(ggplot2)
ggplot(df, aes(x = Employees, y = Cap)) +
  geom_point() + facet_wrap(~ Sector)
ggplot(df, aes(x = Employees, y = Cap,
               color = Sector)) +
  geom_point()

## visualize companies in the Banking sector
## by Market Cap & No of Employees
banks <- subset(df, Sector == 'Banking')
ggplot(banks, aes(x = Employees, y = Cap)) +
  geom_text(aes(label = Company))

ggplot(df, aes(x = Employees, y = Cap)) +
  geom_text(aes(label = Company))

## avoid overlapping labels
library(ggrepel)
ggplot(df, aes(x = Employees, y = Cap)) +
  geom_text_repel(aes(label = Company))

## introduction to data.table
install.packages('data.table')
install.packages('hflights')
library(hflights)
?hflights

str(hflights)
library(data.table)
dt <- data.table(hflights)

## dt[i]
dt[DayOfWeek == 5]
dt[DayOfWeek == 5 & Month == 3]
dt[DayOfWeek == 5 & Month == 3, ActualElapsedTime]

## dt[i, j]
dt[DayOfWeek == 5 & Month == 3, mean(ActualElapsedTime)]

dt[DayOfWeek == 5 & Month == 3,
   mean(ActualElapsedTime, na.rm = TRUE)]

dt[is.na(ActualElapsedTime) & Cancelled == 0 & Diverted == 0]

## the avg flight time to LAX
dt[Dest == 'LAX', mean(AirTime, na.rm = TRUE)]

## avg flight time per dest
## dt[i, j, by = ...]
dta <- dt[, mean(AirTime, na.rm = TRUE), by = Dest]
dta
names(dta)[2] <- 'avgAirTime'

## multiple "j" expresions
dt[, .(
  minAvgTime = min(AirTime, na.rm = TRUE),
  avgAirTime = mean(AirTime, na.rm = TRUE),
  maxAirTime = max(AirTime, na.rm = TRUE)),
   by = .(Dest, Origin)]

## TODO number of cancelled flights to LAX
dt[Dest == 'LAX', sum(Cancelled)]
nrow(dt[Dest == 'LAX' & Cancelled == 1])
dt[Dest == 'LAX' & Cancelled == 1, .N]

dt[Cancelled == 1, .N, by = Dest]

## TODO sum of miles travelled to LAX
dt[Dest == 'LAX', sum(Distance)]

dt$distanceKm <- dt$Distance * 1.6
dt[, distanceKm := Distance * 1.6]

dt[Dest == 'LAX', sum(Distance) * 1.6]
dt[Dest == 'LAX', sum(distanceKm)]

## TODO percentage of flights cancelled per dest
dt[, sum(Cancelled == 1) / .N, by = Dest]
dt[, sum(Cancelled) / .N, by = Dest]
dt[, mean(Cancelled) * 100]

## TODO plot the departure and arrival delays
ggplot(dt, aes(ArrDelay, DepDelay)) + geom_point()
ggplot(dt, aes(ArrDelay, DepDelay)) + geom_hex()

## TODO plot the avg departure and arrival delay by dest:
##      aggregate, then visualize
dta <- dt[, list(
  arrival = mean(ArrDelay, na.rm = TRUE),
  departure = mean(DepDelay, na.rm = TRUE)
), by = Dest]

ggplot(dta, aes(x = departure, y = arrival)) +
  geom_text(aes(label = Dest))

## TODO visualize the avg flight time per dest
dta <- dt[, list(airtime = mean(AirTime, na.rm = TRUE)),
   by = Dest]
ggplot(dta, aes(x = Dest, y = airtime)) +
  geom_bar(stat = 'identity')

## heatmap => day of week + hour => N
install.packages("nycflights13")
library(nycflights13)
str(flights)

dt <- data.table(flights)
dt[, dayOfWeek := weekdays(as.Date(
  paste(year, month, day, sep = '-')
))]

dt[, date := paste(year, month, day, sep = '-')]
dt[, date := as.Date(date)]
dt[, dayOfWeek := weekdays(date)]

dta <- dt[, list(count = .N), by = list(dayOfWeek, hour)]
ggplot(dta, aes(x = hour, y = dayOfWeek, fill = count)) +
  geom_tile()

## long and wide tables
library(reshape2)
?dcast
?melt
dcast(dta, dayOfWeek ~ hour) # long -> wide
dta[dayOfWeek == 'Friday' & hour == 5]

dtw <- dcast(dta, hour ~ dayOfWeek)
melt(dtw, id.vars = 'hour') # wide -> long
