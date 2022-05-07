library(ggplot2)

# Create dummy data
data <- data.frame(
  cond = rep(c("condition_1", "condition_2"), each=10), 
  my_x = 1:100 + rnorm(100,sd=9),
  my_y = 1:100 + rnorm(100,sd=16) 
)

# Basic scatter plot.
p1 <- ggplot(data, aes(x=my_x, y=my_y)) + 
  geom_point(color="#69b3a2")

# Basic scatter plot plus trendline + confidence interval
p2 <- ggplot(data, aes(x=my_x, y=my_y, colour = c("blue") )) + 
  geom_point() +
  geom_smooth(method=lm , color="blue", fill="#69b3a2", se=TRUE) +
  labs(title = "Data Plot", x = "my_x", y = "my_y", color = "Legend\n") +
  scale_color_manual(labels = c("Series 1"), values = c("red"))

# Histograms with different number of bins
p3 <- ggplot(data, aes(x=my_x)) + 
  geom_histogram(stat = "bin", bins = 10) +
  geom_histogram(stat = "bin", bins = 20, color = "red") +
  geom_histogram(stat = "bin", bins = 100, color = "green") +
  labs(title = "Data", x = "my_x", y = "Density")

p4 <- ggplot(data, aes(x=my_x)) + 
  geom_histogram(stat = "density") +
  labs(title = "Data", x = "my_x", y = "Density")


# Box Plot
p5 <- ggplot(mpg, aes(class, cty)) +
  geom_boxplot(varwidth=FALSE, fill="#69b3a2") + 
  labs(title="Box plot", 
       subtitle="City Mileage grouped by Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")

# Time Series - Line Chart
p6 <- ggplot(economics, aes(x=date)) + 
  geom_line(aes(y=psavert)) + 
  labs(title="Time Series Chart", 
       subtitle="Returns Percentage from 'Economics' Dataset", 
       caption="Source: Economics", 
       y="Returns %")

library(treemapify)
p7 <- ggplot(G20, aes(area = gdp_mil_usd, fill = hdi, label = country)) +
  geom_treemap() +
  geom_treemap_text(
    fontface = "italic",
    colour = "white",
    place = "centre",
    grow = TRUE)
  