## #############################################################################
## EDA warmup
## #############################################################################

## read.csv -> fread for better performance and auto-transform to data.table
library(data.table)
df <- fread('http://bit.ly/CEU-R-numbers-set')
str(df)

summary(df)
table(df$x)

summary(df)
lapply(df, summary)
lapply(unique(df$x), function(set) summary(df[x == set]))

## data.table way
df[, as.list(summary(y)), by = x]

pairs(df)
library(GGally)
ggpairs(df)

library(ggplot2)
ggplot(df, aes(x, y)) + geom_point()
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method = 'lm')
ggplot(df, aes(x, y)) + geom_point(alpha = 0.1)
ggplot(df, aes(x, y)) + geom_jitter(alpha = 0.1)

## hexbin
ggplot(df, aes(x, y)) + geom_hex()

ggplot(df, aes(factor(x), y)) + geom_boxplot()
## NOTE jitter showed interesting patterns .. not visible

ggplot(df, aes(factor(x), y)) + geom_violin()
ggplot(df, aes(factor(x), y)) + geom_violin() + geom_jitter()
ggplot(df, aes(factor(x), y)) + geom_violin() +
  geom_jitter(width = 0.1, alpha = 0.1)

ggplot(df, aes(y)) + geom_histogram() + facet_wrap(~x)

ggplot(df, aes(y, fill = factor(x))) + geom_density()
ggplot(df, aes(y, fill = factor(x))) + geom_density(alpha = .25)
ggplot(df, aes(y, fill = factor(x))) +
  geom_density(alpha = .25) +
  theme(legend.position = 'top')

## df <- rbind(
##     data.table(x = 1, y = rbeta(1e3, 0.1, 0.1)),
##     data.table(x = 2, y = rnorm(1e3, 0.5, 0.75)),
##     data.table(x = 3, y = runif(1e3) * 2 - 0.5),
##     data.table(x = 4, y = rnorm(1e3, 0.5, 0.75)))

## TODO do similar exploratory data analysis on the below dataset
df <- fread('http://bit.ly/CEU-R-numbers')
## generated at https://gist.github.com/daroczig/23d1323652a70c03b27cfaa6b080aa3c

## TODO find interesting pattern in data?

ggplot(df, aes(x, y)) + geom_point() # slow?
ggplot(df, aes(x, y)) + geom_point(alpha = 0.05)
ggplot(df, aes(x, y)) + geom_point(size = 0.2, alpha = 0.1)
ggplot(df, aes(x, y)) + geom_hex(binwidth = 5)
ggplot(df, aes(x, y)) + geom_count()

df[, .N, by = list(x, y)]
ggplot(df[, .N, by = list(x, y)], aes(x, y, fill = N)) + geom_tile()

## TODO replicate https://www.research.autodesk.com/publications/same-stats-different-graphs/
install.packages('datasauRus')
library(datasauRus)
dt <- datasauRus::datasaurus_dozen

library(datasauRus)
datasaurus_dozen

library(ggplot2)
ggplot(datasaurus_dozen, aes(x, y)) +
  geom_point() + facet_wrap(~dataset)

## just another mapping!
library(gganimate)
ggplot(datasaurus_dozen, aes(x, y)) +
  geom_point() + geom_smooth(method = 'lm') +
  transition_states(dataset)

## #############################################################################
## modeling
## #############################################################################

# https://www.dropbox.com/scl/fi/q2iot650arzlb8cppwf4r/white-and-red-points.csv?rlkey=59rxme3a1yc3mmlja259vbs3m&st=gbdynstv&dl=1
library(data.table)
points <- fread('https://bit.ly/white-red-points')

str(points)
summary(points)

library(ggplot2)
ggplot(points, aes(x, y)) + geom_point()
ggplot(points, aes(x, y)) + geom_point() + facet_wrap(~col)

ggplot(points, aes(col, x)) + geom_boxplot()

ggplot(points, aes(x, y, color = col)) + geom_point() +
  scale_color_manual(values = c("red", "white")) +
  theme_minimal() +
  theme(legend.position = 'none') +
  coord_equal()

## #############################################################################
## let's try a super simple model: logistic regression
## drawing a straight line that separates red from white?
fit <- glm(col ~ x + y, data = points, family = binomial(link = 'logit'))
## NOTE the error .. targeting a character variable?
points$col <- factor(points$col)
## fread(..., stringsAsFactors=TRUE)
fit <- glm(col ~ x + y, data = points, family = binomial(link = 'logit'))
summary(fit)
## high log-odds for a pixel being white ... no predictive power in x or y
## let's see exact value by using the inverse logit/logistic function:
plogis(3.39)
## 0.9682477

## let's see the predicted probabilities
points$pred <- predict(fit, points, type = 'response')
ggplot(points, aes(x, y, color = pred)) + geom_point() +
  theme_void() + theme(legend.position = 'none') +
  scale_color_gradient(low = 'white', high = 'red') +
  coord_equal()
## check the legend: between 0.967 ... 0.968 probabilities

## let's return the actual number with a threashold of 0.5
points$pred <- factor(ifelse(predict(fit, points, type = 'response') > 0.5, 'white', 'red'))
ggplot(points, aes(x, y, color = pred)) + geom_point() +
  theme_void() + theme(legend.position = 'none') +
  scale_color_manual(values = c('white', 'red')) +
  coord_equal()

## confusion matrix
points[, .N, by = .(col, pred)]

## TODO how to improve this "model"?

## 1st try: feature engineering to measure the distance from the center
points$x2 <- abs(0.5 - points$x)
points$y2 <- abs(0.5 - points$y)

fit <- glm(col ~ x2 + y2, data = points, family = binomial(link = 'logit'))
summary(fit)
## all coefficients are significant! intercept -18 means 0 chance of being white in the middle.
## the 143s means that as we get further from the center, the chance of being white increases.
points$pred <- factor(ifelse(predict(fit, points, type = 'response') > 0.5, 'white', 'red'))

## visualize the results
ggplot(points, aes(x, y)) + geom_point(aes(color = col), size=1, alpha=0.5) +
  theme_void() + theme(legend.position = 'none') +
  scale_color_manual(values = c("red", "white")) +
  geom_point(aes(color = pred), size = 0.5)

## visualize the original colors and the predicted as well
ggplot(points, aes(x, y)) + geom_point(aes(color = col), size=2, alpha=0.5) +
    theme_void() + theme(legend.position = 'none') +
    scale_color_manual(values = c("red", "white")) +
    geom_point(aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("red", "white"))

# visualize with artificial background
n <- 250
base <- data.frame(x = rep(seq(0, 1, 1/n), each = n-1), y = rep(seq(0, 1, 1/n), times = n-1))
base$col <- 'white'
base$col[sqrt((base$x - 0.5) ^ 2 + (base$y - 0.5) ^ 2) < 0.1] <- 'red'
ggplot(base, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white")) +
    geom_point(data = points, aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("black", "transparent"))

## confusion matrix
points[, .N, by = .(col, pred)]

## TODO improve this further!
points$x2 <- (0.5 - points$x)^2
points$y2 <- (0.5 - points$y)^2

## what about no feature engineering at all?

## #############################################################################
## other approaches #1: k-nearest neighbors

library(class)
knn(points[, .(x, y)], data.frame(x=0.5, y=0.5), points$col, k = 5)

## TODO backtest for all points and visualize the results + confusion matrix
points$pred <- knn(points[, .(x, y)], points[, .(x, y)], points$col, k = 5)
points[, .N, by = .(col, pred)]

## #############################################################################
## other approaches #2: decision trees

library(rpart)
fit <- rpart(col ~ x + y, points)
fit

plot(fit)
text(fit)

library(partykit)
plot(as.party(fit))

points$pred <- predict(fit, points, type = "response") # note error
points$pred <- predict(fit, points, type = "class")

ggplot(base, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white")) +
    geom_point(data = points, aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("black", "transparent"))

## TODO how to improve?
?rpart
?rpart.control

## stub
fit <- rpart(col ~ x + y, points, maxdepth = 1)
points$pred <- predict(fit, points, type = "class")

ggplot(base, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white")) +
    geom_point(data = points, aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("black", "transparent"))

## what happened? all white ...
fit
plot(as.party(fit))

## let's grow a larger tree
fit <- rpart(col ~ x + y, points, control = rpart.control(cp = 0, minsplit = 1))
points$pred <- predict(fit, points, type = "class")

ggplot(base, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white")) +
    geom_point(data = points, aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("black", "transparent"))

fit
plot(as.party(fit))
## "nicely" overfitted model!

## now what was that partykit?
library(party)
fit <- ctree(col ~ x + y, data = points)
?ctree
?ctree_control

plot(fit) # all white

## #############################################################################
## other approaches #3: random forest
library(randomForest)
fit <- randomForest(col ~ x + y, data = points)
fit
points$pred <- predict(fit, points, type = "class")

ggplot(base, aes(x, y, fill = col)) + geom_tile() +
    theme_void() + theme(legend.position = 'none') +
    scale_fill_manual(values = c("red", "white")) +
    geom_point(data = points, aes(x, y, color = pred), size = 1) +
    scale_color_manual(values = c("black", "transparent"))

## TODO compare with confusion matrix manually
points[, .N, by = .(col, pred)]

## let's try with only 10  trees .. still super good results!
fit <- randomForest(col ~ x + y, data = points, ntree = 10)
fit
points$pred <- predict(fit, points, type = "class")

## #############################################################################
## other approaches #4: GBM (Gradient Boosting Machines)
library(gbm)
fit <- gbm(col ~ x + y, data = points)
## note the error .. we need to convert the factor to a numeric
points$col_num <- ifelse(points$col == 'white', 1, 0)
fit <- gbm(col_num ~ x + y, data = points)
fit

points$pred <- predict(fit, points, type = "response")
points$pred <- factor(ifelse(predict(fit, points, type = 'response') > 0.5, 'white', 'red'))

## try allowing deeper trees
fit <- gbm(col_num ~ x + y, data = points, interaction.depth = 2)
