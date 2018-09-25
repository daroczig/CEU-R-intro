## #############################################################################
## reminder on data frames
## #############################################################################

df <- read.csv('http://bit.ly/CEU-R-heights')

## TODO check the number of observation
length(df)
str(df)
nrow(df)
?nrow
dim(df)

## dim returns same as
c(nrow(df), ncol(df))

## TODO check the height of the 2nd respondent
df$heightIn[2]
df[2, 4]
df[2, 'heightIn']
df[2, "heightIn"]

## TODO compute height in cm
df$heightIn * 2.54
str(df)
df$height <- df$heightIn * 2.54
str(df)

##
df$heightIn <- NULL
str(df)

## TODO compute weight in kg
df$weight <- df$weightLb * .45
str(df)

## TODO compute BMI
df$bmi <- df$weight / (df$height/100)^2

## removing 2 columns
df$weightLb <- df$ageMonth <- NULL
str(df)

## quick EDA
plot(df) ## data.frame
pairs(df)
class(df)

## why ggplot?
install.packages('GGally')
library(GGally)
ggpairs(df)

## interactivity
install.packages('pairsD3')
library(pairsD3)
pairsD3(df)

## ############################################################################
## more business-like data

hotels <- read.csv('http://bit.ly/CEU-R-hotels-2018-prices')
str(hotels)

## TODO print all rows with hotel_id equals to 1

hotels[2, ]
table(hotels[, 'hotel_id'] == 1)
hotels[hotels[, 'hotel_id'] == 1, ]
which(hotels[, 'hotel_id'] == 1)
hotels[which(hotels[, 'hotel_id'] == 1), ]

## http://bit.ly/CEU-R-hotels-2018-metadata
library(readxl)
read_excel('~/downloads/VARIABLES.xlsx')
variables <- read_excel('VARIABLES.xlsx')
## windows: c:\\Users\\foobar\\Downloads ...
## windows: c:/Users/foobar/Downloads ...
variables <- data.frame(variables)
variables <- variables[21:30, ]
variables

## TODO weekend
min(hotels$weekend)
max(hotels$weekend)
sum(hotels$weekend)
mean(hotels$weekend)
table(hotels$weekend)

## convert to flag
str(hotels$weekend)
example <- hotels$weekend[1:20]
example == 1
as.logical(example)

hotels$weekend <- as.logical(hotels$weekend)
str(hotels)

hotels$holiday <- as.logical(hotels$holiday)
hotels$scarce_room <- as.logical(hotels$scarce_room)
hotels$offer <- as.logical(hotels$offer)
str(hotels)


ggpairs(hotels)

summary(hotels)

## TODO count the number of bookings with price > 10,000 EUR
hotels[which(hotels$price > 10000), ]

length(which(hotels$price > 10000))
str(hotels$price > 10000)
table(hotels$price > 10000)
sum(hotels$price > 10000)

## TODO compute the average price of a booking in April
mean(hotels$price[which(hotels$month == 4)])
## df[, ]
##  v[]

mean(hotels$price[which(hotels$month == 5)])

## TODO which month is the most expensive on avg?
aggregate(price ~ month, hotels, FUN = mean)

## TODO convert numeric vector -> categorical
hist(hotels$price)
?cut
table(cut(hotels$price, c(0, 500, 1000, 5000), dig.lab = 8))

