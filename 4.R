## DT examples
set.seed(42)
tx <- data.table(
    item   = sample(letters[1:3], 10, replace = TRUE),
    time   = as.POSIXct(as.Date('2016-01-01')) - runif(10) * 36*60^2,
    amount = rpois(10, 25))
prices <- data.table(
    item  = letters[1:3],
    date  = as.Date('2016-01-01') - 1:2,
    price = as.vector(outer(c(100, 200, 300), c(1, 1.2))))
items <- data.table(
    item   = letters[1:3],
    color  = c('red', 'white', 'red'),
    weight = c(2, 4, 2.5))

## DT exercises
## TODO filter for the transaction with "b" items
tx[item == 'b']
## TODO filter for the transaction with less than 25 items
tx[amount < 25]
## TODO filter for the transaction with less then 25 "b" items
tx[item == 'b' & amount < 25]
## TODO count the number of transactions for each items
tx[, .N, by = item]
## TODO count the number of transactions for each day
tx[, date := as.Date(time)]
tx[, .N, by = date]
## TODO count the overall number of items sold on each day
tx[, sum(amount), by = date]

## #############################################################################
## joins
## #############################################################################

merge(tx, items, by = 'item')

setkey(tx, item)
setkey(items, item)
items[tx]

tx <- items[tx]

## TODO count the number of transactions with "red" items
tx[color == 'red', .N]

## TODO count the overall revenue per colors
setkey(prices, item, date)
setkey(tx, item, date)
tx <- prices[tx]
tx[, sum(price * amount), by = color]

## TODO count the overall weight of items sold on each day
tx[, sum(weight), by = date]

## TODO create a frequency table on the number of sold items per color
tx[, .N, by = color]

## #############################################################################
## wide and long tables
## #############################################################################

## TODO create a frequency table on the number of sold items per color and date
tx[, .N, by = .(color, date)]

## traditional frequency table
table(tx$color, tx$date)

## reshape long and wide tables
ft <- tx[, .N, by = .(color, date)]
dcast(ft, date ~ color)
dcast(ft, color ~ date)

## ggplot needs long data
ft  <- dcast(ft, color ~ date)
ftl <- melt(ft, id.vars = 'color')
ggplot(ftl, aes(variable, value, fill = color)) + geom_bar(stat = 'identity')

## but we do not need to do that
ftl <- tx[, .N, by = .(color, date)]
ggplot(ftl, aes(date, N, fill = color)) + geom_bar(stat = 'identity')

## #############################################################################
## rolling joins
## #############################################################################

## TODO find the percentage of amount change between transactions
tx[, diff(amount)]

## but we need to order by time first
setkey(tx, date)
tx[, diff(amount)]

## but now we want to merge the purchase price for the sold items
purchases <- data.table(
    item = letters[1:3],
    date = as.Date('2016-01-01') - c(1, 10),
    cost = as.vector(outer(c(100, 200, 300), c(0.5, 0.75))))

setkey(tx, item, date)
setkey(purchases, item, date)
purchases[tx] # mind the NAs

purchases[tx, roll = TRUE]
purchases[tx, roll = 7]  # roll to purchase in the past week
purchases[tx, roll = 30] # roll to purchase in the past month
purchases[tx, roll = -1] # merge to the future cost

## #############################################################################
## introduction to modeling
## #############################################################################

df <- read.csv('http://bit.ly/BudapestBI-R-csv')
setDT(df)

df[, height := heightIn * 2.54]
df[, weight := weightLb * 0.45]

## compare a continuous variable by groups (categorical variable)
ggplot(df, aes(sex, height)) + geom_boxplot()
## statistical test: t-test, ANOVA
t.test(height ~ sex, data = df) # diff (see means)

## generalize this to multiple groups
aov(height ~ sex, data = df)
summary(aov(height ~ sex, data = df))
summary(aov(weight ~ sex, data = df))

## compare categorical variables
df[, high := height > mean(height)]
str(df)
table(df$sex, df$high)
chisq.test(table(df$sex, df$high))

## TODO do this in the data.table way
df[, .N, by = .(sex, high)]
dcast(df[, .N, by = .(sex, high)], sex ~ high)

chisq.test(dcast(df[, .N, by = .(sex, high)], sex ~ high)) # error
chisq.test(dcast(df[, .N, by = .(sex, high)], sex ~ high)[, -1])

library(descr)
CrossTable(df$sex, df$high, chisq = TRUE)
CrossTable(df$sex, df$high, asresid = TRUE, chisq = TRUE)

## #############################################################################
## Simpson's paradox
## #############################################################################

library(openxlsx)
download.file('http://bit.ly/bickel-1975', 'bickel.xlsx', method = 'curl', extra = '-L')
df <- read.xlsx('bickel.xlsx')
setDT(df)
## all data are dirty
names(df)[1] <- 'department'

## University of California, Berkeley was sued for bias against women in 1973
## due to the percentage of admissions being lower for females
df[, sum(admissions) / sum(applicants), by = gender]

## seems to be right
ft <- df[, .(Y = sum(admissions), N = sum(applicants) - sum(admissions)), by = gender]
chisq.test(ft[, .(Y, N)])

## BUT: if we do the same analysis for each department,
##      this does not stand any more
ft <- df[, .(Y = sum(admissions), N = sum(applicants) - sum(admissions)), by = .(gender, department)]
chisq.test(ft[department == 'A', .(Y, N)])
chisq.test(ft[department == 'B', .(Y, N)])
chisq.test(ft[department == 'C', .(Y, N)])
chisq.test(ft[department == 'D', .(Y, N)])
chisq.test(ft[department == 'E', .(Y, N)])
chisq.test(ft[department == 'F', .(Y, N)])

## and more interestingly:
## it seems the admission/rejection rate is very different for the departments
ft <- df[, .(Y = sum(admissions), N = sum(applicants) - sum(admissions)), by = department]
ft
ft[, P := round(Y/(Y+N) * 100, 2)]
ft
chisq.test(ft[, .(Y, N)])

## turns out males and females tend to apply for different departments
ft <- df[, .(applicants = sum(applicants)), by = .(department, gender)]
ft <- dcast(ft, department ~ gender)
setDT(ft)
ft[, ratio := f / m]
ft
