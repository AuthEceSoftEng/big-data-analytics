rm(list=ls())

people = read.csv("people.txt")

people = read.csv("people.txt", sep = ';', header = FALSE, col.names = c("Age", "Height", "Weight"))

m = median(people$Weight, na.rm = TRUE)
people$Weight[is.na(people$Weight)] = m

