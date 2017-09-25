## #############################################################################
## a techie intro into repetitive tasks
## #############################################################################

for (counter in 1:5) {
    print(counter)
}

## looping
set.seed(9)
plot(cumsum(round(runif(25))*2 - 1), type = 's')
plot(cumsum(round(runif(25))*2 - 1), type = 's', ylim = c(-10, 10))
for (counter in 2:5) {
  lines(cumsum(round(runif(25))*2 - 1), type = 's', col = counter)
}

set.seed(9)
sum(round(runif(25))*2 - 1)
sum(round(runif(25))*2 - 1)
sum(round(runif(25))*2 - 1)
sum(round(runif(25))*2 - 1)
sum(round(runif(25))*2 - 1)

## TODO check the distribution of values after the 25th iteration
set.seed(9)
x <- sum(round(runif(25))*2 - 1)
for (i in 1:50) { # 1000
    x <- c(x, sum(round(runif(25))*2 - 1))
}
hist(x)
## rings a bell?

hist(replicate(1000, sum(round(runif(25))*2 - 1)))

## do something until ...
set.seed(9)
x <- sum(round(runif(25))*2 - 1)
for (i in 1:5000) {
    if (x > 20) {
        print('found it!')
        break()
    }
    x <- sum(round(runif(25))*2 - 1)
}
## increase x to 15
## increase x to 20 -> increase counter -> Inf -> while?

set.seed(9)
x <- sum(round(runif(25))*2 - 1)
while (x < 20) {
    x <- sum(round(runif(25))*2 - 1)
}

set.seed(9)
x <- sum(round(runif(25))*2 - 1)
counter <- 0
while (x < 20) {
    counter <- counter + 1
    x <- sum(round(runif(25))*2 - 1)
}

## we know for loops and if conditions!
