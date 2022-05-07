rm(list=ls())

# See details about iris dataset
str(iris)

# See stats of iris dataset
summary(iris)

# Compute statistics for a vector
sl = iris$Sepal.Length  # Select column Sepal.Length of iris dataset
mean(sl)
median(sl)
min(sl)
max(sl)
sd(sl)      # Standard Deviation
var(sl)     # Variance
range(sl)

# Find cross correlation for columns 1 to 4 of iris dataset
cor(iris[1:4])

