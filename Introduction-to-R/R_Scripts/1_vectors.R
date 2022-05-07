rm(list=ls())

A = c(10,5,3,100,-2,5,-50)
A

A[c(1,3:5)]

A > 5
which(A>5)         # Returns the positions for the elements of A that are higher than 5

S = A > 0          # Find with (TRUE, FALSE) the positive elements of A
positives = A[A>0] # Select positive elements of A
positives          # Print positives to screen

A = c(10,5,3,100,-2,5,-50)
B = c(1 ,2, 5, 6, 9, 0, 100)
cbind(A,B)         # Add as column
rbind(A,B)         # Add as row

