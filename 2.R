## Review R object types from yesterday

2
pi
'pi'
1:5
runif(5)
c(1, 3, 5)
c('a', 'b', 'c')
letters[1:3]
str(letters)
letters[c(1, 3)]

## custom vectors -> combine values into vector
h <- c(174, 170, 160)
w <- c(90, 80, 70)

## render a scatterplot
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')

## compute the correlation coefficient
cor(w, h)

## build a basic linear model
lm(w ~ h)
fit <- lm(w ~ h)
summary(fit)

## plot this model
plot(h, w, main = "Demo", xlab = 'Height', ylab = 'Weight')
abline(fit, col = 'red')

## intro to data.frame object type
df <- data.frame(weight = w, height = h)
df
str(df)
df[1, ]
df[, 1]
df[3, 2]
df$weight
df$weight[2]

## TODO how do you get 174 from the above matrix
df[1, 2]

## compute Body Mass Index (BMI) by:
## a person's weight in kilograms divided by the square of height in meters
df$height <- df$height / 100
df
df$bmi <- df$weight / df$height^2
df

## import more data with similar structure
df <- read.csv('http://bit.ly/BudapestBI-R-csv')
str(df)

## TODO compute weight in kg, height in cm and BMI
df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / (df$height/100)^2
str(df)

## #############################################################################
## basic plots
## #############################################################################

## draw a histogram
hist(df$bmi)
## add two vertical lines with the limits of normal BMI
abline(v = c(18.5, 25), col = 'red')

## density plot on the same variable
plot(density(df$bmi))

## boxplot on the same variable
boxplot(df$bmi)
## with a split by gender
boxplot(bmi ~ sex, df)

## boxplot alternatives
install.packages('vioplot')
library(vioplot)
par(mfrow=c(1,2))
boxplot(df$bmi)
## the violin plot includes the above boxplot + the kernel density plots
vioplot(df$bmi)

library(beanplot)
par(mfrow=c(1,2))
boxplot(df$bmi)
beanplot(df$bmi)

## revert the graphical device to include only one plot in the future
par(mfrow=c(1,1))

## example on the advantages of vioplot over boxplot
boxplot(
  rbeta(1e3, 0.1, 0.1),
  runif(1e3)*2-0.5,
  rnorm(1e3, 0.5, 0.75))

vioplot(
  rbeta(1e3, 0.1, 0.1),
  runif(1e3)*2-0.5,
  rnorm(1e3, 0.5, 0.75))

## some pie chart alternatives
pie(table(df$sex))
barplot(table(df$sex))
dotchart(table(df$sex))
dotchart(table(df$sex), xlim = c(0, 150))

## last important basic EDA plot
pairs(df)
plot(df)

## #############################################################################
## Wilkinson: The Grammar of Graphics
## R implementation by Hadley Wickham: ggplot2
## #############################################################################

library(ggplot2)
?diamonds

## barplot with ggplot: you specify a dataset, then define an aesthetic and geom
ggplot(diamonds, aes(x = cut)) + geom_bar()
## and optionally some further layers (theme)
ggplot(diamonds, aes(x = cut)) + geom_bar() + theme_bw()
ggplot(diamonds, aes(x = cut)) + geom_bar(colour = "darkgreen", fill = "white") + theme_bw()

## we can store the resulting plot as an R object for future reuse
p <- ggplot(diamonds, aes(x = cut)) + geom_bar(colour = "darkgreen", fill = "white") + theme_bw()
p

## it's better to split long lines for easier reading
p <- ggplot(diamonds, aes(x = cut)) +
     geom_bar(colour = "darkgreen", fill = "white") +
     theme_bw()
p


## coord transformations
library(scales)
p + scale_y_log10()
p + scale_y_sqrt()
p + scale_y_reverse()
p + coord_flip()

## facet => create separate plots per group
p + facet_wrap( ~ clarity)
p + facet_grid(color ~ clarity)

## stacked, clustered bar charts
p <- ggplot(diamonds, aes(x = color, fill = cut))
p + geom_bar()
p + geom_bar(position = "fill")
p + geom_bar(position = "dodge")

## histogram
ggplot(diamonds, aes(x = price)) + geom_bar(binwidth = 100)
ggplot(diamonds, aes(x = price)) + geom_bar(binwidth = 1000)
ggplot(diamonds, aes(x = price)) + geom_bar(binwidth = 10000)

## density plot
ggplot(diamonds, aes(price, fill = cut)) + geom_density(alpha = 0.2) + theme_bw()

## scatterplot
p <- ggplot(diamonds, aes(x = carat, y = price)) + geom_point()

## stacking layers
p
p <- p + geom_smooth()
p
p + geom_smooth(method = "lm", se = FALSE, color = 'red')

ggplot(diamonds, aes(x = carat, y = price, colour = cut)) + geom_point() + geom_smooth()

## themes
library(ggthemes)
p + theme_economist() + scale_colour_economist()
p + theme_stata() + scale_colour_stata()
p + theme_excel() + scale_colour_excel()
p + theme_wsj() + scale_colour_wsj("colors6", "")
p + theme_gdocs() + scale_colour_gdocs()

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
p <- ggplot(diamonds, aes(x = carat, y = price, colour = cut)) + geom_point()
p + theme_custom()
## pick a color palette from http://colorbrewer2.org/
p + theme_custom() + scale_color_brewer(palette = "Greens")
## see more examples at http://docs.ggplot2.org/dev/vignettes/themes.html

## quick exploratory data analysis with ggplot (similar to the pairs command)
library(GGally)
ggpairs(diamonds)
ggpairs(df)

## JavaScript libraries
library(pairsD3)
pairsD3(df)

## Further reading at http://www.cookbook-r.com/Graphs/

## TODO on mtcars
##  * number of carburators
##  * hp
##  * barplot of carburators per am
##  * boxplot of hp by carb
##  * hp and wt by carb
##  * hp and wt by carb regression
