#install the osmdata, sf, tidyverse and ggmap package
if(!require("osmdata")) install.packages("osmdata")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("sf")) install.packages("sf")
if(!require("ggmap")) install.packages("ggmap")

#load packages
library(tidyverse)
library(osmdata)
library(sf)
library(ggmap)



available_features()

setwd("C:/Users/Jessica/Google Drive/Wolf/Wolf-Logs")
wolf1=read.csv("GPS_Collar29456_20190513173121.csv")
wolf1 =wolf1[c(1:15, 49, 50)]
wolf1=na.omit(wolf1)
colnames(wolf1)<- c("No", "CollarID", "UTC_Date", "UTC_Time", "LMT_Date", "LMT_Time","Origin", "SCTS_Date","SCTS_Time" , "ECEF_X", "ECEF_Y", "ECEF_Z", "Latitude", "Longitude", "asl", "Easting", "Northing" )

head(wolf1)


map <- get_map(getbb("Bezirk Zwettl"),location = c(lon = mean(wolf1$Longitude), lat = mean(wolf1$Latitude)),maptype = "satellite", zoom=1)

ggmap(map)+
  geom_point(aes(x=Longitude, y= Latitude), data=wolf1)




library(plotKML)
mapImage <- get_map(location = c(lon = mean(wolf1$Longitude), lat = mean(wolf1$Latitude)),
                    source="stamen",
                    maptype = "toner")
