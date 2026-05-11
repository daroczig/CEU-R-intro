## #############################################################################
## antipatterns
## #############################################################################

## how to list programatically objects from RStudio IDE's environment tab?
ls()

## clean your R session from past objects ...
## and the set RStudio to never save your session again
rm(list = ls())

## running an R script from a trusted source
## NOTE never do this again!
source('http://bit.ly/CEU-R-heights-2018')
ls()
heights

## TODO compute the average height of this group
mean(heights, na.rm = TRUE)
## TODO visualize the data
library(ggplot2)
ggplot(data.frame(heights), aes(heights)) + geom_histogram()
ggplot(data.frame(heights), aes(heights)) + geom_boxplot()

## had enough .. let's clean up the session
rm(list = ls())

## but wow:
ls(all = TRUE)
.secret # "A warm hello from the Internet."

## learnings: don't `source` from the Internet, and don't rm(list = list())
## https://twitter.com/hadleywickham/status/940021008764846080

## #############################################################################
## warm-up exercise and security reminder

## we learned at the "Intro to R" course that we should not do this:
source('http://bit.ly/CEU-R-shoes')

## let's install a package instead!
install.packages('remotes')
remotes::install_github('daroczig/students')

library(students)
?students

## this is a dataset on students from a study group,
## where we run a math test and found interesting association with the shoe size
## TODO EDA
students

cor(students$shoe, students$math)
lm(math ~ shoe, students)

plot(students$shoe, students$math)
abline(lm(math ~ shoe, students), col = 'red')

library(ggplot2)
ggplot(students, aes(math, shoe)) + geom_point() + geom_smooth(method = 'lm')

## EDA - everyone!
str(students)
summary(students)
plot(students)

library(ggplot2)
ggplot(students, aes(math, shoe, color = z)) + geom_point()
ggplot(students, aes(math, shoe, color = y)) + geom_point() # !!

library(GGally)
ggpairs(students)

## https://datavizuniverse.substack.com/p/navigating-the-table-jungle
library(gtExtras)
gt_plt_summary(students)

## partial correlation
residuals(lm(math ~ x, students))
residuals(lm(shoe ~ x, students))
cor(residuals(lm(math ~ x, students)), residuals(lm(shoe ~ x, students)))

library(psych)
partial.r(students, 1:2, 3)

plot(residuals(lm(math ~ x, students)), residuals(lm(shoe ~ x, students)))
abline(lm(residuals(lm(math ~ x, students)) ~ residuals(lm(shoe ~ x, students))))

plot(residuals(lm(math ~ x, students)), residuals(lm(shoe ~ x, students)))
abline(lm(residuals(lm(shoe ~ x, students)) ~ residuals(lm(math ~ x, students))))

## had enough
rm(list = ls())

## but wow!
students
.secret # "A warm hello from the Internet."
## TODO look at the source code of the package!
## TODO always install from trusted source

## #############################################################################
## MDS examples

## download data to a file in your temp folder
t <- tempfile()
t
t <- tempfile(fileext = '.xls')
t

## or keep in the current working directory
t <- 'cities.xls'

# points to https://www.dropbox.com/scl/fi/j37yk84qvczdsojz532eb/de-cities-distance.xls?rlkey=7wuif6cm3wvvgqwqf18dg31rp&st=n0zd9xxx&dl=1
download.file('https://bit.ly/de-cities-matrix', t, mode = 'wb')

## further checks on the downloaded file
file.info(t)
pander::openFileInOS(t)

## read the downloaded file
library(readxl)
cities <- read_excel(t)

cities
## tibble VS data.frame VS data.table
str(cities)

## get rid of 1st column and last three rows (metadata)
cities <- cities[, -1]
cities <- cities[1:(nrow(cities) - 3), ]
str(cities)

mds <- cmdscale(as.dist(cities))
mds

plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## TODO interpret what we see
## looks like German cities on a rotated map ... Berlin NW, Munich SW, Dortmund/Dusseldorf W

## flipping both x and y axis
mds <- -mds
plot(mds)
text(mds[, 1], mds[, 2], names(cities))
## flipping only on y axis
mds[, 1] <- -mds[, 1]
plot(mds)
text(mds[, 1], mds[, 2], names(cities))
## flipping only on x axis
mds[, 2] <- -mds[, 2]
plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## TODO ggplot2 way
mds <- as.data.frame(mds)
mds$city <- rownames(mds)
str(mds)

library(ggplot2)
ggplot(mds, aes(V1, V2, label = city)) +
    geom_text() + theme_bw()

## flip one axis and grid
ggplot(mds, aes(V1, -V2, label = city)) +
    geom_text() + theme_void()

## #############################################################################
## TODO visualize the distance between the European cities
## stored in the built-in dataframe:

?eurodist

mds <- cmdscale(eurodist)
mds <- as.data.frame(mds)
mds$city <- rownames(mds)
ggplot(mds, aes(V1, -V2, label = city)) +
    geom_text() + theme_bw()

## #############################################################################
## TODO non-geo example

?mtcars
str(mtcars)
mtcars

mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))
## oh no, the overlaps!

mds <- as.data.frame(mds)
mds$car <- rownames(mds)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text() + theme_bw()

library(ggrepel)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text_repel() + theme_bw()

## #############################################################################
## QQ what does it mean that two cards are "close to each other"?
## NOTE think about why the above visualization is off

## check actual distances eg for Camaro (or other sport cars)
which(rownames(mtcars) == 'Camaro Z28')
sort(as.matrix(dist(mtcars))[, 24])
## Mercedes sedans are closer?! than e.g. Ferrari Dino or Maserati Bora

mtcars

subset(mtcars, hp >= 245)

?cmdscale
?dist

summary(mtcars)

## need to standardize to give every variable equal weight!
mtcars$hp - mean(mtcars$hp)
mean(mtcars$hp - mean(mtcars$hp))

(x <- (mtcars$hp - mean(mtcars$hp)) / sd(mtcars$hp))
mean(x)
sd(x)
hist(x)

x
scale(mtcars$hp)
plot(x, scale(mtcars$hp))
x - scale(mtcars$hp)

plot(mtcars$hp, scale(mtcars$hp))

?scale
scale(mtcars)

mds <- cmdscale(dist(scale(mtcars)))
mds <- as.data.frame(mds)
mds$car <- rownames(mds)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text_repel() + theme_bw()

subset(mtcars, hp >= 200)

## #############################################################################
## introduction to Simpson's paradox with the Berkeley example

## then do the analysis in R
UCBAdmissions
plot(UCBAdmissions)

berkeley <- as.data.frame(UCBAdmissions)

ggplot(berkeley, aes(Gender, Freq, fill = Admit)) + geom_col()

p <- ggplot(berkeley, aes(Gender, Freq, fill = Admit)) + geom_col(position = 'fill')
p

p + facet_wrap(~Dept)
p + facet_wrap(~Dept) + scale_fill_manual(values = c('Admitted' = 'darkgreen', 'Rejected' = 'red'))
# https://colorbrewer2.org
p + facet_wrap(~Dept) + scale_fill_brewer(palette = 'Dark2')

ggplot(berkeley, aes(Gender, Freq, fill = Admit)) + geom_col() +
    facet_wrap(~Dept) + scale_fill_brewer(palette = 'Dark2')

## TODO iris
## TODO anscombe if we want to
## TODO DV2: 3.R


## #############################################################################
## intro to data.table
## #############################################################################

## let's get back to the heights datasets
df <- read.csv('https://bit.ly/height-weight-csv')

## TODO plot number of girls and boys below and above 160 cm!
## maybe a stacked barchart?

df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45
df$bmi <- df$weight / (df$height/100)^2

ggplot(df, aes(x = sex, y = ...)) + geom_bar()
## need to transform the data ...
df$height_cat <- df$height < 160
table(df$height_cat)
df$height_cat <- cut(df$height, breaks = c(0, 160, Inf))
table(df$height_cat)

ggplot(df, aes(x = sex, fill = height_cat)) + geom_bar()
ggplot(df, aes(x = sex, fill = height_cat)) + geom_bar(position = "dodge")
ggplot(df, aes(x = sex, fill = height_cat)) + geom_bar(position = "fill")

## avg height per gender
mean(df[df$sex == "f", "weight"])

dff <- subset(df, sex == 'f')
mean(dff$weight)

aggregate(height ~ sex, FUN = mean, data = df)

## there must be a better way!
library(data.table)
dt <- data.table(df)
dt # VS df!

## dt[i]
dt[1]
dt[1:5]
dt[sex == "f"]
dt[sex == "f"][1:5] # chaining
dt[ageYear == min(ageYear)]
dt[ageYear == min(ageYear)][order(height)]

dt[round(runif(1)*.N)]
dt[round(runif(10)*.N)]
dt[.N]

## dt[i, j]
dt[, mean(height)]
dt[ageYear == min(ageYear), mean(height)]
dt[ageYear == min(ageYear), summary(height)]
dt[ageYear == min(ageYear), hist(height)]

## TODO compute the average height of girls and boys
dt[sex == "f", mean(height)]
dt[sex == "m", mean(height)]

## dt[i, j, by]
dt[, mean(height), by = sex]
dt[, list(H = mean(height)), by = list(gender = sex)]
## note that list can be abbreviated by a dot (.) in data.table
dt[, .(H = mean(height)), by = .(gender = sex)]
dt[, .(H = mean(height), W = mean(weight)), by = .(gender = sex)]
dt[, .(H = mean(height), W = mean(weight)), by = .(gender = sex, elementary_school = ageYear < 14)]

## count the number of folks below/above 12 yrs
dt$agecat <- cut(dt$ageYear, c(0, 12, Inf))
dt[, agecat := cut(ageYear, c(0, 12, Inf))]
dt[, .N, by = agecat]
## show the average weight of high BMI (25) folks
dt[bmi > 25, mean(weight)]
## categorize folks to underweight (<18.5)/normal/overweight (25+)
dt[, bmicat := cut(bmi, c(0, 18.5, 25, Inf))]
## stacked bar chart for BMI categorization split by gender
ggplot(dt, aes(x = sex, fill = bmicat)) + geom_bar()
ggplot(dt[, .N, by = .(sex, bmicat)], aes(x = sex, y = N, fill = bmicat)) + geom_col()
