
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







