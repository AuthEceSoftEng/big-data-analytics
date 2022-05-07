rm(list=ls())

m = matrix(1:9,byrow = TRUE, nrow=3)
m

m2 = matrix(10:18,byrow = TRUE, nrow=3)
Mat = cbind(m,m2)   # or rbind() to connect the matrices by rows
Mat
rowSums(Mat)
colSums(Mat)
mean(Mat)

a = matrix(10:18,byrow = TRUE, nrow=3)
b = matrix(c(3,6,7,10,8,1,2,3,2),byrow = TRUE, nrow=3)
a*b                 # Multiply elements one-by-one
a%*%b               # Multiply matrices

