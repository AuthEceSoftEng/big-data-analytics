setwd("C:/Users/Thomas/Desktop/BDA Med/Practical/Classification/")

# Decision Trees

weather = read.csv("weather.csv", stringsAsFactors = TRUE)

library(rpart)
library(rpart.plot)

model <- rpart(Play ~ Outlook, method = "class", data = weather, minsplit = 1)
rpart.plot(model, extra = 104, nn = TRUE)

model <- rpart(Play ~ Temperature, method = "class", data = weather, minsplit = 1)
rpart.plot(model, extra = 104, nn = TRUE)

model <- rpart(Play ~ Humidity, method = "class", data = weather, minsplit = 1)
rpart.plot(model, extra = 104, nn = TRUE)

absfreq = table(weather[, c(1, 4)])
freq = prop.table(absfreq, 1)
freqSum = rowSums(prop.table(absfreq))
GINI_Sunny = 1 - freq["Sunny", "No"]^2 - freq["Sunny", "Yes"]^2
GINI_Rainy = 1 - freq["Rainy", "No"]^2 - freq["Rainy", "Yes"]^2
GINI_Outlook = freqSum["Sunny"] * GINI_Sunny + freqSum["Rainy"] * GINI_Rainy
GINI_Outlook

freq = prop.table(table(weather[, c(4)]))
Entropy_All = - freq["No"] * log2(freq["No"]) - freq["Yes"] * log2(freq["Yes"])

absfreq = table(weather[, c(1, 4)])
freq = prop.table(absfreq, 1)
freqSum = rowSums(prop.table(absfreq)) 
Entropy_Sunny = - freq["Sunny", "No"] * log2(freq["Sunny", "No"]) - freq["Sunny", "Yes"] * log2(freq["Sunny", "Yes"])
Entropy_Rainy = - freq["Rainy", "No"] * log2(freq["Rainy", "No"]) - freq["Rainy", "Yes"] * log2(freq["Rainy", "Yes"])
GAIN_Outlook = Entropy_All - freqSum["Sunny"] * Entropy_Sunny - freqSum["Rainy"] * Entropy_Rainy 
GAIN_Outlook

model <- rpart(Play ~ Outlook + Temperature + Humidity, method = "class", data = weather, minsplit = 1, minbucket = 1, cp = -1)
rpart.plot(model, extra = 104, nn = TRUE)



iris2 = iris[, c(1, 2, 5)]
iris2$Species[c(101:150)] = iris2$Species[c(21:70)]
iris2$Species = factor(iris2$Species)

trainingdata = iris2[c(1:40, 51:90, 101:140),]
testdata = iris2[c(41:50, 91:100, 141:150),]

model <- rpart(Species ~ ., method = "class", data = trainingdata, minsplit = 20)
rpart.plot(model, extra = 104, nn = TRUE)

xtest = testdata[,1:2]
ytest = testdata[,3]
pred = predict(model, xtest, type="class")

cm = as.matrix(table(Actual = ytest, Predicted = pred))
accuracy = sum(diag(cm)) / sum(cm)
precision = diag(cm) / colSums(cm)
recall = diag(cm) / rowSums(cm)
f1 = 2 * precision * recall / (precision + recall)
data.frame(precision, recall, f1)

library(MLmetrics)
ConfusionMatrix(pred, ytest)
Precision(ytest, pred, "versicolor")
Recall(ytest, pred, "versicolor")



# kNN

knndata = read.csv("knndata.csv", stringsAsFactors = TRUE)

library(class)

X_train = knndata[,c("X1","X2")]
Y_train = knndata$Y
plot(X_train, col = Y_train, pch = c("o","+")[Y_train])

knn(X_train, c(0.7, 0.4), Y_train, k = 1, prob = TRUE)

knn(X_train, c(0.7, 0.4), Y_train, k = 5, prob = TRUE)

knn(X_train, c(0.7, 0.6), Y_train, k = 5, prob = TRUE)



# ANN

anndata = data.frame(X1 = c(0,0,1,1), X2 = c(0,1,0,1), Y = c(1,1,-1,-1))

library(neuralnet)

Y12 = ifelse(anndata$Y > 0, 1, 2)
plot(anndata[,c("X1","X2")], col = Y12, pch = c("o","+")[Y12]) 

model = neuralnet(Y ~ X1 + X2, anndata, hidden = 0, threshold = 0.000001)
plot(model)
print(model$weights)



alldata = read.csv("anndata.csv", stringsAsFactors = TRUE)
trainingdata = alldata[1:600, ]
testdata = alldata[601:800, ]

library(neuralnet)

plot(trainingdata[, c(1:2)], col = trainingdata$y, pch = c("o","+")[trainingdata$y])

model <- neuralnet(y ~ X1 + X2, data = trainingdata, hidden = c(2, 2), threshold = 0.01)
plot(model)

yEstimateTrain = compute(model, trainingdata[, c(1:2)])$net.result
TrainingError = trainingdata$y - yEstimateTrain
MAE = mean(abs(trainingdata$y - yEstimateTrain)) 
plot(hist(TrainingError, breaks = 20))

yEstimateTest = compute(model, testdata[, c(1:2)])$net.result
TestingError = testdata$y - yEstimateTest
MAE = mean(abs(testdata$y - yEstimateTest)) 
plot(hist(TestingError, breaks = 20))



# SVM

library(MLmetrics)
library(e1071)

alldata = read.csv("svmdata.csv", stringsAsFactors = TRUE)
trainingdata = alldata[1:600, ]
testdata = alldata[601:800, ]

plot(trainingdata[, c(1:2)], col = trainingdata$y, pch = c("o","+")[trainingdata$y])

X1 = seq(min(trainingdata[, 1]), max(trainingdata[, 1]), by = 0.1)
X2 = seq(min(trainingdata[, 2]), max(trainingdata[, 2]), by = 0.1)
mygrid = expand.grid(X1, X2)
colnames(mygrid) = colnames(trainingdata)[1:2]

svm_model = svm(y ~ ., kernel="radial", type="C-classification", data = trainingdata, gamma = 1)
pred = predict(svm_model, mygrid)
Y = matrix(pred, length(X1), length(X2))
contour(X1, X2, Y, add = TRUE, levels = 1.5, labels = "gamma = 1", col = "blue")

svm_model = svm(y ~ ., kernel="radial", type="C-classification", data = trainingdata, gamma = 0.01)
pred = predict(svm_model, mygrid)
Y = matrix(pred, length(X1), length(X2))
contour(X1, X2, Y, add = TRUE, levels = 1.5, labels = "gamma = 0.01", col = "red")

svm_model = svm(y ~ ., kernel="radial", type="C-classification", data = trainingdata, gamma = 100)
pred = predict(svm_model, mygrid)
Y = matrix(pred, length(X1), length(X2))
contour(X1, X2, Y, add = TRUE, levels = 1.5, labels = "gamma = 100", col = "green")

gammavalues = c(0.01, 0.1, 1, 10, 100, 1000, 10000, 100000, 1000000)

training_error = c()
for (gamma in gammavalues) {
  svm_model = svm(y ~ ., kernel="radial", type="C-classification", data = trainingdata, gamma = gamma)
  pred = predict(svm_model, trainingdata[, c(1:2)])
  training_error = c(training_error, 1 - Accuracy(trainingdata$y, pred))
}

testing_error = c()
for (gamma in gammavalues) {
  svm_model = svm(y ~ ., kernel="radial", type="C-classification", data = trainingdata, gamma = gamma)
  pred = predict(svm_model, testdata[, c(1:2)])
  testing_error = c(testing_error, 1 - Accuracy(testdata$y, pred))
}

plot(training_error, type = "l", col="blue", ylim = c(0, 0.5), xlab = "Gamma", ylab = "Error", xaxt = "n")
axis(1, at = 1:length(gammavalues), labels = gammavalues)
lines(testing_error, col="red")
legend("right", c("Training Error", "Testing Error"), pch = c("-","-"),  col = c("blue", "red"))
