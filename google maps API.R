
require("ggmap")
require("tidyverse")

# register Google Maps API key
register_google(key="AIzaSyBS83qg3lBvZQO9itLvkagw9fPzn6Hw_qQ")

# quick display of maps
qmap("Germany", zoom = 6)
ger_map <- get_map("Germany", zoom = 6)
ggmap(ger_map)

# geocoding with latitude and longitude data
germany <- geocode("Germany")

# find the white house and store it under a variable
whitehouse <- ggmap(get_map("whitehouse", zoom = 18))

# different map types
ggmap(get_map("Germany", maptype = "roadmap", zoom = 6))
ggmap(get_map("Germany", maptype = "terrain", zoom = 6))
ggmap(get_map("Germany", maptype = "terrain-labels", zoom = 6))
ggmap(get_map("Germany", maptype = "terrain-lines", zoom = 11))
ggmap(get_map("Germany", maptype = "satellite", zoom = 6))
ggmap(get_map("Germany", maptype = "hybrid", zoom = 6))
ggmap(get_map("Munich", maptype = "toner", zoom = 12))
ggmap(get_map("Munich", maptype = "toner-lite", zoom = 12))
ggmap(get_map("Munich", maptype = "toner-background", zoom = 12))
ggmap(get_map("Munich", maptype = "watercolor", zoom = 12))

# mark points on a map by combining tidyverse functions from ggplot2
germany <- geocode("germany") 
munich <- geocode("munich") 

ggmap(get_map("germany", zoom = 6)) +
  geom_point(mapping = aes(x = lon, y = lat), color = "red", data = munich)

placenames <- c("Leipzig", "Dortmund", "Brandenburger Tor", "Hamburg", "Hannover", 
                "Hannover", "Hannover", "Hannover", "Hannover")
locations <- geocode(placenames)
places <- tibble(name = placenames, lat = locations$lat,
                 lon = locations$lon)
places$grp <- c(1,2,3,4,1,1,2,3,4)

ggmap(get_map("germany", zoom = 6, maptype = "toner-background")) +
  geom_point(mapping = aes(x = lon, y = lat), color = "darkgreen",
             data = places, size = 2, shape = 15) +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "darkgreen", data = places, nudge_y = 0.3)


# create a network using the data from lat and lon from geocode
ggplot(mapping =aes(x = lon, y = lat, group = grp), data = places) +
  geom_point() + geom_line() + 
  geom_text(mapping = aes(x = lon, y = lat, label = name),
                                         color = "darkgreen", data = places, nudge_y = 0.1)


### RMD-report code ###

# 1. CREATE A LON-LAT PLOT WITH NO MAP BEHIND

# inspect the city
ggmap(get_map("Cologne", maptype = "roadmap", zoom = 10))

# 3 points North in Cologne
deliveryNorth <- c("Pulheim", "Opladen", "Bergisch Gladbach")
locationsNorth <- geocode(deliveryNorth)
deliveryRouteNorth <- tibble(name = deliveryNorth, lat = locationsNorth$lat,
                             lon = locationsNorth$lon)


# 4 points south in Cologne
deliverySouth <- c("Kerpen", "zülpich", "Bonn", "Siegburg")
locationsSouth <- geocode(deliverySouth)
deliveryRouteSouth <- tibble(name = deliverySouth, lat = locationsSouth$lat,
                             lon = locationsSouth$lon)


# Truck center (some dirty wrangling here!)
locationCenter <- c("Cologne", "Cologne", "Cologne", "Cologne", "Cologne")
locationCenter <- geocode(locationCenter)
name <- "Cologne"
truckCenter <- cbind(name,locationCenter) %>% 
  as.tibble()

# create a plot of all the points in the logistics network
logisticsNetwork <- rbind(deliveryRouteNorth, truckCenter, deliveryRouteSouth)

genericMap <- ggplot(mapping = aes(x = lon, y = lat), data = logisticsNetwork) +
  geom_point() +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "black", data = logisticsNetwork, nudge_y = 0.02) +
  theme_few()

# create the milk-run visualization in air-travelling distance

logisticsNetwork$group <- c(1,1,1,1,1,1,1,1,1,1,1,1)

ggplot(mapping = aes(x = lon, y = lat), data = logisticsNetwork) +
  geom_point() +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "black", data = logisticsNetwork, nudge_y = 0.02) +
  theme_few()









