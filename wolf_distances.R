#measuring distance between two wolves 

library(data.table)
library(geosphere)



setwd("C:/Users/cornilsj/Google Drive/Wolf/Wolf-Logs")


wolf1=read.csv("GPS_Collar29456_20190902_june.csv")
wolf2=read.csv("GPS_Collar30776_20190902_june.csv")

head(wolf1)

wolf1$datetime<-as.POSIXct(paste(wolf1$UTC_Date, wolf1$UTC_Time), format="%d.%m.%Y %H:%M:%S")
wolf2$datetime<-as.POSIXct(paste(wolf2$UTC_Date, wolf2$UTC_Time), format="%d.%m.%Y %H:%M:%S")

#formatting the tables into data.tables and setting the setkey so that datetime is the variable
#its oriantating itself on
wolf1.dt <- data.table(wolf1)
setkey(wolf1.dt, datetime)

wolf2.dt <- data.table(wolf2)
setkey(wolf2.dt, datetime)

#looking for the nearest matching datetime
wolf1.2 <- wolf1.dt[wolf2.dt, roll="nearest"]

#calculate distances between points with package geosphere
wolf1.2$distance<-distHaversine(wolf1.2[,13:14], wolf1.2[,38:39])

#creating a new variable called dayNight to separate behaviours during night (18:00-06:00) and day (06:00-18:00)
wolf1.2$UTC_Time<- as.POSIXct(wolf1.2$UTC_Time, format="%H:%M:%S")
wolf1.2$dayNight <- ifelse(wolf1.2$UTC_Time> "2019-09-03 06:00:00" & wolf1.2$UTC_Time< "2019-09-03 18:00:00", 'day', 'night')

#creating a factor variable out of the character variable dayNight so we can colourCode it
wolf1.2$dayNight<-as.factor(wolf1.2$dayNight)
#plotting the dayNight coded plot along a time axis
plot(wolf1.2$distance~wolf1.2$datetime, col=wolf1.2$dayNight)
legend('topright', legend = levels(wolf1.2$dayNight), col=1:2, cex=0.8, pch=1)


wolf1.2.NA<-na.omit(wolf1.2)
aggregate(wolf1.2.NA[,wolf1.2.NA$distance], list(wolf1.2.NA$dayNight), mean)

write.csv(wolf1.2, file="wolf1.2.csv")


