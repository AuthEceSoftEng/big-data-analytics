setwd("C:/Users/Thomas/Desktop/BDA Med/Practical/Clustering/")



# kMeans

X = c(7, 3, 1, 5, 1, 7, 8, 5)
Y = c(1, 4, 5, 8, 3, 8, 2, 9)
rnames = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8")
kdata = data.frame(X, Y, row.names = rnames)

plot(kdata, pch = 15)
text(kdata, labels = row.names(kdata), pos = 2)

model = kmeans(kdata, centers = kdata[1:3,])
model$centers
model$cluster

cohesion = model$tot.withinss
separation = model$betweenss

plot(kdata, col = model$cluster, pch = 15)
text(kdata, labels = row.names(kdata), pos = 2)
points(model$centers, col = 1:length(model$centers), pch = "+", cex = 2)

library(cluster)
cdata = read.csv("cdata.csv", stringsAsFactors = TRUE)
target = cdata[, 3]
cdata = cdata[, 1:2]

plot(cdata, col = target)

SSE <- c()
for (i in 1:10)
  SSE[i] <- kmeans(cdata, centers = i)$tot.withinss
plot(1:10, SSE, type="b", xlab="Number of Clusters", ylab="SSE")

model = kmeans(cdata, centers = 3)

model$centers
model$cluster

cohesion = model$tot.withinss
separation = model$betweenss

plot(cdata, col = model$cluster)
points(model$centers, col = 4, pch = "+", cex = 2)

model_silhouette = silhouette(model$cluster, dist(cdata))
plot(model_silhouette)
mean_silhouette = mean(model_silhouette[, 3])

cdata_ord = cdata[order(model$cluster),]
heatmap(as.matrix(dist(cdata_ord)), Rowv = NA, Colv = NA, col = heat.colors(256), revC = TRUE)



# Hierarchical Clustering

X = c(2, 8, 0, 7, 6)
Y = c(0, 4, 6, 2, 1)
rnames = c("x1", "x2", "x3", "x4", "x5")
hdata = data.frame(X, Y, row.names = rnames)

plot(hdata, pch = 15)
text(hdata, labels = row.names(hdata), pos = 2)

d = dist(hdata)
hc_single = hclust(d, method = "single")
plot(hc_single)

hc_complete = hclust(d, method = "complete")
plot(hc_complete)

clusters = cutree(hc_single, k = 2)
plot(hdata, col = clusters, pch = 15, main = "Single Linkage")
text(hdata, labels = row.names(hdata), pos = 2)

clusters = cutree(hc_complete, k = 2)
plot(hdata, col = clusters, pch = 15, main = "Complete Linkage")
text(hdata, labels = row.names(hdata), pos = 2)

library(cluster)
library(scatterplot3d)
europe = read.csv("europe.csv", stringsAsFactors = TRUE)

d = dist(scale(europe))
hc <- hclust(d, method = 'complete')
plot(hc)

slc = c()
for (i in 2:20){
  clusters = cutree(hc, k = i)
  slc [i-1] = mean(silhouette(clusters, d)[, 3])
}
plot(2:20, slc, type="b", xlab="Number of Clusters", ylab="Silhouette")

clusters = cutree(hc, k = 7)

plot(hc)
rect.hclust(hc, k = 7)

s3d = scatterplot3d(europe, angle = 125, scale.y = 1.5, color = clusters)
coords <- s3d$xyz.convert(europe)
text(coords$x, coords$y, labels=row.names(europe), pos=sample(1:4), col = clusters)

model_silhouette = silhouette(clusters, d)
plot(model_silhouette)



# DBSCAN

library(dbscan)
X = c(2, 2, 8, 5, 7, 6, 1, 4)
Y = c(10, 5, 4, 8, 5, 4, 2, 9)
rnames = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8")
ddata = data.frame(X, Y, row.names = rnames)

plot(ddata, pch = 15)
text(ddata, labels = row.names(ddata), pos = 4)

model = dbscan(ddata, eps = 2, minPts = 2)
clusters = model$cluster
plot(ddata, col=clusters+1, pch=15, main="DBSCAN(eps = 2, minPts = 2)")
text(ddata, labels = row.names(ddata), pos = 4)

library(dbscan)
mdata = read.csv("mdata.csv", stringsAsFactors = TRUE)

plot(mdata)

model = kmeans(mdata, 2)
plot(mdata, col = model$cluster + 1)

knndist = kNNdist(mdata, k = 10)
plot(sort(knndist), type = 'l', xlab = "Points sorted by distance", ylab = "10-NN distance")

model = dbscan(mdata, eps = 0.4, minPts = 10)
plot(mdata, col = model$cluster + 1, pch = ifelse(model$cluster, 1, 4))
