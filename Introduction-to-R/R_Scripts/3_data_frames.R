rm(list=ls())

n = c(2, 3, 5)
s = c("aa", "bb", "cc")
b = c(TRUE, FALSE, TRUE)

# Create data frame df and print it to screen
df = data.frame(n, s, b)
df

# Print column n of the data frame using character '$'
df$n

