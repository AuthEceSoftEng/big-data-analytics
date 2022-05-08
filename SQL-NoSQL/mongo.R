####### INSTALL PACKAGES #######

install.packages("mongolite")


####### ADD LIBRARY #######
library(mongolite)


####### CONNECT TO DB #######

connection_string = '<add the connection string here>'
trips_collection = mongo(collection="trips", db="sample_training", url=connection_string)


####### SIMPLE QUERIES #######

# Get all trips and count them
trips = trips_collection$find()
count = trips_collection$count()

# Get a single object of the collection
trips_collection$iterate()$one()

# Find with sorting and limit
trips_collection$find(sort = '{"tripduration" : -1}' , limit = 5, fields = '{"_id" : true, "tripduration" : true}')

# Find with query
query = trips_collection$find('{"usertype":"Subscriber","tripduration":{"$gt":500},"$expr": {"$eq": ["$start station name","$end station name"]}}')
nrow(query)


####### AGGREGATION #######

# Grouping and counting
user_types = trips_collection$aggregate('[{"$group":{"_id":"$usertype", "Count": {"$sum":1}}}]')
user_types <- as.data.frame(user_types)

install.packages("tidyverse", dependencies=T)
install.packages("lubridate") 
install.packages("ggplot2")
library(tidyverse)
library(lubridate)
library(ggplot2)
ggplot(user_types,aes(x=reorder(`_id`,Count),y=Count))+
  geom_bar(stat="identity",color='yellow',fill='#FFC300')+geom_text(aes(label = Count), color = "red") +coord_flip()+xlab("User Type")


####### INSPECTIONS COLLECTION #######
inspections_collection = mongo(collection="inspections", db="sample_training", url=connection_string)

# Get failed inspections in buildings for 2015-2016
year_failures = inspections_collection$aggregate('[{"$addFields": {"format_year":{"$year":{"$toDate":"$date"}}}},
{"$match":{"result":"Fail"}},
{"$group":{"_id":"$format_year", "Failed": {"$sum":1}}}]')

year_failures<-as.data.frame(year_failures)

ggplot(year_failures,aes(x=reorder(`_id`,Failed),y=Failed))+
  geom_bar(stat="identity", width=0.4, color='skyblue',fill='skyblue')+
  geom_text(aes(label = Failed), color = "black") +coord_flip()+xlab("Year")


####### COMPANIES COLLECTION #######
companies_collection = mongo(collection="companies", db="sample_training", url=connection_string)

# Trend of number of 'consulting' companies founded after 2003
consulting_companies_year_wise = companies_collection$aggregate('[
{"$match":{"category_code":"consulting","founded_year":{"$gt":2003}}},
{"$group":{"_id":"$founded_year", "Count": {"$sum":1}}},
{"$sort":{"_id": 1}}
]')

consulting_companies_year_wise <- as.data.frame(consulting_companies_year_wise)

ggplot(consulting_companies_year_wise,aes(x=`_id`,y=Count))+
  geom_line(size=2,color="blue")+
  geom_point(size=4,color="red")+
  ylab("Number of consulting companies")+ggtitle("Year-wise (2004 onwards) companies founded in the category 'consulting'")+xlab("Year")


# Get all facebook offices
fb_locs = companies_collection$aggregate('[{"$match":{"name":"Facebook"}},{"$unwind":{"path":"$offices"}}]')
loc_long <- fb_locs$offices$longitude
loc_lat <- fb_locs$offices$latitude
loc_city <- fb_locs$offices$city

# Plot the map
install.packages("maps")
library(maps)

# Plot offices
map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(loc_long,loc_lat, col="red", pch=16)
text(loc_long, y = loc_lat, loc_city, pos = 4, col="red")


####### GRADES COLLECTION #######
grades_collection = mongo(collection="grades", db="sample_training", url=connection_string)

# Get scores of students of class 7
class_score_allstudents = grades_collection$aggregate('[{"$match":{"class_id":7}},{"$unwind":{"path": "$scores"}},{"$project":{"scores.score":1,"_id":0,"scores.type":1,"class_id":1}}]')
score_values <- class_score_allstudents$scores$score

# Score statistics
median(score_values)
mean(score_values)
boxplot(score_values,col="orange",main = "Overall score details of all students attending class with id '7'")
hist(score_values,col="skyblue",border="black",xlab="Scores of all students of class id 7")
